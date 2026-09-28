import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/form_screen.dart';
import 'screens/detail_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

/// Root Application Widget configuring Named Routes and Material 3 Theme.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Registration App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // Initial route for the application
      initialRoute: HomeScreen.routeName, // '/'

      // Table of Named Routes
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        FormScreen.routeName: (context) => const FormScreen(),
        DetailScreen.routeName: (context) => const DetailScreen(),
      },

      // Fallback route generator for dynamic route handling
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Page Not Found')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No route defined for "${settings.name}"',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/'),
                    child: const Text('Return to Home'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
