import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/reminder_title.dart';
import '../providers/notification_provider.dart';
import '../widgets/notification_toggle.dart';
import '../widgets/reminder_time_picker.dart';

/// ============================================================================
/// File: notification_settings_screen.dart
/// ============================================================================
///
/// Notification Settings Screen
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Displays notification settings.
/// - Enables/disables notifications.
/// - Allows selecting a reminder time.
/// - Sends a test notification.
/// - Cancels all notifications.
/// - Contains no notification business logic.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///     ↓
/// NotificationProvider
///     ↓
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
                //----------------------------------------------------------------
                // Enable Notifications
                //----------------------------------------------------------------
                const NotificationToggle(),

                const SizedBox(height: 16),

                //----------------------------------------------------------------
                // Reminder Time
                //----------------------------------------------------------------
                ReminderTimePicker(
                  selectedTime: _selectedTime,
                  enabled: provider.enabled,
                  onTimeSelected: (time) {
                    setState(() {
                      _selectedTime = time;
                    });
                  },
                ),

                const SizedBox(height: 16),

                //----------------------------------------------------------------
                // Reminder Preview
                //----------------------------------------------------------------
                ReminderTile(
                  title: 'Daily Notes Reminder',
                  time: _selectedTime,
                  enabled: provider.enabled,
                  onEdit: () {},
                ),

                const SizedBox(height: 32),

                //----------------------------------------------------------------
                // Test Notification
                //----------------------------------------------------------------
                FilledButton.icon(
                  onPressed: provider.enabled
                      ? () async {
                          await provider.sendTestNotification();

                          if (!context.mounted) {
                            return;
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Test notification sent.'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.notifications_active_outlined),
                  label: const Text('Send Test Notification'),
                ),

                const SizedBox(height: 12),

                //----------------------------------------------------------------
                // Cancel All Notifications
                //----------------------------------------------------------------
                OutlinedButton.icon(
                  onPressed: provider.enabled
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
              ],
            ),
          ),
        );
      },
    );
  }
}
