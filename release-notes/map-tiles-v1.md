# Map Enhancer — Offline Map Tile Packs (Andrews to Sylva Corridor)

**Release Tag:** `map-tiles-v1`  
**Coverage:** Andrews to Sylva (100% Rail Corridor Coverage)  
**Operation:** 100% Offline Local Tile Streaming (Zero Network Calls during gameplay)

---

## Requirements

- **Map Enhancer:** Version **2.0.17 or higher** (USGS Topo & OSM work on 2.0.16+)
- **Railroader:** Version **0.6.0+ Experimental** (native C# mod loader)
- **Disk Space:**
  - ~926 MB for **USGS Satellite & Topo**
  - ~692 MB for **USGS Topo**
  - ~76.5 MB for **OpenStreetMap**
  - (~1.65 GB for all three packs installed together)

---

## Included Tile Packages

| Package | Filename | Size | Zoom Range | Tile Count | SHA256 Checksum |
| :--- | :--- | :---: | :---: | :---: | :--- |
| **USGS Satellite & Topo** *(New in v2.0.17)* | `MapEnhancer_Tiles_USGSImageryTopo_Andrews_to_Sylva.zip` | 926 MB | Zooms 12–16 | 6,040 | `E3612DD9F3129684DB65877CD53C08CAF0D1B1147B99D647CF0C058CCD3C74A7` |
| **USGS Topo** | `MapEnhancer_Tiles_USGSTopo_Andrews_to_Sylva.zip` | 692 MB | Zooms 12–16 | 6,040 | `0539BEFAA157DB5CCAB136FCA0B485EEAD6F0BEED6457AA53EF973F49CFD53F8` |
| **OpenStreetMap** | `MapEnhancer_Tiles_OSM_Andrews_to_Sylva.zip` | 76.5 MB | Zooms 12–17 | 23,315 | `40587516F526027644A593829D23F590A20DFC00280204137C0B72B03322AE5E` |

---

## Installation Instructions

### Method 1: Automated Downloader (`downloadtiles.bat`) — Recommended

Every Map Enhancer release bundle includes **`downloadtiles.bat`**:

1. Ensure **Railroader is closed**.
2. Run **`downloadtiles.bat`** (located inside your mod folder or extracted release zip).
3. Select an option from the menu:
   - `[1]` **Download USGS Topographic Corridor Pack** (692 MB)
   - `[2]` **Download OpenStreetMap Corridor Pack** (76.5 MB)
   - `[3]` **Download USGS Satellite & Topo Corridor Pack** (926 MB — *High-resolution NAIP aerial photography + contours & labels*)
   - `[4]` **Download ALL 3 Packs** (~1.65 GB Total — Recommended)
4. The script will automatically download the archives directly from this release, verify their SHA256 cryptographic hashes for corruption-free integrity, and extract all tiles into the appropriate subfolders.

---

### Method 2: Manual Installation

1. Download the tile ZIP archives from the **Assets** section below.
2. Extract the archives into your Map Enhancer `Tiles` directory:
   - **USGS Satellite & Topo Archive:** Extract into:
     ```text
     Documents\Railroader\Mods\reaper-map-enhancer\Tiles\USGSImageryTopo\
     ```
   - **USGS Topo Archive:** Extract into:
     ```text
     Documents\Railroader\Mods\reaper-map-enhancer\Tiles\USGSTopo\
     ```
   - **OpenStreetMap Archive:** Extract into:
     ```text
     Documents\Railroader\Mods\reaper-map-enhancer\Tiles\OSM\
     ```
3. **Steam Deck & Linux (Proton) Path:**
   ```bash
   ~/.steam/steam/steamapps/compatdata/1683150/pfx/drive_c/users/steamuser/Documents/Railroader/Mods/reaper-map-enhancer/Tiles/
   ```
4. Confirm folder structure: inside `Tiles\USGSImageryTopo\`, `Tiles\USGSTopo\`, or `Tiles\OSM\`, you should see tile files (e.g., `12-1093-1615.tile`) or zoom subfolders (`12` through `17`).

---

## In-Game Activation

1. Launch Railroader and load your game save.
2. Press **`M`** to open the map (Railroader default).
3. Press **`Ctrl + M`** (or click the **`[ME]`** button in the top-left toolbar) to open Settings.
4. In Section 1, set **Map Background Mode** to **`Map Tiles (Local Tile Packs)`**.
5. Choose **`USGS Satellite (Imagery & Topo)`**, **`USGS Topo`**, or **`OpenStreetMap`** in the **Tile Set** dropdown.
6. Adjust the **Background Opacity** slider ($40\%–60\%$ recommended).
