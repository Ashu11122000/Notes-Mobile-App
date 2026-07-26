import 'package:flutter/material.dart';

/// ============================================================================
/// File: reminder_tile.dart
/// ============================================================================
///
/// Reminder Tile
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Displays reminder information.
/// - Shows the configured reminder time.
/// - Exposes edit and delete callbacks.
/// - Contains no business logic.
/// - Reusable across the notification feature.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// NotificationSettingsScreen
///            │
///            ▼
///       ReminderTile
///
/// ============================================================================

final class ReminderTile extends StatelessWidget {
  const ReminderTile({
    super.key,
    required this.title,
    required this.time,
    required this.onEdit,
    this.onDelete,
    this.enabled = true,
  });

  /// Reminder title.
  final String title;

  /// Reminder time.
  final TimeOfDay time;

  /// Called when editing the reminder.
  final VoidCallback onEdit;

  /// Called when deleting the reminder.
  ///
  /// Optional because not every reminder must be removable.
  final VoidCallback? onDelete;

  /// Whether interactions are enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        enabled: enabled,
        leading: CircleAvatar(
          child: Icon(
            Icons.notifications_active_outlined,
            color: theme.colorScheme.primary,
          ),
        ),
        title: Text(title, style: theme.textTheme.titleMedium),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(time.format(context), style: theme.textTheme.bodyMedium),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Edit Reminder',
              onPressed: enabled ? onEdit : null,
              icon: const Icon(Icons.edit_outlined),
            ),
            if (onDelete != null)
              IconButton(
                tooltip: 'Delete Reminder',
                onPressed: enabled ? onDelete : null,
                icon: const Icon(Icons.delete_outline),
              ),
          ],
        ),
      ),
    );
  }
}
