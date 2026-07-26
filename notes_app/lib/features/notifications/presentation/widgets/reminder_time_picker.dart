import 'package:flutter/material.dart';

/// ============================================================================
/// File: reminder_time_picker.dart
/// ============================================================================
///
/// Reminder Time Picker
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Displays the currently selected reminder time.
/// - Opens the Material Time Picker.
/// - Returns the selected time through a callback.
/// - Contains no business logic.
/// - Reusable across the application.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// NotificationSettingsScreen
///            │
///            ▼
///    ReminderTimePicker
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

  /// Called when the user selects a new time.
  final ValueChanged<TimeOfDay> onTimeSelected;

  /// Whether the picker is enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.schedule_outlined),
        title: const Text('Reminder Time'),
        subtitle: Text(selectedTime.format(context)),
        trailing: const Icon(Icons.chevron_right),
        enabled: enabled,
        onTap: enabled ? () => _pickTime(context) : null,
      ),
    );
  }

  // ===========================================================================
  // Pick Time
  // ===========================================================================

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(data: Theme.of(context), child: child!);
      },
    );

    if (time == null) {
      return;
    }

    onTimeSelected(time);
  }
}
