import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/logger_service.dart';
import '../../../core/services/notification_service.dart';
import '../models/reminder_model.dart';

/// ============================================================================
/// File: reminder_manager.dart
/// ============================================================================
///
/// Reminder Manager
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Persists reminders locally.
/// • Schedules notifications.
/// • Updates reminders.
/// • Deletes reminders.
/// • Restores reminders after restart.
/// • Generates notification identifiers.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///      ↓
/// ReminderManager
///      ↓
/// NotificationService
///      ↓
/// flutter_local_notifications
///
/// ============================================================================

final class ReminderManager {
  ReminderManager._();

  static final ReminderManager instance = ReminderManager._();

  static const String _storageKey = 'note_reminders';

  // ===========================================================================
  // Get All Reminders
  // ===========================================================================

  Future<List<ReminderModel>> getReminders() async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      final List<String> stored =
          preferences.getStringList(_storageKey) ?? <String>[];

      return stored
          .map(
            (item) => ReminderModel.fromJson(
              jsonDecode(item) as Map<String, dynamic>,
            ),
          )
          .toList(growable: false);
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to load reminders.',
        error: exception,
        stackTrace: stackTrace,
      );

      return <ReminderModel>[];
    }
  }

  // ===========================================================================
  // Get Reminder By Note
  // ===========================================================================

  Future<ReminderModel?> getReminderByNote(int noteId) async {
    final reminders = await getReminders();

    for (final reminder in reminders) {
      if (reminder.noteId == noteId) {
        return reminder;
      }
    }

    return null;
  }

  // ===========================================================================
  // Save Reminder
  // ===========================================================================

  Future<void> saveReminder(ReminderModel reminder) async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      final List<ReminderModel> reminders = await getReminders();

      reminders.removeWhere(
        (item) => item.notificationId == reminder.notificationId,
      );

      reminders.add(reminder);

      await preferences.setStringList(
        _storageKey,
        reminders.map((item) => jsonEncode(item.toJson())).toList(),
      );

      await scheduleReminder(reminder);

      LoggerService.info(
        'Reminder saved successfully. '
        'ID: ${reminder.notificationId}',
      );
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to save reminder.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  // ===========================================================================
  // Public Schedule Reminder
  // ===========================================================================

  Future<void> scheduleReminder(ReminderModel reminder) async {
    await _scheduleReminder(reminder);
  }

  // ===========================================================================
  // Internal Scheduling
  // ===========================================================================

  Future<void> _scheduleReminder(ReminderModel reminder) async {
    if (!reminder.isEnabled) {
      return;
    }

    if (reminder.isExpired) {
      LoggerService.warning('Skipped expired reminder.');

      return;
    }

    if (reminder.repeatDaily) {
      await NotificationService.instance.scheduleDaily(
        id: reminder.notificationId,
        title: reminder.title,
        body: reminder.body,
        scheduledAt: reminder.scheduledAt,
        payload: reminder.payload,
      );
    } else {
      await NotificationService.instance.schedule(
        id: reminder.notificationId,
        title: reminder.title,
        body: reminder.body,
        scheduledAt: reminder.scheduledAt,
        payload: reminder.payload,
      );
    }
  }

  // ===========================================================================
  // Update Reminder
  // ===========================================================================

  Future<void> updateReminder(ReminderModel reminder) async {
    try {
      await NotificationService.instance.cancel(reminder.notificationId);

      await saveReminder(reminder);

      LoggerService.info('Reminder updated successfully.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to update reminder.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  // ===========================================================================
  // Delete Reminder
  // ===========================================================================

  Future<void> deleteReminder(int notificationId) async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      final reminders = await getReminders();

      reminders.removeWhere((item) => item.notificationId == notificationId);

      await preferences.setStringList(
        _storageKey,

        reminders.map((item) => jsonEncode(item.toJson())).toList(),
      );

      await NotificationService.instance.cancel(notificationId);

      LoggerService.info(
        'Reminder deleted successfully. '
        'ID: $notificationId',
      );
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to delete reminder.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  // ===========================================================================
  // Delete Reminder By Note
  // ===========================================================================

  Future<void> deleteReminderByNote(int noteId) async {
    try {
      final ReminderModel? reminder = await getReminderByNote(noteId);

      if (reminder == null) {
        return;
      }

      await deleteReminder(reminder.notificationId);

      LoggerService.info(
        'Reminder removed for note. '
        'Note ID: $noteId',
      );
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to delete reminder by note.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  // ===========================================================================
  // Restore Reminders After App Restart
  // ===========================================================================

  Future<void> restoreReminders() async {
    try {
      final List<ReminderModel> reminders = await getReminders();

      final List<ReminderModel> activeReminders = <ReminderModel>[];

      for (final reminder in reminders) {
        if (!reminder.isEnabled) {
          continue;
        }

        if (reminder.isExpired) {
          await NotificationService.instance.cancel(reminder.notificationId);

          continue;
        }

        await _scheduleReminder(reminder);

        activeReminders.add(reminder);
      }

      // Remove expired reminders permanently.

      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      await preferences.setStringList(
        _storageKey,

        activeReminders.map((item) => jsonEncode(item.toJson())).toList(),
      );

      LoggerService.info('Restored ${activeReminders.length} reminders.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to restore reminders.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  // ===========================================================================
  // Clear All Reminders
  // ===========================================================================

  Future<void> clear() async {
    try {
      final List<ReminderModel> reminders = await getReminders();

      for (final reminder in reminders) {
        await NotificationService.instance.cancel(reminder.notificationId);
      }

      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      await preferences.remove(_storageKey);

      LoggerService.info('All reminders cleared successfully.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to clear reminders.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  // ===========================================================================
  // Generate Next Notification ID
  // ===========================================================================

  Future<int> nextNotificationId() async {
    final List<ReminderModel> reminders = await getReminders();

    if (reminders.isEmpty) {
      return 1;
    }

    int maxId = 0;

    for (final reminder in reminders) {
      if (reminder.notificationId > maxId) {
        maxId = reminder.notificationId;
      }
    }

    return maxId + 1;
  }

  // ===========================================================================
  // Dispose
  // ===========================================================================

  void dispose() {
    LoggerService.info('ReminderManager disposed.');
  }
}
