import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/settings_provider.dart';

/// ============================================================================
/// File: settings_screen.dart
/// ============================================================================
///
/// Production Settings Screen.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays application settings.
/// • Controls theme preference.
/// • Shows user information.
/// • Handles logout.
/// • Navigates to notification settings.
///
/// Does NOT:
/// ----------------------------------------------------------------------------
/// • Call APIs.
/// • Manage authentication logic.
/// • Manage notification scheduling.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///   ↓
/// SettingsProvider
///   ↓
/// SharedPreferences
///
/// AuthProvider
///   ↓
/// SessionManager
///
/// ============================================================================

final class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // ===========================================================================
  // Build
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Consumer2<SettingsProvider, AuthProvider>(
      builder: (BuildContext context, SettingsProvider settings, AuthProvider auth, Widget? child) {
        final ThemeData theme = Theme.of(context);

        final user = auth.currentUser;

        return Scaffold(
          appBar: AppBar(title: const Text('Settings'), centerTitle: true),

          body: ListView(
            padding: const EdgeInsets.all(16),

            children: <Widget>[
              // ===============================================================
              // Profile Section
              // ===============================================================
              _SectionCard(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 64,

                      height: 64,

                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,

                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Icon(
                        Icons.person_outline_rounded,

                        size: 34,

                        color: theme.colorScheme.primary,
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: <Widget>[
                          Text(
                            user?.email ?? 'Guest User',

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,

                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            user?.role ?? 'No role available',

                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===============================================================
              // Appearance
              // ===============================================================
              Text('Appearance', style: theme.textTheme.titleMedium),

              const SizedBox(height: 8),

              _SectionCard(
                child: Column(
                  children: ThemeMode.values.map((ThemeMode mode) {
                    return RadioListTile<ThemeMode>(
                      value: mode,

                      groupValue: settings.themeMode,

                      title: Text(_themeTitle(mode)),

                      subtitle: Text(_themeSubtitle(mode)),

                      onChanged: settings.isLoading
                          ? null
                          : (ThemeMode? value) {
                              if (value != null) {
                                settings.setThemeMode(value);
                              }
                            },
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // ===============================================================
              // Notifications
              // ===============================================================
              Text('Notifications', style: theme.textTheme.titleMedium),

              const SizedBox(height: 8),

              _SectionCard(
                child: ListTile(
                  leading: const Icon(Icons.notifications_outlined),

                  title: const Text('Notification Settings'),

                  subtitle: const Text('Manage reminders and alerts.'),

                  trailing: const Icon(Icons.chevron_right_rounded),

                  onTap: () {
                    context.push(AppRoutes.notificationSettings);
                  },
                ),
              ),

              const SizedBox(height: 24),

              // ===============================================================
              // About
              // ===============================================================
              Text('About', style: theme.textTheme.titleMedium),

              const SizedBox(height: 8),

              const _SectionCard(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.info_outline_rounded),

                      title: Text('Notes App'),

                      subtitle: Text(
                        'Production-ready Flutter Notes application.',
                      ),
                    ),

                    Divider(height: 1),

                    ListTile(
                      leading: Icon(Icons.code_rounded),

                      title: Text('Version'),

                      subtitle: Text('1.0.0'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===============================================================
              // Logout
              // ===============================================================
              _SectionCard(
                child: ListTile(
                  leading: Icon(
                    Icons.logout_rounded,

                    color: theme.colorScheme.error,
                  ),

                  title: Text(
                    'Logout',

                    style: TextStyle(
                      color: theme.colorScheme.error,

                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  subtitle: const Text('Sign out from this device.'),

                  onTap: () {
                    _logout(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ===========================================================================
  // Logout
  // ===========================================================================

  Future<void> _logout(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,

      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),

          content: const Text('Are you sure you want to logout?'),

          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },

              child: const Text('Cancel'),
            ),

            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },

              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    final AuthProvider auth = context.read<AuthProvider>();

    await auth.logout();

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully.'),

        behavior: SnackBarBehavior.floating,
      ),
    );

    context.go(AppRoutes.login);
  }

  // ===========================================================================
  // Theme Helpers
  // ===========================================================================

  String _themeTitle(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System';

      case ThemeMode.light:
        return 'Light';

      case ThemeMode.dark:
        return 'Dark';
    }
  }

  String _themeSubtitle(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'Follow device theme';

      case ThemeMode.light:
        return 'Always use light theme';

      case ThemeMode.dark:
        return 'Always use dark theme';
    }
  }
}

// ============================================================================
// Section Card
// ============================================================================

final class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(clipBehavior: Clip.antiAlias, child: child);
  }
}
