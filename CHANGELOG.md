# Changelog

All notable public releases of Map Enhancer are documented in this file.

Download release packages and view assets on the **[GitHub Releases page](../../releases)**.

---

## [2.0.16] — 2026-11-06

### Added
- **Dynamic Slippy Map Tile Streaming:** 100% local, offline multi-resolution pyramid tile streaming subsystem for both **USGS Topo** (Zooms 12–15) and **OpenStreetMap** (Zooms 12–17).
- **In-Game Tile Set Selector & Hot Reload:** Dynamically detects any custom tile folder in `Tiles/<Folder>/`, plus a one-click **"Rescan & Reload Tiles"** button.
- **Corridor Trimming & Margins:** Optional polygon bounding box margin ($500\text{m}–10,000\text{m}$) clipping tile loading strictly to track corridors.
- **Curvature Safe Speed Overlay (INV-026):** Physics-based track curve radius analysis rendering safe speed bands (Purple $\le 10\text{ mph}$ up to Blue $> 35\text{ mph}$) to prevent derailments.
- **CTC Passing Siding Route Propagation:** Breadth-First-Search (BFS) route propagation correctly identifying multi-segment sidings as Branch Blue rather than Mainline Green.
- **Sub-Segment Industry Delivery Slicing:** Accurate sub-segment interval rendering so only the precise delivery spot is colored, leaving through-tracks uncolored.
- **Rolling Stock Trim & Alternating Shading:** Sliders for car marker length trim ($0.80–1.00$) and width trim ($0.70–1.00$) with alternating two-tone consist shading.
- **Automated Installer & Tile Downloader Scripts:** Bundled `install.bat` (automated backup/restore of `settings.json` and legacy folder cleanup) and `downloadtiles.bat` (checksum-verified offline tile downloader).
- **Scale Sliders:** Added scaling sliders for upright Track & Yard Signs ($0.2\text{x}–2.0\text{x}$), Turntables ($0.2\text{x}–1.5\text{x}$), and Tooltip Font Sizes ($10–24\text{ pt}$).

### Changed
- **Zero Network Calls:** Tile subsystem is completely offline, eliminating rate limits and external tracking.
- **Pure Mathematical Hysteresis (5% Guard Band):** Eliminates zoom boundary flickering when panning or zooming near threshold camera sizes.
- **Non-Blanking Zoom Transitions:** Keeps current zoom tiles visible while new zoom tiles load asynchronously in the background.
- **Active-Aware LRU Texture Cache:** Expanded texture cache to 1,024 items with recycled GameObject pool of 384 renderers.
- **Adaptive Texture Upload Budget:** Throttled to max 24 tiles per frame within a strict 5ms main-thread frame budget for silky 60+ FPS performance.

### Fixed
- Fixed save-screen and load-time hitching by moving tile folder indexing to background threads.
- Fixed legacy folder conflicts by automatically warning/migrating old settings from `vanguard-map-enhancer`.
- Fixed track line thickness persistence and grade overlay legend toggle synchronization.

---

## [2.0.15] — 2026-10-20

### Added
- **Tactical Waypoint Navigation:** Hold `CapsLock` to display precision targeting crosshair; click any track location to dispatch locomotives with AutoEngineer pathfinding.
- **Click-to-Couple Automation:** Hold `CapsLock` and click any stationary car; automatically lines up path, matches coupler end, and executes gentle soft joint.
- **Live Coupling Ribbon & Obstruction Warning:** Dynamic route preview line tracing path from locomotive to target, pulsing red when blocked or switch-locked.
- **Rolling Stock Operations Context Menu:** Right-click any car on the map to access Smart Handbrakes, consist brake controls, trainline air controls, and throttle/reverser cuts.
- **Smart Handbrakes (Grade-Calibrated):** Automatic calculation of grade-holding brakes (10%, 25%, 50%) protecting engines and tenders from handbrake dragging.
- **HOPA Defect Alerts Window:** Consolidated rolling stock defect monitor tracking Hotboxes, Low Oil, Dragging Handbrakes, Air Leaks, and Derailments.

### Changed
- Refactored camera follow and maximization keybindings to eliminate conflict with native game map controls (<kbd>M</kbd> native open, <kbd>Z</kbd> maximize/float).

---

## [2.0.0] — 2026-09-15

### Added
- **Complete Railroader 0.6 Native Port:** Full native C# mod implementation loaded from `Documents\Railroader\Mods\reaper-map-enhancer\`, removing Unity Mod Manager dependency.
- **Centralized Map Overlays:** Unified overlay framework supporting Routes, Grade Slopes, FRA Track Classes, Track Condition, and Ballast Cleanliness.
- **Turntable Safety Clearance:** Prevents bridge rotation if cars foul lead tracks.
- **Hover Cargo & Telemetry HUD:** Gross tonnage, speed, passenger destinations, fuel levels, and waybill summaries on map hover.
