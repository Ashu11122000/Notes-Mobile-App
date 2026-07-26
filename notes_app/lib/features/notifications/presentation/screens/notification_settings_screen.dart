import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notification_provider.dart';
import '../widgets/notification_toggle.dart';
import '../widgets/reminder_time_picker.dart';
import '../widgets/reminder_title.dart';

/// ============================================================================
/// File: notification_settings_screen.dart
/// ============================================================================
///
/// Notification Settings Screen
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays notification preferences.
/// • Enables/disables notifications.
/// • Configures daily reminder preference.
/// • Selects default reminder time.
/// • Sends test notifications.
/// • Cancels notifications.
///
/// Notes
/// ----------------------------------------------------------------------------
/// This screen manages only notification preferences.
///
/// Notification scheduling is handled by ReminderManager.
///
/// ============================================================================

final class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

final class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Notification Settings'),
            centerTitle: true,
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // =============================================================
                // Enable Notifications
                // =============================================================
                const NotificationToggle(),

                const SizedBox(height: 16),

                // =============================================================
                // Daily Reminder Preference
                // =============================================================
                Card(
                  child: SwitchListTile(
                    secondary: const Icon(Icons.repeat),
                    title: const Text('Enable Daily Reminder'),
                    subtitle: const Text(
                      'Repeat reminder every day at the selected time.',
                    ),
                    value: provider.dailyReminderEnabled,
                    onChanged: provider.notificationsEnabled
                        ? (value) async {
                            await provider.setDailyReminderEnabled(value);
                          }
                        : null,
                  ),
                ),

                const SizedBox(height: 16),

                // =============================================================
                // Reminder Time
                // =============================================================
                ReminderTimePicker(
                  selectedTime: _selectedTime,
                  enabled: provider.notificationsEnabled,
                  onTimeSelected: (time) {
                    setState(() {
                      _selectedTime = time;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // =============================================================
                // Reminder Preview
                // =============================================================
                ReminderTile(
                  title: 'Daily Notes Reminder',
                  time: _selectedTime,
                  enabled: provider.notificationsEnabled,
                  onEdit: () {},
                ),

                const SizedBox(height: 32),

                // =============================================================
                // Send Test Notification
                // =============================================================
                FilledButton.icon(
                  onPressed: provider.notificationsEnabled
                      ? () async {
                          await provider.sendTestNotification();

                          if (!context.mounted) {
                            return;
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Test notification sent successfully.',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.notifications_active_outlined),
                  label: const Text('Send Test Notification'),
                ),

                const SizedBox(height: 12),

                // =============================================================
                // Cancel All Notifications
                // =============================================================
                OutlinedButton.icon(
                  onPressed: provider.notificationsEnabled
                      ? () async {
                          await provider.cancelAllNotifications();

                          if (!context.mounted) {
                            return;
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('All notifications cancelled.'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.notifications_off_outlined),
                  label: const Text('Cancel All Notifications'),
                ),

                const SizedBox(height: 12),

                // =============================================================
                // Reset Preferences
                // =============================================================
                TextButton.icon(
                  onPressed: () async {
                    await provider.resetPreferences();

                    if (!context.mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notification preferences reset.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Reset Preferences'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
