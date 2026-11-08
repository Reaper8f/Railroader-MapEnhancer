# Changelog

All notable public releases of Map Enhancer for Railroader are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Download release packages and view assets on the **[GitHub Releases page](../../releases)**.

---

## [2.0.16] — 2026-11-07

### 100% Local Slippy Map Tiles, Safe Speed Overlay & Freight Dispatch Polish

### Added
- **100% Local Slippy Map Tile Subsystem:** High-performance, multi-resolution pyramid tile streaming for both **USGS Topo** (Zooms 14–16) and **OpenStreetMap** (Zooms 12–17) with zero mod-initiated network requests. Operates completely offline with zero rate-limit, bandwidth, or privacy concerns.
- **Dynamic Provider Auto-Discovery:** In-game dropdown automatically discovers tile packs placed in `Tiles/<Folder>/` (such as `USGSTopo`, `OSM`, or custom user packs) with automatic fallback to native Railroader GIS session caches.
- **Physical Safe Speed Restriction Overlay (INV-026):** Evaluates real-time physical curve geometry (Chord-Deflection formula) and renders a 6-band speed spectrum (Purple $\le 10\text{ mph}$ up to Blue $> 35\text{ mph}$) to prevent train derailments.
- **Spatial Corridor Trimming:** Optional bounding box margin ($500\text{m}–10,000\text{m}$, default $2500\text{m}$) clipping tile streaming strictly to active track corridors to conserve VRAM.
- **Sub-Segment Industry Delivery Slicing:** Calculates normalized start/end offsets for industry delivery TrackSpans, highlighting only actual delivery spots while preserving route coloration on the rest of the segment.
- **Rolling Stock Trim Sliders:** In-game sliders ($0.70–1.00$) for car marker length and width trimming to eliminate end-seam overlap and lateral clipping on closely spaced yard classification tracks.
- **Consist Depth Filing (Shingling) & Zebra Contrast:** Sequential top-down depth layering renders each car over the preceding car's tail, paired with alternating two-tone value shading for instant car counting.
- **Pulsating Equipment Selection Halo:** Pulsating golden highlight for selected rolling stock, with automatic paired highlighting for steam locomotives and coupled tenders.
- **Automated Installer & Tile Downloader Scripts:** Bundled `install.bat` (automated backup/restore of `settings.json` and legacy folder cleanup) and `downloadtiles.bat` (checksum-verified offline tile downloader).
- **Scale Sliders:** Added in-game scaling sliders for upright Track & Yard Signs ($0.2\text{x}–2.0\text{x}$), Turntables ($0.2\text{x}–1.5\text{x}$), and Tooltip Font Sizes ($10–24\text{ pt}$).

### Changed
- **Zero Network Calls:** Tile subsystem operates strictly locally from disk files, eliminating external dependencies and rate limiting.
- **Anti-Jitter Zoom Hysteresis:** Pure mathematical hysteresis (5% guard band) permanently eliminates zoom boundary oscillation and flickering when panning or zooming near threshold camera altitudes.
- **Non-Blanking Zoom Transitions:** Smoothly retains previous zoom tiles underneath until newly requested zoom tiles are $\ge 70\%$ loaded in the background, eliminating black flashes or visual blanks.

### Performance
- **Active-Aware LRU Cache & Object Pooling:** Expanded in-memory texture cache to 1,024 entries with active on-screen protection, 384 recycled sprite renderers on Unity layer `Layers.Map`, and an adaptive 5ms main-thread frame budget (up to 24 tile uploads/frame).
- **Non-Blocking Asynchronous Cataloging:** Moved tile directory inspections to background threads, resolving save-screen and load-time hitching. Added in-game **"Rescan & Reload Tiles"** button.

### Fixed
- **CTC Passing Siding Route Propagation:** Siding BFS route tracing through multi-segment signaled passing sidings ensures intermediate siding segments are correctly classified as Branch Blue rather than Mainline Green.
- **Player Sign Text Orientation Fix:** Corrected vertical and horizontal text mirroring vectors on top-down camera views for player-placed track signs, yard limit boards, and speed restrictions.
- **Settings & Data Preservation:** Packaging and installation pipelines automatically detect and preserve existing user `settings.json`, custom `Backgrounds/`, and offline `Tiles/` folders.

---

## [2.0.15] — 2026-11-04

### Interactive Locomotive Dispatch, Train Car Context Menu & Track Signs

