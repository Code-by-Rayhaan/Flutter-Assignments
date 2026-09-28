import 'package:flutter/material.dart';
import 'screens/post_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Primary seed color with modern Teal/Cyan aesthetic
    const Color seedColor = Color(0xFF00897B);

    return MaterialApp(
      title: 'Flutter Assignment 8 - REST API & Cache',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 1.5,
          centerTitle: false,
          backgroundColor: Color(0xFFFFFFFF),
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 1.5,
          centerTitle: false,
          backgroundColor: Color(0xFF1E1E1E),
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
        ),
      ),
      home: const PostListScreen(),
    );
  }
}
