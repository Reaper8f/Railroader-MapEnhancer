# Troubleshooting & Diagnostics Guide

This guide covers common issues, log diagnostics, and solutions for Map Enhancer 2.0 in Railroader 0.6+.

---

## Log File Locations

Railroader writes its runtime log to `Player.log`. If you experience a crash, missing UI, or mod error, this file contains the relevant stack traces.

### Windows:
```text
%USERPROFILE%\AppData\LocalLow\Giraffe Lab LLC\Railroader\Player.log
```
*(Press `Win + R`, paste the path above, and press Enter).*

### Steam Deck & Linux (Proton):
```bash
~/.steam/steam/steamapps/compatdata/1683150/pfx/drive_c/users/steamuser/AppData/LocalLow/Giraffe Lab LLC/Railroader/Player.log
```

### Inspecting Recent Mod Logs (PowerShell):
```powershell
Get-Content "$env:USERPROFILE\AppData\LocalLow\Giraffe Lab LLC\Railroader\Player.log" -Tail 100
```

### Filtering Map Enhancer Messages:
```powershell
Select-String -Path "$env:USERPROFILE\AppData\LocalLow\Giraffe Lab LLC\Railroader\Player.log" -Pattern "MapEnhancer|ModAssembly|TypeLoad|Harmony"
```

---

## Common Issues & Solutions

### 1. Mod Does Not Appear in Game (Esc > Mods)
- **Symptom:** You unzipped the release, but Map Enhancer does not appear anywhere in Railroader's in-game mod list.
- **Cause:** Double-nested folder created during extraction (e.g. `Mods\reaper-map-enhancer\reaper-map-enhancer\Info.json`). Railroader only scans one directory deep.
- **Fix:** Open `Documents\Railroader\Mods\reaper-map-enhancer\` and ensure `Info.json` and `MapEnhancer.dll` sit directly inside it.

### 2. Game Crashes on Startup or "Multiple Copies of Mod Loaded"
- **Symptom:** Railroader crashes during initial mod load or displays duplicate Harmony patch warnings.
- **Cause:** An obsolete older version folder (such as `vanguard-map-enhancer` from v1.5 or UMM days) is still present alongside `reaper-map-enhancer`.
- **Fix:** Delete `Documents\Railroader\Mods\vanguard-map-enhancer\`. Railroader 0.6 uses `reaper-map-enhancer\`.

### 3. Pressing 'M' Does Not Open Map or [ME] Toolbar Missing
- **Symptom:** Pressing `M` does not open the map, or the top-right `[ME]` settings button is absent.
- **Cause:** Mod is disabled in Railroader's mod menu, or an input dialog currently has focus.
- **Fix:** Press `Esc > Mods` and ensure Map Enhancer has a green checkmark. Press `Ctrl + M` to test opening the settings window directly. If the map opens but is docked, press `Z` to maximize or float the view.

### 4. Slippy Map Background Appears as Solid Black
- **Symptom:** You selected "Map Tiles (Local Tile Packs)" in settings, but the background under your tracks is black.
- **Cause:** Tile packs have not been downloaded, or were extracted into the wrong subfolder.
- **Fix:**
  1. Run `downloadtiles.bat` inside your mod directory to download the packs automatically.
  2. If installing manually, verify tiles are extracted into:
     - `Documents\Railroader\Mods\reaper-map-enhancer\Tiles\USGSTopo\14\` ...
     - `Documents\Railroader\Mods\reaper-map-enhancer\Tiles\OSM\12\` ...
  3. In Settings (`Ctrl+M`), click **"Rescan & Reload Tiles"**.

### 5. Waypoint Dispatch Doesn't Respond
- **Symptom:** Holding `CapsLock` does not show the crosshair cursor or clicking track does nothing.
- **Cause:** You must first have a **locomotive or train selected** on the map before dispatching.
- **Fix:** Left-click your locomotive icon on the map first. Then hold `CapsLock` — the crosshair cursor will appear. Click destination track to dispatch, or hold `CapsLock` and right-click to cancel.

---

## Still Experiencing an Issue?

If your problem is not covered in this guide, report the issue through our official community channels:

1. **[GitHub Issues](https://github.com/Reaper8f/railroader-mapenhancer/issues)** — Open a formal bug report.
2. **[Nexus Mods Bug Tracker](https://www.nexusmods.com/railroader/mods/18?tab=bugs)** — Submit feedback on Nexus Mods.
3. **[Official Railroader Discord Thread](https://discord.com/channels/795878618697433097/1212693563738034196)** — Get live community troubleshooting support.

### What to include in your report:
- Exact Railroader version (e.g. `0.6.2 Experimental`)
- Map Enhancer version (e.g. `v2.0.16`)
- Relevant error snippet or stack trace from `Player.log`
- Steps to reproduce the issue
- List of other installed mods
