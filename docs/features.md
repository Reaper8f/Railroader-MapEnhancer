# Map Enhancer for Railroader — Comprehensive Features Guide

**Target Game Version:** Railroader 0.6.0+ Experimental  
**Current Mod Version:** v2.0.16  
**Package:** `reaper-mapenhancer-2.0.16.zip`  
**Official Website:** [https://mapenhancer.refizar.in](https://mapenhancer.refizar.in)  
**Nexus Mods:** [https://www.nexusmods.com/railroader/mods/18](https://www.nexusmods.com/railroader/mods/18)  
**Official Discord Thread:** [Map Enhancer Thread](https://discord.com/channels/795878618697433097/1212693563738034196)

---

## Overview

**Map Enhancer 2.0 (ME2.0)** transforms Railroader’s in-game map into an advanced dispatching, operations, and telemetry platform. From managing local yard freight switching to coordinating heavy mainline runs across the entire corridor, it equips players and multiplayer crews with:

- **Interactive Locomotive Dispatching & Waypoints:** Point-and-click movement and coupling automation with AutoEngineer pathfinding.
- **6 Dynamic Operational Overlays:** Instant visual switching between Routes, Grade Slopes, Curvature Safe Speeds, FRA Track Safety Classes, Track Condition, and Ballast Cleanliness.
- **100% Offline Topographic Slippy Tiles:** Multi-resolution USGS Topo and OpenStreetMap map tile streaming directly beneath the track network.
- **Rolling Stock Operations & Smart Handbrakes:** Right-click context menus for grade-calibrated handbrakes, trainline air connections, and engine throttle cuts.
- **HOPA Rolling Stock Defect Alerts:** Early warning detection for Hotbox overheats, Low Oil levels, Dragging Handbrakes, Air Leaks, and Derailments.
- **Turntable Stepper Controls & Clearance:** Precision bridge step rotation with fouling clearance checks.
- **Live Consist & Cargo Telemetry:** Gross tonnage, speed, passenger destinations, fuel levels, and waybill summaries.

---

## 1. Tactical Map Dispatching & Waypoint Navigation

Dispatch trains, spot railcars, and manage movements directly from your dispatch map without having to walk over to the locomotive or switch to 3D cab view.

### 1.1 Click-to-Dispatch Waypoints
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

### 1.2 Click-to-Couple Consist Automation
- **How to Use:** Hold `CapsLock` and left-click on any stationary railcar or consist on the map.
- **Smart End Selection:** The system checks which end of the target consist is accessible from your locomotive's direction and automatically routes to the open coupler, avoiding dead-end traps.
- **Soft Joint & Coupling:** AutoEngineer drives up, slows down for a gentle joint, and couples automatically.

### 1.3 Live Route Preview & Target HUD
- **Route Line:** While holding the dispatch key, an animated route preview line traces the path between your locomotive and the cursor.
- **Target Info:** A floating cursor readout displays target distance, destination track ID, and car reporting marks.
- **Obstruction Warnings:** The route preview pulses red if a track is blocked by other cars, a switch is locked against the path, or the destination cannot be reached.

### 1.4 Instant Order Cancellation
- Hold `CapsLock` and **right-click anywhere on the map** to cancel active waypoint or coupling orders immediately.

<p align="center">
  <img width="394" height="354" alt="Cancel Waypoint Order" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-CancelWaypoint.png" />
  <br><em>Hold CapsLock and right-click to cancel orders instantly.</em>
</p>

---

## 2. Rolling Stock Operations & Context Menu

Right-click any railcar on the map to open a dedicated operations context menu.

<p align="center">
  <img width="371" height="326" alt="Rolling Stock Operations Menu" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-ContextMenu.png" />
  <br><em>Right-click any car on the map for quick mechanical and brake operations.</em>
</p>

### 2.1 Smart Handbrakes (Grade-Calibrated)
Automatically calculates the exact number of handbrakes needed based on track grade and consist weight:
- **Level (<1%):** Applies ~10% holding brakes.
- **Moderate (1–2%):** Applies ~25% holding brakes.
- **Steep (>2%):** Applies ~50% holding brakes.
- **Motive Power Safety Protection:** Smart Handbrakes always skips locomotives and tenders, preventing flat spots and traction motor damage.

### 2.2 Consist Brake & Air Controls
- **Apply All Handbrakes / Release All Handbrakes:** One-click operation across every car in the train.
- **Connect / Disconnect Train Line Air:** Hook up or vent train line hoses across the entire consist without walking car-to-car.
- **Bleed Reservoirs:** Drain auxiliary air reservoirs instantly when switching free-rolling cars in gravity yards.

### 2.3 Direct Locomotive Cuts
- Cut reverser to neutral or drop throttle to idle directly from the map menu.

---

## 3. Topographic Backgrounds & Map Tile Streaming

Render high-detail cartography directly under your railroad tracks with zero gameplay stutter and 100% offline capability.

<p align="center">
  <img width="600" alt="USGS Topographic Background" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-USGSTopo_Preview.png" />
  <br><em>USGS Topo Pack: Authentic Appalachian mountain contours and elevations.</em>
</p>

<p align="center">
  <img width="600" alt="OpenStreetMap Background" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-OpenStreetMap_Preview.png" />
  <br><em>OpenStreetMap Pack: High-contrast GIS roads, rivers, and switching yards.</em>
</p>

### Tile Streaming Features:
- **Zero Network Lag:** All tiles stream from local files in `Documents\Railroader\Mods\reaper-map-enhancer\Tiles\`.
- **Hysteresis Zoom:** Multi-resolution pyramid zoom with a 5% transition band preventing zoom-flicker.
- **Corridor Trimming:** Optional bounding box margin (500m–10,000m) clipping rendering to active track corridors to conserve GPU VRAM.
- **Background Opacity Slider:** Dial in transparency from 0% (pure tracks) to 100% (solid topo).

---

## 4. Centralized Map Overlays & Safety Filters

Cycle between 6 live operational overlays using the `[ME]` Quick Overlay switcher or settings window (`Ctrl+M`):

| Overlay Mode | Visual Display | Operational Value |
|---|---|---|
| **Routes** | 6-Color Route Hierarchy (Mainline, Branch, Industrial, Passenger, Unreachable, MoW) | General dispatching and route planning. |
| **Grade (%)** | 5-Tier Color Banding with Directional Slope Arrows | Train handling, helper assignment, tonnage budgeting. |
| **Curvature Safe Speed** | Safe speed color banding based on curve radius (Chord-Deflection formula) | Derailment prevention, passenger comfort. |
| **TrackClass** | FRA Track Safety Classes (Excepted through Class 5) | Speed limits, weight restrictions. |
| **Condition** | Track degradation and tie wear color grading (0% to 100%) | Maintenance of Way (MoW) work planning. |
| **Cleanliness** | Ballast weed infestation and foulness monitoring | Ballast regulation and chemical weed spray routing. |

---

## 5. Mechanical Defect Alerts (HOPA)

Real-time diagnostic telemetry detects rolling stock defects before they cause mainline derailments.

<p align="center">
  <img width="450" alt="HOPA Operational Alerts Window" src="https://ik.imagekit.io/nbe76wmno/MapEnhancer/Features/RRME2.0-AlertWindow-ConsistSummary.png" />
  <br><em>Consist-grouped operational defect summary window.</em>
</p>

- **Monitored Conditions:**
  - 🔴 **Hotbox:** Overheated journal bearings emitting smoke/fire.
  - 🟡 **Low Lubricating Oil:** Journal oil boxes running low.
  - 🟠 **Dragging Handbrakes:** Handbrakes left applied on in-motion cars.
  - 🔵 **Train Line Air Leak:** Severed hose or leaking triple valve.
  - 🔴 **Derailment:** Axle off the rails while moving.
- **Map Warning Badges:** Live pulsating warning icons appear over defective cars on the map.
- **Interactive Navigation:** Click any alert in the summary window to immediately snap the camera to the troubled car.

---

## 6. Turntables, Crossings & Navigation

- **Turntable Clearances:** Automatic safety checks prevent bridge rotation when cars are fouling the lead track.
- **Incremental Stepper:** Step turntable bridges clockwise (`Ctrl+Click`), counter-clockwise (`Alt+Click`), or perform a 180° reverse (`Ctrl+Shift+Click`).
- **Road Crossing Markers:** Visual icons at all public grade crossings.
- **Track & Yard Signs:** Custom placement and rendering of mileposts, whistle signs, speed limits, and yard boundary signs.
- **Smooth Navigation:** Maximize/float map window (`Z`), track active car (`Shift+Z`), and recenter on player (`Ctrl+Z`).
