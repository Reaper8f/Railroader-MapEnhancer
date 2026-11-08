# In-Game Configuration & Settings Reference

Map Enhancer 2.0 settings can be configured directly in-game. Preferences are automatically saved to `settings.json` in your mod directory and persist across game sessions and mod updates.

To open the settings panel in-game:
- Press **`Ctrl + M`** anywhere in the game, or
- Click the **`[ME]`** button in the upper-right corner of the Map Window.

---

## Default Controls & Keyboard Shortcuts

All Map Enhancer keybindings can be customized directly in the in-game settings panel:

| Keybinding | Action | Description |
|---|---|---|
| **`M`** | **Open / Close Map** | Game native key to toggle the Railroader map window. |
| **`Ctrl + M`** | **Map Enhancer Settings** | Opens the dedicated 10-section configuration window. |
| **`Z`** | **Maximize / Float Map** | Toggles between compact docked view and resizable floating window. |
| **`Shift + Z`** | **Follow Active Train** | Smoothly locks the camera to follow the selected train or locomotive. |
| **`Ctrl + Z`** | **Recenter Camera** | Instantly centers map view on player's current world position. |
| **`CapsLock + Left-Click`** | **Dispatch Waypoint** | Dispatches selected locomotive to clicked track location or target car. |
| **`CapsLock + Right-Click`** | **Cancel Dispatch** | Cancels active AutoEngineer waypoint navigation immediately. |
| **`Right-Click Car`** | **Context Menu** | Opens rolling stock handbrakes, trainline air, and locomotive cuts menu. |
| **`Click Switch`** | **Throw Switch** | Direct switch throw (or require double-click if configured). |
| **`Ctrl + Click Turntable`** | **Step Clockwise** | Rotates turntable bridge one increment clockwise. |
| **`Alt + Click Turntable`** | **Step Counter-Clockwise** | Rotates turntable bridge one increment counter-clockwise. |
| **`Ctrl + Shift + Click Turntable`** | **180° Reverse** | Fully reverses turntable bridge orientation. |

---

## Settings Reference (By Section)

