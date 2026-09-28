import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'info_tile.dart';
import 'skill_chip.dart';
import 'stat_item.dart';

/// The core Profile Card widget showcasing:
/// - [Column] for hierarchical vertical structuring
/// - [Row] for horizontal alignment (badges, stats, actions, contacts)
/// - [Container] for styling, borders, gradients, shadows, and paddings
/// - [CircleAvatar] for profile imagery and avatar indicators
/// - [Text] for formatted typography and textual content
/// - [Icon] for rich visual cues and iconography
/// - Custom Theme Colors and styling presets
class ProfileCard extends StatefulWidget {
  final CustomColorPreset currentPreset;
  final VoidCallback onSelectTheme;

  const ProfileCard({
    super.key,
    required this.currentPreset,
    required this.onSelectTheme,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool _isFollowing = false;
  bool _isLiked = false;
  int _followerCount = 12840;

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
      _followerCount += _isFollowing ? 1 : -1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _isFollowing ? Icons.check_circle : Icons.person_remove,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              _isFollowing
                  ? 'You are now following Rayhaan Siledar!'
                  : 'Unfollowed Rayhaan Siledar',
            ),
          ],
        ),
        backgroundColor: _isFollowing ? widget.currentPreset.primary : Colors.grey[800],
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 440),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: widget.currentPreset.primary.withValues(alpha: isDark ? 0.25 : 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.currentPreset.primary.withValues(alpha: isDark ? 0.18 : 0.12),
            blurRadius: 30,
            spreadRadius: 2,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // -------------------------------------------------------------
          // 1. BANNER & HEADER CONTAINER
          // -------------------------------------------------------------
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: widget.currentPreset.gradient,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(26),
                topRight: Radius.circular(26),
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Decorative Geometric Circles in Header
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -10,
                  left: 20,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                ),

                // Top Status Badge & Action Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Active status pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981), // Emerald online dot
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'AVAILABLE FOR HIRE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Like & Palette Action Buttons Row
                      Row(
                        children: [
                          // Theme Palette Trigger Button
                          InkWell(
                            onTap: widget.onSelectTheme,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.35),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                              ),
                              child: const Icon(
                                Icons.palette_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Heart Like Button
                          InkWell(
                            onTap: _toggleLike,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.35),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Icon(
                                _isLiked ? Icons.favorite : Icons.favorite_border,
                                color: _isLiked ? const Color(0xFFF43F5E) : Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ---------------------------------------------------------
                // 2. PROFILE CIRCLE AVATAR (Overlapping Header)
                // ---------------------------------------------------------
                Positioned(
                  bottom: -45,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Stack(
                      children: [
                        // Outer Glow Ring Container
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.surface,
                            boxShadow: [
                              BoxShadow(
                                color: widget.currentPreset.primary.withValues(alpha: 0.3),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 44,
                            backgroundColor: widget.currentPreset.primary.withValues(alpha: 0.2),
                            child: CircleAvatar(
                              radius: 41,
                              backgroundColor: widget.currentPreset.primary,
                              child: CircleAvatar(
                                radius: 39,
                                backgroundColor: widget.currentPreset.primary,
                                backgroundImage: const NetworkImage(
                                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&auto=format&fit=crop&q=80',
                                ),
                                onBackgroundImageError: (exception, stackTrace) {
                                  // Fallback gracefully to child initials
                                },
                                child: const Text(
                                  'RS',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Online Green Badge on Avatar
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.colorScheme.surface,
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Spacing for overlapping avatar
          const SizedBox(height: 52),

          // -------------------------------------------------------------
          // 3. USER IDENTITY & INFO SECTION (Column & Rows)
          // -------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Name and Verified Icon Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Rayhaan Siledar',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.verified_rounded,
                      size: 22,
                      color: widget.currentPreset.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Role / Profession Text
                Text(
                  'Senior Flutter & Mobile Architect',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: widget.currentPreset.primary,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),

                // Location Row (Icon & Text)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 15,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'San Francisco, CA • Remote',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Bio Text inside a subtle styled Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Text(
                    'Passionate software engineer crafting fluid, high-performance cross-platform apps with Flutter & Dart. UI/UX enthusiast & open-source contributor.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // ---------------------------------------------------------
                // 4. STATS BAR (Container with Row of StatItem Columns)
                // ---------------------------------------------------------
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: widget.currentPreset.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: widget.currentPreset.primary.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      StatItem(
                        count: '148+',
                        label: 'Projects',
                        countColor: widget.currentPreset.primary,
                      ),
                      Container(
                        width: 1,
                        height: 28,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                      ),
                      StatItem(
                        count: _formatFollowers(_followerCount),
                        label: 'Followers',
                        countColor: widget.currentPreset.primary,
                      ),
                      Container(
                        width: 1,
                        height: 28,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                      ),
                      StatItem(
                        count: '4.9 ★',
                        label: 'Rating',
                        countColor: const Color(0xFFF59E0B),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // ---------------------------------------------------------
                // 5. SKILLS & EXPERTISE SECTION (Row / Wrap with SkillChips)
                // ---------------------------------------------------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.stars_rounded,
                          size: 16,
                          color: widget.currentPreset.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'CORE EXPERTISE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        SkillChip(
                          label: 'Flutter & Dart',
                          icon: Icons.flutter_dash_rounded,
                          primaryColor: widget.currentPreset.primary,
                        ),
                        SkillChip(
                          label: 'UI/UX Design',
                          icon: Icons.palette_rounded,
                          primaryColor: widget.currentPreset.secondary,
                        ),
                        SkillChip(
                          label: 'State Management',
                          icon: Icons.account_tree_rounded,
                          primaryColor: widget.currentPreset.accent,
                        ),
                        SkillChip(
                          label: 'REST & GraphQL',
                          icon: Icons.cloud_done_rounded,
                          primaryColor: widget.currentPreset.primary,
                        ),
                        SkillChip(
                          label: 'CI / CD Pipeline',
                          icon: Icons.terminal_rounded,
                          primaryColor: widget.currentPreset.secondary,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // ---------------------------------------------------------
                // 6. CONTACT DETAILS SECTION (Column with InfoTile Rows)
                // ---------------------------------------------------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.contact_mail_rounded,
                          size: 16,
                          color: widget.currentPreset.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'GET IN TOUCH',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    InfoTile(
                      icon: Icons.email_rounded,
                      label: 'Email Address',
                      value: 'rayhaan.siledar@example.com',
                      iconColor: widget.currentPreset.primary,
                      iconBgColor: widget.currentPreset.primary.withValues(alpha: 0.12),
                    ),
                    const SizedBox(height: 8),
                    InfoTile(
                      icon: Icons.phone_android_rounded,
                      label: 'Phone Number',
                      value: '+1 (555) 382-9104',
                      iconColor: widget.currentPreset.secondary,
                      iconBgColor: widget.currentPreset.secondary.withValues(alpha: 0.12),
                    ),
                    const SizedBox(height: 8),
                    InfoTile(
                      icon: Icons.language_rounded,
                      label: 'Portfolio Website',
                      value: 'https://rayhaan-dev.io',
                      iconColor: widget.currentPreset.accent,
                      iconBgColor: widget.currentPreset.accent.withValues(alpha: 0.12),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ---------------------------------------------------------
                // 7. PRIMARY ACTION BUTTONS (Row of Containers with Icons & Text)
                // ---------------------------------------------------------
                Row(
                  children: [
                    // Follow / Unfollow Button
                    Expanded(
                      child: InkWell(
                        onTap: _toggleFollow,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            gradient: _isFollowing ? null : widget.currentPreset.gradient,
                            color: _isFollowing
                                ? theme.colorScheme.onSurface.withValues(alpha: 0.1)
                                : null,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: _isFollowing
                                ? []
                                : [
                                    BoxShadow(
                                      color: widget.currentPreset.primary.withValues(alpha: 0.35),
                                      blurRadius: 14,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _isFollowing
                                    ? Icons.check_circle_outline_rounded
                                    : Icons.person_add_alt_1_rounded,
                                size: 18,
                                color: _isFollowing ? theme.colorScheme.onSurface : Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isFollowing ? 'Following' : 'Follow',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _isFollowing ? theme.colorScheme.onSurface : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Send Message Button
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Row(
                                children: [
                                  Icon(Icons.send_rounded, color: Colors.white, size: 20),
                                  SizedBox(width: 10),
                                  Text('Opening chat with Rayhaan...'),
                                ],
                              ),
                              backgroundColor: widget.currentPreset.secondary,
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: widget.currentPreset.primary,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 18,
                                color: widget.currentPreset.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Message',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: widget.currentPreset.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatFollowers(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}
