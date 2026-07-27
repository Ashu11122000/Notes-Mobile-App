import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notification_provider.dart';

/// ============================================================================
/// File: notification_toggle.dart
/// ============================================================================
///
/// Notification Toggle
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays notification preference switch.
/// • Reads state from NotificationProvider.
/// • Updates notification preference.
/// • Handles loading state.
/// • Contains no business logic.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// NotificationSettingsScreen
///             │
///             ▼
///     NotificationToggle
///             │
///             ▼
///   NotificationProvider
///
/// ============================================================================

final class NotificationToggle extends StatelessWidget {
  const NotificationToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, provider, child) {
        final bool isEnabled = provider.notificationsEnabled;

        return Card(
          clipBehavior: Clip.antiAlias,

          child: SwitchListTile(
            // ===============================================================
            // Icon
            // ===============================================================
            secondary: Tooltip(
              message: isEnabled
                  ? 'Notifications enabled'
                  : 'Notifications disabled',

              child: Icon(
                isEnabled
                    ? Icons.notifications_active_outlined
                    : Icons.notifications_off_outlined,
              ),
            ),

            // ===============================================================
            // Title
            // ===============================================================
            title: const Text('Enable Notifications'),

            // ===============================================================
            // Description
            // ===============================================================
            subtitle: Text(
              isEnabled
                  ? 'Receive reminders for your notes.'
                  : 'Notifications are disabled.',
            ),

            // ===============================================================
            // Value
            // ===============================================================
            value: isEnabled,

            // ===============================================================
            // Action
            // ===============================================================
            onChanged: provider.isLoading
                ? null
                : (bool value) async {
                    await provider.setNotificationsEnabled(value);
                  },
          ),
        );
      },
    );
  }
}
