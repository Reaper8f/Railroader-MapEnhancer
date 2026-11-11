# Frequently Asked Questions (FAQ)

### Where do I download Map Enhancer?
Download published releases from the **[GitHub Releases](../../releases)** page, the **[Official Website](https://mapenhancer.refizar.in/download)**, or from **[Nexus Mods #18](https://www.nexusmods.com/railroader/mods/18)**.

### What is the difference between the Complete Package and the Nexus Mods Edition?
- **Complete Package (`reaper-mapenhancer-2.0.16.zip`)**: Downloaded from the website or GitHub releases. Contains the full mod files plus **`install.bat`** (automated installer/updater) and **`downloadtiles.bat`** (automated tile downloader).
- **Nexus Mods Edition (`reaper-mapenhancer-2.0.16-nexus.zip`)**: Downloaded from Nexus Mods. Contains the identical game mod binaries, marker textures, and documentation, but **omits all `.bat` scripts**. This ensures instant automated security approval on Nexus Mods without quarantine delays.

### Why does the Nexus Mods edition have no `.bat` scripts?
Nexus Mods' automated security scanners flag archives containing `.bat`, `.cmd`, or script executables and place them in automated quarantine for manual staff review. To give players immediate, instant access to releases without security delays, the Nexus release is provided as a clean archive of binaries and assets.

### How do I install offline map tiles if I downloaded from Nexus Mods?
You have two simple options:
1. **Direct Zip Download:** Download the pre-packaged offline tile zip archives (`MapEnhancer_Tiles_USGSTopo_Andrews_to_Sylva.zip` and/or `MapEnhancer_Tiles_OSM_Andrews_to_Sylva.zip`) directly from the [Official Website](https://mapenhancer.refizar.in/download) or [GitHub Releases](../../releases), and extract them into `reaper-map-enhancer\Tiles\USGSTopo\` or `reaper-map-enhancer\Tiles\OSM\`.
2. **Download Tile Script:** Grab `downloadtiles.bat` from the GitHub repository `tools/` folder, place it in your mod directory, and double-click it.

### Which Railroader versions are supported?
Map Enhancer 2.0 targets **Railroader 0.6.0+ Experimental** (native C# modding). It is actively tested and verified on Railroader 0.6.0 through 0.6.2+.

### Does Map Enhancer require Unity Mod Manager (UMM)?
**No.** Railroader 0.6 introduced native mod loading. Map Enhancer runs entirely as a native mod located in `Documents\Railroader\Mods\reaper-map-enhancer\`. You do not need to patch game files with UMM.

### Will updating the mod delete my settings or downloaded map tiles?
**No**, as long as you follow the instructions:
- Use **`install.bat`** bundled in the Complete release zip; it automatically backs up and restores `settings.json` and preserves `Backgrounds/` and `Tiles/`.
- If copying manually, choose **"Replace the files in the destination"** without deleting the folder. Never delete your entire `reaper-map-enhancer` directory when updating.

### Can I use Map Enhancer in Multiplayer?
**Yes.** Map Enhancer is client-side safe in multiplayer games. Clients with Map Enhancer can view telemetry, overlays, offline map backgrounds, and use waypoint dispatching. If the host has not enabled the mod, replace the client mod entry in `Documents\Railroader\Preferences.json` with:

```json
"clientMods": [
  {
    "identifier": "reaper/map-enhancer",
    "version": "2.0.16",
    "enabled": true,
    "scope": 2
  }
],
```

Keep the surrounding `Preferences.json` structure valid JSON, then start or join the multiplayer session.

### Do offline map tiles require an internet connection?
**No.** Once downloaded, all tiles live on your local drive in `Tiles\USGSTopo\` or `Tiles\OSM\`. During gameplay, Map Enhancer makes zero network calls and works completely offline.

### What is the default key to open the map?
The default key to open the map in Railroader is **`M`**. Once open, you can press **`Z`** to toggle between docked and floating maximized map views. To open the Map Enhancer settings window, press **`Ctrl + M`**.

### How do I report a bug or request a feature?
- Open an issue via the [GitHub Bug Report](../../issues/new?template=bug_report.yml) or [Feature Request](../../issues/new?template=feature_request.yml) forms.
- Or chat with the developer and community in the [Official Railroader Discord Thread](https://discord.com/channels/795878618697433097/1212693563738034196).
