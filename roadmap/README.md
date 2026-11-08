# Map Enhancer — Public Development Roadmap

Welcome to the **Map Enhancer** public roadmap. This page outlines what has been accomplished in recent releases, what is currently in active development, and what is planned for future updates.

Our core design principle: **Operational realism, dispatching ease, and player immersion without visual clutter.**

---

## 🚦 Roadmap at a Glance

| Status             | Focus Area                        | Description                                                                           |     Target     |
| :----------------- | :-------------------------------- | :------------------------------------------------------------------------------------ | :------------: |
| 🟢 **Completed**   | **Offline Topo & Slippy Tiles**   | 100% offline USGS Topo & OSM tile streaming with smooth zoom transitions.             |  **v2.0.16**   |
| 🟢 **Completed**   | **Physical Safe Speed Overlay**   | Curve geometry analysis color-coding safe corridor speeds to prevent derailments.     |  **v2.0.16**   |
| 🟢 **Completed**   | **Waypoint Dispatch & Coupling**  | Click-to-dispatch locomotive navigation and click-to-couple via AutoEngineer.         |  **v2.0.15**   |
| 🟢 **Completed**   | **Smart Handbrakes & Car Menu**   | Grade-calibrated holding brakes protecting motive power and right-click car menu.     |  **v2.0.15**   |
| 🟢 **Completed**   | **HOPA Mechanical Defect Alerts** | Real-time map badges & alert window for hotbox, oil, handbrake, leak, and derailment. |  **v2.0.0+**   |
| 🟢 **Completed**   | **Turntable Map Controls**        | Rotating bridge display, clearance safety check, and rotation shortcuts.              |  **v2.0.0+**   |
| 🟢 **Completed**   | **Consist Telemetry & Shingling** | Gross tonnage, car tooltips, alternating contrast, and selected equipment halos.      |  **v2.0.16**   |
| 🟡 **In Progress** | **Map Search & Train Finder**     | Instant search bar to quickly find locomotives, railcars, industries, and towns.      | **Next Minor** |
| 🟢 **Completed**   | **Industry Delivery Refinements** | Fine-tuned delivery spot highlighting and spur span interval calibration.             |  **v2.0.16**   |
| 🟢 **Completed**   | **Consist Visual Aids**           | Full consist outline highlighting, train head/rear markers, and air hose alerts.      |  **v2.0.16**   |
| 🔵 **Planned**     | **Industry Supply Chain HUD**     | Visual status for active/waiting industries, input shortages, and ready cargo.        |   **Future**   |
| 🔵 **Planned**     | **Multiplayer Crew Tools**        | Player map markers, crew camera jump, and shared dispatch pings.                      |   **Future**   |
| 🔵 **Planned**     | **Map Bookmarks & Export**        | Save favorite yard/depot views and export high-resolution map screenshots.            |   **Future**   |
| 🔵 **Planned**     | **Turntable Speed Controls**      | Multi-speed turntable rotation settings (1x, 2x, 4x) for faster engine servicing.     |   **Future**   |
| 🔵 **Planned**     | **CTC Block Occupancy**           | Signal block reservation visualization and route measurement tools.                   |   **Future**   |

---

## 🟢 Completed Features (What We've Built)

### 1. 🗺️ Topographic Backgrounds & Map Tile Streaming (v2.0.16)

- **100% Offline Local Tile Streaming:** High-performance local tile streaming for **USGS Topo** (Appalachian contours & elevations) and **OpenStreetMap** (high-contrast roads & yards). Zero active internet connection required during gameplay.
- **Custom Map Images:** Load your own historic track charts, aerial photos, or maps from the `Backgrounds/` folder with auto-fit or coordinate calibration.
- **Smooth Zoom Ladder:** 6 seamless zoom tiers (Zooms 12 to 17) with anti-jitter smoothing to eliminate flickering and black flashes.
- **Buttery-Smooth Performance:** Low-memory texture caching, recycled sprite renderers, and frame-budgeted loading keep game FPS rock solid.

### 2. 📍 Tactical Map Dispatching & Waypoint Navigation (v2.0.15)

- **Click-to-Dispatch:** Hold `CapsLock` to display precision crosshair; left-click track to dispatch selected locomotives via AutoEngineer.
- **Click-to-Couple Automation:** Click any stationary railcar or consist to automatically route locomotives for a soft joint.
- **Live Route Preview Ribbon:** Traces the planned route from locomotive to target, pulsing red if blocked or switches are locked.
- **Instant Order Cancellation:** Hold `CapsLock` and right-click anywhere to cancel active dispatch orders immediately.

### 3. 🔧 Rolling Stock Operations & Context Menu (v2.0.15)

- **Interactive Car Menu:** Right-click any railcar or locomotive on the map for brake, air line, and throttle operations.
- **Smart Handbrakes:** Automatically calculates holding handbrakes based on track grade (10% flat, 25% moderate, 50% steep) while safely protecting locomotives and tenders from brake drag.
- **Cut Behind Locomotive:** Instantly uncouples the engine and tender with one click and secures trailing cars with Smart Handbrakes.
- **Consist Air & Bleed Controls:** Connect/disconnect air hoses, cycle angle cocks, or bleed brake reservoirs for swift yard switching.

### 4. 📊 6 Centralized Map Overlays (v2.0.12 – v2.0.16)

