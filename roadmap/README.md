# Map Enhancer — Public Development Roadmap

Welcome to the **Map Enhancer** public roadmap. This page outlines what has been accomplished in recent releases, what is currently in active development, and what is planned for future updates.

Our core design principle: **Rendering correctness, operational safety, and player immersion always come before adding visual clutter.**

---

## 🚦 Roadmap at a Glance

| Status           | Focus Area                            | Description                                                        |   Target    |
| :--------------- | :------------------------------------ | :----------------------------------------------------------------- | :---------: |
| 🟢 **Completed** | **Offline Topo & Slippy Tiles**       | 100% offline USGS Topo & OSM tile streaming with pure hysteresis.  | **v2.0.16** |
| 🟢 **Completed** | **Safe Speed Curve Overlay**          | Physics-based curve radius analysis showing safe corridor speeds.  | **v2.0.16** |
| 🟢 **Completed** | **Waypoint Dispatch & Coupling**      | Point-and-click AutoEngineer dispatching and coupling ribbon.      | **v2.0.15** |
| 🟢 **Completed** | **Smart Handbrakes & Context Menu**   | Grade-calibrated holding brakes protecting motive power.           | **v2.0.15** |
| 🟢 **Completed** | **Industry Delivery Slicing**         | Sub-segment interval accuracy so only active delivery spots color. | **v2.0.16** |
| 🔵 **Maybe**     | **Map Search & Train Finder**         | Quick search bar for locomotives, railcars, towns, and industries. | **Future**  |
| 🔵 **Maybe**     | **Industry Supply Chain HUD**         | Visual indicators for input shortages and loaded output goods.     | **Future**  |
| 🔵 **Maybe**     | **Multiplayer Crew Utilities**        | Player name markers, crew camera jump, and shared map pings.       | **Future**  |
| 🔵 **Maybe**     | **Map Bookmarks & Screenshot Export** | Save favorite camera locations and export high-res map charts.     | **Future**  |

---

## 🟢 Completed Milestones (Implemented)

### Version 2.0.16 — The Cartography & Physics Update

- [x] **100% Offline Slippy Map Backgrounds:** High-performance local tile streaming for **USGS Topo** (Appalachian contours & elevations) and **OpenStreetMap** (high-contrast roads & yards).
- [x] **Pure 5% Mathematical Hysteresis:** Smooth zoom transitions between zoom levels without camera flicker or black flashes.
- [x] **Curvature Safe Speed Overlay (INV-026):** Evaluates track curve geometry and color-codes safe speeds ($\le 10\text{ mph}$ up to $> 35\text{ mph}$) to prevent derailments.
- [x] **CTC Passing Siding Propagation:** Breadth-first route search correctly classifies intermediate passing sidings as Branch Blue instead of Mainline Green.
- [x] **Rolling Stock Geometry Trimming:** Sliders for car marker length and width trimming with two-tone alternating consist shading.
- [x] **Automated Setup Scripts:** Bundled `install.bat` (preserves settings and tiles) and `downloadtiles.bat` (automated tile pack downloads with SHA256 verification).

### Version 2.0.15 — Interactive Operations & Waypoint Dispatch

- [x] **Point-and-Click Waypoint Dispatch:** Hold `CapsLock` to display precision crosshair; left-click track to dispatch selected locomotives via AutoEngineer.
- [x] **Click-to-Couple Automation:** Automatically detects reachable couplers and routes locomotives for a soft joint.
- [x] **Live Route Ribbon & Obstruction Warning:** Traces path from locomotive to target, pulsing red if blocked or switches are locked.
- [x] **Rolling Stock Context Menu:** Right-click any railcar on the map for brake, air line, and throttle operations.
- [x] **Grade-Aware Smart Handbrakes:** Calculates holding brakes based on track grade (10% flat, 25% moderate, 50% steep) while safely protecting locomotives and tenders.
- [x] **Track & Yard Signs on Map:** In-game placement and map rendering of mileposts, whistle posts, speed limits, and yard signs with corrected text orientation.

