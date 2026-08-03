import 'package:flutter/material.dart';

/// ============================================================================
/// File: reminder_time_picker.dart
/// ============================================================================
///
/// Reminder Time Picker
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays selected reminder time.
/// • Opens Material Time Picker.
/// • Returns selected time through callback.
/// • Contains no business logic.
/// • Optimized for minimal rebuilds.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// NotificationSettingsScreen
///            │
///            ▼
///    ReminderTimePicker
///            │
///            ▼
///      Callback
///
/// ============================================================================

final class ReminderTimePicker extends StatelessWidget {
  const ReminderTimePicker({
    super.key,
    required this.selectedTime,
    required this.onTimeSelected,
    this.enabled = true,
  });

  /// Currently selected reminder time.
  final TimeOfDay selectedTime;

  /// Called when user selects a new time.
  final ValueChanged<TimeOfDay> onTimeSelected;

  /// Whether picker is interactive.
  final bool enabled;

  // ===========================================================================
  // Constants
  // ===========================================================================

  static const String _title = 'Reminder Time';

  static const IconData _leadingIcon = Icons.schedule_outlined;

  static const IconData _arrowIcon = Icons.chevron_right_rounded;

  // ===========================================================================
  // Build
  // ===========================================================================

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

        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),

        leading: Icon(_leadingIcon, color: iconColor),

        title: const Text(_title),

        subtitle: Text(selectedTime.format(context)),

        trailing: const Icon(_arrowIcon),

        onTap: enabled ? () => _showTimePicker(context) : null,
      ),
    );
  }

  // ===========================================================================
  // Time Picker
  // ===========================================================================

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,

      initialTime: selectedTime,

      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (pickedTime == null) {
      return;
    }

    onTimeSelected(pickedTime);
  }
}
