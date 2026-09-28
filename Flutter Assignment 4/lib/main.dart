import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ResponsiveDashboardApp());
}

class ResponsiveDashboardApp extends StatefulWidget {
  const ResponsiveDashboardApp({super.key});

  @override
  State<ResponsiveDashboardApp> createState() => _ResponsiveDashboardAppState();
}

class _ResponsiveDashboardAppState extends State<ResponsiveDashboardApp> {
  bool _isDarkMode = true;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexus Responsive Dashboard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: DashboardScreen(
        isDarkMode: _isDarkMode,
        onThemeToggle: _toggleTheme,
      ),
    );
  }
}
