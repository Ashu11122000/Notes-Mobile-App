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
/// • Reusable across notification settings.
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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,

      child: ListTile(
        enabled: enabled,

        leading: Icon(
          Icons.schedule_outlined,
          color: enabled
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
        ),

        title: const Text('Reminder Time'),

        subtitle: Text(selectedTime.format(context)),

        trailing: const Icon(Icons.chevron_right),

        onTap: enabled ? () => _pickTime(context) : null,
      ),
    );
  }

  // ===========================================================================
  // Pick Time
  // ===========================================================================

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime == null) {
      return;
    }

    onTimeSelected(pickedTime);
  }
}