### Added
- **Interactive Locomotive Waypoint Dispatch:** Command AutoEngineer waypoint movements directly from the map screen by holding the dispatch activation key (default: `CapsLock`, fully rebindable) and left-clicking track.
- **Click-to-Couple from Map:** Left-click any railcar while holding the dispatch key to automatically compute bi-directional reachability and route locomotives to the open consist end for a gentle soft joint.
- **Real-Time Visual Route Preview & Diagnostics:** Live animated route line preview while holding the dispatch key, with pulsing red obstruction warnings for blocked tracks or locked switches.
- **Instant Order Cancellation:** Right-click anywhere on the map while holding `CapsLock` to cancel active AutoEngineer waypoint or coupling orders immediately.
- **Train Car Operations Context Menu:** Right-click any railcar on the map to open a dedicated operations menu (Smart Handbrakes, consist handbrakes, bleed air, pipe connect/disconnect, engine reverser/throttle cut).
- **Smart Handbrakes Engine:** Calculates and applies holding handbrakes based on consist tonnage and grade (10% flat, 25% moderate, 50% steep) while safely protecting locomotives and tenders from brake dragging.
- **Track & Yard Signs on Map:** Place mileposts, speed restrictions, whistle posts, yard limits, and flares directly from the map with live color-coded badges and click-to-edit integration.

### Changed
- Rebindable keybindings reorganized in settings window: `M` (Railroader native open/close), `Z` (maximize/float view), `Shift+Z` (camera follow car), `Ctrl+Z` (recenter on player), `Ctrl+M` (Map Enhancer settings).

### Fixed
- **Zero-Flashbang Map Rendering:** Eliminated full-screen cyan flash artifacts when placing waypoints by isolating overlay canvas passes.
- **Player Sign Text Mirroring:** Resolved 90-degree tilt and horizontal text mirroring on top-down camera views for placed track and yard signs.

### Performance
- Added typography scaling sliders in settings for Train Hover Tooltip and Context Menu elements.

---

## [2.0.14] — 2026-11-02

### Railroader 0.6.0+ Experimental Compatibility & Telemetry Overhaul

### Added
- **Railroader 0.6.0+ & 0.6.1 Experimental Compatibility:** Verified native C# mod loading and engine hook stability.
- **Real-Time Car Telemetry Overlays:** Apex-anchored switch stand chevrons and consist telemetry.
- **Vector Station Markers:** Station depot badges displaying live directional passenger counts ("Up / Down" waiting destinations).

### Performance
- **Analytical SDF Pipeline:** Shader pipeline with zero low-zoom artifacts and $O(1)$ cached lookup structures.

### Security & Licensing
- Bundled proprietary End-User License Agreement granting full personal entertainment rights.

---

## [2.0.13] — 2026-11-01

### Mainline Engine Optimization & Siding Isolation

### Added
- **Multi-Tier Mainline Detection Engine:** Replaces naive CTC block span search with Timetable corridor pathfinding (+50m diverging switch penalties) across the Great Smoky Mountains network.

### Fixed
- **INV-020 East Whittier Siding Fix:** Correctly isolates the 25 mph MOW siding chord from the 45 mph mainline bypass.
- **Category Isolation:** Prevents connected-track BFS expansion from misclassifying ordinary route trackage as Maintenance of Way.

---

## [2.0.12] — 2026-10-31

### Dark Territory Mainline Discovery

### Added
- **Timetable Corridor Routing:** Traces continuous mainline through dark territory gaps between consecutive station pairs (Sylva–Whittier, Bryson–Andrews).

### Fixed
- Resolved dark-territory corridor segments falling back to blue branchline classification.

### Performance
- Added atomic `_isExecuting` re-entrancy locks preventing `StackOverflowException` during rapid world loading and track graph rebuilding.

---

## [2.0.3] — 2026-10-30

### SDF Quad Shading & Station Intelligence

### Added
- **Custom Station Marker Assets:** 128×128 gold-rimmed station marker assets with directional passenger breakdown ("Up: 12 towards Andrews").
- **Lateral HOPA Operational Badges:** Warning badges (Hotbox, Oil, Handbrake, Air Leak) anchored to the flank of defective equipment with screen-upright rotation.
- **Dynamic Settings Panel:** Integrated 10-section configuration UI accessible in-game via `Ctrl+M` or the `[ME]` map toolbar button.

### Fixed
- **SDF White Background Clearing:** 0.5-texel UV insets permanently eliminating low-zoom ghost dotted lines.

---

## [2.0.0] — 2026-10-28

### Map Enhancer 2.0 Native Modernization

### Added
- **Native Railroader 0.6+ Architecture:** Complete migration from legacy Unity Mod Manager (UMM) to Railroader's native C# 9.0 (.NET Framework 4.7.2) modding pipeline.
- **Centralized Operational Overlays:** Unified overlay framework supporting Routes, Grade Slopes, FRA Track Classes (0 through 5), Track Condition, and Ballast Cleanliness.
- **Dynamic Track Gradient Analysis:** Quantized 0.5% slider steps and 5-tier slope color bands.
- **Turntable Safety Clearance:** Prevents turntable bridge rotation if cars foul lead tracks.
- **Consist Telemetry HUD:** Gross tonnage, speed, passenger destinations, fuel levels, and waybill summaries on hover.
