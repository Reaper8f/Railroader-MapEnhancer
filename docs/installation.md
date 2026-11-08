# Installation & Update Guide

Map Enhancer 2.0 is a native C# mod for **Railroader 0.6.0+ Experimental**. It does not use Unity Mod Manager (UMM) and loads directly via Railroader's built-in mod loader.

---

## ⚠️ Critical: Preserving Settings, Backgrounds & Offline Tiles

When updating Map Enhancer to a newer version:
- **Do NOT delete your entire `reaper-map-enhancer` directory.**
- Deleting the directory will erase:
  - `settings.json` (your custom keybindings, track colors, zoom limits, and alert thresholds).
  - `Backgrounds/` (your custom orthophoto images and calibration JSON files).
  - `Tiles/` (your downloaded offline USGS Topo and OpenStreetMap tile packs).

---

## Method 1: Automated 1-Click Installer (Windows) — Recommended

Every official release ZIP package includes **`install.bat`** and **`downloadtiles.bat`**.

1. Download `reaper-mapenhancer-2.x.x.zip` from [GitHub Releases](../../releases) or [Nexus Mods](https://www.nexusmods.com/railroader/mods/18).
2. Extract the archive into any temporary location (e.g., your `Downloads` folder).
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

## Method 2: Manual Installation (Windows)

If you prefer installing manually:

1. Close Railroader.
2. Navigate to your Railroader Mods folder:
   ```text
   %USERPROFILE%\Documents\Railroader\Mods\reaper-map-enhancer\
   ```
3. *(Optional precaution)* Copy `settings.json` to your desktop as a backup.
4. Copy the new files from the release ZIP into `reaper-map-enhancer\`:
   - `MapEnhancer.dll`
   - `0Harmony.dll`
   - `Info.json`
   - Image assets: `station.png`, `arrow.png`, `flare.png`, `level-crossing.png`, `traincar.png`, `MapEnhancer2.0.png`, `mapenhancer-station-marker.svg`
   - Scripts: `install.bat`, `downloadtiles.bat`, `INSTALL_AND_UPDATE_GUIDE.txt`
   - Notices: `LICENSE`, `THIRD_PARTY_NOTICES.md`
5. When Windows displays the prompt, select **"Replace the files in the destination"**.
6. Verify that an old `Documents\Railroader\Mods\vanguard-map-enhancer` folder does not exist. If present, delete it.

---

## Method 3: Steam Deck & Linux (Proton)

1. Switch your Steam Deck to **Desktop Mode**.
2. Locate the Proton prefix for Railroader (Steam App ID `1683150`):
   ```bash
   ~/.steam/steam/steamapps/compatdata/1683150/pfx/drive_c/users/steamuser/Documents/Railroader/Mods/reaper-map-enhancer/
   ```
   *(Note: If installed on an SD card, check `/run/media/mmcblk0p1/steamapps/compatdata/1683150/...`)*
3. Extract the release ZIP and copy all files into `reaper-map-enhancer/`.
4. Ensure `Info.json` and `MapEnhancer.dll` sit directly in `reaper-map-enhancer/`, not in a nested subfolder.
5. Launch Railroader from Steam. Open **Esc > Mods** to verify Map Enhancer is enabled.

---

## Downloading Offline Map Tile Packs

Map Enhancer supports 100% offline local map tile streaming with zero internet requests during gameplay.

### Option A: Automated Tile Downloader (`downloadtiles.bat`)
1. Inside your mod folder or extracted zip, run **`downloadtiles.bat`**.
2. Select an option:
   - `[1]` **USGS Topographic Corridor Pack** (~574 MB, 5,101 tiles, Zooms 14–16)
   - `[2]` **OpenStreetMap Corridor Pack** (~76.5 MB, 23,315 tiles, Zooms 12–17)
   - `[3]` **Both Packs** (~650 MB Total — Recommended)
3. The script downloads the packs, validates cryptographic SHA256 checksums, and extracts tiles into `Tiles\USGSTopo\` and `Tiles\OSM\`.

### Option B: Manual Tile Download
Download tile archives from [GitHub Releases](../../releases) and extract them:
- **USGS Topo Archive:** Extract into `Documents\Railroader\Mods\reaper-map-enhancer\Tiles\USGSTopo\`  
  *(SHA256: `F6B4499A2D4F301BAFD108525415E53B6026396DC5B2DC3252D334864D31BE99`)*
- **OpenStreetMap Archive:** Extract into `Documents\Railroader\Mods\reaper-map-enhancer\Tiles\OSM\`  
  *(SHA256: `40587516F526027644A593829D23F590A20DFC00280204137C0B72B03322AE5E`)*

### Activating Tiles In-Game
1. In Railroader, press **`M`** to open the map.
2. Press **`Ctrl+M`** (or click the **`[ME]`** button in the upper-right corner) to open Settings.
3. In Section 1, set **Map Background Mode** to **`Map Tiles (Local Tile Packs)`**.
4. Select **`USGSTopo`** or **`OSM`** in the **Tile Set** dropdown.
