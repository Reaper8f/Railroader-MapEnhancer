# Installation & Update Guide

Map Enhancer 2.0 is a native C# mod for **Railroader 0.6.0+ Experimental**. It does not use Unity Mod Manager (UMM) and loads directly via Railroader's built-in native mod loader.

---

## 📦 Official Release Packages

Map Enhancer is distributed in two official release packages:

| Package | Intended For | Contents |
|:---|:---|:---|
| **Complete Package**<br>`reaper-mapenhancer-2.0.16.zip` | Website & GitHub users wanting 1-click automated setup | Mod binaries (`MapEnhancer.dll`, `0Harmony.dll`), marker icons, `Info.json`, plus **`install.bat`** (automated installer/updater) and **`downloadtiles.bat`** (offline tile downloader). |
| **Nexus Mods Edition**<br>`reaper-mapenhancer-2.0.16-nexus.zip` | Nexus Mods downloaders | Clean mod binaries, marker icons, `Info.json`, and guides. Contains **zero batch scripts** to guarantee automated security verification and instant approval. |

---

## ⚠️ Critical: Preserving Settings, Backgrounds & Offline Tiles

When updating Map Enhancer to a newer version:
- **Do NOT delete your existing `reaper-map-enhancer` directory.**
- Deleting the directory will erase:
  - `settings.json` (your custom keybindings, track colors, zoom limits, and alert thresholds).
  - `Backgrounds/` (your custom orthophoto images and calibration JSON files).
  - `Tiles/` (your downloaded offline USGS Topo and OpenStreetMap tile packs).
- Always overwrite existing files or use `install.bat`.

---

## Method 1: Automated 1-Click Installer (Complete Package)

*Included in the **Complete Package** (`reaper-mapenhancer-2.0.16.zip`).*