### Version 2.0.0 – 2.0.14 — Core Native Foundation

- [x] **Native Railroader 0.6+ Architecture:** Direct C# mod loaded from `Documents\Railroader\Mods\reaper-map-enhancer\` (no Unity Mod Manager required).
- [x] **Centralized 6-Mode Map Overlays:** Instant switching between Routes, Grade Slopes, Safe Speeds, FRA Track Classes, Track Condition, and Ballast Cleanliness.
- [x] **HOPA Mechanical Defect Alerts:** Real-time monitoring and map warning badges for Hotboxes, Low Oil, Dragging Handbrakes, Air Leaks, and Derailments.
- [x] **Turntable Safety Clearance & Stepper:** Automatic fouling clearance detection and bridge rotation steps (`Ctrl+Click`, `Alt+Click`, `Ctrl+Shift+Click`).
- [x] **Consist Telemetry HUD:** Gross tonnage, train velocity, passenger destinations, fuel reserves, and waybill summaries on hover.

---

## 🟡 Currently in Progress (Active Focus)

### 1. Industry Delivery TrackSpan Interval Precision (P0)

- Refining track delivery spot geometry so that only the exact car-spotting interval is colored, preventing industry colors from bleeding onto through-tracks in complex rail yards (e.g. East Whittier).
- Ensuring full compatibility with Maintenance of Way tracks, interchange tracks, and multi-segment curves.

### 2. Search, Jump & Train Finder (P1)

- **Fast Search Bar:** Integrated map toolbar search to quickly find trains by locomotive road number, car reporting mark, town, or industry name.
- **One-Click Jump:** Click search results to instantly snap the camera to the train or industry siding.
- **Train List HUD:** Dedicated dropdown listing all active trains with current speed, engineer assignment, and location.

---

## 🔵 Planned Features (Upcoming Milestones)

### 3. Industry Intelligence & Supply Chain HUD (P1)

- Visual indicators showing which industries are active, waiting for empties, or blocked by full output tracks.
- Hover details summarizing input material shortages (e.g., coal for power plants, logs for sawmills) and finished goods ready for pickup.

### 4. Consist & Yard Switching Assistance (P2)

- Visual front/rear consist markers and indicators for parted air hoses or uncoupled cars.
- One-click "Select Entire Connected Consist" to make yard classification and switching easier.
- Fuel and water servicing station markers (coaling towers, water plugs, diesel pumps) on the dispatch map.

### 5. Multiplayer Crew Coordination (P2)

- **Player Markers & Labels:** Render connected crew members on the map with custom color badges.
- **Crew Jump:** Quick jump to teleport or view connected crew members.
- **Shared Dispatch Pings:** Place temporary tactical markers or slow-order zones visible to all crew members.

---

## ⚪ Under Review & Explorations (Future Considerations)

- **Overlay Profiles:** Save and switch between custom map color and layer presets (e.g., "Night Dispatch", "Maintenance Crew", "Yardmaster").
- **Map Export:** Export high-resolution PNG map images with custom overlays and legends for framing or web route planning.
- **CTC Signal Block Aspects:** Displaying real-time CTC signal block occupancy and signal head aspects on the dispatch screen.
- **Custom Alert Audio:** Optional audio cues when a HOPA defect (hotbox or dragging handbrake) is detected.

---

## 💡 Have an Idea or Feedback?

We build Map Enhancer for the community!

- Submit feature proposals via our **[Feature Request Form](../../issues/new?template=feature_request.yml)**.
- Share ideas and vote on proposals in **[GitHub Discussions](https://github.com/Reaper8f/Railroader-MapEnhancer/discussions)**.
- Join the conversation in the **[Official Railroader Discord Thread](https://discord.com/channels/795878618697433097/1212693563738034196)**.
