<# :
@echo off
setlocal EnableDelayedExpansion
title Railroader Map Enhancer - Offline Tile Downloader
cls
set "SCRIPT_SOURCE=%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$code = [System.IO.File]::ReadAllText('%~f0'); Invoke-Command -ScriptBlock ([scriptblock]::Create($code))"
set "EXIT_CODE=%ERRORLEVEL%"
if %EXIT_CODE% NEQ 0 (
    echo.
    echo ======================================================================
    echo  Download process stopped or encountered an error.
    echo ======================================================================
)
echo.
echo Press any key to exit...
pause >nul
exit /b %EXIT_CODE%
: #>
# ======================================================================
# Railroader Map Enhancer - Offline Tile Downloader (PowerShell)
# Downloads, verifies SHA256 checksums, and extracts offline corridor tiles.
# ======================================================================

$ErrorActionPreference = "Stop"
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12 -bor [System.Net.SecurityProtocolType]::Tls13

$USGS_URL = "https://github.com/Reaper8f/Railroader-MapEnhancer/releases/download/map-tiles-v1/MapEnhancer_Tiles_USGSTopo_Andrews_to_Sylva.zip"
$USGS_HASH = "F6B4499A2D4F301BAFD108525415E53B6026396DC5B2DC3252D334864D31BE99"
$USGS_EXPECTED_TILES = 5101
$USGS_SIZE_MB = "574 MB"

$OSM_URL = "https://github.com/Reaper8f/Railroader-MapEnhancer/releases/download/map-tiles-v1/MapEnhancer_Tiles_OSM_Andrews_to_Sylva.zip"
$OSM_HASH = "40587516F526027644A593829D23F590A20DFC00280204137C0B72B03322AE5E"
$OSM_EXPECTED_TILES = 23315
$OSM_SIZE_MB = "76.5 MB"

function Write-Header {
    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host "          Railroader Map Enhancer - Offline Tile Downloader            " -ForegroundColor White
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Locate-TilesDirectory {
    $rawSrc = $env:SCRIPT_SOURCE
    if (-not $rawSrc) { $rawSrc = [System.AppDomain]::CurrentDomain.BaseDirectory }
    $sourceDir = (Resolve-Path $rawSrc).Path

    # Check if run directly inside reaper-map-enhancer folder
    if ((Test-Path (Join-Path $sourceDir "Info.json")) -or (Test-Path (Join-Path $sourceDir "Tiles"))) {
        $tilesDir = Join-Path $sourceDir "Tiles"
        New-Item -ItemType Directory -Force -Path $tilesDir | Out-Null
        return $tilesDir
    }

    # Otherwise, search Documents\Railroader\Mods\reaper-map-enhancer\Tiles
    $myDocs = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::MyDocuments)
    $candidatePaths = @(
        (Join-Path $myDocs "Railroader\Mods\reaper-map-enhancer\Tiles"),
        (Join-Path $env:USERPROFILE "Documents\Railroader\Mods\reaper-map-enhancer\Tiles"),
        (Join-Path $env:USERPROFILE "OneDrive\Documents\Railroader\Mods\reaper-map-enhancer\Tiles")
    )

    foreach ($cand in $candidatePaths) {
        if (Test-Path -LiteralPath (Split-Path -Parent $cand)) {
            New-Item -ItemType Directory -Force -Path $cand | Out-Null
            return $cand
        }
    }

    # Default fallback
    $defaultTiles = Join-Path $myDocs "Railroader\Mods\reaper-map-enhancer\Tiles"
    New-Item -ItemType Directory -Force -Path $defaultTiles | Out-Null
    return $defaultTiles
}

function Get-TileCounts {
    param([string]$TilesDir)

    $usgsDir = Join-Path $TilesDir "USGSTopo"
    $osmDir = Join-Path $TilesDir "OSM"

    $usgsCount = 0
    if (Test-Path -LiteralPath $usgsDir) {
        $usgsCount = (Get-ChildItem -LiteralPath $usgsDir -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -eq ".tile" -or $_.Extension -eq ".png" }).Count
    }

    $osmCount = 0
    if (Test-Path -LiteralPath $osmDir) {
        $osmCount = (Get-ChildItem -LiteralPath $osmDir -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -eq ".tile" -or $_.Extension -eq ".png" }).Count
    }

    return @{
        USGS = $usgsCount
        OSM  = $osmCount
    }
}

