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
/// • Uses selective rebuilds for better performance.
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

  static const String _title = 'Enable Notifications';

  static const String _enabledDescription = 'Receive reminders for your notes.';

  static const String _disabledDescription = 'Notifications are disabled.';

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = context.select<NotificationProvider, bool>(
      (NotificationProvider provider) => provider.notificationsEnabled,
    );

    final bool isLoading = context.select<NotificationProvider, bool>(
      (NotificationProvider provider) => provider.isLoading,
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Semantics(
        container: true,
        toggled: isEnabled,
        child: SwitchListTile.adaptive(
          value: isEnabled,
          onChanged: isLoading
              ? null
              : (bool value) async {
                  await context
                      .read<NotificationProvider>()
                      .setNotificationsEnabled(value);
                },

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

          title: const Text(_title),

          subtitle: Text(
            isEnabled ? _enabledDescription : _disabledDescription,
          ),
        ),
      ),
    );
  }
}
