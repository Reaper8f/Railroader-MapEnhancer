<# :
@echo off
setlocal EnableDelayedExpansion
title Railroader Map Enhancer - Installer and Updater
cls
set "SCRIPT_SOURCE=%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$code = [System.IO.File]::ReadAllText('%~f0'); Invoke-Command -ScriptBlock ([scriptblock]::Create($code))"
set "EXIT_CODE=%ERRORLEVEL%"
if %EXIT_CODE% NEQ 0 (
    echo.
    echo ======================================================================
    echo  Installation failed or was cancelled (Exit code: %EXIT_CODE%).
    echo ======================================================================
)
echo.
echo Press any key to exit...
pause >nul
exit /b %EXIT_CODE%
: #>
# ======================================================================
# Railroader Map Enhancer - Automated Installer & Updater (PowerShell)
# Preserves user settings.json, custom Backgrounds, and offline Tiles.
# ======================================================================

$ErrorActionPreference = "Stop"

function Write-Header {
    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host "         Railroader Map Enhancer - Automated Installer & Updater       " -ForegroundColor White
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Success {
    param([string]$Message)
    Write-Host "  [OK] $Message" -ForegroundColor Green
}

function Write-Info {
    param([string]$Message)
    Write-Host "  [..] $Message" -ForegroundColor Gray
}

function Write-WarningMessage {
    param([string]$Message)
    Write-Host "  [WARN] $Message" -ForegroundColor Yellow
}

function Write-ErrorMessage {
    param([string]$Message)
    Write-Host "  [FAIL] $Message" -ForegroundColor Red
}

try {
    Write-Header

    # 1. Determine Source Directory containing the mod files
    $rawSrc = $env:SCRIPT_SOURCE
    if (-not $rawSrc) { $rawSrc = [System.AppDomain]::CurrentDomain.BaseDirectory }
    $sourceDir = (Resolve-Path $rawSrc).Path

    # Check if Info.json and MapEnhancer.dll are in $sourceDir or a subfolder
    $manifestPath = Join-Path $sourceDir "Info.json"
    $dllPath = Join-Path $sourceDir "MapEnhancer.dll"

    if (-not (Test-Path $manifestPath) -or -not (Test-Path $dllPath)) {
        # Check child directories (e.g. MapEnhancer-2.x.x or reaper-map-enhancer)
        $subDirs = Get-ChildItem -LiteralPath $sourceDir -Directory -ErrorAction SilentlyContinue
        foreach ($dir in $subDirs) {
            $candidateManifest = Join-Path $dir.FullName "Info.json"
            $candidateDll = Join-Path $dir.FullName "MapEnhancer.dll"
            if ((Test-Path $candidateManifest) -and (Test-Path $candidateDll)) {
                $sourceDir = $dir.FullName
                $manifestPath = $candidateManifest
                $dllPath = $candidateDll
                break
            }
        }
    }

    # Development build/ fallback check
    if (-not (Test-Path $dllPath)) {
        $devBuildDll = Join-Path $sourceDir "build\MapEnhancer.dll"
        if (Test-Path $devBuildDll) {
            $dllPath = $devBuildDll
        }
    }

    if (-not (Test-Path $manifestPath) -or -not (Test-Path $dllPath)) {
        Write-ErrorMessage "Could not find mod files (Info.json and MapEnhancer.dll) in: $sourceDir"
        Write-Host "  Please ensure you extracted the entire contents of the release ZIP before running install.bat." -ForegroundColor Yellow
        exit 1
    }

    # Read manifest info
    $manifestJson = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
    $modId = if ($manifestJson.identifier) { $manifestJson.identifier } else { "reaper/map-enhancer" }
    $modVersion = if ($manifestJson.version) { $manifestJson.version } else { "2.0.16" }
    $modFolder = ($modId -replace '/', '-')

    Write-Host "  Mod Package: " -NoNewline -ForegroundColor White
    Write-Host "$modId v$modVersion" -ForegroundColor Cyan
    Write-Host "  Source Path: " -NoNewline -ForegroundColor White
    Write-Host "$sourceDir" -ForegroundColor Gray
    Write-Host ""

    # 2. Check if Railroader is currently running
    $runningGame = Get-Process -Name "Railroader" -ErrorAction SilentlyContinue
    while ($runningGame) {
        Write-WarningMessage "Railroader.exe is currently running (PID: $($runningGame.Id))."
        Write-Host "  Windows locks mod DLL files while the game is running." -ForegroundColor Yellow
        Write-Host "  Please save and exit Railroader, then press [Enter] to continue." -ForegroundColor White
        Write-Host "  (Or type 'q' and press [Enter] to cancel): " -NoNewline -ForegroundColor White
        $choice = Read-Host
        if ($choice -and $choice.Trim().ToLower() -eq 'q') {
            Write-Host "Installation cancelled by user." -ForegroundColor Yellow
            exit 2
        }
        $runningGame = Get-Process -Name "Railroader" -ErrorAction SilentlyContinue
    }

    # 3. Detect Railroader Mods Directory
    $myDocs = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::MyDocuments)
    $candidatePaths = @(
        (Join-Path $myDocs "Railroader\Mods"),
        (Join-Path $env:USERPROFILE "Documents\Railroader\Mods"),
        (Join-Path $env:USERPROFILE "OneDrive\Documents\Railroader\Mods")
    )

    $modsDir = $null
    foreach ($cand in $candidatePaths) {
        if (Test-Path -LiteralPath $cand) {
            $modsDir = $cand
            break
        }
    }

    if (-not $modsDir) {
        # Fall back to standard Documents\Railroader\Mods
        $modsDir = Join-Path $myDocs "Railroader\Mods"
        Write-Info "Creating Railroader Mods directory at: $modsDir"
        New-Item -ItemType Directory -Force -Path $modsDir | Out-Null
    }

    $targetModDir = Join-Path $modsDir $modFolder
    Write-Host "  Destination: " -NoNewline -ForegroundColor White
    Write-Host "$targetModDir" -ForegroundColor Cyan
    Write-Host ""

    # Check if source and destination are the exact same directory
    $isSameDir = $false
    if (Test-Path -LiteralPath $targetModDir) {
        $resolvedSource = (Resolve-Path $sourceDir).Path.TrimEnd('\')
        $resolvedTarget = (Resolve-Path $targetModDir).Path.TrimEnd('\')
        if ($resolvedSource -ieq $resolvedTarget) {
            $isSameDir = $true
        }
    }

    # 4. Check for legacy mod folders (vanguard-map-enhancer or MapEnhancer)
    $legacyDirs = @(
        (Join-Path $modsDir "vanguard-map-enhancer"),
        (Join-Path $modsDir "MapEnhancer")
    )

    $legacyFound = $null
    foreach ($ld in $legacyDirs) {
        if ((Test-Path -LiteralPath $ld) -and ($ld -ne $targetModDir)) {
            $legacyFound = $ld
            break
        }
    }

    # 5. USER DATA PRESERVATION CHECK (settings.json, Backgrounds, Tiles)
    $hasExistingTarget = Test-Path -LiteralPath $targetModDir
    $settingsPath = Join-Path $targetModDir "settings.json"
    $hasSettings = Test-Path -LiteralPath $settingsPath
    $settingsBackup = $null

    if ($hasSettings) {
        $settingsBackup = [System.IO.File]::ReadAllText($settingsPath)
        Write-Success "Preserved existing user settings.json (Your hotkeys, colors, and trim options are safe)."
    } elseif ($legacyFound -and (Test-Path (Join-Path $legacyFound "settings.json"))) {
        $legacySettingsPath = Join-Path $legacyFound "settings.json"
        $settingsBackup = [System.IO.File]::ReadAllText($legacySettingsPath)
        Write-Success "Migrated existing settings.json from previous directory: $legacyFound"
        $hasSettings = $true
    }

    # Check custom Backgrounds
    $bgDir = Join-Path $targetModDir "Backgrounds"
    $existingBgCount = 0
    if (Test-Path -LiteralPath $bgDir) {
        $existingBgCount = (Get-ChildItem -LiteralPath $bgDir -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne "README.txt" -and $_.Name -ne "calibration.sample.json" }).Count
        if ($existingBgCount -gt 0) {
            Write-Success "Preserved existing custom Backgrounds folder ($existingBgCount custom background files intact)."
        }
    } elseif ($legacyFound -and (Test-Path (Join-Path $legacyFound "Backgrounds"))) {
        Write-Info "Migrating custom Backgrounds from legacy mod folder..."
        New-Item -ItemType Directory -Force -Path $bgDir | Out-Null
        Copy-Item -Recurse -Force -Path (Join-Path $legacyFound "Backgrounds\*") -Destination $bgDir -ErrorAction SilentlyContinue
        Write-Success "Migrated custom Backgrounds from legacy directory."
    }

    # Check offline Tiles
    $tilesDir = Join-Path $targetModDir "Tiles"
    $existingTileCount = 0
    if (Test-Path -LiteralPath $tilesDir) {
        $existingTileCount = (Get-ChildItem -LiteralPath $tilesDir -Recurse -File -Filter "*.tile" -ErrorAction SilentlyContinue).Count
        $pngTileCount = (Get-ChildItem -LiteralPath $tilesDir -Recurse -File -Filter "*.png" -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '^\d+[-_]\d+[-_]\d+\.png$' -or $_.Directory.Name -match '^\d+$' }).Count
        $totalTilesFound = $existingTileCount + $pngTileCount
        if ($totalTilesFound -gt 0) {
            Write-Success "Preserved existing offline Tiles folder ($totalTilesFound map tiles intact)."
        }
    } elseif ($legacyFound -and (Test-Path (Join-Path $legacyFound "Tiles"))) {
        Write-Info "Migrating offline Tiles from legacy mod folder..."
        New-Item -ItemType Directory -Force -Path $tilesDir | Out-Null
        Copy-Item -Recurse -Force -Path (Join-Path $legacyFound "Tiles\*") -Destination $tilesDir -ErrorAction SilentlyContinue
        Write-Success "Migrated offline Tiles from legacy directory."
    }

    # Remove obsolete legacy folder to avoid game dual-loading crashes
    if ($legacyFound) {
        try {
            Write-Info "Removing obsolete mod folder '$legacyFound' to prevent Railroader dual-loading crashes..."
            Remove-Item -Recurse -Force -LiteralPath $legacyFound
            Write-Success "Removed obsolete folder '$legacyFound'."
        } catch {
            Write-WarningMessage "Could not remove legacy folder '$legacyFound': $($_.Exception.Message)"
        }
    }

    # 6. Copy / Update Mod Files
    if (-not $isSameDir) {
        Write-Info "Installing mod files to: $targetModDir"
        New-Item -ItemType Directory -Force -Path $targetModDir | Out-Null

        # Files to copy
        $filesToCopy = @(
            "Info.json",
            "MapEnhancer.dll",
            "0Harmony.dll",
            "arrow.png",
            "flare.png",
            "level-crossing.png",
            "traincar.png",
            "station.png",
            "MapEnhancer2.0.png",
            "mapenhancer-station-marker.svg",
            "LICENSE",
            "THIRD_PARTY_NOTICES.md",
            "install.bat",
            "downloadtiles.bat",
            "INSTALL_AND_UPDATE_GUIDE.txt"
        )

        foreach ($fileName in $filesToCopy) {
            $srcFile = Join-Path $sourceDir $fileName
            if (Test-Path -LiteralPath $srcFile) {
                Copy-Item -Force -LiteralPath $srcFile -Destination (Join-Path $targetModDir $fileName)
            }
        }

        # Initialize Backgrounds placeholders without overwriting existing files
        New-Item -ItemType Directory -Force -Path $bgDir | Out-Null
        $bgReadmeSrc = Join-Path $sourceDir "Backgrounds\README.txt"
        if ((Test-Path $bgReadmeSrc) -and -not (Test-Path (Join-Path $bgDir "README.txt"))) {
            Copy-Item -Force -LiteralPath $bgReadmeSrc -Destination (Join-Path $bgDir "README.txt")
        }
        $bgSampleSrc = Join-Path $sourceDir "Backgrounds\calibration.sample.json"
        if ((Test-Path $bgSampleSrc) -and -not (Test-Path (Join-Path $bgDir "calibration.sample.json"))) {
            Copy-Item -Force -LiteralPath $bgSampleSrc -Destination (Join-Path $bgDir "calibration.sample.json")
        }

        # Initialize Tiles directories and readme without overwriting existing tiles
        $usgsDir = Join-Path $tilesDir "USGSTopo"
        $osmDir = Join-Path $tilesDir "OSM"
        New-Item -ItemType Directory -Force -Path $usgsDir | Out-Null
        New-Item -ItemType Directory -Force -Path $osmDir | Out-Null
        $tilesReadmeSrc = Join-Path $sourceDir "Tiles\README.txt"
        if ((Test-Path $tilesReadmeSrc) -and -not (Test-Path (Join-Path $tilesDir "README.txt"))) {
            Copy-Item -Force -LiteralPath $tilesReadmeSrc -Destination (Join-Path $tilesDir "README.txt")
        }

        Write-Success "Mod files and assets copied successfully."
    }

    # 7. Restore preserved settings.json
    if ($hasSettings -and $settingsBackup) {
        [System.IO.File]::WriteAllText($settingsPath, $settingsBackup)
        Write-Success "User settings restored and verified at: $settingsPath"
    }

    # 8. Check for installed map tiles and provide recommendations
    $totalTilesInstalled = 0
    if (Test-Path -LiteralPath $tilesDir) {
        $totalTilesInstalled = (Get-ChildItem -LiteralPath $tilesDir -Recurse -File -Filter "*.tile" -ErrorAction SilentlyContinue).Count
        $totalTilesInstalled += (Get-ChildItem -LiteralPath $tilesDir -Recurse -File -Filter "*.png" -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '^\d+[-_]\d+[-_]\d+\.png$' -or $_.Directory.Name -match '^\d+$' }).Count
    }

    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Green
    Write-Host "         Map Enhancer v$modVersion Installed Successfully!             " -ForegroundColor White
    Write-Host "======================================================================" -ForegroundColor Green
    Write-Host "  Mod Folder:    $targetModDir" -ForegroundColor Gray
    Write-Host "  Settings:      " -NoNewline -ForegroundColor White
    if ($hasSettings) {
        Write-Host "PRESERVED (All your hotkeys, colors, and trims kept intact)" -ForegroundColor Green
    } else {
        Write-Host "Fresh install (Default settings will generate on first launch)" -ForegroundColor Cyan
    }

    Write-Host "  Backgrounds:   " -NoNewline -ForegroundColor White
    if ($existingBgCount -gt 0) {
        Write-Host "PRESERVED ($existingBgCount custom background images)" -ForegroundColor Green
    } else {
        Write-Host "Ready for custom images in 'Backgrounds\'" -ForegroundColor Gray
    }

    Write-Host "  Map Tiles:     " -NoNewline -ForegroundColor White
    if ($totalTilesInstalled -gt 0) {
        Write-Host "PRESERVED ($totalTilesInstalled offline map tiles detected)" -ForegroundColor Green
    } else {
        Write-Host "None installed (Optional offline corridor packs available)" -ForegroundColor Yellow
    }
    Write-Host "======================================================================" -ForegroundColor Green
    Write-Host ""

    # Offer to run downloadtiles.bat if no tiles are installed
    if ($totalTilesInstalled -eq 0) {
        $tileScript = Join-Path $targetModDir "downloadtiles.bat"
        if (Test-Path -LiteralPath $tileScript) {
            Write-Host "  [TIP] Would you like to run 'downloadtiles.bat' now to download" -ForegroundColor Cyan
            Write-Host "        the offline USGS Topo or OpenStreetMap corridor packs? (y/N): " -NoNewline -ForegroundColor White
            $answer = Read-Host
            if ($answer -and $answer.Trim().ToLower() -eq 'y') {
                Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$tileScript`"" -WorkingDirectory $targetModDir
            }
        }
    } else {
        Write-Host "  In-Game Usage:" -ForegroundColor White
        Write-Host "    1. Start Railroader and open your world." -ForegroundColor Gray
        Write-Host "    2. Press [M] to open the map (Railroader default)." -ForegroundColor Gray
        Write-Host "    3. Press [Ctrl+M] or click [ME] in top-right to open settings." -ForegroundColor Gray
        Write-Host "    4. Press [Z] to maximize or toggle large floating map view." -ForegroundColor Gray
        Write-Host ""
    }

    exit 0
}
catch {
    Write-ErrorMessage "An unexpected error occurred during installation:"
    Write-Host "  $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    exit 1
}

