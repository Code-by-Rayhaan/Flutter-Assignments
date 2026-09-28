import 'package:flutter/material.dart';
import 'screens/profile_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ProfileCardApp());
}

class ProfileCardApp extends StatefulWidget {
  const ProfileCardApp({super.key});

  @override
  State<ProfileCardApp> createState() => _ProfileCardAppState();
}

class _ProfileCardAppState extends State<ProfileCardApp> {
  // Current active color preset
  CustomColorPreset _selectedPreset = AppTheme.colorPresets.first;
  
  // Dark/Light theme mode state (defaults to dark mode for rich aesthetics)
  bool _isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Card',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.getLightTheme(_selectedPreset),
      darkTheme: AppTheme.getDarkTheme(_selectedPreset),
      home: ProfileScreen(
        currentPreset: _selectedPreset,
        isDarkMode: _isDarkMode,
        onPresetChanged: (newPreset) {
          setState(() {
            _selectedPreset = newPreset;
          });
        },
        onThemeModeChanged: (isDark) {
          setState(() {
            _isDarkMode = isDark;
          });
        },
      ),
    );
  }
}
