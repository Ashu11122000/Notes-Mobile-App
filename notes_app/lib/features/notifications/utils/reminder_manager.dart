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
/// • Persist reminders locally.
/// • Schedule notifications.
/// • Update reminders.
/// • Delete reminders.
/// • Restore reminders after app restart.
/// • Generate notification identifiers.
///
/// Notes
/// ----------------------------------------------------------------------------
/// This manager is the single source of truth for reminder persistence.
///
/// UI should never directly communicate with NotificationService.
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

      final List<String> storedReminders =
          preferences.getStringList(_storageKey) ?? <String>[];

      return storedReminders
          .map(
            (json) => ReminderModel.fromJson(
              jsonDecode(json) as Map<String, dynamic>,
            ),
          )
          .toList();
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

    try {
      return reminders.firstWhere((reminder) => reminder.noteId == noteId);
    } catch (_) {
      return null;
    }
  }

  // ===========================================================================
  // Save Reminder
  // ===========================================================================

  Future<void> saveReminder(ReminderModel reminder) async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      final reminders = await getReminders();

      reminders.removeWhere(
        (item) => item.notificationId == reminder.notificationId,
      );

      reminders.add(reminder);

      await preferences.setStringList(
        _storageKey,
        reminders.map((item) => jsonEncode(item.toJson())).toList(),
      );

      await _scheduleReminder(reminder);

      LoggerService.info(
        'Reminder saved successfully. '
        '(notificationId: ${reminder.notificationId})',
      );
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to save reminder.',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // Schedule Reminder
  // ===========================================================================

  Future<void> _scheduleReminder(ReminderModel reminder) async {
    if (!reminder.isEnabled) {
      return;
    }

    if (reminder.isExpired) {
      LoggerService.warning('Skipped scheduling expired reminder.');

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
    await NotificationService.instance.cancel(reminder.notificationId);

    await saveReminder(reminder);

    LoggerService.info('Reminder updated successfully.');
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
        '(notificationId: $notificationId)',
      );
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to delete reminder.',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // Delete Reminder By Note
  // ===========================================================================

  Future<void> deleteReminderByNote(int noteId) async {
    try {
      final reminder = await getReminderByNote(noteId);

      if (reminder == null) {
        return;
      }

      await deleteReminder(reminder.notificationId);

      LoggerService.info(
        'Reminder deleted for note. '
        '(noteId: $noteId)',
      );
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to delete reminder by note.',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // Restore Reminders
  // ===========================================================================

  Future<void> restoreReminders() async {
    try {
      final reminders = await getReminders();

      for (final reminder in reminders) {
        if (!reminder.isEnabled) {
          continue;
        }

        if (reminder.isExpired) {
          continue;
        }

        await _scheduleReminder(reminder);
      }

      LoggerService.info('Restored ${reminders.length} reminder(s).');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to restore reminders.',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // Clear All Reminders
  // ===========================================================================

  Future<void> clear() async {
    try {
      final reminders = await getReminders();

      for (final reminder in reminders) {
        await NotificationService.instance.cancel(reminder.notificationId);
      }

      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      await preferences.remove(_storageKey);

      LoggerService.info('All reminders cleared.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to clear reminders.',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // Next Notification Id
  // ===========================================================================

  Future<int> nextNotificationId() async {
    final reminders = await getReminders();

    if (reminders.isEmpty) {
      return 1;
    }

    reminders.sort((a, b) => a.notificationId.compareTo(b.notificationId));

    return reminders.last.notificationId + 1;
  }

  // ===========================================================================
  // Dispose
  // ===========================================================================

  void dispose() {
    LoggerService.info('ReminderManager disposed.');
  }
}
