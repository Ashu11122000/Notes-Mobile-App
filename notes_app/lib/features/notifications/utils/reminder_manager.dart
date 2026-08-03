import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/logger_service.dart';
import '../../../core/services/notification_service.dart';
import '../models/reminder_model.dart';

/// ============================================================================
/// File: reminder_manager.dart
/// ============================================================================
///
/// Enterprise Reminder Manager.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Stores reminders locally.
/// • Schedules notifications.
/// • Restores reminders after app restart.
/// • Updates and deletes reminders.
/// • Maintains lightweight in-memory cache.
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

  // ===========================================================================
  // Constants
  // ===========================================================================

  static const String _storageKey = 'note_reminders';

  // ===========================================================================
  // Internal Cache
  // ===========================================================================

  List<ReminderModel>? _cache;

  SharedPreferences? _preferences;

  // ===========================================================================
  // Preferences
  // ===========================================================================

  Future<SharedPreferences> get _prefs async {
    return _preferences ??= await SharedPreferences.getInstance();
  }

  // ===========================================================================
  // Get All Reminders
  // ===========================================================================

  Future<List<ReminderModel>> getReminders() async {
    if (_cache != null) {
      return List<ReminderModel>.unmodifiable(_cache!);
    }

    try {
      final SharedPreferences preferences = await _prefs;

      final List<String> stored =
          preferences.getStringList(_storageKey) ?? <String>[];

      _cache = stored
          .map((String item) {
            return ReminderModel.fromJson(
              jsonDecode(item) as Map<String, dynamic>,
            );
          })
          .toList(growable: false);

      return List<ReminderModel>.unmodifiable(_cache!);
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to load reminders.',

        error: exception,

        stackTrace: stackTrace,
      );

      return const <ReminderModel>[];
    }
  }

  // ===========================================================================
  // Get Reminder By Note
  // ===========================================================================

  Future<ReminderModel?> getReminderByNote(int noteId) async {
    final List<ReminderModel> reminders = await getReminders();

    for (final ReminderModel reminder in reminders) {
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
      final List<ReminderModel> reminders = List<ReminderModel>.from(
        await getReminders(),
      );

      reminders.removeWhere(
        (ReminderModel item) => item.notificationId == reminder.notificationId,
      );

      reminders.add(reminder);

      await _saveReminders(reminders);

      await _scheduleReminder(reminder);

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
  // Schedule Internal
  // ===========================================================================

  Future<void> _scheduleReminder(ReminderModel reminder) async {
    if (!reminder.isEnabled) {
      return;
    }

    if (reminder.isExpired) {
      LoggerService.warning(
        'Skipped expired reminder '
        '${reminder.notificationId}',
      );

      return;
    }

    final NotificationService service = NotificationService.instance;

    if (reminder.repeatDaily) {
      await service.scheduleDaily(
        id: reminder.notificationId,

        title: reminder.title,

        body: reminder.body,

        scheduledAt: reminder.scheduledAt,

        payload: reminder.payload,
      );
    } else {
      await service.schedule(
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
      final List<ReminderModel> reminders = List<ReminderModel>.from(
        await getReminders(),
      );

      reminders.removeWhere(
        (ReminderModel item) => item.notificationId == notificationId,
      );

      await _saveReminders(reminders);

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
    final ReminderModel? reminder = await getReminderByNote(noteId);

    if (reminder == null) {
      return;
    }

    await deleteReminder(reminder.notificationId);

    LoggerService.info(
      'Reminder removed for note. '
      'Note ID: $noteId',
    );
  }

  // ===========================================================================
  // Restore Reminders After Restart
  // ===========================================================================

  Future<void> restoreReminders() async {
    try {
      final List<ReminderModel> reminders = await getReminders();

      final List<ReminderModel> activeReminders = <ReminderModel>[];

      for (final ReminderModel reminder in reminders) {
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

      await _saveReminders(activeReminders);

      LoggerService.info(
        'Restored '
        '${activeReminders.length} reminders.',
      );
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

      for (final ReminderModel reminder in reminders) {
        await NotificationService.instance.cancel(reminder.notificationId);
      }

      final SharedPreferences preferences = await _prefs;

      await preferences.remove(_storageKey);

      _cache = <ReminderModel>[];

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

    for (final ReminderModel reminder in reminders) {
      if (reminder.notificationId > maxId) {
        maxId = reminder.notificationId;
      }
    }

    return maxId + 1;
  }

  // ===========================================================================
  // Save Local Cache
  // ===========================================================================

  Future<void> _saveReminders(List<ReminderModel> reminders) async {
    final SharedPreferences preferences = await _prefs;

    _cache = List<ReminderModel>.unmodifiable(reminders);

    await preferences.setStringList(
      _storageKey,

      reminders
          .map((ReminderModel item) => jsonEncode(item.toJson()))
          .toList(growable: false),
    );
  }

  // ===========================================================================
  // Dispose
  // ===========================================================================

  void dispose() {
    _cache = null;

    _preferences = null;

    LoggerService.info('ReminderManager disposed.');
  }
}
