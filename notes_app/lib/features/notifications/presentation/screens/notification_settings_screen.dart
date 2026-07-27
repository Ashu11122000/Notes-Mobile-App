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
/// • Configures daily reminders.
/// • Selects reminder time.
/// • Sends test notifications.
/// • Cancels notifications.
///
/// Does NOT:
/// ----------------------------------------------------------------------------
/// • Schedule reminders directly.
/// • Access NotificationService.
/// • Handle notification business rules.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///   ↓
/// NotificationProvider
///   ↓
/// NotificationService
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
                // ============================================================
                // Notifications Toggle
                // ============================================================
                const NotificationToggle(),

                const SizedBox(height: 16),

                // ============================================================
                // Daily Reminder
                // ============================================================
                Card(
                  clipBehavior: Clip.antiAlias,

                  child: SwitchListTile(
                    secondary: const Icon(Icons.repeat_rounded),

                    title: const Text('Daily Reminder'),

                    subtitle: const Text('Repeat reminder every day.'),

                    value: provider.dailyReminderEnabled,

                    onChanged: provider.notificationsEnabled
                        ? (value) async {
                            await provider.setDailyReminderEnabled(value);
                          }
                        : null,
                  ),
                ),

                const SizedBox(height: 16),

                // ============================================================
                // Reminder Time
                // ============================================================
                ReminderTimePicker(
                  selectedTime: _selectedTime,

                  enabled: provider.notificationsEnabled,

                  onTimeSelected: (time) {
                    setState(() {
                      _selectedTime = time;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // ============================================================
                // Reminder Preview
                // ============================================================
                ReminderTile(
                  title: 'Daily Notes Reminder',

                  time: _selectedTime,

                  enabled: provider.notificationsEnabled,

                  onEdit: () async {
                    final TimeOfDay? time = await showTimePicker(
                      context: context,

                      initialTime: _selectedTime,
                    );

                    if (time == null) {
                      return;
                    }

                    setState(() {
                      _selectedTime = time;
                    });
                  },
                ),

                const SizedBox(height: 32),

                // ============================================================
                // Test Notification
                // ============================================================
                FilledButton.icon(
                  icon: const Icon(Icons.notifications_active_outlined),

                  label: const Text('Send Test Notification'),

                  onPressed: provider.notificationsEnabled
                      ? () async {
                          await provider.sendTestNotification();

                          if (!context.mounted) {
                            return;
                          }

                          _showMessage(
                            context,
                            'Test notification sent successfully.',
                          );
                        }
                      : null,
                ),

                const SizedBox(height: 12),

                // ============================================================
                // Cancel Notifications
                // ============================================================
                OutlinedButton.icon(
                  icon: const Icon(Icons.notifications_off_outlined),

                  label: const Text('Cancel All Notifications'),

                  onPressed: provider.notificationsEnabled
                      ? () async {
                          await provider.cancelAllNotifications();

                          if (!context.mounted) {
                            return;
                          }

                          _showMessage(context, 'All notifications cancelled.');
                        }
                      : null,
                ),

                const SizedBox(height: 12),

                // ============================================================
                // Reset
                // ============================================================
                TextButton.icon(
                  icon: const Icon(Icons.restart_alt_rounded),

                  label: const Text('Reset Preferences'),

                  onPressed: () async {
                    await provider.resetPreferences();

                    if (!context.mounted) {
                      return;
                    }

                    setState(() {
                      _selectedTime = const TimeOfDay(hour: 9, minute: 0);
                    });

                    _showMessage(context, 'Notification preferences reset.');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================================
  // Snackbar Helper
  // ==========================================================================

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
