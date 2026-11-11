# Map Enhancer for Railroader — Comprehensive Features Guide

**Target Game Version:** Railroader 0.6.0+ Experimental  
**Current Mod Version:** v2.0.17  
**Package:** `reaper-mapenhancer-2.0.17.zip`  
**Official Website:** [https://mapenhancer.refizar.in](https://mapenhancer.refizar.in)  
**My Discord:** [https://discord.refizar.in](https://discord.refizar.in)  
**RailRoader Discord:** [https://discord.gg/r8xeTPAnhw](https://discord.gg/r8xeTPAnhw)
**Nexus Mods:** [https://www.nexusmods.com/railroader/mods/18](https://www.nexusmods.com/railroader/mods/18)  
**Official Discord Thread:** [Map Enhancer Thread](https://discord.com/channels/795878618697433097/1212693563738034196)

---

## 🌟 Overview

**Executive Summary.** _Map Enhancer 2.0 (ME2.0)_ is the next-generation overhaul of the classic Railroader Map Enhancer mod. It builds on the original **Vanguard** mod (Map Enhancer v1.x) and the community-maintained v1.5.x fork (by Reaper8f) by reimplementing, modernizing, and extending core features for Railroader 0.6+ (the “MOW” expansion).

**Map Enhancer** turns Railroader’s in-game map into a powerful dispatching and navigation platform. From managing local freight operations to coordinating a busy multiplayer railroad, it provides the tools to stay informed and in control — with real-time train telemetry, interactive dispatching, track condition monitoring, 6 centralized map overlays, topographic background tile streaming, customizable track colors, precise siding detection, and deep mechanical diagnostics.

### 🏷️ Feature Lineage & Classification Legend

To clearly identify the historical origins and evolution of each capability across releases:

- **Inherited `[Vanguard]`** — Originated in the original Vanguard Map Enhancer mod (v1.0.0 – v1.4.0).
- **Fork Enhancement `[Reaper8f Fork]`** — Added or improved in the Reaper8f community fork (v1.5.0 – v1.5.6).
- **ME2.0 New / Overhaul `[ME2.0]`** — Reimplemented, modernized, or introduced specifically for Railroader 0.6+ native modding (v2.0.0 – v2.0.17).
- **Status Indicators:**
  - ✅ **Active** — Fully implemented, ported, and verified in current Railroader 0.6+ builds.
  - 🧪 **Experimental** — Active in code and functional, undergoing community feedback.
  - 📋 **Planned** — Under design or API investigation for future releases.

> [!NOTE]
> **Architecture Distinction:** Map Enhancer 2.0 targets Railroader 0.6.0+ Experimental as a native C# mod loaded directly from `Documents\Railroader\Mods\reaper-map-enhancer\`. It operates independently of the legacy Unity Mod Manager (UMM) framework, with custom Harmony patches and complete integration into 0.6 native track, MOW, and map rendering engines.

---

## 📋 Feature Contents

1. [Tactical Map Dispatching & Waypoint Navigation](#1-tactical-map-dispatching--waypoint-navigation)
2. [Rolling Stock Operations & Context Menu](#2-rolling-stock-operations--context-menu)
3. [Topographic Backgrounds & Map Tile Streaming](#3-topographic-backgrounds--map-tile-streaming)
4. [Centralized Map Overlays & Safety Filters](#4-centralized-map-overlays--safety-filters)
5. [Intelligent Track Classification & Siding Accuracy](#5-intelligent-track-classification--siding-accuracy)
6. [Rolling Stock & Freight Cargo Intelligence](#6-rolling-stock--freight-cargo-intelligence)
7. [Rolling Stock Mechanical Defect Alerts (HOPA)](#7-rolling-stock-mechanical-defect-alerts-hopa)
8. [Passenger Operations & Station Intelligence](#8-passenger-operations--station-intelligence)
9. [Turntable Controls, Crossings & Trackside Assets](#9-turntable-controls-crossings--trackside-assets)
10. [Switch Controls, CTC Locks & Quick Switch Reset](#10-switch-controls-ctc-locks--quick-switch-reset)
11. [Camera Navigation, Windowing & Zoom](#11-camera-navigation-windowing--zoom)
12. [Performance, Rendering & Marker Optimization](#12-performance-rendering--marker-optimization)
13. [In-Game Settings & Keybinding Customization](#13-in-game-settings--keybinding-customization)
14. [Diagnostics, Logging & Multiplayer Audit Trail](#14-diagnostics-logging--multiplayer-audit-trail)
15. [Master Feature Matrix & Lineage Comparison](#15-master-feature-matrix--lineage-comparison)
16. [Historical Release Milestones & Version History](#16-historical-release-milestones--version-history)
17. [Contributors, Credits & Repositories](#17-contributors-credits--repositories)
18. [Installation & Setup](#18-installation--setup)

---

## 1. Tactical Map Dispatching & Waypoint Navigation

Dispatch trains, spot railcars, and manage movements directly from your dispatch map without having to walk over to the locomotive or switch to 3D cab view.

### 1.1 Click-to-Dispatch Waypoints `[ME2.0 v2.0.15]`

- **How to Use:**
  1. Select your active locomotive or train on the map.
  2. Hold the dispatch key (default: `CapsLock`, customizable in settings). A precision targeting crosshair appears over your cursor.
  3. Left-click anywhere on the target track to send your train to that spot.
- **Automatic Routing:** The train calculates the shortest clear route, lines up the movement, and engages AutoEngineer to drive smoothly to the destination.
- **Active Path Display:** When a dispatched train is selected, its planned route lights up across all switches and corridors.

<p align="center">
  <img width="451" height="369" alt="Target Pointer HUD" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-CreateWaypoint.png" />
  <br><em>Hold CapsLock to acquire the precision targeting crosshair.</em>
</p>

<p align="center">
  <img width="478" height="347" alt="Waypoint Destination Click" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-ViewSelectedLocoWaypoint.png" />
  <br><em>Click on any track to dispatch your engineer to that location.</em>
</p>

### 1.2 Intelligent Click-to-Couple Consist Automation `[ME2.0 v2.0.17]`

- **How to Use:** Hold `CapsLock` and left-click on any stationary railcar or consist on the map.
- **Coupling-Point Awareness & Occupancy Checks:** Inspects both couplers (`End A` and `End B`) of the target car and never routes into an already occupied coupling point.
- **Dynamic Route Planning & Run-Arounds:** Evaluates actual track distance and switch connectivity. If the direct facing end is blocked by another coupled car, the planner automatically routes the locomotive past the target through available switches/turnouts to reverse and approach the open coupling end.
- **Soft Joint & Coupling:** AutoEngineer drives smoothly along the calculated approach, stops at safe coupling distance, and couples automatically.

### 1.3 Live Route Preview, Toggle Keybind & Target HUD `[ME2.0 v2.0.17]`

- **Route Line:** While holding the dispatch key (or toggled active), an animated route preview ribbon traces the real-time path between your locomotive and the cursor.
- **Configurable Route Preview Keybind:** Includes a dedicated settings toggle and customizable shortcut key (`routePreviewToggle`) to turn route previews on/off anytime.
- **Target Info:** A floating cursor readout displays target distance, destination track ID, and car reporting marks.
- **Obstruction Warnings:** The route preview pulses red if a track is blocked by other cars, a switch is locked against the path, or no open coupling point can be reached.

### 1.4 Instant Order Cancellation `[ME2.0 v2.0.15]`

- Hold `CapsLock` and **right-click anywhere on the map** to cancel active waypoint or coupling orders immediately.

<p align="center">
  <img width="394" height="354" alt="Cancel Waypoint Order" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-CancelWaypoint.png" />
  <br><em>Hold CapsLock and right-click to cancel orders instantly.</em>
</p>

---

## 2. Rolling Stock Operations & Context Menu

Perform essential yard switching and train operations directly through a clean right-click context menu on the map.

<p align="center">
  <img width="513" height="563" alt="Train Car Context Menu" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-ContextMenu1.png" />
  <br><em>Right-click any railcar or locomotive on the map for instant operations.</em>
</p>

### 2.1 Interactive Car Context Menu `[ME2.0 v2.0.15]`

- Right-click any railcar, locomotive, or caboose on the map to access operations.

### 2.2 Smart Handbrakes Engine `[ME2.0 v2.0.15]`

Stop rollaways on grades without manually walking down the train to tighten handbrakes:

- **Slope-Based Calculation:** Automatically checks track steepness beneath your train and sets the exact percentage of handbrakes needed to hold it securely:
  - **Flat yards ($\le 0.2\%$ grade):** Sets handbrakes on $10\%$ of cars (minimum 2 cars).
  - **Moderate lines ($0.2\% – 2.0\%$ grade):** Sets handbrakes on $25\%$ of cars.
  - **Mountain grades ($> 2.0\%$ grade):** Sets handbrakes on $50\%$ of cars.
- **Locomotive & Tender Protection:** Smart handbrakes are applied strictly to freight and passenger cars. Locomotives and tenders are automatically kept free of handbrakes to prevent dragged wheels and motor overload.

### 2.3 Cut Behind Locomotive & Secure Train `[ME2.0 v2.0.15]`

- Instantly uncouples the engine and tender from the train with one click.
- Automatically applies Smart Handbrakes to the uncoupled cars to prevent them from rolling away down the mountain.

### 2.4 Consist Air, Steam & Brake Controls `[ME2.0 v2.0.15]`

- **Toggle Car Handbrake:** Sets or releases the handbrake on the specific car clicked.
- **Apply / Release All Handbrakes:** Sets or releases handbrakes across 100% of the consist.
- **Connect Air & Steam:** Couples all gladhands, opens angle cocks, and connects steam heat lines throughout the train.
- **Disconnect Air & Steam:** Closes angle cocks and disconnects all hoses.
- **Bleed Consist Air:** Bleeds air brake reservoirs across the train for quick, drag-free yard switching.

### 2.5 Auto-Release Handbrakes on Dispatch `[ME2.0 v2.0.15]`

- Optional setting: When enabled, dispatching a train automatically knocks off holding handbrakes so the train can start rolling immediately.

---

## 3. Topographic Backgrounds & Map Tile Streaming

Add realistic geographic maps and topographic mountain terrain beneath your railroad tracks.

<p align="center">
  <img width="976" height="1078" alt="OpenStreetMap Live Tile Background" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-OpenSt...p_Preview.png" />
  <br><em>OpenStreetMap live road and town overlay streaming beneath tracks.</em>
</p>

<p align="center">
  <img width="976" height="1078" alt="USGS Topo Topographic Background" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-USGSTopo_Preview.png" />
  <br><em>Authentic Appalachian USGS Topo mountain contours, waterways, and elevations.</em>
</p>

### 3.1 Background Architecture & Modes `[ME2.0 v2.0.17]`

1. **`Disabled (Default Map)`** — Clean, plain vanilla canvas background.
2. **`Custom Image`** — Load your own historical track chart, aerial photo, or map drawing from the `Backgrounds/` folder. Supports automatic track boundary fitting or companion `.json` coordinate calibration.
3. **`Map Tiles (Unified Local Tile Subsystem)`** — High-performance, 100% local-only slippy tile streaming subsystem. Select any installed tile pack from the dynamic dropdown:
   - **`USGSTopo`** _(Recommended)_: Authentic Appalachian mountain topography, contour lines, elevations, waterways, and historical alignments (U.S. Geological Survey Public Domain) spanning Zooms 12–16.
   - **`USGSImageryTopo`**: High-resolution USDA NAIP aerial satellite orthoimagery layered with USGS topographic contours, rivers, roads, and station labels spanning Zooms 12–16.
   - **`OSM`**: High-contrast street, track, and water features from OpenStreetMap offline packs or automatically discovered native Railroader GIS session caches spanning Zooms 12–17.
   - **Custom Packs**: Drop any folder of Web Mercator tiles into `Tiles/<YourPackName>/` and Map Enhancer will detect and list it automatically.

> [!NOTE]
> **100% Local-Only Operation:** Zero network requests are initiated by Map Enhancer. All tile loading is strictly local from disk, eliminating network stutter, rate-limiting, external tracking, or API dependencies.

### 3.2 Dynamic Zoom Ladder & Anti-Jitter Hysteresis `[ME2.0 v2.0.16]`

- **Adaptive Zoom Ladder (Zooms 12 to 17):**
  - **Zoom 17 (Close-up):** Razor-sharp yard switching, siding turnouts, and car spotting in terminals like Bryson and Andrews (~0.97 m/px).
  - **Zoom 16:** Station districts and industrial branch lines (~1.9 m/px).
  - **Zoom 15:** Mountain passes and river valleys (~3.8 m/px).
  - **Zoom 14:** Multi-town corridor view (~7.6 m/px).
  - **Zoom 13:** Regional valley overview (~15.3 m/px).
  - **Zoom 12 (Far Overview):** Complete regional bird's-eye view (~30.5 m/px).
- **Anti-Jitter Hysteresis:** Pure mathematical hysteresis with a 5% guard band prevents rapid flickering or oscillating between zoom tiers when panning near zoom thresholds.
- **Non-Blanking Zoom Transitions:** Tiles from the previous zoom level remain smoothly rendered underneath while new zoom tiles load asynchronously, preventing jarring black flashes or visual blanks.

### 3.3 Seamless Performance & Resource Management `[ME2.0 v2.0.16]`

- **Active-Aware LRU Cache:** 1,024-entry texture cache protects currently visible on-screen tiles from eviction. Eviction synchronizes with request records so zooming out and in reloads seamlessly.
- **Pooled Sprite Renderers:** Capped at 384 recycled, fully sanitized sprite renderers on Unity layer `Layers.Map` with zero garbage-collection stutter.
- **Adaptive Frame Budget:** Throttles texture uploads up to 24 tiles per frame within a strict 5ms main-thread frame budget, ensuring buttery-smooth camera panning and zooming.
- **Non-Blocking Discovery:** Asynchronous tile scanning prevents save-screen or world-load freezes even with 25,000+ local files.
- **In-Game Controls:**
  - **Rescan & Reload Tiles Button:** Triggers an immediate background disk rescan and refreshes the tile grid without interrupting gameplay.
  - **Background Opacity Slider:** Fade the background from $0\%$ (hidden) to $100\%$ (full strength), keeping tracks and cars easily readable (recommended: $40\% – 60\%$).

### 3.4 Pre-Packaged Offline Corridor Tile Packs `[ME2.0 v2.0.17]`

Three distinct pre-rendered offline tile archives provide 100% complete coverage for the entire Railroader mountain corridor (Andrews $\to$ Bryson City $\to$ Sylva, including Whittier, Dillsboro, Ela, and Fontana Branch) with zero active internet connection required during gameplay:

1. **`MapEnhancer_Tiles_USGSImageryTopo_Andrews_to_Sylva.zip`** (926 MB):
   - **Coverage:** 6,040 tiles spanning **Zooms 12 through 16** (100% corridor coverage).
   - **Cartography:** High-resolution USDA NAIP aerial photography overlaid with USGS topographic contours, rivers, roads, and station place names.
   - **Installation:** Extract into `Documents\Railroader\Mods\reaper-map-enhancer\Tiles\USGSImageryTopo\`.
2. **`MapEnhancer_Tiles_USGSTopo_Andrews_to_Sylva.zip`** (692 MB):
   - **Coverage:** 6,040 tiles spanning **Zooms 12 through 16** (100% corridor coverage).
   - **Cartography:** Authentic USGS topographic contours, hillshading, waterways, and elevations from USGS The National Map.
   - **Installation:** Extract into `Documents\Railroader\Mods\reaper-map-enhancer\Tiles\USGSTopo\`.
3. **`MapEnhancer_Tiles_OSM_Andrews_to_Sylva.zip`** (76.5 MB):
   - **Coverage:** 23,315 tiles spanning all zoom levels from **Zoom 12 down to Zoom 17**.
   - **Cartography:** High-contrast street, track, and water rendering generated locally via Docker Mapnik from OpenStreetMap North Carolina extracts.
   - **Installation:** Extract into `Documents\Railroader\Mods\reaper-map-enhancer\Tiles\OSM\`.

- **Side-by-Side Installation:** All three tile packs can be installed simultaneously in their respective subfolders (`Tiles\USGSImageryTopo\`, `Tiles\USGSTopo\`, and `Tiles\OSM\`). Map Enhancer automatically detects each provider and seamlessly switches between them when you toggle tile sets in the in-game options menu (`Ctrl+M`).

---

## 4. Centralized Map Overlays & Safety Filters

Six specialized overlay layers turn the dispatch map into an operational analysis tool.

### 4.1 Overlay Modes Toolbar Switcher `[Reaper8f Fork v1.5.5 / ME2.0 v2.0.12]`

Switch between all 6 overlay views directly from the settings window or toolbar buttons:

- **`Routes`**
- **`SafeSpeed`**
- **`Grade`**
- **`TrackClass`**
- **`Condition`**
- **`Cleanliness`**

### 4.2 Mode 1: Functional Routes `[Vanguard v1.0.0 / Fork v1.5.3.7 / ME2.0 v2.0.12 / v2.0.16]`

<p align="center">
  <img width="1433" height="1051" alt="Default Route Filter" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-OverlayFilterDefaultRoutes.png" />
  <br><em>Default Route Filter</em>
</p>

- **Mainline (Green):** Primary continuous through-corridor.
- **Branch Line & Sidings (Blue):** Secondary lines, passing sidings, and runarounds.
- **Industry Tracks (Yellow or Area Color):** Delivery spurs and factory tracks.
- **Maintenance of Way (MOW) Tracks (Indigo / Gold):** Maintenance equipment and work tracks.
- **Passenger Platforms (Purple):** Station boarding and passenger stops.
- **Unreachable / Under Construction (Light Grey):** Unavailable or out-of-service trackage.

### 4.3 Mode 2: Physical Safe Speed Curve Restrictions `[ME2.0 v2.0.16]`

Prevents train derailments by calculating the real, physical safe speed a train can take through every curve based on track geometry (`TrainMath.MaximumSpeedMphForCurve`):

<p align="center">
  <img width="969" height="706" alt="Curvature Speed Restriction Curve" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-TrackPhysicalSpeedOverlay1.png" />
  <br><em>Physical Safe Speed Overlay highlighting severe curves in red and purple.</em>
</p>

<p align="center">
  <img width="964" height="708" alt="Curvature Speed Restriction Tangent" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-TrackPhysicalSpeedOverlay.png" />
  <br><em>Physical Safe Speed Overlay showing high-speed straight track in blue.</em>
</p>

- Calculates the true physical overturning limit of every curve, independent of posted speed limits or slow orders.
- **6-Band Speed Color Spectrum:**
  - 🟣 **$\le 10\text{ mph}$ (Extreme Curves / Sharp Turnouts):** Deep Purple.
  - 🔴 **$11 – 15\text{ mph}$ (Sharp Mountain Curves):** Red (High Derailment Risk).
  - 🟠 **$16 – 20\text{ mph}$ (Moderate Curvature):** Orange.
  - 🟡 **$21 – 25\text{ mph}$ (Corridor Curves):** Yellow.
  - 🟢 **$26 – 35\text{ mph}$ (Gentle Curves):** Green.
  - 🔵 **$> 35\text{ mph}$ (Straight / High-Speed Track):** Deep Blue.

### 4.4 Mode 3: Track Grade (%) Slope Analysis `[Reaper8f Fork v1.5.4.5 / ME2.0 v2.0.12]`

Visualizes hill climbs and descending slopes across the mountains:

- **5-Band Slope Spectrum:**
  - 🔵 **Flat ($< 0.1\%$):** Blue.
  - 🟢 **Easy ($0.1\% – 1.0\%$):** Green.
  - 🟡 **Moderate ($1.0\% – 2.0\%$):** Yellow.
  - 🟠 **Steep ($2.0\% – 3.0\%$):** Orange.
  - 🔴 **Severe ($\ge 3.0\%$):** Red.

<p align="center">
  <img width="1430" height="1052" alt="Track Grades Overlay" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-OverlayFilterTrackGrades.png" />
  <br><em>Overlay for Track Grades.</em>
</p>

- **Hover Grade Readout `[Fork v1.5.5]`:** Hover your mouse over any track segment to see its exact gradient (e.g. `+2.14% Ascending` or `-1.85% Descending`).
- **Directional Grade Markers `[Fork v1.5.5]`:** Visual uphill/downhill arrows indicating slope direction on steep segments.
- **Numeric Grade Text Markers `[Fork v1.5.4.5]`:** Optional numeric grade labels displayed on track segments exceeding a configurable intensity threshold (`GradeMarkerMinIntensity`, default $1.0\%$), with offset controls to ensure clean readability.
- **Tooltip Color Styling `[Fork v1.5.5]`:** Grade tooltips adapt their accent colors matching configured track or industry colors.

### 4.5 Mode 4: FRA Track Safety Class Standards `[ME2.0 v2.0.12]`

- Displays track safety speed classifications according to official FRA standards:
  - **Class 0 (10 mph):** Red
  - **Class 1 (15 mph):** Orange
  - **Class 2 (25 mph):** Yellow
  - **Class 3 (40 mph):** Green
  - **Class 4 (60 mph):** Cyan
  - **Class 5 (80 mph):** Blue

### 4.6 Mode 5: Track Condition Heatmap & Metric Parity `[ME2.0 v2.0.17]`

- Highlights rail and tie wear across your network from Red (worn out) to Blue (pristine), helping you schedule Maintenance of Way work before slow orders occur.
- **Selectable Condition Overlay Metric:** Choose between **Per-Class Target (Relative)** (comparing physical wear against the track segment's FRA class threshold) and **Overall Physical (0–100%)**, matching hover percentages without confusion.

### 4.7 Mode 6: Track Cleanliness Heatmap (Brush & Vegetation) `[ME2.0 v2.0.12]`

- Shows vegetation clearance along your right-of-way, identifying overgrown lines that need brush-cutter attention.

### 4.8 Dynamic On-Screen Overlay Legend & Track Hover Metrics `[ME2.0 v2.0.17]`

- A floating on-screen legend panel that automatically updates its color swatches and labels (including Condition Overlay Metric percentages) to match whichever overlay mode is currently active. Positioned cleanly to clear the top toolbar ($Y = 44\text{px}$).
- **Toggleable Track Hover Readouts:** Optional hover details for **Track Class, Condition & Speed**, **Track Condition & Weed Growth**, and selectable **Hover Track Metric Display** (`Per-Class Target`, `Overall Physical`, or `Both`).

---

## 5. Intelligent Track Classification & Siding Accuracy

Enjoy clean, accurate track coloring that reflects true railroad operations.

<p align="center">
  <img width="836" height="425" alt="Continuous Mainline Across All Territories" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-Continuous%20Mainline%20Across%20All%20Territories.png" />
  <br><em>Accurate Detection for Mainline, Branch Line, Industry Span, MOW yards Tracks.</em>
</p>

### 5.1 Continuous Mainline Across All Territories `[ME2.0 v2.0.12]`

- Traces the primary mainline continuously from Sylva all the way to Andrews, eliminating old issues where straight through-tracks would turn blue in unsignaled territory.

### 5.2 Smart Passing Siding Accuracy & BFS Propagation `[ME2.0 v2.0.16]`

- In multi-track signaled corridors, passing sidings between entrance and exit switches are accurately recognized as sidings and kept blue across their entire length, rather than intermediate segments mistakenly turning green.

<p align="center">
  <img width="836" height="425" alt="CTC Passing Siding Propagation" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-CTC_MainLineDetection.png" />
  <br><em>Passing sidings correctly stay blue across their entire length instead of mistakenly turning green.</em>
</p>

### 5.3 Sub-Segment Industry Delivery Highlighting (`ZoneA`/`ZoneB` Slicing) `[ME2.0 v2.0.16]`

- When an industry delivery spot occupies only part of a track, only that exact delivery spot is highlighted in industry yellow. The rest of the track retains its proper mainline or branch color, making delivery locations instantly clear.

<p align="center">
  <img width="1919" height="1079" alt="Sub-Segment Industry Delivery Slicing" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-IndustrySpanRealView.png" />
  <br><em>Only the actual delivery spot is highlighted, keeping through-tracks clearly colored.</em>
</p>

### 5.4 Completed Milestone Site Cleanup `[ME2.0 v2.0.16]`

- Temporary construction sites (such as Alarka Junction, Bryson Bridge, and Nantahala) automatically revert to normal mainline or branch coloring once their construction milestone is completed, removing clutter while preserving hover information.

### 5.5 Stable Track Colors Independent of Switch Position `[ME2.0 v2.0.16]`

- Throwing a switch against a track no longer causes the track to change to white or unreachable color. Functional track colors stay persistent, while switch alignment is indicated cleanly by switch clearance dimming and junction arrows.

### 5.6 Custom Switch Throat Dimming `[ME2.0 v2.0.16]`

- Customize the dimmed color of unaligned switch tracks (`TrackColorSwitchDimmed`) to suit your preferred contrast.

<p align="center">
  <img width="974" height="707" alt="Custom Switch Color" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-CustomSwitchColor.png" />
  <br><em>Custom switch dimming and reachability options in settings.</em>
</p>

### 5.7 Visual-Only Track Colouring Engine `[Reaper8f Fork v1.5.3.6 / ME2.0 v2.0.0]`

- Map Enhancer 2.0 applies custom track and corridor colors purely through non-destructive shader overlays.
- It does **not** alter the underlying game track classification (`TrackSegment.trackClass`). This eliminates compatibility conflicts with the base game, dispatcher systems, and other mods while maintaining total visual fidelity.

### 5.8 Unreachable & Unavailable Track Visuals `[Reaper8f Fork / ME2.0 v2.0.0]`

- **Unreachable Tracks (`#B3B3B3` Light Grey):** Distinct visual treatment for tracks physically disconnected or unreachable by the locomotive route solver.
- **Unavailable Tracks (`TrackColorUnavailable`):** Out-of-service, locked, or unbuilt track segments clearly signaled on the map.

### 5.9 Configurable Track Line Thickness `[Vanguard v1.1.0 / ME2.0 v2.0.12]`

- Fine-tune track line thickness across the map with an in-game slider (range: $0.5 – 3.0\text{px}$, default: $2.0\text{px}$) to suit high-DPI displays or custom aesthetic tastes.

---

## 6. Rolling Stock & Freight Cargo Intelligence

Access complete operational information for every car, locomotive, and consist on the map.

<p align="center">
  <img width="1124" height="822" alt="Train Tooltip Cargo" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-TrainToolTipCargo.png" />
  <br><em>Train tool tip with cargo details.</em>
</p>

### 6.1 Proportional Car Markers, Scaling & Customization Trim `[Vanguard v1.1.0 / Fork v1.4.0 / ME2.0 v2.0.16]`

- **True Physical Scaling:** Railcars render as neat rectangular icons scaled to their true physical length (`carLength / 11`) and aligned with track curve heading.
- **End Seam Trim Slider (`CarMarkerLengthTrim`):** Calibrates coupler and car-end margins ($70\% - 100\%$, default $92\%$) to eliminate overlapping seams between coupled cars.
- **Side Flank Trim Slider (`CarMarkerWidthTrim`):** Calibrates side margins ($70\% - 100\%$, default $90\%$) so parallel cars parked in adjacent yard tracks fit cleanly side-by-side without touching or clipping.
- **Bounded Centered Text:** Reporting marks and road numbers are strictly bounded to the car marker's physical dimensions with automatic font scaling (8–18pt) and center alignment, preventing text from bleeding into adjacent cars.
- **Upright Text Display:** Text rotates smoothly with track orientation and flips automatically to stay upright and legible from any view angle.

### 6.2 Destination Area Tinting, Consist Shingling & Alternating Contrast `[Reaper8f Fork v1.5.3.7 / ME2.0 v2.0.16]`

- **Destination Color-Coding:** Cars are dynamically color-coded matching their destination town or yard (e.g. Sylva, Dillsboro, Bryson, Whittier). Bright colors indicate cars en route; dimmed colors indicate empty or already-spotted cars.
- **Consist Depth Filing (Shingling):** Consist cars are topologically indexed from lead to rear with sequential depth offsets ($Y = 3000\text{f} + \text{consistIndex} \times 0.15\text{f}$). Because the top-down map camera looks downward, each subsequent car's leading edge renders cleanly over the preceding car's tail, creating crisp, dark division seams across the entire train.
- **Alternating Consist Colors (Zebra Contrast):** When multiple consecutive cars in a consist share the same destination area color (or unassigned white), odd-indexed cars automatically render in an $18\%$ darker shade (`v * 0.82f`) while $100\%$ preserving hue and saturation. This allows players to count individual cars in a destination block at any zoom level.
- **In-Game Alternating Color Toggle:** Can be toggled on or off at will in settings (`AlternatingConsistColors`).

<p align="center">
  <img width="1124" height="822" alt="Expanded Car Icons" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-CarSize_Selecthighighlight.png" />
  <br><em>Alternate Shade, Select to highlight, Custom Car Marker Size</em>
</p>

### 6.3 Train Hover Telemetry Card `[Reaper8f Fork v1.5.5 / ME2.0 v2.0.0]`

Hovering over any locomotive or consist displays an instant summary:

- **Consist Name & Locomotive Reporting Marks**
- **Engineer Name:** Name of the player currently controlling the train (multiplayer synced).
- **Control Mode:** Manual, Helper, Road, Yard, or AutoEngineer.
- **Speed:** Current speed in mph.
- **Consist Length:** Accurate train length in feet.
- **Total Weight:** Accurate total train tonnage (gross weight including cargo).
- **Car Breakdown:** Number of locomotives, loaded cars, empty cars, and cabooses.
- **Passenger Counts:** Current passenger load and seating capacity.

### 6.4 Locomotive Fuel Telemetry `[Reaper8f Fork v1.5.5 / ME2.0 v2.0.0]`

- **Steam Locomotives:** Displays Coal % and Water % (e.g. `Fuel: Coal 78% | Water 64%`).
- **Diesel Locomotives:** Displays Diesel Fuel % (e.g. `Fuel: Diesel 82%`).

### 6.5 Consist Cargo Summary `[Reaper8f Fork v1.5.5 / ME2.0 v2.0.0]`

- Groups cars in the consist into a clean manifest summary:
  ```text
  Consist Cargo:
  4x Loaded Lumber Flatcars
  2x Loaded Coal Hoppers
  1x Loaded Steel Gondola
  5x Empty Boxcars
  ```

<p align="center">
  <img width="1466" height="1079" alt="Consist Cargo" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-ConsistCargoTelemetry.png" />
  <br><em>Consist Cargo completed details.</em>
</p>

### 6.6 Individual Freight Car Tooltips `[Reaper8f Fork v1.5.5 / ME2.0 v2.0.16]`

Hovering directly over an individual car displays:

- **Consist Position:** Indicates the car's order in the consist (e.g. `Boxcar (Car 3 of 12)`).
- **Reporting Mark & Number:** (e.g. `PRR 142857`)
- **Car Type:** (e.g. `40ft Boxcar`)
- **Cargo Type & Weight:** Current load name, capacity %, and tonnage.
- **Destination:** Assigned industry, track, and town.
- **Brake & Air Status:** Handbrake position, brake cylinder pressure, and air line status.

### 6.7 Selected Car & Locomotive Map Highlighting `[ME2.0 v2.0.16]`

- **Pulsating Selection Halo:** Currently selected equipment is highlighted on the map with a high-contrast, pulsating golden halo outline (`UnityEngine.UI.Outline` with animated breathing alpha).
- **Combined Locomotive + Tender Support:** Selecting a steam locomotive automatically highlights both the engine and its coupled tender together as a unified unit. Selecting the tender directly also highlights its coupled locomotive.
- **Vertical Altitude Boost:** Highlighted cars receive a $+0.5\text{f}$ vertical altitude boost while selected, ensuring their outline floats cleanly above neighbor cars in the consist without clipping or occlusion.
- **Independent Settings:**
  - `HighlightSelectedCar`: Toggles map selection highlights for revenue rolling stock (freight cars, passenger cars, cabooses).
  - `HighlightSelectedLocomotive`: Toggles map selection highlights for locomotives and attached tenders.

### 6.8 3 Hover HUD Display Modes & Dedicated Inspection HUD `[ME2.0 v2.0.17]`

Choose how hover telemetry is displayed across the map under **Train & Cargo Telemetry → Hover HUD Display Mode**:

1. **Attached to Map:** Compact tooltip anchored in the upper corner of the map window.
2. **Hover Window:** Floating tooltip dynamically following the cursor as you inspect tracks or rolling stock.
3. **Hover Pinned Window (Dedicated Inspection HUD):**
   - Detached, resizable, movable native Railroader window (`WindowManager`) that automatically remembers its last position and dimensions.
   - Retains the `[Last Inspected]` readout until you hover another item so you can read full manifests and waybills comfortably.
   - **Dynamic Toolbar Button & `Ctrl+H` Keybind:** The compact `HUD` button appears on the map toolbar only when Hover Pinned mode is selected; toggle the Inspection HUD open or closed anytime via the `HUD` button or `Ctrl+H` (rebindable).
   - **Unified Locomotive + Tender + Consist Layout:** Hovering either a locomotive or its coupled tender shows combined engine telemetry (crew, mode, speed, coal/water/diesel, handbrakes, journal oil, hotboxes) **alongside** consist metrics, passenger destinations, freight manifest, and alerts.
   - **Tailored Cards by Entity Type:** Distinct structured layouts for Individual Freight Cars, Track Segments (grade, length, FRA class, safe speed, wear, weeds), Station Agents, and Player Signs.

---

## 7. Rolling Stock Mechanical Defect Alerts (HOPA)

Catch journal failures, air leaks, and dragging brakes before they cause train delays or wrecks.

### 7.1 Real-Time Mechanical Defect Monitoring & Thresholds `[Reaper8f Fork v1.5.5 / ME2.0 v2.0.3]`

Continuously scans all equipment across the railroad for critical issues using calibrated telemetry thresholds:

- 🔥 **Hotbox (`H`):** Overheated journal bearing requiring immediate stop and inspection (Journal oil $< 10\%$).
- 🛢️ **Low Journal Oil (`O`):** Oil level below warning thresholds:
  - **Low Oil Warning:** Oil level $< 50\%$.
  - **Critical Oil Warning:** Oil level $< 25\%$, risking an imminent bearing failure.
- ⚠️ **Applied Handbrake (`P`):** Handbrake left applied on a moving car, causing dragging resistance and flat spots.
- 💨 **Air Leak (`A`):** Significant air leak in the train brake pipe or gladhand hoses.
- 🚨 **Derailment (`D`):** Derailed wheelset or overturned equipment.

<p align="center">
  <img width="1154" height="850" alt="HOPA Indicators" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRM2.0-HOPA_Indicators.png" />
  <br><em>Real Time HOPA Indicator Alerts Badges.</em>
</p>

> [!WARNING]
> **Operational Caution:** HOPA defect alerts provide real-time diagnostic telemetry for crew convenience. They are informational tools and do not substitute for standard operating procedures, visual walk-around inspections, or game mechanical simulation rules.

### 7.2 Lateral Car Badges & Upright Display `[ME2.0 v2.0.3]`

- Defects display as compact, color-coded letter badges on the flank of the car:
  - Red **`H`** (Hotbox)
  - Orange **`O`** (Low Oil)
  - Purple **`P`** (Handbrake)
  - Blue **`A`** (Air Leak)
  - Red-Orange **`D`** (Derailment)
- Badges stay upright facing the camera regardless of vehicle orientation.
- Configurable size slider (`HopaIndicatorScale`) and independent toggles for every defect type.

### 7.3 Dedicated Rolling Stock Alerts Window `[ME2.0 v2.0.3]`

- Accessible from the map toolbar or by clicking the map-corner defect counter.
- **Defect Counts:** Shows total active defects, affected cars, and affected trains.
- **Filters & Sorting:** Filter by any defect type and sort by urgency, car ID, or consist.
- **One-Click Actions:**
  - **Locate:** Centers the map camera on the defective car.
  - **Highlight:** Traces a pulsing highlight around the car on the map for 5 seconds.
  - **Select:** Selects the car and opens its inspection window.

<p align="center">
  <img width="718" height="1080" alt="Rolling Stock Alert Window" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-RollingStockAlertWindow.png" />
  <br><em>Dedicated Rolling Stock Alerts window with filters, locate and highlight on map.</em>
</p>

<p align="center">
  <img width="1923" height="1080" alt="Highlight Locate Select Car" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-HighlightLocateSelectCar.png" />
  <br><em>From Alert window Locate and highlight car/consist on map.</em>
</p>

### 7.4 Map-Corner Defect Counter `[ME2.0 v2.0.3]`

- A compact badge in the corner of your map displays total active defects at a glance. Clicking it opens the Alerts Window immediately.

---

## 8. Passenger Operations & Station Intelligence

Manage passenger business and monitor depot traffic with ease.

<p align="center">
  <img width="965" height="705" alt="Station Agent and Hover Info" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-StationInfo.png" />
  <br><em>Hover over any station for directional passenger counts and 1-click Station Agent access.</em>
</p>

### 8.1 Vector Station Depot Markers `[ME2.0 v2.0.3]`

- Station depots are clearly marked by gold-rimmed station icons on the map (`station.png`).
- Adjustable marker scale slider in settings (`StationMarkerScale`).

### 8.2 Directional Passenger Breakdown on Hover `[ME2.0 v2.0.12]`

Hovering over any station icon displays an instant traffic breakdown:

- **Up-Train Passengers:** Waiting to travel Eastbound towards Sylva / Dillsboro.
- **Down-Train Passengers:** Waiting to travel Westbound towards Bryson / Andrews.
- **Destination Breakdown:** Exact passenger counts waiting for specific stops down the line.

### 8.3 1-Click Station Agent Access `[ME2.0 v2.0.12]`

- Left-click any station icon on the map to immediately open the native **Station Agent** window.
- Set ticket prices, view express deliveries, and manage passenger operations without having to walk to the physical depot.

### 8.4 Passenger Platform Track Protection `[Reaper8f Fork v1.5.2 / ME2.0 v2.0.12]`

- Station passenger boarding tracks are highlighted in purple (`#800080`) and protected from turning industrial yellow.

<p align="center">
  <img width="1086" height="797" alt="Passenger Highlight Purple" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-PassengerStopHighlightPurple.png" />
  <br><em>Passenger Stop highlight Purple on map.</em>
</p>

---

## 9. Turntable Controls, Crossings & Trackside Assets

Operate engine terminal turntables, view road crossings, and place signs directly from your map.

### 9.1 Live Turntable Bridge Display & Rotation `[Reaper8f Fork v1.5.4.2 / ME2.0 v2.0.0]`

- Turntable bridges in Whittier, Bryson, and Andrews display live rotating bridge markers on the map.
- Bridge angle on the map matches the physical 3D bridge in real time.

<p align="center">
  <img width="967" height="704" alt="Turntable Map Control" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-TurnTableControls.png" />
  <br><em>Interactive turntable marker controls and rotation shortcuts.</em>
  <br><a href="https://youtu.be/zMtQZzuPjXE"><strong>Watch Turntable Control Video Demo</strong></a>
</p>

### 9.2 Turntable Map Controls & Shortcuts `[Reaper8f Fork v1.5.4.2 / ME2.0 v2.0.0]`

- **Click Turntable Marker:** Opens the native turntable control window.
- **Turntable Shortcuts:**
  - `Ctrl + Left-Click`: Rotate bridge **Clockwise** to the clicked radial track.
  - `Alt + Left-Click`: Rotate bridge **Counter-Clockwise** to the clicked radial track.
  - `Ctrl + Shift + Left-Click`: Rotate bridge **180°** (reverse engine facing).

### 9.3 Bridge Clearance & Anti-Derailment Safety `[Reaper8f Fork v1.5.4.4 / ME2.0 v2.0.0]`

- Verifies that no locomotive or railcar is straddling the pit boundary before moving (`CheckTurntableClearance`), preventing catastrophic derailments from accidental rotation commands.

### 9.4 Multiplayer Turntable Synchronization `[Reaper8f Fork v1.5.4.2 / ME2.0 - Experimental]`

- Bridge rotation commands are synchronized across both host and multiplayer clients via network request handling (`TurntableRequestState`).

### 9.5 Road Crossing Markers & Clustering `[Reaper8f Fork v1.5.4.4 / ME2.0 v2.0.0]`

- Renders crossing markers over 31+ grade crossings across the map.
- **Smart Spatial Clustering:** Clusters nearby crossing nodes into single icons to eliminate cluttered duplicate icons on multi-track or siding crossings.

<p align="center">
  <img width="1920" height="1080" alt="Road Crossing Markers" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-RailRoadCrossingSigns.png" />
  <br><em>Customisable Road Crossing Markers.</em>
</p>

### 9.6 Place Signs & Flares from Map `[Vanguard v1.1.0 / ME2.0 v2.0.15]`

- Right-click anywhere on track to open the placement menu:
  - **Speed Limit Signs** (Yellow badge)
  - **Speed Resume Signs** (Green badge)
  - **Whistle Posts & Yard Markers** (Blue badge)
  - **Safety Flares / Fusees** (Red warning halo)
- Hover over any sign badge on the map to read its message; click it to open the native sign editor.

<p align="center">
  <img width="963" height="703" alt="Track Sign Orientation Fix" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-TrackSigns.png" />
  <br><em>Track and yard signs render with upright, readable text at all zoom levels.</em>
</p>

### 9.7 Upright Sign Text `[ME2.0 v2.0.16]`

- Track signs and speed numbers display upright and readable across all map zoom levels without being flipped or mirrored.

---

## 10. Switch Controls, CTC Locks & Quick Switch Reset

Control track switches across your railroad with confidence and precision.

### 10.1 Clickable Switch Markers & Chevrons `[Vanguard v1.0.0 / v1.0.1 / ME2.0 v2.0.0]`

- Click turnouts on the map to throw switches.
- **Clear Alignment Colors:**
  - **Normal Position:** Green / White Arrow.
  - **Reversed Position:** Red / White Arrow.

### 10.2 Double-Click Switch Safety `[Vanguard v1.0.1 / ME2.0 v2.0.0]`

- Optional setting requiring a double-click to throw switches (`DoubleClick`), preventing accidental switch throws while dragging or panning the map.

### 10.3 CTC Switch Permission & Lock Checks `[Vanguard v1.0.1 / ME2.0 v2.0.0]`

- Honors dispatcher CTC switch locks in signaled territory. Switches locked by the dispatcher cannot be thrown until unlocked, preventing conflicting movements.

### 10.4 Global Switch Reset (Normal / Thrown) `[Reaper8f Fork v1.5.3.6 / ME2.0 v2.0.0]`

- Quickly reset all switches across your railroad via the **Switch Reset** toolbar dropdown:
  - **`Reset All to Normal`**
  - **`Reset All to Thrown`**
- Optional visibility toggle in settings (`ShowSwitchResetOption`).

### 10.5 Multiplayer Switch Reset Chat Notifications & Audit `[Reaper8f Fork v1.5.4 / ME2.0 v2.0.0]`

- When a switch reset is triggered in multiplayer, a notification is broadcast to all players in chat naming who reset the switches and how many switches were aligned.

### 10.6 Switch Far-Zoom Cutoff (LOD Culling) `[Vanguard v1.0.0 / ME2.0 v2.0.0]`

- When zoomed far out, minor yard switches fade out (`MarkerCutoff = 0.12f`) to reduce visual clutter while major mainline turnouts remain crisp and visible.

### 10.7 Signal Aspects on Map `[Reaper8f Fork v1.5.3.6 / ME2.0 v2.0.0]`

- Displays real-time signal aspect states (Red, Yellow, Green) directly at signaled junction masts on the map.

---

## 11. Camera Navigation, Windowing & Zoom

Effortless navigation and smooth window controls.

### 11.1 Maximize / Toggle Floating Map View (`Z` Key) `[Vanguard v1.3.0 / ME2.0 v2.0.14]`

- Press **`M`** to open the map (Railroader default).
- While the map is open, press **`Z`** (customizable in `Ctrl+M`) to toggle between:
  - **Normal Map Size:** Compact map in the top-left corner.
  - **Extra Large Map:** Large, resizable floating map window positioned anywhere across your screens.

### 11.2 Resizable Window with Position & Dimension Memory `[Vanguard v1.2.0 / Fork v1.5.6 / ME2.0 v2.0.0]`

- Drag the bottom-right corner handle to resize the map window to any size you prefer.
- Remembers your custom window size and position when reopening or toggling settings, preventing window shifts.

### 11.3 Camera Re-Center on Player (`Ctrl+Z`) `[Vanguard v1.4.0 / ME2.0 v2.0.14]`

- Press **`Ctrl+Z`** to recenter map camera on player view/position.

### 11.4 Camera Follow Mode (`Shift+Z`) `[Vanguard v1.4.0 / ME2.0 v2.0.14]`

- Press **`Shift+Z`** to enable follow mode on locomotive.

### 11.5 Click Select `[Reaper8f Fork v1.5.0 / ME2.0 v2.0.0]`

- **`Left-Click` on Car:** Open Car Inspect Menu.
- **`Shift + Left-Click` on Car:** Selects the car/loco.
- **`Ctrl + Left-Click` on Car:** Snaps your 3D game camera to follow that vehicle in cab/track view.
- **`Ctrl + Shift + Left-Click`:** Selects the car and snaps the 3D camera simultaneously.

### 11.6 Quick Jump-to Location Dropdown `[Vanguard v1.4.0 / Fork v1.5.0 / ME2.0 v2.0.0]`

- Jump your map camera to any town, yard, or junction (Whittier, Bryson, Dillsboro, Sylva, Andrews, Almond, Connelly, and custom mod locations).

### 11.7 Quick Jump-to Locomotive Dropdown `[Reaper8f Fork v1.5.0 / ME2.0 v2.0.0]`

- Jump your map camera directly to any active locomotive across your railroad.

### 11.8 Extended Zoom Ladder (50m to 15,000m) `[Vanguard v1.1.0 / Fork v1.5.4.2 / ME2.0 v2.0.0]`

- Zoom smoothly from **50 meters** (close-up yard track inspection) out to **15,000 meters** (complete regional bird's-eye view).
- Set Max and Min zoom levels.
- Displays real-time zoom percentage ($0\%$ to $100\%$) and camera altitude readout.

### 11.9 Anti-Aliasing (MSAA) `[Vanguard v1.2.0 / ME2.0 v2.0.0]`

- Built-in anti-aliasing produces clean, smooth track curves and sharp text labels with zero jagged edges.

### 11.10 Advanced Map Controls Toggle `[Reaper8f Fork v1.5.6 / ME2.0 v2.0.0]`

- Toggle advanced map window controls on/off (`ShowAdvancedMapWindowSettings`) to declutter the user interface for streamlined dispatching.

---

## 12. Performance, Rendering & Marker Optimization

Engineered for smooth frame rates and low CPU overhead on complex multiplayer railroads.

### 12.1 Dynamic Marker Culling (`MarkerCutoff`) `[Vanguard v1.0.0 / ME2.0 v2.0.0]`

- Minor yard switches, flare indicators, and secondary markers are culled automatically at distant zoom levels (`MarkerCutoff = 0.12f`), reducing draw calls and keeping the map responsive.

### 12.2 Road Crossing Node Clustering `[Reaper8f Fork v1.5.4.4 / ME2.0 v2.0.0]`

- Aggregates multi-node grade crossings into unified map icons, preventing duplicate renders and visual clutter in busy industrial parks.

### 12.3 Viewport Tile Caching & Texture Streaming `[ME2.0 v2.0.16]`

- Background slippy tiles are asynchronously fetched, memory-cached, and evicted outside the viewport to prevent RAM bloat during extended sessions.

### 12.4 Canvas Culler & Memory Discipline `[ME2.0 v2.0.0]`

- Dedicated `CanvasCuller` cleans up off-screen UI elements, eliminating GC stutter during high-speed camera pans.

---

## 13. In-Game Settings & Keybinding Customization

Easily configure every feature to match your personal playstyle.

<p align="center">
  <img width="796" height="353" alt="Map Enhancer Settings Tab and Keybindings" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Settings/RRME2.0-MapKeybinds_And_Logs_Settings.png" />
  <br><em>In-game settings tab with keybind manager, color customization, and toggles.</em>
</p>

### 13.1 Easy Access to Settings `[ME2.0 v2.0.4]`

- Open settings via:
  - **Preferences → Mod Settings → Map Enhancer**
  - Or click the **`[ME]`** button in the map toolbar.
  - Or press the shortcut (`Ctrl+M`).

### 13.2 Full Visual Color Customization `[Vanguard v1.0.0 / Fork / ME2.0 v2.0.4]`

- Customize track and overlay colors using intuitive color pickers or hex codes:
  - Mainline, Branch, Industry, Passenger, and MOW track colors.
  - All 5 Grade band colors.
  - Switch throat dimming and unreachable track colors.
  - One-click reset buttons to restore default colors for any section.

### 13.3 Integrated Keybinding Manager `[ME2.0 v2.0.17]`

- Rebind any shortcut directly in-game:
  - Map Toggle (Default: `M`)
  - Left-Click Car to inspect
  - Shift + Left-Click to select/highlight
  - Control + Left-Click to snap 3D Camera to car
  - Control + Shift + Left-Click Selects the car and snaps the 3D camera simultaneously.
  - Right-Click on car/loco to open context menu
  - Right-Click on track to place track sign, speed restriction and flare
  - Re-center on Player (Default: `Ctrl + Z`)
  - Follow Mode (Default: `Shift + Z`)
  - Settings Toggle (Default: `Ctrl + M`)
  - Inspection HUD Toggle (Default: `Ctrl + H`)
  - Live Route Preview Toggle (Configurable shortcut, no default)
  - Waypoint Dispatch Key (Default: `CapsLock`) + Left-click on Track/Car to set waypoint/couple, Right-Click to cancel

### 13.4 Comprehensive Settings Directory

| Setting Category          | Config Parameter                    | Default Value   | Description                                         |
| :------------------------ | :---------------------------------- | :-------------- | :-------------------------------------------------- |
| **Navigation & Keys**     | `mapToggle`                         | `M`             | Opens or docks the map window.                      |
|                           | `mapFollow`                         | `Shift + Z`     | Locks camera onto selected locomotive.              |
|                           | `mapRecenter`                       | `Ctrl + Z`      | Centers camera on player position.                  |
|                           | `mapSettingsToggle`                 | `Ctrl + M`      | Toggles Map Enhancer settings UI.                   |
|                           | `hudToggle`                         | `Ctrl + H`      | Shows or hides the dedicated Inspection HUD window. |
|                           | `routePreviewToggle`                | `None`          | Configurable shortcut to toggle route preview ribbon.|
|                           | `LocomotiveDispatchKey`             | `CapsLock`      | Precision targeting dispatch key.                   |
| **Waypoint Dispatch**     | `EnableLocomotiveDispatch`          | `true`          | Enables interactive click-to-dispatch.              |
|                           | `ShowRoutePreview`                  | `true`          | Traces route line from train to target cursor.      |
|                           | `AutoReleaseHandbrakesOnDispatch`   | `true`          | Releases holding brakes when dispatching.           |
| **Context Operations**    | `ContextMenuEnableLocoOperations`   | `true`          | Shows locomotive operations in menu.                |
|                           | `ContextMenuEnableConsistBrakes`    | `true`          | Shows consist brake commands.                       |
|                           | `ContextMenuEnableConsistAir`       | `true`          | Shows air and steam connect/disconnect.             |
|                           | `ContextMenuSmartHandbrakesDefault` | `true`          | Uses grade calculation for handbrakes.              |
| **Map Backgrounds**       | `BackgroundMode`                    | `Disabled`      | Selects Disabled, Custom Image, or Map Tiles.       |
|                           | `MapTileFolder`                     | `USGSTopo`      | Chooses `USGSTopo`, `USGSImageryTopo`, `OSM`, custom.|
|                           | `MapBackgroundOpacity`              | `0.40` ($40\%$) | Background opacity ($0.0 – 1.0$).                   |
| **Hover HUD & Track Metrics** | `HoverHud`                      | `AttachedToMap` | HUD Mode: `AttachedToMap`, `HoverWindow`, `HoverPinned`.|
|                           | `ShowTrackClassConditionSpeed`      | `false`         | Adds FRA track class & effective speed on hover.    |
|                           | `ShowTrackConditionWeeds`           | `false`         | Adds track condition & weed growth on hover.        |
|                           | `TrackConditionDisplay`             | `PerClass`      | Hover metric: Per-Class Target, Overall, or Both.   |
|                           | `TrackConditionOverlayMetric`       | `PerClass`      | Condition overlay mode metric (syncs legend).       |
| **Track Rendering**       | `TrackLineThickness`                | `2.0`           | Track line rendering width ($0.5 – 3.0$).           |
|                           | `EnableIndustryAreaColors`          | `true`          | Tints industry tracks by area colors.               |
|                           | `ShowMoWYardTracks`                 | `true`          | Highlights MOW tracks with distinct color.          |
|                           | `TrackColorSwitchDimmed`            | `RGB(61,61,61)` | Color of unaligned switch tracks.                   |
| **Rolling Stock Markers** | `CarMarkerLengthTrim`               | `0.92` ($92\%$) | Trims car length edges to file over neighbor tails. |
|                           | `CarMarkerWidthTrim`                | `0.90` ($90\%$) | Trims car width for neat side-by-side yard fit.     |
|                           | `AlternatingConsistColors`          | `true`          | Alternates shading between same-destination cars.   |
|                           | `HighlightSelectedCar`              | `true`          | Highlights selected freight/passenger car on map.   |
|                           | `HighlightSelectedLocomotive`       | `true`          | Highlights selected locomotive & tender on map.     |
| **Switch & Safety**       | `DoubleClick`                       | `false`         | Requires double-click to throw switches.            |
|                           | `ShowSwitchResetOption`             | `false`         | Shows global switch reset dropdown.                 |
|                           | `MarkerCutoff`                      | `0.12`          | LOD zoom threshold for minor marker culling.        |
| **Turntables & Assets**   | `ShowTurntableMarkers`              | `true`          | Renders rotating turntable bridges.                 |
|                           | `EnableTurntableControl`            | `true`          | Enables interactive bridge rotation.                |
|                           | `CheckTurntableClearance`           | `true`          | Prevents rotation when bridge is fouled.            |
|                           | `ShowRoadCrossingMarkers`           | `true`          | Renders clustered grade crossing icons.             |
|                           | `ShowPlayerSigns`                   | `true`          | Renders player track signs and flares.              |
| **Mechanical Alerts**     | `ShowOperationalAlerts`             | `true`          | Toggles lateral HOPA warning badges.                |
|                           | `ShowHotboxAlert`                   | `true`          | Badges hotbox bearing failures.                     |
|                           | `ShowLowOilAlert`                   | `true`          | Badges low journal oil levels.                      |
|                           | `ShowHandbrakeAlert`                | `true`          | Badges applied dragging handbrakes.                 |
|                           | `ShowAirLeakAlert`                  | `false`         | Badges trainline air leaks.                         |
|                           | `ShowDerailmentAlert`               | `true`          | Badges derailed equipment.                          |
| **Diagnostics**           | `EnableDebugLogging`                | `false`         | Enables verbose diagnostic output.                  |

### 13.5 Backup your Files `[ME2.0 v2.0.0 / v2.0.16]`

- All your settings (`settings.json`), custom background images (`Backgrounds/`), and downloaded offline map tiles (`Tiles/`) are present in the mods folder; ensure you back up when updating.

---

## 14. Diagnostics, Logging & Multiplayer Audit Trail

Robust diagnostic and auditing tools for single-player troubleshooting and multiplayer administration.

### 14.1 Production Debug Logging Toggle (`EnableDebugLogging`) `[Reaper8f Fork v1.5.6 / ME2.0 v2.0.16]`

- Diagnostic logging is disabled by default to maintain clean log files and optimal frame rates.
- Enable `EnableDebugLogging` in settings when reporting issues to output detailed route calculation traces, slippy tile coordinates, and geometry resolution data.

### 14.2 Multiplayer Switch Reset Audit Trail `[Reaper8f Fork v1.5.4.1 / ME2.0 v2.0.0]`

- Bulk switch reset actions record full audit entries (`SwitchResetAuditState` / `SwitchResetAuditStorage`) logging the initiating player’s identity, timestamp, and the exact count of switches aligned to chat and diagnostic logs.

### 14.3 Turntable Command Diagnostics `[Reaper8f Fork v1.5.4.2 / ME2.0 v2.0.0]`

- Records turntable rotation requests, fouling check verifications, and player inputs to maintain smooth multiplayer synchronization.

---

## 15. Master Feature Matrix & Lineage Comparison

| Feature / Subsystem                             | Lineage Origin | Historical Milestones                                          | Current ME2.0 (v2.0.17) Status |
| :---------------------------------------------- | :------------: | :------------------------------------------------------------- | :----------------------------: |
| **Track Color Coding (Main/Branch/Ind)**        | Vanguard v1.x  | `v1.0.0` (base), `v1.5.3.7` (area), `v2.0.12` (overhaul)       |           ✅ Active            |
| **Visual-Only Track Colors (No Game Mutation)** |  Fork v1.5.x   | `v1.5.3.6` (visual isolation), `v2.0.0` (native shader)        |           ✅ Active            |
| **Clickable Switch Markers & Chevrons**         | Vanguard v1.x  | `v1.0.0` (base), `v1.0.1` (chevrons), `v2.0.0` (native sync)   |           ✅ Active            |
| **Double-Click Switch Throw Safety**            | Vanguard v1.x  | `v1.0.1` (prevention toggle), `v2.0.0` (maintained)            |           ✅ Active            |
| **CTC Dispatcher Switch Locks**                 | Vanguard v1.x  | `v1.0.1` (CTC check), `v2.0.0` (signaled territory)            |           ✅ Active            |
| **Far-Zoom Switch Cutoff (LOD Culling)**        | Vanguard v1.x  | `v1.0.0` (base), `v2.0.0` (performance optimization)           |           ✅ Active            |
| **Track Flares / Fusees on Map**                | Vanguard v1.x  | `v1.1.0` (base markers), `v2.0.15` (right-click placement)     |           ✅ Active            |
| **Length-Scaled Car Markers**                   | Vanguard v1.x  | `v1.1.0` (scaled), `v1.4.0` (upright labels), `v2.0.3` (crisp) |           ✅ Active            |
| **Min/Max Zoom Settings (50m–10,000m)**         | Vanguard v1.x  | `v1.1.0` (slider), `v1.5.4.2` (smooth zoom ladder)             |           ✅ Active            |
| **Custom Track Line Thickness**                 | Vanguard v1.x  | `v1.1.0` (0.5–2.0), `v2.0.12` (in-game slider up to 3.0)       |           ✅ Active            |
| **Resizable Map Window with Memory**            | Vanguard v1.x  | `v1.2.0` (drag resize), `v1.3.0` (memory), `v1.5.6` (fixed)    |           ✅ Active            |
| **Anti-Aliasing (MSAA)**                        | Vanguard v1.x  | `v1.2.0` (base), `v1.3.1` (auto-detection), `v2.0.0` (URP)     |           ✅ Active            |
| **Docked vs Floating Toggle (`Z`)**             | Vanguard v1.x  | `v1.3.0` (toggle), `v2.0.14` (keybinding manager)              |           ✅ Active            |
| **Camera Follow Mode (`Ctrl+Z`)**               | Vanguard v1.x  | `v1.4.0` (base), `v1.5.0` (player track), `v2.0.14` (rebind)   |           ✅ Active            |
| **Camera Re-Center (`Shift+Z`)**                | Vanguard v1.x  | `v1.4.0` (base shortcut), `v2.0.14` (rebindable)               |           ✅ Active            |
| **Jump-to Location Menu**                       | Vanguard v1.x  | `v1.4.0` (base), `v1.5.0` (extended towns), `v2.0.0` (native)  |           ✅ Active            |
| **3D Cab View Follow (`Ctrl+Click`)**           |  Fork v1.5.x   | `v1.5.0` (camera snap), `v2.0.0` (seamless transition)         |           ✅ Active            |
| **Consist Selection (`Shift+Click`)**           |  Fork v1.5.x   | `v1.5.0` (selection), `v2.0.0` (operations integration)        |           ✅ Active            |
| **Jump-to Locomotive Menu**                     |  Fork v1.5.x   | `v1.5.0` (loco list), `v2.0.0` (type & road number)            |           ✅ Active            |
| **Signal Aspects on Map**                       |  Fork v1.5.x   | `v1.5.3.6` (aspect display), `v2.0.0` (0.6 CTC signaling)      |           ✅ Active            |
| **Passenger Platform Protection**               |  Fork v1.5.x   | `v1.5.2` (purple highlight), `v2.0.12` (distinct category)     |           ✅ Active            |
| **Industry Area Colors**                        |  Fork v1.5.x   | `v1.5.3.7` (area tints), `v2.0.16` (sub-segment delivery)      |           ✅ Active            |
| **Bulk Switch Reset (Normal/Thrown)**           |  Fork v1.5.x   | `v1.5.3.6` (bulk reset), `v1.5.4` (audit), `v2.0.0` (sync)     |           ✅ Active            |
| **Modded Map Compatibility & Spawns**           |  Fork v1.5.x   | `v1.5.4.1` (branchlines), `v1.5.4.2` (custom spawns)           |           ✅ Active            |
| **Turntable Map Control & Shortcuts**           |  Fork v1.5.x   | `v1.5.4.2` (rotation), `v1.5.4.4` (fouling check), `v2.0.0`    |           ✅ Active            |
| **Road Crossing Markers & Clustering**          |  Fork v1.5.x   | `v1.5.4.4` (crossing markers), `v2.0.0` (31+ clustered)        |           ✅ Active            |
| **Track Grade (%) Slope Overlay**               |  Fork v1.5.x   | `v1.5.4.5` (gradient bands), `v2.0.12` (centralized engine)    |           ✅ Active            |
| **Grade Hover Readout & Markers**               |  Fork v1.5.x   | `v1.5.5` (hover readout), `v2.0.15` (customizable scale)       |           ✅ Active            |
| **Consist Cargo Summary**                       |  Fork v1.5.x   | `v1.5.5` (manifest aggregation), `v2.0.0` (0.6 waybills)       |           ✅ Active            |
| **Individual Freight Car Tooltips**             |  Fork v1.5.x   | `v1.5.5` (waybill destination, weight, air, handbrake)         |           ✅ Active            |
| **Locomotive Fuel Telemetry**                   |  Fork v1.5.x   | `v1.5.5` (coal, water, diesel monitoring), `v2.0.0` (synced)   |           ✅ Active            |
| **Accurate Train Length & Tonnage**             |  Fork v1.5.x   | `v1.5.5` (length & tonnage), `v2.0.0` (gross calculations)     |           ✅ Active            |
| **Advanced Map Controls Toggle**                |  Fork v1.5.x   | `v1.5.6` (UI declutter), `v2.0.0` (preserved dimensions)       |           ✅ Active            |
| **Debug Logging Toggle**                        |  Fork v1.5.x   | `v1.5.6` (config setting), `v2.0.16` (clean production logs)   |           ✅ Active            |
| **Railroader 0.6 Native Mod Support**           |   ME2.0 New    | `v2.0.0` (direct install in Mods folder, no UMM needed)        |           ✅ Active            |
| **Settings File Persistence**                   |   ME2.0 New    | `v2.0.0` (JSON persistence), `v2.0.16` (data protection)       |           ✅ Active            |
| **Station Depot Vector Markers**                |   ME2.0 New    | `v2.0.3` (vector assets), `v2.0.12` (1-click Station Agent)    |           ✅ Active            |
| **Rolling Stock HOPA Alert Badges**             |   ME2.0 New    | `v2.0.3` (Hotbox, Oil, Handbrake, Air, Derailment)             |           ✅ Active            |
| **Rolling Stock Alerts Window**                 |   ME2.0 New    | `v2.0.3` (filters, sorting, Locate/Highlight/Select)           |           ✅ Active            |
| **In-Game Settings Window & Toolbar**           |   ME2.0 New    | `v2.0.4` (swatches, hex edit, section resets, toolbar)         |           ✅ Active            |
| **Continuous Mainline Discovery**               |   ME2.0 New    | `v2.0.12` (unbroken mainline Sylva–Andrews)                    |           ✅ Active            |
| **Centralized Track Overlays (6 Modes)**        |   ME2.0 New    | `v2.0.12` (Routes, SafeSpeed, Grade, Class, Cond, Clean)       |           ✅ Active            |
| **Directional Passenger Breakdowns**            |   ME2.0 New    | `v2.0.12` (Up/Down corridor passenger breakdown)               |           ✅ Active            |
| **1-Click Station Agent Access**                |   ME2.0 New    | `v2.0.12` (click station icon to open Station Agent)           |           ✅ Active            |
| **MOW Yard Track Identification**               |   ME2.0 New    | `v2.0.13` (isolates MOW tracks with dedicated color)           |           ✅ Active            |
| **Keybinding Manager**                          |   ME2.0 New    | `v2.0.14` (in-game keyboard shortcut remapping)                |           ✅ Active            |
| **Locomotive Waypoint Dispatch**                |   ME2.0 New    | `v2.0.15` (`CapsLock` + Left-Click to dispatch train)          |           ✅ Active            |
| **Click-to-Couple Consist Automation**          |   ME2.0 New    | `v2.0.15` (`CapsLock` + Left-Click car to couple)              |           ✅ Active            |
| **Live Route Preview Line & HUD**               |   ME2.0 New    | `v2.0.15` (real-time path tracing and target HUD)              |           ✅ Active            |
| **1-Click Waypoint Cancel**                     |   ME2.0 New    | `v2.0.15` (`CapsLock` + Right-Click to cancel orders)          |           ✅ Active            |
| **Train Car Context Menu**                      |   ME2.0 New    | `v2.0.15` (right-click car for brake, air, and consist)        |           ✅ Active            |
| **Smart Handbrakes Engine**                     |   ME2.0 New    | `v2.0.15` (grade-calculated handbrakes, engine safety)         |           ✅ Active            |
| **Cut Behind Locomotive**                       |   ME2.0 New    | `v2.0.15` (uncouple lead engine and auto-secure train)         |           ✅ Active            |
| **Consist Air & Steam Line Controls**           |   ME2.0 New    | `v2.0.15` (connect/disconnect lines, bleed air)                |           ✅ Active            |
| **Track & Yard Signs from Map**                 |   ME2.0 New    | `v2.0.15` (right-click track to place speed limits/signs)      |           ✅ Active            |
| **Sign Badges & Interactive Editing**           |   ME2.0 New    | `v2.0.15` (click sign badge to open sign editor)               |           ✅ Active            |
| **Tooltip Sizing & Scale Controls**             |   ME2.0 New    | `v2.0.15` (in-game font scale and width controls)              |           ✅ Active            |
| **Map Backgrounds (4 Modes)**                   |   ME2.0 New    | `v2.0.16` (Disabled, Custom Image, USGS Topo, OSM)             |           ✅ Active            |
| **Dynamic Map Tile Streaming**                  |   ME2.0 New    | `v2.0.16` (dynamic zoom ladder Zooms 13–17)                    |           ✅ Active            |
| **Pre-Packaged Offline Topo Pack**              |   ME2.0 New    | `v2.0.16` (Andrews–Sylva pack Zooms 12–16, 6,040 tiles)        |           ✅ Active            |
| **Custom Image Background Support**             |   ME2.0 New    | `v2.0.16` (auto-fit bounding box or JSON calibration)          |           ✅ Active            |
| **Physical Safe Speed Curve Overlay**           |   ME2.0 New    | `v2.0.16` (curvature physics safe speed, 6 bands)              |           ✅ Active            |
| **Passing Siding Accuracy Fix**                 |   ME2.0 New    | `v2.0.16` (siding tracks stay blue along entire span)          |           ✅ Active            |
| **Sub-Segment Industry Delivery Slicing**       |   ME2.0 New    | `v2.0.16` (only exact delivery spots highlighted)              |           ✅ Active            |
| **Completed Milestone Site Cleanup**            |   ME2.0 New    | `v2.0.16` (completed sites revert to route colors)             |           ✅ Active            |
| **Upright Track Sign Text**                     |   ME2.0 New    | `v2.0.16` (labels and speed numbers stay upright)              |           ✅ Active            |
| **Persistent Functional Track Colors**          |   ME2.0 New    | `v2.0.16` (functional colors immune to switch throws)          |           ✅ Active            |
| **Custom Switch Throat Dimming**                |   ME2.0 New    | `v2.0.16` (custom color for unaligned switch tracks)           |           ✅ Active            |
| **Settings & Map Data Protection**              |   ME2.0 New    | `v2.0.16` (updating preserves settings, tiles, images)         |           ✅ Active            |
| **Car Marker Dimension Customization**          |   ME2.0 New    | `v2.0.16` (end seam trim & side flank trim sliders)            |           ✅ Active            |
| **Consist Car Shingling & Depth Filing**        |   ME2.0 New    | `v2.0.16` (topological depth layering over neighbor tails)     |           ✅ Active            |
| **Alternating Consist Colors**                  |   ME2.0 New    | `v2.0.16` (zebra shading toggle for same-destination cars)     |           ✅ Active            |
| **Selected Car & Locomotive Map Highlighting**  |   ME2.0 New    | `v2.0.16` (pulsing golden halo for selected cars & engines)    |           ✅ Active            |
| **USGS Satellite & Topo Pack (`USGSImageryTopo`)** | ME2.0 New   | `v2.0.17` (3rd pack: NAIP aerial imagery + contours & labels)  |           ✅ Active            |
| **3 Hover HUD Modes & Inspection HUD (`Ctrl+H`)**  | ME2.0 New   | `v2.0.17` (Attached, Cursor, Resizable Pinned HUD + Loco+Consist)|         ✅ Active            |
| **Intelligent Coupling-Point Dispatch**         |   ME2.0 New    | `v2.0.17` (open coupler check & run-around route planning)     |           ✅ Active            |
| **Track Condition Metric & Hover Details**      |   ME2.0 New    | `v2.0.17` (Class, Condition, Speed, Weeds & Per-Class sync)    |           ✅ Active            |

---

## 16. Historical Release Milestones & Version History

### Vanguard Era (Original Mod)

- **v1.0.0** — Initial release by Vanguard: Clickable switch markers, basic track color coding, far-zoom switch cutoff.
- **v1.0.1** — Double-click switch throw toggle, switch alignment colors, CTC permission checks.
- **v1.1.0** — Proportional length-scaled car markers, min/max zoom settings, track line thickness, flare markers.
- **v1.2.0** — Resizable floating map window, anti-aliasing (MSAA) integration.
- **v1.3.0** — Docked vs floating map window modes (`Z`), window dimension memory.
- **v1.3.1** — Automatic graphics quality detection and MSAA synchronization.
- **v1.4.0** — Upright car labels and reporting marks, camera follow mode (`Ctrl+Z`), camera re-center (`Shift+Z`), jump-to location dropdown.

### Reaper8f Community Fork Era

- **v1.5.0** — 3D cab view follow (`Ctrl+Click`), consist selection (`Shift+Click`), jump-to locomotive dropdown, Connelly & Walker location additions.
- **v1.5.2** — Signal aspect indicators on map, distinct passenger platform protection highlighting (`#800080`).
- **v1.5.3.6** — Visual-only track coloring engine, bulk switch reset tools (Reset All to Normal / Thrown).
- **v1.5.3.7** — Industry-area track color tinting by territory.
- **v1.5.4.1** — Modded map compatibility improvements, switch reset audit logging with player names.
- **v1.5.4.2** — Map-based turntable controls with rotation shortcuts, mod-provided spawn point integration.
- **v1.5.4.4** — Turntable bridge fouling & clearance verification, road crossing markers and clustering (31+ crossings).
- **v1.5.4.5** — Track grade (%) slope analysis overlay, uphill/downhill directional markers, numeric grade labels.
- **v1.5.5** — Rich train hover telemetry card (gross tonnage, length, fuel levels, consist cargo manifests, waybill destinations, individual car tooltips).
- **v1.5.6** — Advanced map controls toggle, debug logging toggle (`EnableDebugLogging`), map resize preservation fix.

### Map Enhancer 2.0 Era (Railroader 0.6+ MOW Expansion)

- **v2.0.0** — Complete ground-up rebuild as a native Railroader 0.6 C# mod (no UMM required). Direct installation in `Documents\Railroader\Mods\`. JSON settings persistence.
- **v2.0.3** — Lateral rolling stock defect alert badges (HOPA: Hotbox, Oil, Handbrake, Air, Derailment), Dedicated Rolling Stock Alerts Window, map-corner defect counter, custom depot vector markers.
- **v2.0.4** — In-game settings window (`Ctrl+M` / `[ME]` button), RGBA/Hex color customizers with live swatches and section resets.
- **v2.0.12** — Continuous mainline discovery engine (Sylva to Andrews), centralized track overlay system (6 modes), directional passenger breakdown on station hover, 1-click Station Agent access.
- **v2.0.13** — Maintenance of Way (MOW) track classification and dedicated color rendering.
- **v2.0.14** — Full in-game keybinding manager for remapping shortcuts without editing JSON files.
- **v2.0.15** — Interactive click-to-dispatch waypoints (`CapsLock`), click-to-couple consist automation, live route preview tracing, right-click car context menu, smart handbrakes engine, track and yard sign placement.
- **v2.0.16** — Topographic map backgrounds (USGS Topo, OpenStreetMap live slippy tiles, custom images), physical safe speed curvature overlay, CTC passing siding BFS propagation fix, sub-segment industry delivery slicing, upright sign text fix, settings & tile asset preservation during updates, car marker length and width trimming sliders, consist car depth filing/shingling, alternating consist colors (zebra contrast with in-game toggle), and selected car/locomotive map outline highlighting (animated golden pulse halo, combined steam engine + tender support, and vertical depth boost).
- **v2.0.17** — Added 3rd offline corridor tile pack (**USGS Satellite & Topo / `USGSImageryTopo`** with USDA NAIP aerials + contours & place labels, 926 MB), 3 selectable **Hover HUD Display Modes** including a detached, resizable **Inspection HUD window** (`Ctrl+H` toggle hotkey & conditional map `HUD` button), reorganized entity views unifying locomotive + tender + consist telemetry, **Intelligent Coupling-Point Dispatch** with occupied-end run-around route planning, **Live Route Preview** keybind, toggleable Track Class/Condition/Speed & Weed Growth hover details paired with **Per-Class vs Overall Condition** metric alignment, Linux/Proton archive path normalization, and updated installers/documentation.

---

## 17. Contributors, Credits & Repositories

- **Vanguard / Original Authors** — Created the original Map Enhancer mod and established its foundational map interface, track classification, switch interaction, and locomotive navigation.
- **Reaper8f** — Lead developer of Map Enhancer 2.0 and maintainer of the v1.5.x community fork, introducing telemetry systems, HOPA defect alerts, interactive dispatching, tile streaming, and 0.6 native architecture.
- **Cartography & Spatial Data:**
  - **OpenStreetMap Contributors** — Map data © [OpenStreetMap contributors](https://www.openstreetmap.org/copyright) under ODbL 1.0. Cartographic stylesheet `openstreetmap-carto` under CC-BY-SA 2.0. Offline tiles rendered locally via private toolchain.
  - **U.S. Geological Survey (USGS) & USDA NAIP** — Appalachian topographic contours, NAIP aerial orthoimagery, hillshading, waterways, and elevations courtesy of USGS The National Map & USDA FPAC (Public Domain).
- **Community Contributors & Testers** — Railroader community members who contributed bug reports, multiplayer testing, track geometry feedback, and suggestions.

### Source Repositories

- **Map Enhancer 2.0 (Official Current):** [https://github.com/Reaper8f/railroader-mapenhancer2.0](https://github.com/Reaper8f/railroader-mapenhancer2.0)
- **Reaper8f v1.5.x Community Fork:** [https://github.com/Reaper8f/rr-mapenhancer-fix](https://github.com/Reaper8f/rr-mapenhancer-fix)
- **Original Vanguard Map Enhancer:** [https://github.com/mricher-git/rr-mapenhancer-mod](https://github.com/mricher-git/rr-mapenhancer-mod)

---

## 18. Installation & Setup

> **Target Game:** Railroader 0.6.0+ Experimental<br />
> **Mod Type:** Native C# 9.0 (.NET Framework 4.7.2)<br />
> **Folder Name:** `Documents\Railroader\Mods\reaper-map-enhancer\`<br />
> **Active Mod Manifest:** `Info.json` (`identifier: "reaper/map-enhancer"`)

---

### ⚠️ Critical Notice: User Data Preservation on Updates

When updating Map Enhancer to a newer version:

- **Do not delete your existing `reaper-map-enhancer` folder!**
- Deleting the folder permanently erases:
  1. **`settings.json`** — Custom keybindings, overlay colors, car trim sliders, zoom thresholds, and options.
  2. **`Backgrounds/`** — Any custom maps, diagrams, and companion calibration JSON files you added.
  3. **`Tiles/`** — Pre-downloaded offline USGS Topo (~692 MB), USGS Satellite & Topo (~926 MB), and OpenStreetMap (~76.5 MB) map tile packs.

Use either **Method 1 (Automated 1-Click Installer)** or **Method 2 (Safe Manual Update)** below.

---

### Method 1: Automated 1-Click Install & Update (Recommended)

Every official release archive includes **`install.bat`** and **`downloadtiles.bat`**.

1. Download the latest release `reaper-mapenhancer-2.x.x.zip` from [GitHub Releases](https://github.com/Reaper8f/railroader-mapenhancer2.0/releases) or [Nexus Mods](https://www.nexusmods.com/railroader/mods/18/).
2. Extract the archive into any temporary folder (e.g. your `Downloads` directory).
3. Ensure **Railroader** is closed (Windows locks mod DLL files while the game runs).
4. Double-click **`install.bat`**.

**What `install.bat` does automatically:**

- [✓] Auto-discovers `Documents\Railroader\Mods\` (handles OneDrive document redirection seamlessly).
- [✓] Backs up your existing `settings.json` before touching files and restores it immediately upon copy completion.
- [✓] Preserves your custom images in `Backgrounds\` and all downloaded map tiles in `Tiles\` untouched.
- [✓] Removes obsolete legacy folders (like `vanguard-map-enhancer`) after migrating old settings/tiles, preventing duplicate assembly load crashes.
- [✓] Verifies file hashes of deployed assemblies to guarantee a clean, corruption-free installation.
- [✓] Offers to launch `downloadtiles.bat` if offline map tiles are not yet installed.

---

### Downloading Offline Map Tiles (`downloadtiles.bat`)

Map Enhancer supports 100% offline local slippy map tiles with zero network requests during gameplay.

1. Double-click **`downloadtiles.bat`** (located in your mod folder or extracted zip).
2. Choose from the interactive menu:
   - **`[1]` USGS Topographic Corridor Pack (~692 MB, 6,040 tiles, Zooms 12–16):** Authentic Appalachian mountain contours, elevations, waterways, and historical alignments from USGS The National Map (100% US Government Public Domain).
   - **`[2]` OpenStreetMap Corridor Pack (~76.5 MB, 23,315 tiles, Zooms 12–17):** High-contrast street, river, highway GIS cartography with razor-sharp yard switching detail (~0.97 m/px).
   - **`[3]` USGS Satellite & Topo Corridor Pack (~926 MB, 6,040 tiles, Zooms 12–16):** High-resolution USDA NAIP aerial orthoimagery with USGS contours, rivers, roads, and station place names.
   - **`[4]` All 3 Packs (~1.65 GB Total):** Recommended for instant multi-provider toggling in the game.
3. The script displays real-time download speed and progress, verifies the cryptographic **SHA256 checksum**, and automatically extracts all tiles into `Tiles\USGSTopo\`, `Tiles\OSM\`, or `Tiles\USGSImageryTopo\`.

**In-Game Activation:**

1. Start Railroader and load your world.
2. Press **`M`** to open the map (Railroader default).
3. Press **`Ctrl+M`** (or click the **`[ME]`** button in the upper-left corner) to open mod options.
4. Set **Map Background** to **`Map Tiles (Local Tile Packs)`**.
5. Select **`USGSTopo`**, **`USGSImageryTopo`**, or **`OSM`** from the **Tile Set** dropdown.

---

### Method 2: Safe Manual Installation & Update

**Standard Mod Location:**

```text
%USERPROFILE%\Documents\Railroader\Mods\reaper-map-enhancer\
```

**Step-by-Step Manual Update:**

1. Exit Railroader.
2. Open your mod folder: `Documents\Railroader\Mods\reaper-map-enhancer\`.
3. _(Optional precaution)_ Copy `settings.json` to your desktop as a backup.
4. Copy the new files from the release ZIP into `reaper-map-enhancer\`:
   - `MapEnhancer.dll`, `0Harmony.dll`, `Info.json`
   - Assets: `station.png`, `arrow.png`, `flare.png`, `level-crossing.png`, `traincar.png`, `MapEnhancer2.0.png`, `mapenhancer-station-marker.svg`
   - Scripts: `install.bat`, `downloadtiles.bat`, `INSTALL_AND_UPDATE_GUIDE.txt`
5. When Windows displays the prompt, choose **"Replace the files in the destination"**. Your existing `settings.json`, `Backgrounds/`, and `Tiles/` folders will remain untouched.
6. Delete any obsolete `Documents\Railroader\Mods\vanguard-map-enhancer` directory if present.

**Manual Offline Tile Pack Locations:**

- **USGS Satellite & Topo Archive:** Extract to `Documents\Railroader\Mods\reaper-map-enhancer\Tiles\USGSImageryTopo\` (SHA256: `E3612DD9F3129684DB65877CD53C08CAF0D1B1147B99D647CF0C058CCD3C74A7`)
- **USGS Topo Archive:** Extract to `Documents\Railroader\Mods\reaper-map-enhancer\Tiles\USGSTopo\` (SHA256: `0539BEFAA157DB5CCAB136FCA0B485EEAD6F0BEED6457AA53EF973F49CFD53F8`)
- **OpenStreetMap Archive:** Extract to `Documents\Railroader\Mods\reaper-map-enhancer\Tiles\OSM\` (SHA256: `40587516F526027644A593829D23F590A20DFC00280204137C0B72B03322AE5E`)

---

### Default Controls & Keyboard Shortcuts

| Shortcut                     | Action                    | Description                                                                |
| :--------------------------- | :------------------------ | :------------------------------------------------------------------------- |
| **`M`**                      | **Open / Close Map**      | Railroader default key to open or close the map.                           |
| **`Ctrl + M`**               | **Map Enhancer Settings** | Opens the Map Enhancer Options & Overlay Configuration panel.              |
| **`Ctrl + H`**               | **Inspection HUD**        | Shows or hides the dedicated Inspection HUD window (like clicking `HUD`).  |
| **`Z`**                      | **Maximize / Float Map**  | Toggles between compact docked view and large floating resizable window.   |
| **`Shift + Z`**              | **Follow Selected Car**   | Camera smoothly tracks the active locomotive or railcar.                   |
| **`Ctrl + Z`**               | **Recenter Camera**       | Instantly centers map camera on player world position.                     |
| **`CapsLock + Click`**       | **Waypoint Dispatch**     | Dispatches selected locomotive to track location or couples to target car. |
| **`CapsLock + Right-Click`** | **Cancel Dispatch**       | Cancels active waypoint navigation orders immediately.                     |
| **`Right-Click Car`**        | **Context Menu**          | Opens rolling stock handbrake, air line, and consist action menu.          |
| **`Right-Click Track`**      | **Track Signs & Flares**  | Place speed limit signs, whistle posts, yard limits, and flares on track.  |
| **`Scroll Wheel`**           | **Smooth Zoom**           | Multi-tier zoom streaming with 5% mathematical hysteresis band.            |