- **Functional Routes:** Clear color-coding for Mainline (Green), Passing Sidings & Branches (Blue), Industry Tracks (Yellow), and MOW Tracks.
- **Physical Safe Speed Curves:** Evaluates track curvature physics to show safe operating speeds ($\le 10\text{ mph}$ up to $> 35\text{ mph}$) to prevent train derailments.
- **Track Grade (%):** Visualizes hill climbs and downgrades from flat to steep ($\ge 3\%$) with hover readouts and slope arrows.
- **FRA Safety Classes:** Displays track speed standards according to official FRA track classes (Class 0 to 5).
- **Track Condition:** Highlights physical rail and tie wear so you can schedule Maintenance of Way work before slow orders occur.
- **Track Cleanliness:** Identifies overgrown lines that need brush-cutting.
- **Dynamic On-Screen Legend:** Floating guide that automatically updates to explain whichever overlay is active.

### 5. 🚨 Rolling Stock Mechanical Defect Alerts — HOPA (v2.0.3)

- **Real-Time Telemetry Scans:** Continuously monitors all cars across the railroad for **H**otbox bearings, Low **O**il, Dragging Handbrakes (**P**), **A**ir leaks, and **D**erailments.
- **Lateral Warning Badges:** Compact, upright letter badges float next to defective cars on the map.
- **Dedicated Alerts Window:** Filter, sort, and jump directly to any defective car with 1-click **Locate**, **Highlight**, and **Inspect**.
- **Map-Corner Defect Counter:** Mini badge in the corner of your map displays active railroad defects at a glance.

### 6. 🔄 Turntables, Crossings & Track Controls (v2.0.0 – v2.0.16)

- **Interactive Turntables:** Live rotating bridge markers in Whittier, Bryson, and Andrews that match the 3D bridge in real time.
- **Anti-Derailment Safety:** Automatically verifies that no equipment is straddling the pit boundary before allowing bridge movement.
- **Rotation Shortcuts:** `Ctrl+Click` to step clockwise, `Alt+Click` to step counter-clockwise, and `Ctrl+Shift+Click` for 180° engine turning.
- **Global Switch Reset:** Reset all switches across the railroad to Normal or Thrown from the toolbar, with multiplayer chat audit logs.
- **Road Crossings & Signs:** Over 31 road crossing markers and in-game placement of track signs, whistle posts, and flares with upright text.

### 7. 📈 Consist Telemetry & Equipment Highlighting (v2.0.16)

- **Hover Telemetry Card:** Instant summary of total gross tonnage, train length in feet, speed, car counts, and fuel levels (coal/water or diesel).
- **Consist Shingling & Contrast:** Sequential car depth filing and alternating zebra shading allow easy car counting in long trains.
- **Car Dimension Sliders:** In-game sliders for car marker length and width trimming prevent overlapping icons in yards.
- **Pulsating Golden Halo:** Selected cars and engine/tender pairs glow with an animated high-contrast halo.
- **Station Agent Access:** Hover over stations for directional passenger counts, or click to open the Station Agent menu directly from the map.

---

## 🟡 Currently in Progress (Active Focus)

These items are actively being worked on based on our internal tracker and player feedback:

### 1. 🔍 Map Search & Train Finder

- Add a quick search bar to the map toolbar to find any locomotive by road number or model, any car by reporting mark, and jump to any town or industry with a single click.
- Filter search results by active trains, empty cars, or specific cargo types.

### 2. 🏭 Industry Delivery Span Refinements

- Fine-tune sub-segment track interval detection so complex multi-track yard spurs (such as East Whittier) highlight only the exact delivery spot while leaving through-tracks untouched.
- Clean up completed milestone construction sites so they revert to proper mainline/branch track colors upon completion.

### 3. 🔗 Consist Visual Aids & Integrity

- **Full Consist Map Highlighting:** Highlight all cars belonging to an active train when the locomotive is selected.
- **Head & Rear Markers:** Clear visual indicators for the front and rear of long trains.
- **Uncoupled Air Hose Alerts:** Immediate map markers for parted trains or forgotten gladhands.

---

## 🔵 Planned Features & Future Roadmap

These items are planned for upcoming minor and major updates:

### 1. 🏭 Industry Supply Chain HUD

- Visual indicators showing whether an industry is actively producing, waiting for raw materials, or blocked with finished goods.
- Information cards for input shortages, output inventory, and ready-to-ship waybills.

### 2. 👥 Multiplayer Crew Tools

- Player name badges and markers displayed on the dispatch map.
- 1-click camera jump to crew members and fellow engineers.
- Shared tactical map pings for multiplayer dispatch coordination.

### 3. 📍 Map Bookmarks & Screenshot Export

- Save favorite camera locations and yard viewpoints with custom labels.
- Export high-resolution map screenshots with active overlays and markers included for printing or sharing.

### 4. ⚙️ Turntable Speed Controls & Route Measurement

- Configurable turntable rotation speeds (1x, 2x, 4x) for faster engine servicing in busy yards.
- Interactive route measuring tool to check distance in feet and ruling grade between any two points on the railroad.

### 5. 🚦 CTC Block Occupancy & Signal Aspects

- Visual display of CTC block reservations and dispatcher track warrants.
- Real-time signal aspect indication across all signaled junctions.

---

## 💡 Have an Idea or Feedback?

We build Map Enhancer for the community!

- Submit feature proposals via our **[Feature Request Form](https://github.com/Reaper8f/Railroader-MapEnhancer/issues/new?template=feature_request.yml)**.
- Share ideas and vote on proposals in **[GitHub Discussions](https://github.com/Reaper8f/Railroader-MapEnhancer/discussions)**.
- Join the conversation in the **[Official Railroader Discord Thread](https://discord.com/channels/795878618697433097/1212693563738034196)**.
- Submit suggestions via our **[Nexus Mods Page](https://www.nexusmods.com/railroader/mods/18)**.
