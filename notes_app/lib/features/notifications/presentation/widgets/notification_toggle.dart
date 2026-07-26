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
/// • Displays the notification enable/disable switch.
/// • Reads state from NotificationProvider.
/// • Delegates state updates to NotificationProvider.
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
        return Card(
          clipBehavior: Clip.antiAlias,
          child: SwitchListTile(
            secondary: const Icon(Icons.notifications_active_outlined),
            title: const Text('Enable Notifications'),
            subtitle: const Text('Receive reminders for your notes.'),
            value: provider.notificationsEnabled,
            onChanged: (value) async {
              await provider.setNotificationsEnabled(value);
            },
          ),
        );
      },
    );
  }
}
