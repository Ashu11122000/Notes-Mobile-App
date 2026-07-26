import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../providers/settings_provider.dart';

/// ============================================================================
/// File: settings_screen.dart
/// ============================================================================
///
/// Settings Screen
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays application settings.
/// • Displays the logged-in user information.
/// • Allows theme selection.
/// • Navigates to notification settings.
/// • Displays application information.
/// • Performs local logout.
/// • Contains no business logic.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///     ↓
/// SettingsProvider
///     ↓
/// SharedPreferences
///
/// AuthProvider
///     ↓
/// SessionManager
///
/// ============================================================================

final class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

final class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<SettingsProvider>().initialize();

      if (!mounted) {
        return;
      }

      await context.read<NotificationProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SettingsProvider, AuthProvider>(
      builder: (context, settingsProvider, authProvider, child) {
        final theme = Theme.of(context);

        final user = authProvider.currentUser;

        return Scaffold(
          appBar: AppBar(title: const Text('Settings'), centerTitle: true),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ===============================================================
              // Profile Card
              // ===============================================================
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Icon(
                          Icons.person,
                          size: 34,
                          color: theme.colorScheme.primary,
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.email ?? 'Guest User',
                              style: theme.textTheme.titleLarge,
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
              ),

              const SizedBox(height: 24),

              // ===============================================================
              // Appearance Section
              // ===============================================================
              Text('Appearance', style: theme.textTheme.titleMedium),

              const SizedBox(height: 8),

              Card(
                elevation: 0,
                child: Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      title: const Text('System'),
                      subtitle: const Text('Follow the device theme.'),
                      value: ThemeMode.system,
                      groupValue: settingsProvider.themeMode,
                      onChanged: (value) async {
                        if (value == null) {
                          return;
                        }

                        await settingsProvider.setThemeMode(value);
                      },
                    ),

                    const Divider(height: 1),

                    RadioListTile<ThemeMode>(
                      title: const Text('Light'),
                      subtitle: const Text('Always use light mode.'),
                      value: ThemeMode.light,
                      groupValue: settingsProvider.themeMode,
                      onChanged: (value) async {
                        if (value == null) {
                          return;
                        }

                        await settingsProvider.setThemeMode(value);
                      },
                    ),

                    const Divider(height: 1),

                    RadioListTile<ThemeMode>(
                      title: const Text('Dark'),
                      subtitle: const Text('Always use dark mode.'),
                      value: ThemeMode.dark,
                      groupValue: settingsProvider.themeMode,
                      onChanged: (value) async {
                        if (value == null) {
                          return;
                        }

                        await settingsProvider.setThemeMode(value);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===============================================================
              // Notifications
              // ===============================================================
              Text('Notifications', style: theme.textTheme.titleMedium),

              const SizedBox(height: 8),

              Card(
                elevation: 0,
                child: ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('Notification Settings'),
                  subtitle: const Text(
                    'Reminder preferences and test notifications.',
                  ),
                  trailing: const Icon(Icons.chevron_right),
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

              Card(
                elevation: 0,
                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text('Notes App'),
                      subtitle: Text(
                        'Production-ready Flutter Notes application.',
                      ),
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.code),
                      title: Text('Version'),
                      subtitle: Text('1.0.0'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===============================================================
              // Account
              // ===============================================================
              Text('Account', style: theme.textTheme.titleMedium),

              const SizedBox(height: 8),

              Card(
                elevation: 0,
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
                  onTap: () => _logout(context),
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
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
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

    if (shouldLogout != true) {
      return;
    }

    if (!context.mounted) {
      return;
    }

    final AuthProvider authProvider = context.read<AuthProvider>();

    await authProvider.logout();

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
}
