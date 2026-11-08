# Map Enhancer for Railroader

[![Railroader](https://img.shields.io/badge/Railroader-0.6.0%2B%20Experimental-blue.svg)](https://store.steampowered.com/app/1683150/Railroader/)
[![Latest Release](https://img.shields.io/github/v/release/Reaper8f/railroader-mapenhancer?color=emerald&label=Release)](https://github.com/Reaper8f/railroader-mapenhancer/releases)
[![Official Website](https://img.shields.io/badge/Website-mapenhancer.refizar.in-sky.svg)](https://mapenhancer.refizar.in)
[![Nexus Mods](https://img.shields.io/badge/Nexus%20Mods-Mod%2018-amber.svg)](https://www.nexusmods.com/railroader/mods/18)
[![Discord Thread](https://img.shields.io/badge/Discord-Official%20Thread-indigo.svg)](https://discord.com/channels/795878618697433097/1212693563738034196)

**Map Enhancer** is an advanced operational mapping, dispatching, and telemetry suite for **[Railroader](https://store.steampowered.com/app/1683150/Railroader/)** (native C# mod for Railroader 0.6.0+).

This repository is the **official public project hub** — home to releases, documentation, issue tracking, and roadmap planning.

> **Official Website & Docs:** [mapenhancer.refizar.in](https://mapenhancer.refizar.in)  
> **Interactive Web Map:** [railroadermap.refizar.in](https://railroadermap.refizar.in/)  
> **Nexus Mods:** [Nexus Mods #18](https://www.nexusmods.com/railroader/mods/18)  
> **Maintainer:** [Reaper8f](https://github.com/Reaper8f) | *Original Author:* Michael Richer [(Vanguard)](https://github.com/mricher-git)

---

## Key Features

- **Dynamic Operational Overlays:** Seamlessly toggle between 6 live track visual overlays:
  - **Routes:** Full color-coded track hierarchy (Mainline, Branch, Industrial Spurs, Passenger, Unreachable, Maintenance of Way).
  - **Grade (%):** Quantized elevation slope banding with directional slope arrows and hover gradient HUD.
  - **Curvature Safe Speed:** Live safe speed limits calculated from track curve radii (Chord-Deflection physics).
  - **TrackClass:** FRA safety track classes (Excepted through Class 5) with speed limit styling.
  - **Condition & Cleanliness:** Real-time track maintenance wear and ballast weed telemetry.
- **Offline Slippy Map Backgrounds:** Stream authentic 100% offline multi-resolution map tiles with zero network requests:
  - **USGS Topo Pack:** Authentic Appalachian mountain contours, hydrology, elevations, and historical rights-of-way from USGS The National Map.
  - **OpenStreetMap Pack:** Crisp GIS vector roads, waterways, rail yards, and towns.
  - **Custom Calibration:** Support for high-res orthophotos and companion `calibration.json`.
- **Interactive Locomotive Dispatch:** Hold `CapsLock` and left-click any track segment or car marker to dispatch selected locomotives with automatic route pathfinding, real-time coupling ribbons, and automatic handbrake release.
- **Smart Handbrakes & Context Menu:** Right-click any rolling stock marker to calculate grade-calibrated holding brakes (10%, 25%, 50%), bleed reservoirs, connect air, or cut throttle/reverser from the map.
- **HOPA Operational Alerts:** Dedicated rolling stock alert monitoring for Hotboxes, Low Lubricating Oil, Dragging Handbrakes, Train Line Air Leaks, and In-Motion Derailments with on-map warning badges.
- **Turntable Stepper & Clearance:** Rotate turntable bridges in precise increments (`Ctrl+Click`, `Alt+Click`, `Ctrl+Shift+Click`) with automatic fouling clearance protection preventing derailments.
- **Live Consist & Cargo Telemetry:** Hover train markers to view gross tonnage, velocity, passenger destinations, fuel reserves (coal/water/diesel), and individual car waybills.

---

## Documentation

- **[Installation Guide](docs/installation.md)** — Step-by-step setup for Windows & Steam Deck / Linux Proton, safe updates, and tile pack installation.
- **[Feature Catalog](docs/features.md)** — In-depth overview of all subsystems, map overlays, and operational tools.
- **[Configuration Reference](docs/configuration.md)** — Complete breakdown of all 10 in-game settings tabs, sliders, toggles, and rebindable hotkeys.
- **[Map Backgrounds & Slippy Tiles Guide](docs/MAP_BACKGROUND_AND_TILES.md)** — Comprehensive guide to offline tile streaming (USGS Topo & OSM), custom calibration, and downloader scripts.
- **[Troubleshooting & Diagnostics](docs/troubleshooting.md)** — Log inspection (`Player.log`), common error fixes, and conflict resolution.
- **[Frequently Asked Questions (FAQ)](docs/faq.md)** — Answers to common community questions.
- **[Changelog](CHANGELOG.md)** — Detailed version history and release notes.
- **[Development Roadmap](roadmap/README.md)** — Current priorities and upcoming milestones.

---

## Downloads

Download compiled mod releases and optional tile packs directly from the **[GitHub Releases](../../releases)** page, the **[Official Website](https://mapenhancer.refizar.in/download)**, or **[Nexus Mods](https://www.nexusmods.com/railroader/mods/18)**:

| Package | Content | Size |
|---|---|---|
| **`reaper-mapenhancer-2.0.16.zip`** *(Complete Edition)* | Full mod binaries (`MapEnhancer.dll`), Harmony, UI assets, `install.bat`, and `downloadtiles.bat` | ~1.8 MB |
| **`reaper-mapenhancer-2.0.16-nexus.zip`** *(Nexus Mods Edition)* | Clean mod binaries, Harmony, UI assets, and guides (zero `.bat` scripts for instant security clearance) | ~1.8 MB |
| **`MapEnhancer_Tiles_USGSTopo_Andrews_to_Sylva.zip`** | 100% offline USGS Topographical corridor tiles (Zoom 12–16) | 692 MB |
| **`MapEnhancer_Tiles_OSM_Andrews_to_Sylva.zip`** | 100% offline OpenStreetMap corridor tiles (Zoom 12–17) | 76.5 MB |

> **Automated Setup Scripts:** The Complete Edition zip bundle includes `install.bat` (automated mod installer and updater preserving user settings) and `downloadtiles.bat` (automated tile pack downloader and extractor). The Nexus Mods Edition provides the clean binaries without batch scripts.

---

## Support & Community

- **Bug Reports:** Open an issue via the [Bug Report form](../../issues/new?template=bug_report.yml).
- **Feature Requests:** Submit an idea via the [Feature Request form](../../issues/new?template=feature_request.yml).
- **Compatibility Reports:** Report mod compatibility via the [Compatibility form](../../issues/new?template=compatibility_report.yml).
- **Discord:** Chat with the community in the [Official Railroader Map Enhancer Thread](https://discord.com/channels/795878618697433097/1212693563738034196) or [Reaper8f's Discord](https://discord.refizar.in).
- **Nexus Mods:** Join discussions and post feedback on [Nexus Mods #18](https://www.nexusmods.com/railroader/mods/18).

Please search existing issues before opening a new one, and avoid posting unredacted logs with personal credentials or system paths.

---

## Repository Scope

This public repository is the community distribution and issue-tracking hub for Map Enhancer. It contains public documentation, release distribution assets, and issue templates. It does **not** contain the private C# mod source code, build toolchain, website backend source, or private operational credentials.
