# Frequently Asked Questions (FAQ)

### Where do I download Map Enhancer?
Download published releases from the **[GitHub Releases](../../releases)** page, or from **[Nexus Mods #18](https://www.nexusmods.com/railroader/mods/18)**.

### Which Railroader versions are supported?
Map Enhancer 2.0 targets **Railroader 0.6.0+ Experimental** (native C# modding). It is actively tested and verified on Railroader 0.6.0 through 0.6.2+.

### Does Map Enhancer require Unity Mod Manager (UMM)?
**No.** Railroader 0.6 introduced native mod loading. Map Enhancer runs entirely as a native mod located in `Documents\Railroader\Mods\reaper-map-enhancer\`. You do not need to patch game files with UMM.

### Will updating the mod delete my settings or downloaded map tiles?
**No**, as long as you follow the instructions:
- Use **`install.bat`** bundled in the release zip; it automatically backs up and restores `settings.json` and preserves `Backgrounds/` and `Tiles/`.
- If copying manually, choose "Replace files in destination" without deleting the folder. Never delete your `reaper-map-enhancer` directory when updating.

### Can I use Map Enhancer in Multiplayer?
**Yes.** Map Enhancer is client-side safe in multiplayer games. Clients with Map Enhancer can view telemetry, overlays, offline map backgrounds, and use waypoint dispatching.

### Do offline map tiles require an internet connection?
**No.** Once downloaded, all tiles live on your local drive in `Tiles\USGSTopo\` or `Tiles\OSM\`. During gameplay, Map Enhancer makes zero network calls and works completely offline.

### What is the default key to open the map?
The default key to open the map in Railroader is **`M`**. Once open, you can press **`Z`** to toggle between docked and floating maximized map views. To open the Map Enhancer settings window, press **`Ctrl + M`**.

### How do I report a bug or request a feature?
- Open an issue via the [GitHub Bug Report](../../issues/new?template=bug_report.yml) or [Feature Request](../../issues/new?template=feature_request.yml) forms.
- Or chat with the developer and community in the [Official Railroader Discord Thread](https://discord.com/channels/795878618697433097/1212693563738034196).
