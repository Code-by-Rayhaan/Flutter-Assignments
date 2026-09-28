import 'package:flutter/material.dart';
import '../models/mock_data.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_helper.dart';
import '../widgets/activities_list_section.dart';
import '../widgets/app_header.dart';
import '../widgets/horizontal_team_list.dart';
import '../widgets/performance_chart_card.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/responsive_info_banner.dart';
import '../widgets/sidebar_navigation.dart';
import '../widgets/stats_grid_section.dart';
import '../widgets/storage_analytics_card.dart';
import '../widgets/tasks_list_section.dart';

class DashboardScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const DashboardScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedNavIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isMobile = ResponsiveHelper.isMobile(context);
    final isDark = widget.isDarkMode;

    return Scaffold(
      key: _scaffoldKey,
      drawer: isDesktop
          ? null
          : Drawer(
              backgroundColor:
                  isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
              child: SidebarNavigation(
                selectedIndex: _selectedNavIndex,
                onDestinationSelected: (index) {
                  setState(() => _selectedNavIndex = index);
                  Navigator.of(context).pop(); // Close drawer
                },
                isRail: false,
              ),
            ),
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
              currentIndex: _selectedNavIndex.clamp(0, 4),
              onTap: (index) => setState(() => _selectedNavIndex = index),
              selectedItemColor: AppTheme.primary,
              unselectedItemColor: isDark
                  ? AppTheme.darkTextSecondary
                  : AppTheme.lightTextSecondary,
              backgroundColor:
                  isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 11,
              unselectedFontSize: 11,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_rounded),
                  label: 'Overview',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.insights_rounded),
                  label: 'Analytics',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.folder_open_rounded),
                  label: 'Projects',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people_alt_rounded),
                  label: 'Team',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.tune_rounded),
                  label: 'Settings',
                ),
              ],
            )
          : null,
      body: Row(
        children: [
          // Sidebar: Full on Desktop, Collapsed Rail on Tablet, Hidden on Mobile
          if (isDesktop)
            SidebarNavigation(
              selectedIndex: _selectedNavIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedNavIndex = index);
              },
              isRail: false,
            )
          else if (isTablet)
            SidebarNavigation(
              selectedIndex: _selectedNavIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedNavIndex = index);
              },
              isRail: true,
            ),

          // Main View Content wrapped in Expanded
          Expanded(
            child: Column(
              children: [
                // Top App Header
                AppHeader(
                  isDarkMode: widget.isDarkMode,
                  onThemeToggle: widget.onThemeToggle,
                  onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  onSearchChanged: (val) {
                    setState(() => _searchQuery = val);
                  },
                ),

                // Dynamic Dashboard Body
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: ResponsiveHelper.getResponsivePadding(context),
                    child: _buildAdaptiveDashboardContent(
                      context,
                      isDesktop: isDesktop,
                      isTablet: isTablet,
                      isMobile: isMobile,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the adaptive layout depending on MediaQuery breakpoints
  Widget _buildAdaptiveDashboardContent(
    BuildContext context, {
    required bool isDesktop,
    required bool isTablet,
    required bool isMobile,
  }) {
    // Filter activities based on search bar query
    final filteredActivities = _searchQuery.isEmpty
        ? MockData.recentActivities
        : MockData.recentActivities
            .where((a) =>
                a.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                a.subtitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                a.category.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    // 1. DESKTOP LAYOUT (Split Row using Expanded flex: 7 and flex: 3)
    if (isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResponsiveInfoBanner(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left / Primary Column (flex: 7)
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // GridView Metric KPI Cards
                    StatsGridSection(metrics: MockData.metrics),
                    const SizedBox(height: 20),

                    // Quick Actions GridView
                    QuickActionsGrid(actions: MockData.quickActions),
                    const SizedBox(height: 20),

                    // Performance Chart (Expanded and Flexible bars)
                    const PerformanceChartCard(
                      dataPoints: MockData.performanceData,
                    ),
                    const SizedBox(height: 20),

                    // Activities Stream (ListView.builder)
                    ActivitiesListSection(activities: filteredActivities),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              // Right / Secondary Analytics & Tasks Column (flex: 3)
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Horizontal Team Squad ListView
                    const HorizontalTeamList(members: MockData.teamMembers),
                    const SizedBox(height: 20),

                    // Storage Infrastructure Allocation (Flexible / Expanded)
                    const StorageAnalyticsCard(
                      categories: MockData.storageCategories,
                    ),
                    const SizedBox(height: 20),

                    // Sprint Milestones (ListView.separated)
                    const TasksListSection(tasks: MockData.activeTasks),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }

    // 2. TABLET & MOBILE LAYOUT (Sequential stacked sections with responsive GridView and ListView)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveInfoBanner(),

        // GridView Metric KPI Cards
        StatsGridSection(metrics: MockData.metrics),
        const SizedBox(height: 16),

        // Quick Actions GridView
        QuickActionsGrid(actions: MockData.quickActions),
        const SizedBox(height: 16),

        // Horizontal Team Squad ListView
        const HorizontalTeamList(members: MockData.teamMembers),
        const SizedBox(height: 16),

        // Performance Chart
        const PerformanceChartCard(dataPoints: MockData.performanceData),
        const SizedBox(height: 16),

        // Storage Infrastructure
        const StorageAnalyticsCard(categories: MockData.storageCategories),
        const SizedBox(height: 16),

        // Activities Stream (ListView.builder)
        ActivitiesListSection(activities: filteredActivities),
        const SizedBox(height: 16),

        // Sprint Milestones (ListView.separated)
        const TasksListSection(tasks: MockData.activeTasks),
        const SizedBox(height: 24),
      ],
    );
  }
}
