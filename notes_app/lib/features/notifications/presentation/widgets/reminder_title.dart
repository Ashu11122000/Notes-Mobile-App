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
/// • Optimized for ListView performance.
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

  // ===========================================================================
  // Inputs
  // ===========================================================================

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

  // ===========================================================================
  // Constants
  // ===========================================================================

  static const double _iconContainerSize = 42;

  static const double _iconRadius = 14;

  static const double _titleSpacing = 6;

  static const double _buttonSpacing = 4;

  // ===========================================================================
  // Build
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final bool hasDelete = onDelete != null;

    final Color iconColor = enabled
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;

    return Semantics(
      container: true,
      label: 'Reminder $title',

      child: Card(
        clipBehavior: Clip.antiAlias,

        child: ListTile(
          enabled: enabled,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),

          leading: _buildLeadingIcon(theme, iconColor),

          title: Text(
            title.trim(),

            maxLines: 1,

            overflow: TextOverflow.ellipsis,

            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          subtitle: Padding(
            padding: const EdgeInsets.only(top: _titleSpacing),

            child: _buildTimeRow(context, theme),
          ),

          trailing: _buildActions(theme, hasDelete),
        ),
      ),
    );
  }
  // ===========================================================================
  // Leading Icon
  // ===========================================================================

  Widget _buildLeadingIcon(ThemeData theme, Color iconColor) {
    return Container(
      width: _iconContainerSize,

      height: _iconContainerSize,

      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,

        borderRadius: BorderRadius.circular(_iconRadius),
      ),

      alignment: Alignment.center,

      child: Icon(Icons.notifications_active_outlined, color: iconColor),
    );
  }

  // ===========================================================================
  // Time Row
  // ===========================================================================

  // ===========================================================================
  // Time Row
  // ===========================================================================

  Widget _buildTimeRow(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,

      crossAxisAlignment: CrossAxisAlignment.center,

      children: <Widget>[
        Icon(
          Icons.schedule_outlined,

          size: 16,

          color: theme.colorScheme.onSurfaceVariant,
        ),

        const SizedBox(width: 6),

        Text(
          time.format(context),

          maxLines: 1,

          overflow: TextOverflow.ellipsis,

          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
  // ===========================================================================
  // Actions
  // ===========================================================================

  Widget? _buildActions(ThemeData theme, bool hasDelete) {
    if (!hasDelete) {
      return IconButton(
        tooltip: 'Edit Reminder',

        onPressed: enabled ? onEdit : null,

        icon: const Icon(Icons.edit_outlined),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,

      children: <Widget>[
        IconButton(
          tooltip: 'Edit Reminder',

          onPressed: enabled ? onEdit : null,

          icon: const Icon(Icons.edit_outlined),
        ),

        const SizedBox(width: _buttonSpacing),

        IconButton(
          tooltip: 'Delete Reminder',

          onPressed: enabled ? onDelete : null,

          icon: Icon(
            Icons.delete_outline_rounded,

            color: enabled ? theme.colorScheme.error : null,
          ),
        ),
      ],
    );
  }
}