1. Download the Complete Package from the [Website](https://mapenhancer.refizar.in/download) or [GitHub Releases](../../releases).
2. Extract the archive into any temporary location (e.g. your `Downloads` folder).
3. Ensure **Railroader is completely closed**.
4. Double-click **`install.bat`**.

### What `install.bat` does automatically:
- ✅ Auto-detects your active Railroader Mods folder (including OneDrive document redirection).
- ✅ Detects existing `settings.json` and creates a safe backup.
- ✅ Preserves your custom `Backgrounds/` and offline `Tiles/` folders completely untouched.
- ✅ Deploys updated binaries (`MapEnhancer.dll`), Harmony library, and UI marker assets.
- ✅ Restores your `settings.json` so all preferences remain intact.
- ✅ Cleans up obsolete legacy folders (e.g., `vanguard-map-enhancer`) to prevent duplicate assembly crashes.
- ✅ Offers to launch `downloadtiles.bat` to install offline map tiles if not already present.

---

## Method 2: Manual Installation (Nexus Mods & Complete Packages)

*Works with both the **Nexus Mods Edition** and **Complete Package**.*

1. Close Railroader completely.
2. Navigate to your Railroader Mods folder:
   ```text
   %USERPROFILE%\Documents\Railroader\Mods\reaper-map-enhancer\
   ```
3. *(Optional precaution)* Copy `settings.json` to your desktop as a backup.
4. Extract or copy the mod files directly into `reaper-map-enhancer\`:
   - `MapEnhancer.dll`
   - `0Harmony.dll`
   - `Info.json`
   - Marker assets: `station.png`, `arrow.png`, `flare.png`, `level-crossing.png`, `traincar.png`, `MapEnhancer2.0.png`, `mapenhancer-station-marker.svg`
   - Documentation & notices: `LICENSE`, `THIRD_PARTY_NOTICES.md`, `INSTALL_AND_UPDATE_GUIDE.txt`
   - *(If using Complete Edition)*: `install.bat`, `downloadtiles.bat`
5. When Windows displays the prompt, select **"Replace the files in the destination"**.
6. Verify that an old `Documents\Railroader\Mods\vanguard-map-enhancer` folder does not exist. If present, delete it.

### Required Folder Hierarchy

Ensure files sit directly inside `reaper-map-enhancer\`, not in a double-nested folder:

```text
Documents\Railroader\Mods\reaper-map-enhancer\
├── 0Harmony.dll
├── Info.json
├── MapEnhancer.dll
├── MapEnhancer2.0.png
├── arrow.png
├── flare.png
├── level-crossing.png
├── station.png
├── traincar.png
├── mapenhancer-station-marker.svg
├── settings.json                   (Preserved across updates)
├── Backgrounds\                    (User custom images & calibration)
└── Tiles\                          (Offline tile packs)
    ├── USGSTopo\
    └── OSM\
```

> **Note:** Avoid double-nesting folders (e.g. `reaper-map-enhancer\reaper-map-enhancer\Info.json`). Railroader's native loader scans exactly one folder level deep.

---

## Method 3: Steam Deck & Linux (Proton)

1. Switch your Steam Deck to **Desktop Mode**.
2. Locate the Proton prefix for Railroader (Steam App ID `1683150`):
   ```bash
   ~/.steam/steam/steamapps/compatdata/1683150/pfx/drive_c/users/steamuser/Documents/Railroader/Mods/reaper-map-enhancer/
   ```
   *(Note: If installed on an SD card, check `/run/media/mmcblk0p1/steamapps/compatdata/1683150/...`)*
3. Extract the release ZIP and copy all files into `reaper-map-enhancer/`.
4. Ensure `Info.json` and `MapEnhancer.dll` sit directly in `reaper-map-enhancer/`.
5. Launch Railroader from Steam. Open **Esc > Mods** to verify Map Enhancer is active.

---

## Installing Offline Map Tile Packs

Map Enhancer supports 100% offline local map tile streaming with zero internet requests during gameplay.

### Option A: Automated Tile Downloader (`downloadtiles.bat`)
*Included with Complete Package or available separately from the tools directory.*

1. Inside your mod folder or extracted zip, run **`downloadtiles.bat`**.
2. Select an option:
   - `[1]` **USGS Topographic Corridor Pack** (~692 MB, 6,040 tiles, Zooms 12–16)
   - `[2]` **OpenStreetMap Corridor Pack** (~76.5 MB, 23,315 tiles, Zooms 12–17)
   - `[3]` **Both Packs** (~768 MB Total — Recommended)
3. The script downloads the packs, validates cryptographic SHA256 checksums, and extracts tiles directly into `Tiles\USGSTopo\` and `Tiles\OSM\`.

### Option B: Manual Tile Download (Nexus Mods & Direct Downloaders)
Download tile archives from [GitHub Releases](../../releases) or the [Website](https://mapenhancer.refizar.in/download) and extract them into your mod folder:

- **USGS Topo Archive (`MapEnhancer_Tiles_USGSTopo_Andrews_to_Sylva.zip`):**  
  Extract into: `Documents\Railroader\Mods\reaper-map-enhancer\Tiles\USGSTopo\`  
  *(SHA256: `0539BEFAA157DB5CCAB136FCA0B485EEAD6F0BEED6457AA53EF973F49CFD53F8`)*

- **OpenStreetMap Archive (`MapEnhancer_Tiles_OSM_Andrews_to_Sylva.zip`):**  
  Extract into: `Documents\Railroader\Mods\reaper-map-enhancer\Tiles\OSM\`  
  *(SHA256: `40587516F526027644A593829D23F590A20DFC00280204137C0B72B03322AE5E`)*

### Activating Tiles In-Game
1. In Railroader, press **`M`** to open the map.
2. Press **`Ctrl+M`** (or click the **`[ME]`** button in the upper-right corner) to open Settings.
3. In Section 1, set **Map Background Mode** to **`Map Tiles (Local Tile Packs)`**.
4. Select **`USGSTopo`** or **`OSM`** in the **Tile Set** dropdown.
