<#
.SYNOPSIS
    Builds an offline raster tile package (Tiles\{z}-{x}-{y}.tile + ZIP) for the
    Railroader Andrews -> Bryson City -> Sylva corridor, for use by Map Enhancer.
    Intended for mod developers who produce the package; end users only install the ZIP.

.DESCRIPTION
    1. HARVEST  - copies valid tiles from the local Railroader GIS cache into the Tiles folder
                  (local use only by default; see -IncludeLegacy).
    2. DOWNLOAD - fetches missing corridor tiles from a provider that publishes its map
                  services as public-domain data: the USGS National Map tile caches
                  (https://basemap.nationalmap.gov). Requests are sequential, throttled,
                  retry with back-off, honour Retry-After, and stop if the server refuses us.
                  JPEG tiles are converted to PNG so every .tile file is a PNG.
    3. PACKAGE  - validates every tile (PNG signature, chunk CRCs, IDAT inflate + Adler-32,
                  dimensions), builds the ZIP, then re-opens the ZIP and verifies it
                  (entry count, PNG integrity, per-zoom corridor coverage).

    The tile layout is unchanged: flat folder / flat ZIP root, one file per tile named
    {zoom}-{x}-{y}.tile (XYZ / "slippy map" scheme, EPSG:3857, 256x256 PNG).

    This script NEVER contacts tile.openstreetmap.org (or any other OSM Foundation tile
    server): the OSMF tile usage policy prohibits bulk downloading and offline use. It also
    never sends another application's User-Agent.

.PARAMETER Provider
    USGSTopo (default), USGSImageryOnly, or USGSImageryTopo. All are USGS National Map
    tile caches, Web Mercator, 256 px, cached through zoom 16.

.PARAMETER LocalTileUrl
    With -Provider LocalOsm: URL template of a tile server YOU run (for example the
    overv/openstreetmap-tile-server container, http://localhost:8080/tile/{z}/{x}/{y}.png).
    Only loopback / private-network hosts are accepted. This is the supported way to get
    OpenStreetMap "Standard" style tiles: render them yourself from free OSM data instead of
    scraping tile.openstreetmap.org. See tile-osm-selfhost.md.

.PARAMETER Zooms
    Zoom levels to build. Default 12,13,14,15. USGS caches stop at zoom 16, so zoom 17
    can only come from the local game cache.

.PARAMETER DelayMs
    Pause after every network request (default 250 ms, i.e. at most ~4 requests/second).

.PARAMETER Contact
    Optional e-mail or URL appended to the User-Agent so the provider can reach you.

.PARAMETER IncludeLegacy
    Also put tiles that did not come from the selected provider (game-cache harvests and
    tiles of unknown origin) into the ZIP. Off by default because their licence/provenance
    has not been verified. If you use it, you are responsible for the redistribution terms
    of those tiles.

.PARAMETER ReplaceLegacy
    Replace corridor tiles that came from another/unknown source with provider tiles. The
    old file is moved to <dist>\tile-backup\legacy, never deleted.

.PARAMETER QuarantineInvalid
    During packaging, move tiles that fail validation to <dist>\tile-backup\invalid
    instead of just leaving them out of the ZIP.

.PARAMETER DryRun
    Print the plan (tile counts, what is missing) without touching the network or any file.

.PARAMETER VerifyOnly
    Do not harvest, download or package. Re-open the existing -DistZip and verify it: entry
    count, PNG integrity of every tile, per-zoom corridor coverage and geographic extent.

.PARAMETER PackageOnly
    Skip the download step (harvest + validate + package only).

.PARAMETER EmbedAttribution
    Also place ATTRIBUTION.txt inside the ZIP root. Off by default so the ZIP contains only
    {z}-{x}-{y}.tile files (the attribution is always written next to the ZIP).

.NOTES
    Exit codes: 0 = complete and verified; 2 = built/verified but corridor coverage has gaps
    or the download stopped early; 3 = nothing to package / ZIP not found; 4 = invalid tiles
    found in the ZIP.
    Targets Windows PowerShell 5.1 and PowerShell 7+ (needs System.Drawing only when the
    provider returns JPEG tiles that must be converted to PNG).
    Other files written (all outside the Tiles folder): <dist>\tile-provenance.json,
    <dist>\<zip>.ATTRIBUTION.txt, <dist>\<zip>.validation.json, <dist>\tile-backup\*.

.EXAMPLE
    .\download-map-tiles.ps1 -DryRun
.EXAMPLE
    .\download-map-tiles.ps1 -ReplaceLegacy -Contact you@example.com
.EXAMPLE
    .\download-map-tiles.ps1 -Provider USGSImageryOnly -Zooms 12,13,14,15,16
.EXAMPLE
    .\download-map-tiles.ps1 -PackageOnly
.EXAMPLE
    .\download-map-tiles.ps1 -VerifyOnly
#>

[CmdletBinding()]
param(
	[ValidateSet('USGSTopo', 'USGSImageryOnly', 'USGSImageryTopo', 'LocalOsm')]
	[string]$Provider = 'USGSTopo',

	[ValidateRange(0, 22)]
	[int[]]$Zooms = @(12, 13, 14, 15, 16),

	[string]$TilesDir = "$PSScriptRoot\..\Tiles",
	[string]$DistZip = '',
	[string]$GameCacheDir = "$env:LOCALAPPDATA\Temp\Giraffe Lab LLC\Railroader\Map.GIS.Overlay\72ce51dfa64fbcd7",
	[string]$ProvenancePath = '',

	[ValidateRange(0, 60000)]
	[int]$DelayMs = 250,
	[ValidateRange(0, 10)]
	[int]$MaxRetries = 3,
	[string]$Contact = '',

	# Only used with -Provider LocalOsm: URL template of YOUR OWN self-hosted tile server.
	[string]$LocalTileUrl = 'http://localhost:8080/tile/{z}/{x}/{y}.png',

	# Override only for testing against a local mirror. Hosts of the OSM Foundation are refused.
	[string]$ServiceRoot = 'https://basemap.nationalmap.gov/arcgis/rest/services',

	[switch]$PackageOnly,
	[switch]$SkipHarvest,
	[switch]$DryRun,
	[switch]$IncludeLegacy,
	[switch]$ReplaceLegacy,
	[switch]$QuarantineInvalid,
	[switch]$EmbedAttribution,
	[switch]$VerifyOnly
)

$ErrorActionPreference = 'Stop'
$ScriptVersion = '2.0'

# ---------------------------------------------------------------------------------------
# Provider catalogue (verified against the services' REST metadata)
# ---------------------------------------------------------------------------------------
$Providers = @{
	USGSTopo        = @{
		Layer   = 'USGSTopo'
		MaxZoom = 16
		Credit  = 'USGS The National Map: National Boundaries Dataset, 3DEP Elevation Program, Geographic Names Information System, National Hydrography Dataset, National Land Cover Database, National Structures Dataset, and National Transportation Dataset; USGS Global Ecosystems; U.S. Census Bureau TIGER/Line data; USFS Road data; Natural Earth Data; U.S. Department of State HIU; NOAA National Centers for Environmental Information.'
	}
	USGSImageryOnly = @{
		Layer   = 'USGSImageryOnly'
		MaxZoom = 16
		Credit  = 'USDA, USGS The National Map: Orthoimagery.'
	}
	USGSImageryTopo = @{
		Layer   = 'USGSImageryTopo'
		MaxZoom = 16
		Credit  = 'USGS The National Map: Orthoimagery and US Topo.'
	}
}
$Providers['LocalOsm'] = @{
	Layer   = ''
	MaxZoom = 19
	Credit  = '(c) OpenStreetMap contributors (data licensed under the Open Database Licence, ODbL 1.0). Tiles rendered locally from OpenStreetMap data with the openstreetmap-carto style.'
}
$ProviderInfo = $Providers[$Provider]
$IsLocalOsm = ($Provider -eq 'LocalOsm')
$SourceTag = if ($IsLocalOsm) { 'osm-selfrendered:local' } else { "usgs:$Provider" }

# Corridor sub-boxes covering the actual railway line (unchanged from the original script)
$CorridorBoxes = @(
	# Western Segment: Andrews -> Marble -> Topton -> Nantahala
	[PSCustomObject]@{ MinLat = 35.18; MaxLat = 35.35; MinLon = -83.86; MaxLon = -83.56 },
	# Central Segment: Nantahala -> Almond -> Bryson City -> Whittier -> Ela
	[PSCustomObject]@{ MinLat = 35.32; MaxLat = 35.48; MinLon = -83.60; MaxLon = -83.33 },
	# Eastern Segment: Dillsboro -> Sylva -> Addie
	[PSCustomObject]@{ MinLat = 35.33; MaxLat = 35.41; MinLon = -83.35; MaxLon = -83.19 }
)

$KnownOsmBlockPlaceholderBytes = 6725   # size of the OSM "access blocked" tile; only used for legacy files
$ExpectedTileSize = 256

# ---------------------------------------------------------------------------------------
# Path normalisation
# ---------------------------------------------------------------------------------------
function Resolve-FullPath([string]$p) {
	return $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($p)
}
$TilesDir = Resolve-FullPath $TilesDir
if ([string]::IsNullOrWhiteSpace($DistZip)) {
	$tag = if ($Provider -eq 'LocalOsm') { 'OSM' } else { $Provider }
	$DistZip = Join-Path "$PSScriptRoot\..\dist" "MapEnhancer_Tiles_${tag}_Andrews_to_Sylva.zip"
}
$DistZip = Resolve-FullPath $DistZip
$DistDir = Split-Path -Parent $DistZip
if ([string]::IsNullOrWhiteSpace($ProvenancePath)) { $ProvenancePath = Join-Path $DistDir 'tile-provenance.json' }
$ProvenancePath = Resolve-FullPath $ProvenancePath
$BackupRoot = Join-Path $DistDir 'tile-backup'
$ZipBase = [IO.Path]::Combine($DistDir, [IO.Path]::GetFileNameWithoutExtension($DistZip))
$AttributionPath = "$ZipBase.ATTRIBUTION.txt"
$ValidationPath = "$ZipBase.validation.json"

# ---------------------------------------------------------------------------------------
# Guard: refuse OSM Foundation tile servers, require HTTPS (loopback excepted for testing)
# ---------------------------------------------------------------------------------------
try { $rootUri = [Uri]$ServiceRoot } catch { throw "ServiceRoot is not a valid URL: $ServiceRoot" }
$isLoopback = @('localhost', '127.0.0.1', '::1', '[::1]') -contains $rootUri.Host
if ($rootUri.Host -match '(^|\.)openstreetmap\.(org|de|us|fr)$' -or $rootUri.Host -match '(^|\.)osm\.org$') {
	throw "Refusing to use '$($rootUri.Host)': OpenStreetMap tile servers prohibit bulk downloading and offline use. Use a provider that permits it (default: USGS National Map)."
}
if ($rootUri.Scheme -ne 'https' -and -not $isLoopback) { throw 'ServiceRoot must use https.' }
$ServiceRoot = $ServiceRoot.TrimEnd('/')

if ($IsLocalOsm) {
	# LocalOsm exists so tiles can be rendered from OSM *data* on your own machine. It only accepts
	# loopback / private-network hosts so it cannot be pointed at anyone else's public tile server.
	if ($LocalTileUrl -notmatch '\{z\}' -or $LocalTileUrl -notmatch '\{x\}' -or $LocalTileUrl -notmatch '\{y\}') {
		throw '-LocalTileUrl must contain {z}, {x} and {y}, e.g. http://localhost:8080/tile/{z}/{x}/{y}.png'
	}
	try { $localUri = [Uri]($LocalTileUrl -replace '\{[zxy]\}', '0') } catch { throw "-LocalTileUrl is not a valid URL: $LocalTileUrl" }
	$h = $localUri.Host
	$isPrivate = ($h -eq 'localhost') -or ($h -match '^127\.') -or ($h -eq '::1') -or ($h -eq '[::1]') -or
	($h -match '^10\.') -or ($h -match '^192\.168\.') -or ($h -match '^172\.(1[6-9]|2\d|3[01])\.') -or ($h -match '\.local$')
	if (-not $isPrivate) { throw "-LocalTileUrl host '$h' is not a loopback/private address. -Provider LocalOsm is only for a tile server you run yourself." }
	if ($h -match '(^|\.)openstreetmap\.(org|de|us|fr)$' -or $h -match '(^|\.)osm\.org$') { throw 'Refusing OSM Foundation hosts.' }
}

# ---------------------------------------------------------------------------------------
# Native helper: strict PNG validation (signature, chunk CRCs, IDAT inflate + Adler-32, size)
# ---------------------------------------------------------------------------------------
if (-not ('TileCheck' -as [type])) {
	Add-Type -TypeDefinition @'
using System;
using System.IO;
using System.IO.Compression;

public static class TileCheck
{
    static readonly uint[] T = MakeTable();

    static uint[] MakeTable()
    {
        uint[] t = new uint[256];
        for (uint n = 0; n < 256; n++)
        {
            uint c = n;
            for (int k = 0; k < 8; k++) c = ((c & 1) != 0) ? (0xEDB88320u ^ (c >> 1)) : (c >> 1);
            t[n] = c;
        }
        return t;
    }

    static uint Crc(byte[] b, int off, int len)
    {
        uint c = 0xFFFFFFFFu;
        for (int i = 0; i < len; i++) c = T[(c ^ b[off + i]) & 0xFF] ^ (c >> 8);
        return c ^ 0xFFFFFFFFu;
    }

    static uint BE(byte[] b, int o)
    {
        return ((uint)b[o] << 24) | ((uint)b[o + 1] << 16) | ((uint)b[o + 2] << 8) | (uint)b[o + 3];
    }

    // "png", "jpeg" or "other"
    public static string Kind(byte[] b)
    {
        if (b == null) return "other";
        if (b.Length >= 8 && b[0] == 0x89 && b[1] == 0x50 && b[2] == 0x4E && b[3] == 0x47 &&
            b[4] == 0x0D && b[5] == 0x0A && b[6] == 0x1A && b[7] == 0x0A) return "png";
        if (b.Length >= 3 && b[0] == 0xFF && b[1] == 0xD8 && b[2] == 0xFF) return "jpeg";
        return "other";
    }

    // Returns "OK" or a short reason code.
    public static string CheckPng(byte[] b, out int width, out int height)
    {
        width = 0; height = 0;
        if (b == null || b.Length < 33) return "too-small";
        if (Kind(b) != "png") return "bad-signature";

        int pos = 8, chunkIndex = 0, depth = 0, ctype = 0, interlace = 0;
        bool sawIend = false, sawPlte = false;
        MemoryStream idat = new MemoryStream();

        while (pos + 12 <= b.Length)
        {
            long len = BE(b, pos);
            if (len > (long)(b.Length - pos - 12)) return "truncated";
            int l = (int)len;
            string type = System.Text.Encoding.ASCII.GetString(b, pos + 4, 4);
            if (Crc(b, pos + 4, l + 4) != BE(b, pos + 8 + l)) return "bad-crc";

            if (chunkIndex == 0)
            {
                if (type != "IHDR" || l != 13) return "no-ihdr";
                width = (int)BE(b, pos + 8);
                height = (int)BE(b, pos + 12);
                depth = b[pos + 16]; ctype = b[pos + 17]; interlace = b[pos + 20];
                if (width <= 0 || height <= 0 || width > 16384 || height > 16384) return "bad-ihdr";
                if (ctype != 0 && ctype != 2 && ctype != 3 && ctype != 4 && ctype != 6) return "bad-ihdr";
                if (interlace > 1) return "bad-ihdr";
            }
            else if (type == "PLTE") sawPlte = true;
            else if (type == "IDAT") idat.Write(b, pos + 8, l);
            else if (type == "IEND") { sawIend = true; break; }

            pos += 12 + l;
            chunkIndex++;
        }

        if (chunkIndex == 0) return "no-ihdr";
        if (!sawIend) return "no-iend";
        if (ctype == 3 && !sawPlte) return "no-plte";
        if (idat.Length == 0) return "no-idat";

        byte[] z = idat.ToArray();
        if (z.Length < 7) return "bad-idat";
        if ((z[0] & 0x0F) != 8 || ((((int)z[0] << 8) | z[1]) % 31) != 0 || (z[1] & 0x20) != 0) return "bad-idat";

        long total = 0;
        uint a = 1, s2 = 0;
        try
        {
            using (MemoryStream ms = new MemoryStream(z, 2, z.Length - 6))
            using (DeflateStream ds = new DeflateStream(ms, CompressionMode.Decompress))
            {
                byte[] buf = new byte[65536];
                int n;
                while ((n = ds.Read(buf, 0, buf.Length)) > 0)
                {
                    total += n;
                    for (int i = 0; i < n; i++) { a = (a + buf[i]) % 65521; s2 = (s2 + a) % 65521; }
                }
            }
        }
        catch (Exception) { return "bad-idat"; }

        if ((((s2 << 16) | a)) != BE(z, z.Length - 4)) return "bad-adler";

        if (interlace == 0)
        {
            int channels = (ctype == 0 || ctype == 3) ? 1 : (ctype == 2 ? 3 : (ctype == 4 ? 2 : 4));
            long rowBytes = ((long)width * channels * depth + 7) / 8;
            if (total != (long)height * (rowBytes + 1)) return "bad-idat-size";
        }
        else if (total == 0) return "bad-idat-size";

        return "OK";
    }
}
'@
}

# ---------------------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------------------
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

function Convert-LatLonToTile([double]$lat, [double]$lon, [int]$zoom) {
	$x = ($lon + 180.0) / 360.0
	$sinLat = [Math]::Sin($lat * [Math]::PI / 180.0)
	$y = 0.5 - [Math]::Log((1.0 + $sinLat) / (1.0 - $sinLat)) / (4.0 * [Math]::PI)
	$n = [Math]::Pow(2, $zoom)
	return [PSCustomObject]@{
		TileX = [int][Math]::Floor($x * $n)
		TileY = [int][Math]::Floor($y * $n)
	}
}

function Convert-TileToLatLon([int]$x, [int]$y, [int]$zoom) {
	# North-west corner of tile (x, y)
	$n = [Math]::Pow(2, $zoom)
	$lon = $x / $n * 360.0 - 180.0
	$lat = [Math]::Atan([Math]::Sinh([Math]::PI * (1.0 - 2.0 * $y / $n))) * 180.0 / [Math]::PI
	return [PSCustomObject]@{ Lat = $lat; Lon = $lon }
}

function Get-CorridorTiles([int]$zoom) {
	$set = @{}
	foreach ($box in $CorridorBoxes) {
		$nw = Convert-LatLonToTile $box.MaxLat $box.MinLon $zoom
		$se = Convert-LatLonToTile $box.MinLat $box.MaxLon $zoom
		for ($x = $nw.TileX; $x -le $se.TileX; $x++) {
			for ($y = $nw.TileY; $y -le $se.TileY; $y++) {
				$set["$zoom-$x-$y"] = [PSCustomObject]@{ Z = $zoom; X = $x; Y = $y }
			}
		}
	}
	return , @($set.Values | Sort-Object X, Y)
}

$TileNamePattern = '^(\d+)-(\d+)-(\d+)\.tile$'

function Test-TileFile([string]$path) {
	# Read-only validation. Never modifies or deletes the file.
	$r = [PSCustomObject]@{ Ok = $false; Reason = 'missing'; Width = 0; Height = 0; Bytes = 0 }
	if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { return $r }
	try { $bytes = [IO.File]::ReadAllBytes($path) } catch { $r.Reason = 'unreadable'; return $r }
	$w = 0; $h = 0
	$reason = [TileCheck]::CheckPng($bytes, [ref]$w, [ref]$h)
	$r.Ok = ($reason -eq 'OK'); $r.Reason = $reason; $r.Width = $w; $r.Height = $h; $r.Bytes = $bytes.Length
	return $r
}

function Read-Provenance([string]$path) {
	$h = @{}
	if (Test-Path -LiteralPath $path) {
		try {
			$j = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json
			if ($j.tiles) { foreach ($p in $j.tiles.PSObject.Properties) { $h[$p.Name] = $p.Value } }
		}
		catch { Write-Warning "Could not read provenance file ($path): $($_.Exception.Message). Treating tiles as unknown-origin." }
	}
	return $h
}

function Save-Provenance([hashtable]$prov, [string]$path) {
	$dir = Split-Path -Parent $path
	if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
	$sorted = [ordered]@{}
	foreach ($k in ($prov.Keys | Sort-Object)) { $sorted[$k] = $prov[$k] }
	$doc = [ordered]@{ version = 1; updatedUtc = (Get-Date).ToUniversalTime().ToString('o'); tiles = $sorted }
	($doc | ConvertTo-Json -Depth 5) | Set-Content -LiteralPath $path -Encoding UTF8
}

function Get-TileSource([hashtable]$prov, [string]$key) {
	if ($prov.ContainsKey($key) -and $prov[$key].source) { return [string]$prov[$key].source }
	return 'unknown'
}

function Move-ToBackup([string]$file, [string]$category) {
	$dir = Join-Path $BackupRoot $category
	if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
	$dest = Join-Path $dir ([IO.Path]::GetFileName($file))
	if (Test-Path -LiteralPath $dest) { $dest = "$dest.$([DateTime]::UtcNow.ToString('yyyyMMddHHmmssfff'))" }
	Move-Item -LiteralPath $file -Destination $dest -Force
}

function Convert-ImageBytesToPng([byte[]]$bytes) {
	try { Add-Type -AssemblyName System.Drawing } catch { throw 'System.Drawing is required to convert JPEG tiles to PNG (available on Windows PowerShell and PowerShell 7 on Windows).' }
	$in = New-Object IO.MemoryStream(, $bytes)
	try {
		$img = [System.Drawing.Image]::FromStream($in)
		try {
			$out = New-Object IO.MemoryStream
			try {
				$img.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
				return , $out.ToArray()
			}
			finally { $out.Dispose() }
		}
		finally { $img.Dispose() }
	}
	finally { $in.Dispose() }
}

# ---------------------------------------------------------------------------------------
# ZIP verification: re-open the ZIP and check what is actually inside
# ---------------------------------------------------------------------------------------
function Invoke-ZipVerification([string]$zipPath, [hashtable]$plannedByZoom, [int[]]$zoomList) {
	$vOk = 0; $vBad = 0; $vOther = 0
	$present = @{}
	$badEntries = New-Object System.Collections.ArrayList
	$minLat = 90.0; $maxLat = -90.0; $minLon = 180.0; $maxLon = -180.0
	$zr = [IO.Compression.ZipFile]::OpenRead($zipPath)
	try {
		foreach ($entry in $zr.Entries) {
			$m = [regex]::Match($entry.FullName, $TileNamePattern)
			if (-not $m.Success) { $vOther++; continue }
			$st = $entry.Open()
			try {
				$ms = New-Object IO.MemoryStream
				$st.CopyTo($ms)
				$bytes = $ms.ToArray()
			}
			catch { $vBad++; [void]$badEntries.Add("$($entry.FullName): unreadable ($($_.Exception.Message))"); continue }
			finally { $st.Dispose() }
			$w = 0; $h = 0
			$reason = [TileCheck]::CheckPng($bytes, [ref]$w, [ref]$h)
			if ($reason -ne 'OK') { $vBad++; [void]$badEntries.Add("$($entry.FullName): $reason"); continue }
			$vOk++
			$zz = [int]$m.Groups[1].Value; $xx = [int]$m.Groups[2].Value; $yy = [int]$m.Groups[3].Value
			if (-not $present.ContainsKey($zz)) { $present[$zz] = New-Object 'System.Collections.Generic.HashSet[string]' }
			[void]$present[$zz].Add("$xx-$yy")
			$nw = Convert-TileToLatLon $xx $yy $zz
			$se = Convert-TileToLatLon ($xx + 1) ($yy + 1) $zz
			if ($se.Lat -lt $minLat) { $minLat = $se.Lat }
			if ($nw.Lat -gt $maxLat) { $maxLat = $nw.Lat }
			if ($nw.Lon -lt $minLon) { $minLon = $nw.Lon }
			if ($se.Lon -gt $maxLon) { $maxLon = $se.Lon }
		}
	}
	finally { $zr.Dispose() }

	$coverage = @()
	foreach ($z in $zoomList) {
		$need = $plannedByZoom[$z]
		$have = 0
		if ($present.ContainsKey($z)) { foreach ($t in $need) { if ($present[$z].Contains("$($t.X)-$($t.Y)")) { $have++ } } }
		$coverage += [PSCustomObject]@{ Zoom = $z; Needed = $need.Count; InZip = $have; Missing = $need.Count - $have; Percent = [Math]::Round(100.0 * $have / [Math]::Max(1, $need.Count), 1) }
	}
	$zoomsPresent = @($present.Keys | Sort-Object)
	$zoomCounts = [ordered]@{}
	foreach ($zk in $zoomsPresent) { $zoomCounts["z$zk"] = $present[$zk].Count }
	return [PSCustomObject]@{
		PngValid = $vOk; PngInvalid = $vBad; NonTileEntries = $vOther; BadEntries = $badEntries
		Coverage = $coverage; ZoomsPresent = $zoomsPresent; ZoomCounts = $zoomCounts
		ExtraZooms = @($zoomsPresent | Where-Object { $zoomList -notcontains $_ })
		MinLat = $minLat; MaxLat = $maxLat; MinLon = $minLon; MaxLon = $maxLon
	}
}

function Write-VerificationReport($v) {
	Write-Host '   Coverage by zoom (corridor tiles present in the ZIP):' -ForegroundColor Cyan
	foreach ($c in $v.Coverage) {
		$color = if ($c.Missing -eq 0) { 'Green' } else { 'Yellow' }
		Write-Host ("      z{0,-2}  {1,5} / {2,-5} ({3,5}%)  missing {4}" -f $c.Zoom, $c.InZip, $c.Needed, $c.Percent, $c.Missing) -ForegroundColor $color
	}
	if ($v.ExtraZooms.Count -gt 0) { Write-Host "      Additional zoom levels in ZIP (outside the checked -Zooms): $($v.ExtraZooms -join ', ')" -ForegroundColor DarkGray }
	if ($v.PngValid -gt 0) { Write-Host ("   ZIP geographic extent: lat {0:N4}..{1:N4}, lon {2:N4}..{3:N4}" -f $v.MinLat, $v.MaxLat, $v.MinLon, $v.MaxLon) -ForegroundColor Cyan }
	if ($v.NonTileEntries -gt 0) { Write-Host "   ZIP also contains $($v.NonTileEntries) non-tile entr(y/ies) (e.g. ATTRIBUTION.txt)." -ForegroundColor DarkGray }
	if ($v.BadEntries.Count -gt 0) { $v.BadEntries | Select-Object -First 5 | ForEach-Object { Write-Host "   BAD ENTRY: $_" -ForegroundColor Red } }
}

function Write-Banner {
	Write-Host '==========================================================' -ForegroundColor Cyan
	Write-Host ' Railroader Map Enhancer - Tile Builder & Packager' -ForegroundColor Cyan
	Write-Host ' Target Corridor: Andrews -> Bryson City -> Sylva' -ForegroundColor Cyan
	if ($IsLocalOsm) { Write-Host " Provider: LocalOsm  (self-rendered from OSM data: $LocalTileUrl)" -ForegroundColor Cyan }
	else { Write-Host " Provider: $Provider  (USGS National Map, public domain)" -ForegroundColor Cyan }
	Write-Host '==========================================================' -ForegroundColor Cyan
}

Write-Banner
if ($DryRun) { Write-Host ' DRY RUN: no files will be written, no network requests made.' -ForegroundColor Magenta }

if ($VerifyOnly) {
	if (-not (Test-Path -LiteralPath $DistZip)) { Write-Host " ZIP not found: $DistZip" -ForegroundColor Red; exit 3 }
	Write-Host " VERIFY ONLY: $DistZip" -ForegroundColor Magenta
	$voPlanned = @{}; $voZooms = @()
	foreach ($z in ($Zooms | Sort-Object -Unique)) { $voZooms += $z; $voPlanned[$z] = Get-CorridorTiles $z }
	$v = Invoke-ZipVerification $DistZip $voPlanned $voZooms
	Write-Host ("   Tiles: {0} valid PNG, {1} invalid, {2} non-tile entries" -f $v.PngValid, $v.PngInvalid, $v.NonTileEntries) -ForegroundColor Cyan
	Write-VerificationReport $v
	$voGaps = ($v.Coverage | Measure-Object -Property Missing -Sum).Sum
	if ($v.PngInvalid -gt 0) { exit 4 }
	if ($voGaps -gt 0) { Write-Host " Verified: all entries are valid PNG, but corridor coverage has gaps." -ForegroundColor Yellow; exit 2 }
	Write-Host ' Verified: all entries are valid PNG and corridor coverage is complete.' -ForegroundColor Green
	exit 0
}

if (-not $DryRun -and -not (Test-Path -LiteralPath $TilesDir)) {
	New-Item -ItemType Directory -Path $TilesDir -Force | Out-Null
}
$prov = Read-Provenance $ProvenancePath
$provDirty = $false

# ---------------------------------------------------------------------------------------
# 1. Harvest valid tiles from the game's local cache (local use; never overwrites)
# ---------------------------------------------------------------------------------------
if ($SkipHarvest) {
	Write-Host '[1/3] Harvest skipped (-SkipHarvest).' -ForegroundColor Yellow
}
elseif (-not (Test-Path -LiteralPath $GameCacheDir)) {
	Write-Host '[1/3] Game cache not found - nothing to harvest.' -ForegroundColor Yellow
	Write-Host "      ($GameCacheDir)" -ForegroundColor DarkGray
}
else {
	Write-Host '[1/3] Harvesting existing tiles from local game cache...' -ForegroundColor Yellow
	$hNew = 0; $hHave = 0; $hBad = 0; $hPlaceholder = 0; $hName = 0
	foreach ($f in Get-ChildItem -LiteralPath $GameCacheDir -Filter '*.tile' -File) {
		if ($f.Name -notmatch $TileNamePattern) { $hName++; continue }
		$dest = Join-Path $TilesDir $f.Name
		if (Test-Path -LiteralPath $dest) { $hHave++; continue }
		if ($f.Length -eq $KnownOsmBlockPlaceholderBytes) { $hPlaceholder++; continue }
		$chk = Test-TileFile $f.FullName
		if (-not $chk.Ok) { $hBad++; continue }
		if (-not $DryRun) {
			Copy-Item -LiteralPath $f.FullName -Destination $dest
			$key = [IO.Path]::GetFileNameWithoutExtension($f.Name)
			$prov[$key] = [PSCustomObject]@{ source = 'railroader-cache'; retrievedUtc = (Get-Date).ToUniversalTime().ToString('o') }
			$provDirty = $true
		}
		$hNew++
	}
	$verb = if ($DryRun) { 'Would import' } else { 'Imported' }
	Write-Host "      $verb $hNew new tiles from game cache (already present: $hHave)." -ForegroundColor Green
	if ($hBad + $hPlaceholder + $hName -gt 0) {
		Write-Host "      Skipped: $hBad invalid PNG, $hPlaceholder known block-placeholder, $hName unexpected file name." -ForegroundColor DarkYellow
	}
	$siblings = @()
	$cacheParent = Split-Path -Parent $GameCacheDir
	if ($cacheParent -and (Test-Path -LiteralPath $cacheParent)) {
		$siblings = @(Get-ChildItem -LiteralPath $cacheParent -Directory | Where-Object { $_.FullName -ne (Resolve-FullPath $GameCacheDir) })
	}
	if ($siblings.Count -gt 0) {
		Write-Host "      Note: $($siblings.Count) other cache folder(s) exist next to it and were NOT imported (they may be a different map source)." -ForegroundColor DarkGray
	}
}
if ($provDirty) { Save-Provenance $prov $ProvenancePath; $provDirty = $false }

# ---------------------------------------------------------------------------------------
# 2. Download missing tiles from the selected provider
# ---------------------------------------------------------------------------------------
$planned = @{}   # zoom -> tile list (also used for coverage reporting)
$effectiveZooms = @()
foreach ($z in ($Zooms | Sort-Object -Unique)) {
	if ($z -gt $ProviderInfo.MaxZoom) {
		Write-Host "   Zoom $z skipped: $Provider is cached only through zoom $($ProviderInfo.MaxZoom)." -ForegroundColor DarkYellow
		continue
	}
	$effectiveZooms += $z
	$planned[$z] = Get-CorridorTiles $z
}

$totalDownloaded = 0; $totalOurs = 0; $totalHeld = 0; $totalUnavailable = 0; $totalFailed = 0
$failReasons = @{}
$downloadAborted = $false

if ($PackageOnly) {
	Write-Host '[2/3] Download skipped (-PackageOnly).' -ForegroundColor Yellow
}
else {
	Write-Host "[2/3] Checking and downloading corridor tiles from $Provider..." -ForegroundColor Yellow
	$ua = "RailroaderMapEnhancer-TileBuilder/$ScriptVersion"
	if ($Contact) { $ua += " (+$Contact)" }
	$http = $null
	if (-not $DryRun) {
		Add-Type -AssemblyName System.Net.Http
		try { [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12 } catch { }
		$http = New-Object System.Net.Http.HttpClient
		$http.Timeout = [TimeSpan]::FromSeconds($(if ($IsLocalOsm) { 180 } else { 30 }))
		[void]$http.DefaultRequestHeaders.TryAddWithoutValidation('User-Agent', $ua)
	}

	$consecNet = 0; $consecHttp = 0; $consecUnavail = 0
	foreach ($z in $effectiveZooms) {
		$tiles = $planned[$z]
		Write-Host "   Processing Zoom $z : $($tiles.Count) corridor tiles..." -ForegroundColor Cyan
		$zDownloaded = 0; $zMissing = 0; $i = 0
		foreach ($tile in $tiles) {
			if ($downloadAborted) { break }
			$i++
			$key = "$($tile.Z)-$($tile.X)-$($tile.Y)"
			$dest = Join-Path $TilesDir "$key.tile"

			if (Test-Path -LiteralPath $dest) {
				$chk = Test-TileFile $dest
				$src = Get-TileSource $prov $key
				if ($chk.Ok -and $src -eq $SourceTag) { $totalOurs++; continue }
				if ($chk.Ok -and -not $ReplaceLegacy) { $totalHeld++; continue }
				# invalid file, or valid legacy tile being replaced: set aside, never delete
				if (-not $DryRun) { Move-ToBackup $dest $(if ($chk.Ok) { 'legacy' } else { 'invalid' }) }
			}

			if ($DryRun) { $zMissing++; continue }

			# ---- fetch (sequential, throttled, back-off, honours Retry-After) ----
			if ($IsLocalOsm) { $url = $LocalTileUrl.Replace('{z}', "$($tile.Z)").Replace('{x}', "$($tile.X)").Replace('{y}', "$($tile.Y)") }
			else { $url = "$ServiceRoot/$($ProviderInfo.Layer)/MapServer/tile/$($tile.Z)/$($tile.Y)/$($tile.X)" }
			$attempt = 0; $result = $null
			while ($true) {
				$attempt++
				$status = 0; $bytes = $null; $retryAfterSec = 0; $err = $null
				try {
					$resp = $http.GetAsync($url).GetAwaiter().GetResult()
					try {
						$status = [int]$resp.StatusCode
						if ($resp.Headers.RetryAfter -and $resp.Headers.RetryAfter.Delta) { $retryAfterSec = [int]$resp.Headers.RetryAfter.Delta.TotalSeconds }
						if ($status -eq 200) { $bytes = $resp.Content.ReadAsByteArrayAsync().GetAwaiter().GetResult() }
					}
					finally { $resp.Dispose() }
				}
				catch { $err = $_.Exception.Message }

				if ($status -eq 200) { $result = @{ Status = 'ok'; Bytes = $bytes }; break }
				if ($status -eq 404 -or $status -eq 400) { $result = @{ Status = 'unavailable'; Reason = "HTTP $status" }; break }
				if ($status -eq 401 -or $status -eq 403) { $result = @{ Status = 'failed'; Reason = "HTTP $status (refused)"; Refused = $true }; break }
				if ($attempt -gt $MaxRetries) {
					$why = if ($status) { "HTTP $status" } else { "network error: $err" }
					$result = @{ Status = 'failed'; Reason = $why; Network = (-not $status) }
					break
				}
				$wait = if ($retryAfterSec -gt 0) { [Math]::Min($retryAfterSec, 120) } else { [Math]::Min([Math]::Pow(2, $attempt), 60) }
				$what = if ($status) { "HTTP $status" } else { 'network error' }
				Write-Host "      $what for $key - retry $attempt/$MaxRetries in ${wait}s" -ForegroundColor DarkYellow
				Start-Sleep -Seconds $wait
			}

			# ---- classify / convert / validate ----
			if ($result.Status -eq 'ok') {
				$payload = $result.Bytes
				$fmt = [TileCheck]::Kind($payload)
				$note = $null
				if ($fmt -eq 'jpeg') {
					try { $payload = Convert-ImageBytesToPng $payload; $note = 'jpeg->png' }
					catch { $result = @{ Status = 'failed'; Reason = "jpeg conversion failed: $($_.Exception.Message)" } }
				}
				elseif ($fmt -ne 'png') {
					$result = @{ Status = 'unavailable'; Reason = 'non-image response' }
				}
				if ($result.Status -eq 'ok') {
					$w = 0; $h = 0
					$reason = [TileCheck]::CheckPng($payload, [ref]$w, [ref]$h)
					if ($reason -ne 'OK') { $result = @{ Status = 'failed'; Reason = "invalid PNG ($reason)" } }
					elseif ($w -ne $ExpectedTileSize -or $h -ne $ExpectedTileSize) { $result = @{ Status = 'failed'; Reason = "unexpected tile size ${w}x${h}" } }
				}
				if ($result.Status -eq 'ok') {
					$part = "$dest.part"
					[IO.File]::WriteAllBytes($part, $payload)
					Move-Item -LiteralPath $part -Destination $dest -Force
					$prov[$key] = [PSCustomObject]@{
						source       = $SourceTag
						retrievedUtc = (Get-Date).ToUniversalTime().ToString('o')
						converted    = $note
					}
					$provDirty = $true
					$zDownloaded++; $totalDownloaded++
					$consecNet = 0; $consecHttp = 0; $consecUnavail = 0
				}
			}

			switch ($result.Status) {
				'unavailable' { $totalUnavailable++; $failReasons[$result.Reason] = 1 + [int]$failReasons[$result.Reason]; $consecUnavail++; $consecNet = 0 }
				'failed' {
					$totalFailed++; $failReasons[$result.Reason] = 1 + [int]$failReasons[$result.Reason]
					if ($result.Network) { $consecNet++ } else { $consecHttp++ }
				}
			}
			if ($result.Refused -and ($consecHttp -ge 3)) {
				Write-Host "      The provider is refusing requests ($($result.Reason)). Stopping - this script does not try to work around access controls." -ForegroundColor Red
				$downloadAborted = $true
			}
			elseif ($consecNet -ge 3) {
				Write-Host '      Network unreachable for 3 consecutive tiles. Stopping; check your connection and re-run (finished tiles are kept).' -ForegroundColor Red
				$downloadAborted = $true
			}
			elseif ($consecHttp -ge 10) {
				Write-Host '      10 consecutive requests failed. Stopping to avoid hammering the server; check provider status and re-run.' -ForegroundColor Red
				$downloadAborted = $true
			}
			elseif ($consecUnavail -ge 25) {
				Write-Host '      25 consecutive tiles reported unavailable. Stopping; the zoom level or area may not be cached by this provider.' -ForegroundColor Red
				$downloadAborted = $true
			}

			if ($i % 50 -eq 0) { Write-Progress -Activity "Zoom $z ($Provider)" -Status "$i / $($tiles.Count)" -PercentComplete ([int](100 * $i / $tiles.Count)) }
			if ($provDirty -and ($i % 100 -eq 0)) { Save-Provenance $prov $ProvenancePath; $provDirty = $false }
			if ($DelayMs -gt 0) { Start-Sleep -Milliseconds $DelayMs }
		}
		Write-Progress -Activity "Zoom $z ($Provider)" -Completed
		if ($DryRun) { Write-Host "      Zoom $z : would download $zMissing tiles." -ForegroundColor Green }
		else { Write-Host "      Zoom $z : Downloaded $zDownloaded tiles." -ForegroundColor Green }
		if ($downloadAborted) { break }
	}
	if ($provDirty) { Save-Provenance $prov $ProvenancePath; $provDirty = $false }
	if ($http) { $http.Dispose() }

	if ($DryRun) {
		Write-Host "   Dry-run summary: $totalOurs already from $Provider, $totalHeld held by other/unknown-source files (use -ReplaceLegacy to replace)." -ForegroundColor Green
	}
	else {
		Write-Host "   Download Summary: $totalDownloaded downloaded, $totalOurs already present, $totalHeld held by other/unknown-source files, $totalUnavailable not available, $totalFailed failed." -ForegroundColor Green
		foreach ($k in $failReasons.Keys) { Write-Host "      - $k : $($failReasons[$k])" -ForegroundColor DarkYellow }
		if ($totalHeld -gt 0) { Write-Host "      $totalHeld corridor tile(s) kept their existing non-$Provider files; run with -ReplaceLegacy to replace them (originals are backed up, not deleted)." -ForegroundColor DarkYellow }
	}
}

# ---------------------------------------------------------------------------------------
# 3. Validate and package
# ---------------------------------------------------------------------------------------
Write-Host '[3/3] Validating and packaging archive...' -ForegroundColor Yellow

$eligible = New-Object System.Collections.ArrayList
$excluded = @{ 'legacy-not-included' = 0; 'invalid' = 0; 'bad-name' = 0; 'suspect-placeholder' = 0 }
$invalidReasons = @{}
$badSize = New-Object System.Collections.ArrayList
$srcCounts = @{}

if (Test-Path -LiteralPath $TilesDir) {
	foreach ($t in (Get-ChildItem -LiteralPath $TilesDir -Filter '*.tile' -File)) {
		if ($t.Name -notmatch $TileNamePattern) { $excluded['bad-name']++; continue }
		$key = [IO.Path]::GetFileNameWithoutExtension($t.Name)
		$src = Get-TileSource $prov $key
		$isOurs = ($src -eq $SourceTag)

		if (-not $isOurs -and -not $IncludeLegacy) { $excluded['legacy-not-included']++; continue }

		$chk = Test-TileFile $t.FullName
		if (-not $chk.Ok) {
			$excluded['invalid']++
			$invalidReasons[$chk.Reason] = 1 + [int]$invalidReasons[$chk.Reason]
			if ($QuarantineInvalid -and -not $DryRun) { Move-ToBackup $t.FullName 'invalid' }
			continue
		}
		if (-not $isOurs -and $t.Length -eq $KnownOsmBlockPlaceholderBytes) { $excluded['suspect-placeholder']++; continue }
		if ($chk.Width -ne $ExpectedTileSize -or $chk.Height -ne $ExpectedTileSize) { [void]$badSize.Add("$($t.Name) ($($chk.Width)x$($chk.Height))") }

		$m = [regex]::Match($t.Name, $TileNamePattern)
		[void]$eligible.Add([PSCustomObject]@{
				File = $t.FullName; Name = $t.Name; Source = $src
				Z = [int]$m.Groups[1].Value; X = [int]$m.Groups[2].Value; Y = [int]$m.Groups[3].Value
			})
		$srcCounts[$src] = 1 + [int]$srcCounts[$src]
	}
}
$eligible = @($eligible | Sort-Object Z, X, Y)

if ($excluded['invalid'] -gt 0) {
	$why = ($invalidReasons.Keys | ForEach-Object { "$_=$($invalidReasons[$_])" }) -join ', '
	Write-Host "   Left out $($excluded['invalid']) invalid tile(s): $why" -ForegroundColor Yellow
}
if ($excluded['suspect-placeholder'] -gt 0) { Write-Host "   Left out $($excluded['suspect-placeholder']) legacy tile(s) matching the known OSM block-placeholder size." -ForegroundColor Yellow }
if ($excluded['bad-name'] -gt 0) { Write-Host "   Ignored $($excluded['bad-name']) file(s) not named {z}-{x}-{y}.tile." -ForegroundColor Yellow }
if ($excluded['legacy-not-included'] -gt 0) {
	Write-Host "   Left out $($excluded['legacy-not-included']) tile(s) not sourced from $Provider (game-cache harvests / unknown origin). Use -IncludeLegacy to ship them." -ForegroundColor Yellow
}
if ($badSize.Count -gt 0) {
	Write-Host "   Warning: $($badSize.Count) tile(s) are not ${ExpectedTileSize}x${ExpectedTileSize}: $((@($badSize) | Select-Object -First 3) -join ', ')..." -ForegroundColor Yellow
}

if ($eligible.Count -eq 0) {
	Write-Host '   No eligible tiles - nothing to package.' -ForegroundColor Red
	if (-not $PackageOnly -and -not $DryRun) { Write-Host "   Tip: run with -ReplaceLegacy if existing tiles block the $Provider download, or -IncludeLegacy to ship existing tiles." -ForegroundColor Red }
	if ($DryRun) { exit 0 }
	exit 3
}

# ---- attribution text ----
$attr = New-Object System.Text.StringBuilder
[void]$attr.AppendLine('Map tile attribution - Railroader Map Enhancer corridor package (Andrews to Sylva)')
[void]$attr.AppendLine('')
if ($srcCounts.ContainsKey($SourceTag)) {
	if ($IsLocalOsm) {
		[void]$attr.AppendLine('Attribution (required): (c) OpenStreetMap contributors - https://www.openstreetmap.org/copyright')
		[void]$attr.AppendLine("Tiles: $($srcCounts[$SourceTag]) tiles rendered locally from OpenStreetMap data (openstreetmap-carto style); no OSM Foundation tile server was used.")
		[void]$attr.AppendLine("Data: $($ProviderInfo.Credit)")
		[void]$attr.AppendLine('Check the licence of the map style you rendered with and the ODbL attribution rules before redistributing.')
	}
	else {
		[void]$attr.AppendLine("Credit: U.S. Geological Survey")
		[void]$attr.AppendLine("Tiles: $($srcCounts[$SourceTag]) tiles from the USGS National Map '$($ProviderInfo.Layer)' tile service.")
		[void]$attr.AppendLine("Data sources: $($ProviderInfo.Credit)")
		[void]$attr.AppendLine('Licence: USGS National Map services and data are in the U.S. public domain; USGS requests that the USGS be credited as the source.')
		[void]$attr.AppendLine('Service: https://basemap.nationalmap.gov/arcgis/rest/services/' + $ProviderInfo.Layer + '/MapServer')
		[void]$attr.AppendLine('Processing: PNG tiles are stored byte-for-byte as served. Where the service returned JPEG, the decoded image is saved as PNG with no other edits (the service''s own JPEG compression artefacts remain).')
	}
	[void]$attr.AppendLine('')
}
$legacyCount = ($eligible | Where-Object { $_.Source -ne $SourceTag }).Count
if ($legacyCount -gt 0) {
	[void]$attr.AppendLine("WARNING: $legacyCount tile(s) in this package were NOT obtained from $Provider (sources: game cache / unknown).")
	[void]$attr.AppendLine('Their licence and provenance are unverified. If they are OpenStreetMap-derived they require "(c) OpenStreetMap contributors" attribution (ODbL / CC BY-SA 2.0).')
	[void]$attr.AppendLine('')
}
[void]$attr.AppendLine("Generated $((Get-Date).ToUniversalTime().ToString('yyyy-MM-dd HH:mm')) UTC by download-map-tiles.ps1 v$ScriptVersion")

if ($DryRun) {
	Write-Host "   Dry run: would package $($eligible.Count) tiles into $DistZip" -ForegroundColor Cyan
	exit 0
}

if (-not (Test-Path -LiteralPath $DistDir)) { New-Item -ItemType Directory -Path $DistDir -Force | Out-Null }
$tmpZip = "$DistZip.tmp"
if (Test-Path -LiteralPath $tmpZip) { Remove-Item -LiteralPath $tmpZip -Force }

Write-Host "   Compressing $($eligible.Count) tiles into: $DistZip..." -ForegroundColor Cyan
$zip = [IO.Compression.ZipFile]::Open($tmpZip, [IO.Compression.ZipArchiveMode]::Create)
try {
	foreach ($e in $eligible) {
		[void][IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $e.File, $e.Name, [IO.Compression.CompressionLevel]::Optimal)
	}
	if ($EmbedAttribution) {
		$entry = $zip.CreateEntry('ATTRIBUTION.txt')
		$sw = New-Object IO.StreamWriter($entry.Open(), (New-Object Text.UTF8Encoding($false)))
		$sw.Write($attr.ToString()); $sw.Dispose()
	}
}
finally { $zip.Dispose() }
if (Test-Path -LiteralPath $DistZip) { Remove-Item -LiteralPath $DistZip -Force }
Move-Item -LiteralPath $tmpZip -Destination $DistZip
$attr.ToString() | Set-Content -LiteralPath $AttributionPath -Encoding UTF8

# ---- post-build verification ----
Write-Host '   Verifying archive contents...' -ForegroundColor Cyan
$ver = Invoke-ZipVerification $DistZip $planned $effectiveZooms
$vOk = $ver.PngValid; $vBad = $ver.PngInvalid; $vOther = $ver.NonTileEntries
$coverage = $ver.Coverage; $extraZooms = $ver.ExtraZooms
$minLat = $ver.MinLat; $maxLat = $ver.MaxLat; $minLon = $ver.MinLon; $maxLon = $ver.MaxLon
$zipInfo = Get-Item -LiteralPath $DistZip
$zipSizeMb = [Math]::Round($zipInfo.Length / 1MB, 2)
$gaps = ($coverage | Measure-Object -Property Missing -Sum).Sum
$countMatches = ($vOk + $vBad -eq $eligible.Count)
Write-VerificationReport $ver

$validation = [ordered]@{
	generatedUtc   = (Get-Date).ToUniversalTime().ToString('o')
	scriptVersion  = $ScriptVersion
	provider       = $Provider
	zip            = $DistZip
	zipBytes       = $zipInfo.Length
	tileEntries    = $vOk + $vBad
	pngValid       = $vOk
	pngInvalid     = $vBad
	nonTileEntries = $vOther
	sources        = $srcCounts
	coverage       = $coverage
	extraZooms     = $extraZooms
	tilesPerZoom   = $ver.ZoomCounts
	extentLatLon   = [ordered]@{ minLat = $minLat; maxLat = $maxLat; minLon = $minLon; maxLon = $maxLon }
}
($validation | ConvertTo-Json -Depth 6) | Set-Content -LiteralPath $ValidationPath -Encoding UTF8

Write-Host '==========================================================' -ForegroundColor Cyan
$complete = ($vBad -eq 0 -and $countMatches -and $gaps -eq 0 -and -not $downloadAborted)
if ($complete) { Write-Host ' Package Built Successfully!' -ForegroundColor Green }
else { Write-Host ' Package built, but it is INCOMPLETE or has problems (see above).' -ForegroundColor Yellow }
Write-Host " Output File : $DistZip" -ForegroundColor White
Write-Host " File Size   : $zipSizeMb MB ($vOk valid PNG tiles, $vBad invalid)" -ForegroundColor White
Write-Host " Attribution : $AttributionPath" -ForegroundColor White
Write-Host " Validation  : $ValidationPath" -ForegroundColor White
Write-Host '==========================================================' -ForegroundColor Cyan

if ($vBad -gt 0 -or -not $countMatches) { exit 4 }
if (-not $complete) { exit 2 }
exit 0
