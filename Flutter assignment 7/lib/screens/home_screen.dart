import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Screen 1: Home Screen
/// Provides an overview of the application and a call-to-action to begin registration.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Portal'),
        actions: [
          IconButton(
            tooltip: 'App Info',
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => _showAppInfoDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Banner Card
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.route_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Flutter Named Routes Architecture',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Welcome to\nRegistration Portal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'A 3-screen Flutter app demonstrating robust Form validation, named routing, and dynamic data propagation.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/form');
                      },
                      icon: const Icon(Icons.person_add_rounded),
                      label: const Text(
                        'Start Registration',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Section Title: Architecture Flow
              const Text(
                'Navigation Flow',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),

              // Flow Steps
              _buildFlowStep(
                stepNumber: '1',
                title: 'Home Screen ("/")',
                description: 'Landing page & feature introduction.',
                icon: Icons.home_rounded,
                isCurrent: true,
              ),
              _buildFlowStep(
                stepNumber: '2',
                title: 'Registration Form ("/form")',
                description:
                    'Input validation: Email, Password strength, Matching, and required fields.',
                icon: Icons.edit_note_rounded,
              ),
              _buildFlowStep(
                stepNumber: '3',
                title: 'Detail Screen ("/detail")',
                description:
                    'Receives and renders the validated UserModel via route arguments.',
                icon: Icons.badge_rounded,
                isLast: true,
              ),

              const SizedBox(height: 24),

              // Feature Highlights Grid
              const Text(
                'Key Capabilities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),

              _buildFeatureCard(
                icon: Icons.mark_email_read_rounded,
                iconColor: AppTheme.accentColor,
                title: 'Email Format Validation',
                subtitle:
                    'Strict regex matching for standard user@domain.com formatting.',
              ),
              _buildFeatureCard(
                icon: Icons.shield_rounded,
                iconColor: AppTheme.primaryColor,
                title: 'Password Security Rules',
                subtitle:
                    'Requires 8+ chars, uppercase, lowercase, numbers, and special symbols with live strength feedback.',
              ),
              _buildFeatureCard(
                icon: Icons.check_circle_outline_rounded,
                iconColor: AppTheme.successColor,
                title: 'Password Confirmation',
                subtitle:
                    'Real-time equality verification against the primary password.',
              ),

              const SizedBox(height: 32),

              // Main Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/form');
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Proceed to Registration Form'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlowStep({
    required String stepNumber,
    required String title,
    required String description,
    required IconData icon,
    bool isCurrent = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isCurrent ? AppTheme.primaryColor : const Color(0xFFE2E8F0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: isCurrent ? Colors.white : const Color(0xFF64748B),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 36,
                color: const Color(0xFFCBD5E1),
                margin: const EdgeInsets.symmetric(vertical: 4),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isCurrent
                        ? AppTheme.primaryColor
                        : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAppInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Flutter Assignment 7'),
        content: const Text(
          'This application demonstrates:\n\n'
          '• Named route management ("/", "/form", "/detail")\n'
          '• Form validation (Email, Password strength, Confirmation, and Required fields)\n'
          '• Route argument transfer using UserModel\n'
          '• Clean Material 3 architecture with responsive design.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