function Download-And-Install-Pack {
    param (
        [string]$PackName,
        [string]$Url,
        [string]$ExpectedHash,
        [string]$TargetSubDir,
        [int]$ExpectedTiles
    )

    Write-Host ""
    Write-Host "----------------------------------------------------------------------" -ForegroundColor DarkCyan
    Write-Host " Downloading: $PackName" -ForegroundColor White
    Write-Host " Source:      $Url" -ForegroundColor Gray
    Write-Host " Destination: $TargetSubDir" -ForegroundColor Gray
    Write-Host "----------------------------------------------------------------------" -ForegroundColor DarkCyan

    New-Item -ItemType Directory -Force -Path $TargetSubDir | Out-Null
    $tempZip = Join-Path $env:TEMP ("ME_Tiles_" + [System.Guid]::NewGuid().ToString() + ".zip")

    try {
        # Streaming Download with Progress
        $req = [System.Net.HttpWebRequest]::Create($Url)
        $req.Method = "GET"
        $req.UserAgent = "MapEnhancer-TileDownloader/2.0"
        $req.Timeout = 600000 # 10 minutes
        $resp = $req.GetResponse()
        $totalBytes = $resp.ContentLength
        $respStream = $resp.GetResponseStream()

        $fileStream = New-Object System.IO.FileStream($tempZip, [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write, [System.IO.FileShare]::None)
        $buffer = New-Object byte[] 65536
        $downloaded = 0
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $lastReport = [System.Diagnostics.Stopwatch]::StartNew()

        while (($bytesRead = $respStream.Read($buffer, 0, $buffer.Length)) -gt 0) {
            $fileStream.Write($buffer, 0, $bytesRead)
            $downloaded += $bytesRead

            if ($lastReport.ElapsedMilliseconds -ge 200 -or $downloaded -eq $totalBytes) {
                $lastReport.Restart()
                $pct = if ($totalBytes -gt 0) { [math]::Round(($downloaded / $totalBytes) * 100) } else { 0 }
                $mbDownloaded = [math]::Round($downloaded / 1MB, 1)
                $mbTotal = if ($totalBytes -gt 0) { [math]::Round($totalBytes / 1MB, 1) } else { "?" }
                $speedMBs = if ($sw.Elapsed.TotalSeconds -gt 0) { [math]::Round(($downloaded / 1MB) / $sw.Elapsed.TotalSeconds, 2) } else { 0 }
                $barLength = 20
                $filled = [math]::Round(($pct / 100) * $barLength)
                if ($filled -gt $barLength) { $filled = $barLength }
                $bar = ("=" * $filled).PadRight($barLength, "-")

                Write-Host -NoNewline "`r  [$bar] $pct% ($mbDownloaded / $mbTotal MB) @ $speedMBs MB/s    "
            }
        }

        $fileStream.Flush()
        $fileStream.Close()
        $respStream.Close()
        $resp.Close()
        $sw.Stop()

        Write-Host ""
        Write-Host "  Download complete in $([math]::Round($sw.Elapsed.TotalSeconds, 1))s." -ForegroundColor Green

        # Verify SHA256 Checksum
        Write-Host "  Verifying package integrity (SHA256)..." -NoNewline -ForegroundColor Gray
        $computedHash = (Get-FileHash -LiteralPath $tempZip -Algorithm SHA256).Hash.ToUpper()

        if ($computedHash -ne $ExpectedHash.ToUpper()) {
            Write-Host " MISMATCH!" -ForegroundColor Red
            Write-Host "  Expected: $ExpectedHash" -ForegroundColor Red
            Write-Host "  Received: $computedHash" -ForegroundColor Red
            throw "Downloaded file failed SHA256 integrity verification. The file may be corrupt or interrupted."
        }
        Write-Host " VERIFIED [OK]" -ForegroundColor Green

        # Extract directly into target folder
        Write-Host "  Extracting tile files into: $TargetSubDir..." -ForegroundColor Cyan
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        $zip = [System.IO.Compression.ZipFile]::OpenRead($tempZip)
        $totalEntries = $zip.Entries.Count
        $entryIdx = 0

        foreach ($entry in $zip.Entries) {
            $entryIdx++
            if ($entry.FullName.EndsWith("/") -or $entry.FullName.EndsWith("\")) { continue }
            $leafName = Split-Path -Leaf $entry.FullName
            $destFile = Join-Path $TargetSubDir $leafName
            [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $destFile, $true)

            if ($entryIdx % 500 -eq 0 -or $entryIdx -eq $totalEntries) {
                $pctExtract = [math]::Round(($entryIdx / $totalEntries) * 100)
                Write-Host -NoNewline "`r  Extracting: $pctExtract% ($entryIdx / $totalEntries tiles)...    "
            }
        }
        $zip.Dispose()
        Write-Host ""
        Write-Host "  Extraction complete! ($totalEntries tiles installed)" -ForegroundColor Green

        # Remove temp zip
        Remove-Item -Force -LiteralPath $tempZip -ErrorAction SilentlyContinue
        return $true
    }
    catch {
        Write-Host ""
        Write-Host "  [ERROR] $($_.Exception.Message)" -ForegroundColor Red
        if (Test-Path -LiteralPath $tempZip) {
            Remove-Item -Force -LiteralPath $tempZip -ErrorAction SilentlyContinue
        }
        return $false
    }
}

try {
    Write-Header

    $tilesDir = Locate-TilesDirectory
    $usgsDir = Join-Path $tilesDir "USGSTopo"
    $osmDir = Join-Path $tilesDir "OSM"

    while ($true) {
        $counts = Get-TileCounts -TilesDir $tilesDir

        Write-Host "  Target Tiles Directory:" -ForegroundColor White
        Write-Host "    $tilesDir" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  Installed Tile Status:" -ForegroundColor White
        Write-Host "    1. USGS Topographic: " -NoNewline -ForegroundColor Gray
        if ($counts.USGS -gt 0) {
            Write-Host "$($counts.USGS.ToString('N0')) tiles installed [OK]" -ForegroundColor Green
        } else {
            Write-Host "Not installed" -ForegroundColor Yellow
        }

        Write-Host "    2. OpenStreetMap:    " -NoNewline -ForegroundColor Gray
        if ($counts.OSM -gt 0) {
            Write-Host "$($counts.OSM.ToString('N0')) tiles installed [OK]" -ForegroundColor Green
        } else {
            Write-Host "Not installed" -ForegroundColor Yellow
        }
        Write-Host ""

        Write-Host "======================================================================" -ForegroundColor Cyan
        Write-Host "  Select an option:" -ForegroundColor White
        Write-Host "    [1] Download USGS Topo Pack (~$USGS_SIZE_MB, $USGS_EXPECTED_TILES tiles, Zooms 14-16)" -ForegroundColor White
        Write-Host "        Authentic Appalachian mountain contours, elevations, waterways." -ForegroundColor Gray
        Write-Host ""
        Write-Host "    [2] Download OpenStreetMap Pack (~$OSM_SIZE_MB, $OSM_EXPECTED_TILES tiles, Zooms 12-17)" -ForegroundColor White
        Write-Host "        High-contrast GIS roads, rivers, street networks & rail yard sidings." -ForegroundColor Gray
        Write-Host ""
        Write-Host "    [3] Download BOTH Packs (~650 MB Total)" -ForegroundColor White
        Write-Host "        Recommended for instant dual-provider toggling in the game." -ForegroundColor Gray
        Write-Host ""
        Write-Host "    [4] Verify Installed Tiles Integrity" -ForegroundColor White
        Write-Host "    [5] Exit" -ForegroundColor White
        Write-Host "======================================================================" -ForegroundColor Cyan
        Write-Host "  Enter choice (1-5): " -NoNewline -ForegroundColor White
        $choice = Read-Host

        if ($choice -eq "1") {
            $res = Download-And-Install-Pack -PackName "USGS Topographic Corridor Pack" -Url $USGS_URL -ExpectedHash $USGS_HASH -TargetSubDir $usgsDir -ExpectedTiles $USGS_EXPECTED_TILES
            if ($res) {
                Write-Host ""
                Write-Host "  [TIP] In Railroader, press [Ctrl+M], set Map Background to 'Map Tiles'," -ForegroundColor Cyan
                Write-Host "        and select 'USGSTopo' from the Tile Set dropdown!" -ForegroundColor Cyan
            }
        }
        elseif ($choice -eq "2") {
            $res = Download-And-Install-Pack -PackName "OpenStreetMap Corridor Pack" -Url $OSM_URL -ExpectedHash $OSM_HASH -TargetSubDir $osmDir -ExpectedTiles $OSM_EXPECTED_TILES
            if ($res) {
                Write-Host ""
                Write-Host "  [TIP] In Railroader, press [Ctrl+M], set Map Background to 'Map Tiles'," -ForegroundColor Cyan
                Write-Host "        and select 'OSM' from the Tile Set dropdown!" -ForegroundColor Cyan
            }
        }
        elseif ($choice -eq "3") {
            Write-Host ""
            Write-Host "  Starting download of BOTH offline packs..." -ForegroundColor Cyan
            Download-And-Install-Pack -PackName "OpenStreetMap Corridor Pack" -Url $OSM_URL -ExpectedHash $OSM_HASH -TargetSubDir $osmDir -ExpectedTiles $OSM_EXPECTED_TILES
            Download-And-Install-Pack -PackName "USGS Topographic Corridor Pack" -Url $USGS_URL -ExpectedHash $USGS_HASH -TargetSubDir $usgsDir -ExpectedTiles $USGS_EXPECTED_TILES
            Write-Host ""
            Write-Host "  [TIP] Both tile sets are installed! In Railroader, press [Ctrl+M]" -ForegroundColor Green
            Write-Host "        and toggle freely between 'USGSTopo' and 'OSM' anytime!" -ForegroundColor Green
        }
        elseif ($choice -eq "4") {
            Write-Host ""
            Write-Host "  Verifying installed tile files in: $tilesDir" -ForegroundColor Cyan
            $current = Get-TileCounts -TilesDir $tilesDir
            Write-Host "  USGS Topo tiles present: $($current.USGS.ToString('N0'))" -ForegroundColor White
            Write-Host "  OpenStreetMap tiles present: $($current.OSM.ToString('N0'))" -ForegroundColor White
            if ($current.USGS -ge $USGS_EXPECTED_TILES) {
                Write-Host "  [OK] USGS Topo pack is complete." -ForegroundColor Green
            } else {
                Write-Host "  [WARN] USGS Topo has $($current.USGS) tiles (full pack is $USGS_EXPECTED_TILES tiles)." -ForegroundColor Yellow
            }
            if ($current.OSM -ge $OSM_EXPECTED_TILES) {
                Write-Host "  [OK] OpenStreetMap pack is complete." -ForegroundColor Green
            } else {
                Write-Host "  [WARN] OpenStreetMap has $($current.OSM) tiles (full pack is $OSM_EXPECTED_TILES tiles)." -ForegroundColor Yellow
            }
        }
        elseif ($choice -eq "5" -or $choice -eq "q" -or $choice -eq "exit") {
            Write-Host ""
            Write-Host "Exiting Tile Downloader. Happy Railroading!" -ForegroundColor Green
            break
        }
        else {
            Write-Host "Invalid option. Please choose 1, 2, 3, 4, or 5." -ForegroundColor Yellow
        }

        Write-Host ""
        Write-Host "Press [Enter] to return to the main menu..." -ForegroundColor Gray
        Read-Host | Out-Null
        Clear-Host
        Write-Header
    }

    exit 0
}
catch {
    Write-Host ""
    Write-Host "  [FATAL ERROR] $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

