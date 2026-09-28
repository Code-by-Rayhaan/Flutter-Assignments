import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';

/// Screen 3: Detail Screen
/// Displays the registered user profile data received via named route arguments (`/detail`).
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, this.user});

  static const String routeName = '/detail';

  /// Optional direct user model (useful for direct constructor injection during testing)
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    // Extract UserModel passed through Navigator.pushNamed(context, '/detail', arguments: user)
    final resolvedUser =
        user ?? (ModalRoute.of(context)?.settings.arguments as UserModel?);

    if (resolvedUser == null) {
      return _buildNoDataScreen(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            tooltip: 'Return to Home',
            icon: const Icon(Icons.home_rounded),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User Avatar & Hero Header Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.28),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Avatar Circle with Initials
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          resolvedUser.initials,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      resolvedUser.fullName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      resolvedUser.email,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Role Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Text(
                        resolvedUser.accountType,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Success Status Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.successColor.withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      color: AppTheme.successColor,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Registration Complete',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'All form fields passed strict client validation.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Section Header
              const Text(
                'Registration Information',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 10),

              // Detailed Profile Fields Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        icon: Icons.person_rounded,
                        label: 'Full Name',
                        value: resolvedUser.fullName,
                      ),
                      const Divider(),
                      _buildDetailRow(
                        icon: Icons.email_rounded,
                        label: 'Email Address',
                        value: resolvedUser.email,
                        badge: 'Valid Email',
                        badgeColor: AppTheme.accentColor,
                      ),
                      const Divider(),
                      _buildDetailRow(
                        icon: Icons.phone_rounded,
                        label: 'Phone Number',
                        value: resolvedUser.phoneNumber,
                        badge: '10 Digits',
                        badgeColor: AppTheme.primaryColor,
                      ),
                      const Divider(),
                      _buildDetailRow(
                        icon: Icons.badge_rounded,
                        label: 'Account Role',
                        value: resolvedUser.accountType,
                      ),
                      const Divider(),
                      _buildDetailRow(
                        icon: Icons.mark_email_read_rounded,
                        label: 'Newsletter Subscription',
                        value: resolvedUser.subscribedToNewsletter
                            ? 'Subscribed'
                            : 'Not Subscribed',
                        badge: resolvedUser.subscribedToNewsletter
                            ? 'Active'
                            : 'Inactive',
                        badgeColor: resolvedUser.subscribedToNewsletter
                            ? AppTheme.successColor
                            : Colors.grey,
                      ),
                      const Divider(),
                      _buildDetailRow(
                        icon: Icons.access_time_filled_rounded,
                        label: 'Registered On',
                        value: resolvedUser.formattedRegistrationDate,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Route & Architecture Metadata Card
              Card(
                color: const Color(0xFFF1F5F9),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.alt_route_rounded,
                            size: 20,
                            color: AppTheme.primaryColor,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Route & Arguments Info',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildMetaText('Current Route', '/detail'),
                      _buildMetaText('Data Source', 'ModalRoute.of(context)!.settings.arguments'),
                      _buildMetaText('Model Class', 'UserModel'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.edit_rounded, size: 18),
                      label: const Text('Edit Form'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.home_rounded, size: 18),
                      label: const Text('Back to Home'),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    String? badge,
    Color? badgeColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF475569)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (badgeColor ?? AppTheme.primaryColor).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: badgeColor ?? AppTheme.primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMetaText(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Screen')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 64,
                color: AppTheme.warningColor,
              ),
              const SizedBox(height: 16),
              const Text(
                'No User Data Provided',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This screen expected a UserModel route argument via named navigation.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.person_add_rounded),
                label: const Text('Go to Registration Form'),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/form');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
