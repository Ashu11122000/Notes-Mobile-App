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
/// Notification Settings Screen.
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
  // ===========================================================================
  // Constants
  // ===========================================================================

  static const TimeOfDay _defaultReminderTime = TimeOfDay(hour: 9, minute: 0);

  static const EdgeInsets _screenPadding = EdgeInsets.all(16);

  // ===========================================================================
  // Local State
  // ===========================================================================

  TimeOfDay _selectedTime = _defaultReminderTime;

  // ===========================================================================
  // Lifecycle
  // ===========================================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      context.read<NotificationProvider>().initialize();
    });
  }

  // ===========================================================================
  // Build
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final bool notificationsEnabled = context
        .select<NotificationProvider, bool>(
          (NotificationProvider provider) => provider.notificationsEnabled,
        );

    final bool dailyReminderEnabled = context
        .select<NotificationProvider, bool>(
          (NotificationProvider provider) => provider.dailyReminderEnabled,
        );

    final bool isLoading = context.select<NotificationProvider, bool>(
      (NotificationProvider provider) => provider.isLoading,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),

        centerTitle: true,
      ),

      body: SafeArea(
        child: ListView(
          padding: _screenPadding,

          children: <Widget>[
            const NotificationToggle(),

            const SizedBox(height: 16),

            Card(
              clipBehavior: Clip.antiAlias,

              child: SwitchListTile.adaptive(
                secondary: const Icon(Icons.repeat_rounded),

                title: const Text('Daily Reminder'),

                subtitle: const Text('Repeat reminder every day.'),

                value: dailyReminderEnabled,

                onChanged: !notificationsEnabled || isLoading
                    ? null
                    : (bool value) async {
                        await context
                            .read<NotificationProvider>()
                            .setDailyReminderEnabled(value);
                      },
              ),
            ),

            const SizedBox(height: 16),

            ReminderTimePicker(
              selectedTime: _selectedTime,

              enabled: notificationsEnabled && !isLoading,

              onTimeSelected: _updateReminderTime,
            ),

            const SizedBox(height: 16),

            ReminderTile(
              title: 'Daily Notes Reminder',

              time: _selectedTime,

              enabled: notificationsEnabled && !isLoading,

              onEdit: _openReminderTimePicker,
            ),

            const SizedBox(height: 32),

            // ===========================================================================
            // Test Notification
            // ===========================================================================
            FilledButton.icon(
              icon: const Icon(Icons.notifications_active_outlined),

              label: const Text('Send Test Notification'),

              onPressed: notificationsEnabled && !isLoading
                  ? _sendTestNotification
                  : null,
            ),

            const SizedBox(height: 12),

            // ===========================================================================
            // Cancel Notifications
            // ===========================================================================
            OutlinedButton.icon(
              icon: const Icon(Icons.notifications_off_outlined),

              label: const Text('Cancel All Notifications'),

              onPressed: notificationsEnabled && !isLoading
                  ? _cancelNotifications
                  : null,
            ),

            const SizedBox(height: 12),

            // ===========================================================================
            // Reset Preferences
            // ===========================================================================
            TextButton.icon(
              icon: const Icon(Icons.restart_alt_rounded),

              label: const Text('Reset Preferences'),

              onPressed: isLoading ? null : _resetPreferences,
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // Update Reminder Time
  // ===========================================================================

  void _updateReminderTime(TimeOfDay time) {
    setState(() {
      _selectedTime = time;
    });
  }

  // ===========================================================================
  // Open Reminder Picker
  // ===========================================================================

  Future<void> _openReminderTimePicker() async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,

      initialTime: _selectedTime,
    );

    if (selected == null || !mounted) {
      return;
    }

    setState(() {
      _selectedTime = selected;
    });
  }

  // ===========================================================================
  // Send Test Notification
  // ===========================================================================

  Future<void> _sendTestNotification() async {
    final NotificationProvider provider = context.read<NotificationProvider>();

    await provider.sendTestNotification();

    if (!mounted) {
      return;
    }

    _showMessage(
      provider.hasError
          ? provider.errorMessage ?? 'Failed to send notification.'
          : 'Test notification sent successfully.',
    );
  }

  // ===========================================================================
  // Cancel All Notifications
  // ===========================================================================

  Future<void> _cancelNotifications() async {
    final NotificationProvider provider = context.read<NotificationProvider>();

    await provider.cancelAllNotifications();

    if (!mounted) {
      return;
    }

    _showMessage(
      provider.hasError
          ? provider.errorMessage ?? 'Failed to cancel notifications.'
          : 'All notifications cancelled.',
    );
  }

  // ===========================================================================
  // Reset Preferences
  // ===========================================================================

  Future<void> _resetPreferences() async {
    final NotificationProvider provider = context.read<NotificationProvider>();

    await provider.resetPreferences();

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedTime = _defaultReminderTime;
    });

    _showMessage(
      provider.hasError
          ? provider.errorMessage ?? 'Failed to reset preferences.'
          : 'Notification preferences reset.',
    );
  }

  // ===========================================================================
  // Snackbar Helper
  // ===========================================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
