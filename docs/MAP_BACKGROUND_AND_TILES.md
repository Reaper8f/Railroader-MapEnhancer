# Map Enhancer — Map Backgrounds & Slippy Tile Overlay Guide

This guide covers the **Map Background & Slippy Tile Streaming Subsystem** in Railroader Map Enhancer (v2.0.16+). It explains how each background mode works, how to configure custom background images and calibration files, and how to install and stream 100% offline USGS Topo and OpenStreetMap tile packs.

---

## Table of Contents

1. [Overview & Background Modes](#1-overview--background-modes)
2. [How to Use in Game](#2-how-to-use-in-game)
3. [Mode 1: Custom Background Image](#3-mode-1-custom-background-image)
   - [File Locations & Supported Formats](#file-locations--supported-formats)
   - [Technical Requirements for Images](#technical-requirements-for-images)
   - [Automatic Track Alignment](#automatic-track-alignment)
   - [Companion JSON Calibration (Optional)](#companion-json-calibration-optional)
4. [Mode 2: Local Slippy Map Tiles (Dynamic Tile Streaming)](#4-mode-2-local-slippy-map-tiles-dynamic-tile-streaming)
   - [How Streaming Works (100% Offline)](#how-streaming-works-100-offline)
   - [Adaptive Zoom Ladder & Pure Hysteresis](#adaptive-zoom-ladder--pure-hysteresis)
   - [Spatial Corridor Trimming & Memory Protection](#spatial-corridor-trimming--memory-protection)
   - [Tile File Structure & Naming Conventions](#tile-file-structure--naming-conventions)
   - [Technical Requirements for Tiles](#technical-requirements-for-tiles)
5. [Pre-Packaged Offline Tiles (Andrews to Sylva Corridor)](#5-pre-packaged-offline-tiles-andrews-to-sylva-corridor)
   - [Automated Downloader (`downloadtiles.bat`)](#automated-downloader-downloadtilesbat)
   - [Manual Download & Verification](#manual-download--verification)
   - [Available Tile Packages](#available-tile-packages)
6. [Frequently Asked Questions & Troubleshooting](#6-frequently-asked-questions--troubleshooting)

---

## 1. Overview & Background Modes

Map Enhancer provides three distinct background rendering modes:

| Mode | Identifier | Description |
| :--- | :---: | :--- |
| **Disabled** | `0` | Standard vanilla Railroader map (plain dark canvas background). |
| **Custom Image** | `1` | Renders a custom image (historical map, aerial orthophoto, or hand-drawn track chart) placed in `Backgrounds/`. Auto-fits to track boundaries or uses millimeter-accurate companion JSON calibration. |
| **Map Tiles** *(Recommended)* | `2` | 100% local slippy map tile streaming subsystem. Dynamically discovers and loads tile packs installed in `Tiles/<Folder>/` (such as `USGSTopo` or `OSM`), or falls back to Railroader's native GIS cache for OSM. Zero network requests are initiated by the mod. |

> [!NOTE]
> **Automatic Settings Migration:** Older configurations using legacy Mode `2` (USGS Topo) or Mode `3` (OpenStreetMap) are seamlessly migrated to Mode `2` (`Map Tiles`) with their respective folder (`USGSTopo` or `OSM`) automatically preserved.

---

## 2. How to Use in Game

1. Launch Railroader and open the in-game Map (**`M`** key).
2. Click **`[ME]`** in the upper-right corner of the map window (or press **`Ctrl+M`**) to open Map Enhancer Settings.
3. In **Section 1: Map Display, Backgrounds & Slippy Tiles**:
   - **Map Background Mode:** Select `Disabled (Default Map)`, `Custom Image`, or `Map Tiles (Local Tile Packs)`.
   - **When Map Tiles is Selected:**
     - **Tile Set Selector:** Choose which tile pack to stream (`USGSTopo`, `OSM`, or any custom folder placed in `Tiles/`).
     - **Provider Info:** Displays total tiles found on disk, supported zoom ranges (e.g. Zooms 12–16 for USGS, Zooms 12–17 for OSM), and status.
     - **Rescan & Reload Tiles Button:** Triggers an asynchronous background disk scan and refreshes the tile grid without interrupting gameplay.
     - **Trim Map to Corridor:** When checked, restricts tile streaming strictly to the active track corridor polygon, saving VRAM.
     - **Corridor Margin:** Configures the spatial buffer around track centerlines ($500\text{m}–10,000\text{m}$, default: $2500\text{m}$).
   - **Background Opacity Slider:** Adjust map opacity from `0%` (fully transparent) to `100%` (fully opaque). Recommended: `40% – 60%` so tracks, turnouts, and rolling stock markers remain prominently legible.
   - **When Custom Image is Selected:**
     - **Reload Custom Background:** Reloads custom image and calibration files from `Backgrounds/`.

---

## 3. Mode 1: Custom Background Image

### File Locations & Supported Formats

Place your background image inside your Railroader mod directory:

```text
Documents\Railroader\Mods\reaper-map-enhancer\Backgrounds\
```

- **Supported Formats:** `.png`, `.jpg`, `.jpeg`
- **File Selection:** If multiple images exist in the folder, Map Enhancer selects the first valid image found (or you can specify the exact filename in `settings.json` under `"MapBackgroundTexture": "my_map.png"`).
- **Fallback:** If `Backgrounds/` is empty, Map Enhancer renders a lightweight procedural backdrop so you know the mode is active.

### Technical Requirements for Images

| Property | Requirement | Recommendation |
| :--- | :--- | :--- |
| **Dimensions** | Power-of-two not required. Up to $8192 \times 8192$ supported. | $4096 \times 2048$ or $8192 \times 4096$ for the entire Murphy Branch corridor. |
| **Aspect Ratio** | Matches the geographic footprint of your map area. | Approx. $2.6 : 1$ (width to height) for the full Andrews $\to$ Sylva operating corridor. |
| **Color Depth** | 8-bit RGB or 8-bit RGBA (32-bit truecolor). | 32-bit PNG with transparency for non-rail terrain borders. |
| **Compression** | Standard PNG or baseline JPEG. | Avoid progressive JPEGs or 16-bit HDR/Float textures. |

### Automatic Track Alignment

If no companion JSON calibration file is found:
- Map Enhancer calculates the 3D bounding box encompassing all active tracks in the game world (`TrackGraph.Instance.Nodes`).
- It applies an automatic $5\%$ border margin and fits your image across the calculated rectangle.
- **Tip:** If your image already tightly bounds the railway network from Andrews (West) to Sylva/Addie (East), auto-fit will immediately align very closely with track geometry.

### Companion JSON Calibration (Optional)

For pixel-perfect geographic alignment, create a JSON file with the **exact same base name** as your image (or named `calibration.json`) in the same `Backgrounds/` folder:

```text
Backgrounds/
├── my_topo_map.png
└── my_topo_map.json
```

#### JSON Calibration Schema:
```json
{
  "_comment": "World coordinates in Railroader engine space (1 unit = 1 meter).",
  "minX": -35387.0,
  "maxX": 29880.0,
  "minZ": -23788.0,
  "maxZ": 10597.0
}
```

#### Field Definitions:
| Field | Type | Unit | Description |
| :--- | :--- | :--- | :--- |
| `minX` | `float` | Meters | Westernmost edge of the image in Railroader world coordinates ($X$). |
| `maxX` | `float` | Meters | Easternmost edge of the image in Railroader world coordinates ($X$). |
| `minZ` | `float` | Meters | Southernmost edge of the image in Railroader world coordinates ($Z$). |
| `maxZ` | `float` | Meters | Northernmost edge of the image in Railroader world coordinates ($Z$). |

> [!NOTE]
> In Railroader, the $X$ axis points East, the $Z$ axis points North, and $Y$ is elevation. The game origin $(0, 0, 0)$ is centered near Ela / Bryson City (Latitude $35.382614^\circ$, Longitude $-83.495407^\circ$).

---

## 4. Mode 2: Local Slippy Map Tiles (Dynamic Tile Streaming)

### How Streaming Works (100% Offline)

When `Map Tiles` mode is active, Map Enhancer renders an active, responsive local slippy map:

1. **Dynamic Active Tile Grid (`sortingOrder = -100`):**
   - Continuously tracks the camera viewport in real-time (`MapBackgroundManager.UpdateCamera`).
   - Uses an active object pool of up to 384 recycled `GameObject` sprite renderers on Unity layer `Layers.Map`.
   - Maintains an in-memory active-aware LRU cache of up to 1,024 decompressed tile textures to ensure smooth panning with zero garbage collection stutter. Active on-screen tiles are never evicted from the cache.
2. **Non-Blanking Zoom Transitions:**
   - Previous zoom tiles remain smoothly displayed underneath while new zoom tiles load in the background, eliminating black flashes or checkerboards during zoom transitions.
3. **Adaptive Texture Upload Budget:**
   - Limits texture uploads to a maximum of 24 tiles per frame within a strict 5ms main-thread frame budget, preventing framerate hitches during rapid camera movement.
4. **Zero Network Calls:**
   - Map Enhancer makes zero network requests. All tiles stream locally from your storage drive.

### Adaptive Zoom Ladder & Pure Hysteresis

As the camera zooms in or out, Map Enhancer automatically transitions between slippy map zoom levels using pure mathematical hysteresis (5% guard band) to prevent jitter:

| Camera Orthographic Size | Slippy Zoom | Ground Resolution | Best For |
| :--- | :---: | :---: | :--- |
| **$< 380\text{ m}$** | **Zoom 17** | $\approx 0.97\text{ m/px}$ | Yard switching, siding turnouts, locomotive/car spotting. |
| **$380\text{ m} – 900\text{ m}$** | **Zoom 16** | $\approx 1.95\text{ m/px}$ | Station districts, industrial branch lines. |
| **$900\text{ m} – 2,200\text{ m}$** | **Zoom 15** | $\approx 3.9\text{ m/px}$ | Mountain subdivisions, gorge passages. |
| **$2,200\text{ m} – 5,500\text{ m}$** | **Zoom 14** | $\approx 7.8\text{ m/px}$ | Multi-town corridor view. |
| **$5,500\text{ m} – 14,000\text{ m}$** | **Zoom 13** | $\approx 15.6\text{ m/px}$ | Broad subdivision corridor view. |
| **$> 14,000\text{ m}$** | **Zoom 12** | $\approx 31.2\text{ m/px}$ | Full route overview covering the entire region. |

### Spatial Corridor Trimming & Memory Protection

By default, an entire map tile is loaded if any portion touches the camera view. For players running on systems with lower VRAM, Map Enhancer provides **Spatial Corridor Trimming**:
- **Trim Map to Corridor:** When enabled in Settings, Map Enhancer computes a 2D spatial polygon encompassing all track centerlines.
- **Corridor Margin:** Expands the bounding box around active tracks by a configurable distance ($500\text{m}–10,000\text{m}$, default: $2500\text{m}$).
- Any tile whose bounding box falls entirely outside this corridor margin is skipped during streaming, eliminating hundreds of unused wilderness tiles from memory.

### Tile File Structure & Naming Conventions

Map Enhancer discovers tile packs dynamically in `Tiles/<FolderName>/`, supporting both hierarchical and flat slippy map naming conventions:

- **Local Provider Folder:**
  `Documents\Railroader\Mods\reaper-map-enhancer\Tiles\<FolderName>\`
  - Hierarchical slippy: `{z}/{x}/{y}.png` or `{z}/{x}/{y}.tile`
  - Flat slippy: `{z}-{x}-{y}.png` or `{z}-{x}-{y}.tile`
- **Native GIS Cache Auto-Discovery (OSM Fallback):**
  If `OSM` is selected, Map Enhancer also automatically discovers and reads validated game tiles from the newest Railroader native GIS session cache:
  `%LOCALAPPDATA%\Temp\Giraffe Lab LLC\Railroader\Map.GIS.Overlay\<SessionId>\`

### Technical Requirements for Tiles

| Property | Requirement |
| :--- | :--- |
| **Tile Dimensions** | Exactly $256 \times 256$ pixels. |
| **Coordinate Projection** | EPSG:3857 (Web Mercator / Spherical Mercator). |
| **File Format** | Standard PNG with valid PNG signature (`89 50 4E 47`). Non-PNG or truncated files are skipped without mutating user disks. |
| **Tile Naming** | `{z}/{x}/{y}.png`, `{z}/{x}/{y}.tile`, or flat `{z}-{x}-{y}.png` / `{z}-{x}-{y}.tile`. |
| **Network Footprint** | **Zero.** Map Enhancer makes 0 network requests; all operations are local disk reads. |

---

## 5. Pre-Packaged Offline Tiles (Andrews to Sylva Corridor)

Two pre-packaged offline tile sets covering the entire Railroader corridor from Andrews to Sylva are officially available:

### Available Tile Packages

| Package | File | Size | Zooms | Tiles | Description | SHA256 Checksum |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| **USGS Topo** | `MapEnhancer_Tiles_USGSTopo_Andrews_to_Sylva.zip` | 692 MB | 12–16 | 6,040 | Authentic Appalachian mountain topography, elevation contours, hydrology, and historical railroad alignments from USGS The National Map (100% US Government Public Domain). | `0539BEFAA157DB5CCAB136FCA0B485EEAD6F0BEED6457AA53EF973F49CFD53F8` |
| **OpenStreetMap** | `MapEnhancer_Tiles_OSM_Andrews_to_Sylva.zip` | 76.5 MB | 12–17 | 23,315 | High-contrast GIS street, river, highway, and yard cartography with razor-sharp switching detail (~0.97 m/px). | `40587516F526027644A593829D23F590A20DFC00280204137C0B72B03322AE5E` |

---

### Automated Downloader (`downloadtiles.bat`)

Every Map Enhancer release ZIP includes **`downloadtiles.bat`**:

1. Close Railroader.
2. Double-click **`downloadtiles.bat`** (located in your mod folder or extracted release ZIP).
3. Select an option from the menu:
   - `[1]` **Download USGS Topographic Corridor Pack** (692 MB)
   - `[2]` **Download OpenStreetMap Corridor Pack** (76.5 MB)
   - `[3]` **Download Both Packs** (~768 MB Total — Recommended)
4. The script automatically downloads the packages from GitHub Releases, validates the cryptographic **SHA256 checksum**, and extracts the tiles into `Tiles\USGSTopo\` and `Tiles\OSM\`.

---

### Manual Download & Verification

If downloading manually from the [GitHub Releases page](../../releases):

1. Download `MapEnhancer_Tiles_USGSTopo_Andrews_to_Sylva.zip` or `MapEnhancer_Tiles_OSM_Andrews_to_Sylva.zip`.
2. Extract the archives into their respective folders:
   ```text
   Documents\Railroader\Mods\reaper-map-enhancer\Tiles\USGSTopo\
   Documents\Railroader\Mods\reaper-map-enhancer\Tiles\OSM\
   ```
3. Inside `Tiles\USGSTopo\`, you should see zoom subfolders (e.g. `12\`, `13\`, `14\`, `15\`, `16\`) or flat tile files.
4. In Railroader, press **`M`** to open the map, press **`Ctrl+M`** to open Settings, set **Map Background** to **`Map Tiles`**, and select your tile set.

---

## 6. Frequently Asked Questions & Troubleshooting

### Q: Does Map Enhancer connect to the internet to download tiles during gameplay?
**A:** No. The Map Enhancer tile subsystem is **100% local-only**. Zero network requests are initiated by the mod during gameplay. Tiles are loaded entirely from local disk files in `Tiles/<Folder>/` or validated native game cache files.

### Q: Why do tiles appear black when I select "Map Tiles"?
**A:**
1. Check that the tile packs are actually extracted into your active mod directory:
   `Documents\Railroader\Mods\reaper-map-enhancer\Tiles\USGSTopo\` or `Tiles\OSM\`
2. In Settings (`Ctrl+M`), click **"Rescan & Reload Tiles"** to force the background tile scanner to re-index the directories.
3. If you use OneDrive, verify that your Documents folder is not keeping the tile files as "cloud-only" stubs; ensure they are marked as "Always keep on this device".

### Q: Can I install both USGS Topo and OpenStreetMap packs at the same time?
**A:** Yes! Extract each pack into its respective folder (`Tiles\USGSTopo\` and `Tiles\OSM\`). In-game, open Settings (`Ctrl+M`) and use the **Tile Set** dropdown to switch between them instantly.

### Q: Why does my custom image look stretched or misaligned?
**A:**
- If using **Auto-fit**, ensure your custom image's outer borders correspond roughly to the extents of the rail network (Andrews in the west, Sylva/Addie in the east).
- If your image has extra margins or non-rail regions, create a companion `.json` file (see [Companion JSON Calibration](#companion-json-calibration-optional)) specifying the exact world meter boundaries.

### Q: How do I remove or hide the background completely?
**A:** Open the map (`M`), press `Ctrl+M` (or click `[ME]`), and set **Map Background Mode** to **`Disabled`**.
