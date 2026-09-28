# Nexus Responsive Dashboard (Flutter)

A modern, responsive multi-section dashboard application built with Flutter that adapts across **Mobile**, **Tablet**, and **Desktop** viewports.

---

## 🌟 Key Features & Requirements Demonstrated

### 1. **MediaQuery Integration**
- **Live Breakpoints:**
  - **Mobile (< 650px):** Single-column vertical stream, bottom navigation bar, expandable drawer.
  - **Tablet (650px – 1100px):** Collapsed compact `NavigationRail` + single-column stacked layout with adaptive grids.
  - **Desktop (≥ 1100px):** Full persistent sidebar + 2-column split dashboard (`flex: 7` main content, `flex: 3` analytics/sprint panel).
- **Dynamic Orientation & Sizing:** Real-time adaptation to device width, height, orientation (portrait/landscape), and safe-area padding.
- **Inspector Banner:** Built-in `ResponsiveInfoBanner` displaying real-time viewport dimensions, current breakpoint mode, and active grid columns.

### 2. **GridView Implementations**
- **KPI Stat Cards Grid (`StatsGridSection`):**
  - Uses `GridView.builder` with dynamic `crossAxisCount` (1 to 4 columns) and calculated `childAspectRatio` based on `MediaQuery`.
  - Shows key executive metrics (Revenue, Active Projects, Team Velocity, SLA) with custom gradients, trend badges, and progress indicators.
- **Quick Operations Grid (`QuickActionsGrid`):**
  - Uses `GridView.builder` (2 to 6 columns) for one-tap dashboard tools and shortcuts with interactive hover/click states and notification badge chips.

### 3. **ListView Multi-Section Layouts**
- **Recent Activity Stream (`ActivitiesListSection`):**
  - Vertical `ListView.separated` with category filters (All, Finance, DevOps, Design, Security).
  - Shows transaction statuses, time stamps, category tags, and income/expense flows.
- **Active Engineering Squad (`HorizontalTeamList`):**
  - Horizontal `ListView.builder` displaying team avatars, roles, online status indicators, and member invitation CTA.
- **Sprint Milestones (`TasksListSection`):**
  - Vertical `ListView.separated` displaying progress bars, priority pills (High, Medium, Low), assignees, and deadlines.

### 4. **Flexible & Expanded Mastery**
- **Split Desktop View:** Orchestrated via `Row` with `Expanded(flex: 7, child: ...)` and `Expanded(flex: 3, child: ...)`.
- **Infrastructure Allocation Card (`StorageAnalyticsCard`):**
  - Multi-segment storage bar using a `Row` containing multiple `Expanded` widgets with weighted flex values proportional to category percentages.
  - Detailed breakdown rows using `Expanded` for labels and `Flexible` for percentage/size values.
- **Weekly Throughput Chart (`PerformanceChartCard`):**
  - Interactive bar chart built with a `Row` of `Expanded` bar columns and `FractionallySizedBox` / `Flexible` height factors.
- **Adaptive App Header (`AppHeader`):**
  - Search bar wrapped in `Expanded` with maximum constraints; trailing theme toggles and notification badges wrapped in `Flexible`.

---

## 🎨 Design & Aesthetics
- **Adaptive Dark / Light Themes:** Toggleable in real time with custom color palettes (Slate, Indigo, Cyan, Emerald, Rose, Amber).
- **Clean Typography & Card Elevation:** Modern rounded corners (`16px`), glassmorphic borders, soft shadows, and vibrant linear gradients.
- **Smooth Micro-Interactions:** Hover states on quick actions and performance chart bars.

---

## 📁 Project Structure

```
lib/
├── main.dart                      # App entry point with theme state
├── models/
│   ├── dashboard_models.dart      # Data models for metrics, activities, tasks, team
│   └── mock_data.dart             # Mock dataset
├── screens/
│   └── dashboard_screen.dart      # Main responsive dashboard layout coordinator
├── theme/
│   └── app_theme.dart             # Dark and light theme tokens & gradients
├── utils/
│   └── responsive_helper.dart     # MediaQuery calculations and breakpoint helpers
└── widgets/
    ├── activities_list_section.dart  # ListView for activities
    ├── app_header.dart               # Responsive header with search & theme switch
    ├── horizontal_team_list.dart     # Horizontal ListView for team
    ├── performance_chart_card.dart   # Flexible & Expanded custom bar chart
    ├── quick_actions_grid.dart       # GridView for quick shortcuts
    ├── responsive_info_banner.dart   # Live MediaQuery inspector
    ├── sidebar_navigation.dart       # Responsive Desktop sidebar & Tablet rail
    ├── stat_card.dart                # Individual KPI card with trend indicator
    ├── stats_grid_section.dart       # Responsive GridView for stats
    ├── storage_analytics_card.dart   # Multi-segment Expanded progress bar
    └── tasks_list_section.dart       # ListView.separated for tasks
```

---

## 🚀 Running the Project

1. **Run Widget Tests:**
   ```bash
   flutter test
   ```

2. **Analyze Code:**
   ```bash
   flutter analyze
   ```

3. **Run App Locally:**
   - **Chrome / Web:**
     ```bash
     flutter run -d chrome
     ```
   - **macOS Desktop:**
     ```bash
     flutter run -d macos
     ```
   - **Mobile Simulator / Emulator:**
     ```bash
     flutter run
     ```
