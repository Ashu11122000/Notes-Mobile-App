import 'package:flutter/material.dart';

/// ============================================================================
/// File: reminder_tile.dart
/// ============================================================================
///
/// Reminder Tile
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays reminder information.
/// • Shows configured reminder time.
/// • Exposes edit/delete callbacks.
/// • Contains no business logic.
/// • Reusable across notification features.
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

  /// Called when editing reminder.
  final VoidCallback onEdit;

  /// Called when deleting reminder.
  final VoidCallback? onDelete;

  /// Whether interactions are enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Color iconColor = enabled
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;

    return Card(
      clipBehavior: Clip.antiAlias,

      child: ListTile(
        enabled: enabled,

        // ===============================================================
        // Leading Icon
        // ===============================================================
        leading: Container(
          width: 42,
          height: 42,

          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(14),
          ),

          child: Icon(Icons.notifications_active_outlined, color: iconColor),
        ),

        // ===============================================================
        // Content
        // ===============================================================
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),

          child: Row(
            children: [
              Icon(
                Icons.schedule_outlined,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),

              const SizedBox(width: 6),

              Text(time.format(context), style: theme.textTheme.bodyMedium),
            ],
          ),
        ),

        // ===============================================================
        // Actions
        // ===============================================================
        trailing: Wrap(
          spacing: 4,

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

                icon: Icon(
                  Icons.delete_outline,
                  color: enabled ? theme.colorScheme.error : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