### 1. Map Display, Backgrounds & Slippy Tiles
| Setting | Default | Description |
|---|---|---|
| **Map Background Mode** | `Disabled` | Cartography mode: `Disabled` (native dark), `Custom Image` (orthophoto), or `Map Tiles` (slippy tiles). |
| **Tile Set Selector** | `USGSTopo` | Discovers available tile packs (`USGSTopo`, `OSM`, or custom folders in `Tiles\`). |
| **Rescan & Reload Tiles** | Button | Re-indexes tile folders and reloads active pyramid tiles without restarting. |
| **Background Opacity** | `40%` | Controls tile transparency ($0\%–100\%$) beneath the track network. |
| **Trim Map to Corridor** | `Off` | Restricts tile streaming strictly to the active track corridor, saving VRAM. |
| **Corridor Margin** | `2500m` | Spatial buffer around tracks when corridor trimming is active ($500\text{m}–10,000\text{m}$). |
| **Map Quick Overlay HUD** | `Off` | Shows the quick teleport and overlay selector dropdown on the top-right map bar. |
| **Double Click Switches** | `Off` | Requires double-clicking map switches to throw, preventing accidental clicks. |
| **Window Minimum Size** | `800 px` | Minimum window size clamp for the resizable map window ($400\text{px}–1400\text{px}$). |
| **MSAA Quality** | `Disabled` | Multi-Sample Anti-Aliasing for track lines (`Disabled`, `2x`, `4x`, `8x`). |

### 2. Track Colors & Classification
| Setting | Default | Description |
|---|---|---|
| **Track Line Thickness** | `2.00` | Line thickness for all rendered tracks ($1.50–4.00$). |
| **Mainline Color** | Green (`#009B00`) | Track color for primary through-routes. |
| **Branchline Color** | Sky Blue (`#0092CA`) | Track color for secondary branch segments. |
| **Industrial Color** | Yellow (`#BFBF00`) | Track color for industry sidings and spurs. |
| **Unavailable Color** | Red (`#FF0000`) | Track color for unpurchased or locked track segments. |
| **Passenger Color** | Purple (`#800080`) | Track color for passenger depot routes. |
| **Unreachable Color** | Light Grey (`#B3B3B3`) | Track color for disconnected or dead-end segments. |
| **Maintenance of Way (MoW)** | Light Yellow (`#FFDC5E`) | Distinct color coding for Maintenance of Way yard tracks. |
| **Industry Area Coloring** | `Enabled` | Sub-segment color slicing matching industry delivery spot colors. |
| **Dim Alternate Switch Legs** | `Enabled` | Dims non-aligned switch routes to highlight the active path. |
| **Reset Track Colors** | Button | Restores default 6-color palette. |

### 3. Track Grade Indicators & Operational Overlays
| Setting | Default | Description |
|---|---|---|
| **Active Map Overlay** | `Routes` | Centralized overlay mode: `Routes`, `Grade`, `Curvature`, `TrackClass`, `Condition`, `Cleanliness`. |
| **Slope Pointer Arrows** | `Off` | Renders directional arrows along tracks indicating uphill/downhill slope. |
| **Slope Pointer Scale** | `Normal (1.0x)` | Scale of slope direction arrows (`Small 0.6x`, `Normal 1.0x`, `Large 1.5x`). |
| **Min Grade Intensity** | `1.0%` | Minimum slope threshold required before grade markers activate ($0.1\%–3.0\%$). |
| **Grade Hover Tooltip** | `Enabled` | Displays real-time grade percentage when hovering any track segment. |
| **Grade Color Bands** | 5 Tiers | Slope color palette: `<0.5%` (Blue), `0.5–1%` (Green), `1–2%` (Yellow), `2–3%` (Orange), `>3%` (Red). |
| **Reset Grade Colors** | Button | Restores factory slope color thresholds. |

### 4. Marker Scaling & Zoom Limits
| Setting | Default | Description |
|---|---|---|
| **Track & Yard Signs** | `Enabled` | Shows mileposts, speed limits, whistle posts, and yard limit markers. |
| **Sign Marker Scale** | `0.60x` | Adjusts size of upright track signs ($0.2\text{x}–2.0\text{x}$). |
| **Road Crossing Markers** | `Enabled` | Shows railroad crossing warning icons at public grade crossings. |
| **Crossing Marker Scale** | `0.30x` | Size multiplier for road crossing icons ($0.2\text{x}–1.0\text{x}$). |
| **Station Agents & Depots** | `Enabled` | Renders passenger depot and agent location icons. |
| **Station Marker Scale** | `0.50x` | Size multiplier for passenger station icons ($0.2\text{x}–1.0\text{x}$). |
| **Junction Flare Scale** | `0.60x` | Size multiplier for switch position flares ($0.2\text{x}–1.5\text{x}$). |
| **Switch Marker Scale** | `0.60x` | Size multiplier for switch stands ($0.2\text{x}–1.5\text{x}$). |
| **Marker Visibility Cutoff** | `0.12` | LOD zoom threshold below which small markers fade to reduce clutter ($0.01–0.50$). |
| **Show Zoom Indicator** | `Enabled` | Displays camera altitude in bottom-right corner. |
| **Zoom Altitude Range** | `50m – 10,000m` | Configurable min and max camera altitude limits. |

### 5. Turntables & Clearance
| Setting | Default | Description |
|---|---|---|
| **Turntable Markers** | `Enabled` | Renders circular turntable markers over roundhouses and service pits. |
| **Direct Bridge Controls** | `Enabled` | Enables clicking turntable markers to control bridge rotation. |
| **Check Turntable Clearance** | `Enabled` | Prevents bridge rotation if equipment is fouling lead tracks, preventing derailments. |
| **Turntable Marker Scale** | `0.50x` | Size multiplier for turntable markers ($0.2\text{x}–1.5\text{x}$). |

### 6. Train & Cargo Telemetry
| Setting | Default | Description |
|---|---|---|
| **Train Hover Tooltip** | `Enabled` | Master toggle for detailed train hover HUD. |
| **Show Engineer / Driver** | `Enabled` | Displays player name or AI assignment. |
| **Show Train Stats** | `Enabled` | Displays current speed, total tonnage, car count, and train length. |
| **Show Passenger Destinations**| `Enabled` | Summarizes passenger counts grouped by destination depot. |
| **Show Fuel / Tender Levels** | `Enabled` | Displays coal, water, and diesel fuel percentages. |
| **Show Consist Cargo** | `Enabled` | Breakdown of loaded commodities and cargo status across consist. |
| **Show Waybill Destinations** | `Enabled` | Displays town and industry delivery destinations. |
| **Individual Car Tooltips** | `Enabled` | Hover individual cars in a consist to see specific car details. |
| **Train Tooltip Font Size** | `12 pt` | Font size for train hover HUD ($10\text{ pt}–24\text{ pt}$). |
| **Hover Tooltip Font Size** | `12 pt` | Font size for track and grade tooltips ($10\text{ pt}–24\text{ pt}$). |

### 7. HOPA Operational Alerts & Badges
| Setting | Default | Description |
|---|---|---|
| **Monitor Operational Alerts** | `Enabled` | Background telemetry polling for mechanical defects. |
| **Map Alert Badges** | `Enabled` | Shows pulsating defect badges over troubled rolling stock on the map. |
| **Hotbox Overheat** | `Enabled` | Alerts on journal bearing overheats. |
| **Low Oil Alert** | `Enabled` | Alerts on dangerously low journal box oil. |
| **Dragging Handbrake Alert** | `Off` | Alerts on handbrakes applied while moving. |
| **Air Leak Alert** | `Off` | Alerts on significant trainline air loss. |
| **Derailment Alert** | `Enabled` | Alerts on derailed wheels while in-motion. |
| **Alert Summary Text Size** | `14 px` | Text size for the operational defect summary window ($8\text{ px}–16\text{ px}$). |
| **Alert Indicator Scale** | `1.25x` | Size multiplier for map warning badges ($0.75\text{x}–2.0\text{x}$). |

### 8. Locomotive Waypoint Dispatch & Context Menu
| Setting | Default | Description |
|---|---|---|
| **Enable Locomotive Dispatch** | `Enabled` | Allows dispatching selected engines via `CapsLock + Click`. |
| **Dispatch Activation Key** | `CapsLock` | Modifier key held to acquire dispatch crosshair. |
| **Live Route Preview Ribbon** | `Enabled` | Traces route line from locomotive to cursor showing obstructions. |
| **Auto-Release Handbrakes** | `Enabled` | Automatically releases consist handbrakes upon beginning movement. |
| **Smart Handbrakes Default** | `Enabled` | Right-click menu calculates grade-safe holding brakes (10%/25%/50%). |
| **Consist Brake Controls** | `Enabled` | Adds "Apply All Handbrakes" and "Release All Handbrakes" to menu. |
| **Consist Air Controls** | `Enabled` | Adds train line connect/disconnect and reservoir bleed options. |
| **Loco Operations (Cut)** | `Enabled` | Direct reverser neutral cut and throttle idle from the map. |

### 9. Diagnostics & Maintenance
| Setting | Default | Description |
|---|---|---|
| **Verbose Debug Logging** | `Disabled` | Emits detailed tile coordinate math and dispatch pathfinding logs to `Player.log`. |
| **Reset Keybindings** | Button | Restores default navigation shortcuts. |
| **Reset All Settings** | Button | Restores all settings across all 10 sections to factory defaults. |
