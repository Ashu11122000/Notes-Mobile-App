import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/logger_service.dart';
import '../../../../core/services/notification_service.dart';

/// ============================================================================
/// File: notification_provider.dart
/// ============================================================================
///
/// Notification Provider
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Manages notification preferences.
/// • Persists notification settings.
/// • Enables/disables notifications.
/// • Manages default reminder preferences.
/// • Sends test notifications.
/// • Notifies listeners of state changes.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///     ↓
/// NotificationProvider
///     ↓
/// NotificationService
///
/// Notification scheduling is handled by ReminderManager.
///
/// ============================================================================

final class NotificationProvider extends ChangeNotifier {
  NotificationProvider({NotificationService? notificationService})
    : _notificationService =
          notificationService ?? NotificationService.instance;

  static const String _notificationsEnabledKey = 'notifications_enabled';

  static const String _dailyReminderEnabledKey = 'daily_reminder_enabled';

  static const String _defaultReminderEnabledKey = 'default_reminder_enabled';

  final NotificationService _notificationService;

  bool _initialized = false;

  bool _notificationsEnabled = true;

  bool _dailyReminderEnabled = false;

  bool _defaultReminderEnabled = true;

  // ===========================================================================
  // Getters
  // ===========================================================================

  bool get initialized => _initialized;

  bool get notificationsEnabled => _notificationsEnabled;

  bool get dailyReminderEnabled => _dailyReminderEnabled;

  bool get defaultReminderEnabled => _defaultReminderEnabled;

  // ===========================================================================
  // Initialize
  // ===========================================================================

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      _notificationsEnabled =
          preferences.getBool(_notificationsEnabledKey) ?? true;

      _dailyReminderEnabled =
          preferences.getBool(_dailyReminderEnabledKey) ?? false;

      _defaultReminderEnabled =
          preferences.getBool(_defaultReminderEnabledKey) ?? true;

      _initialized = true;

      notifyListeners();

      LoggerService.info('NotificationProvider initialized.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to initialize NotificationProvider.',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // Enable / Disable Notifications
  // ===========================================================================

  Future<void> setNotificationsEnabled(bool enabled) async {
    try {
      _notificationsEnabled = enabled;

      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      await preferences.setBool(_notificationsEnabledKey, enabled);

      notifyListeners();

      LoggerService.info('Notifications ${enabled ? 'enabled' : 'disabled'}.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to update notification preference.',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // Daily Reminder Preference
  // ===========================================================================

  Future<void> setDailyReminderEnabled(bool enabled) async {
    try {
      _dailyReminderEnabled = enabled;

      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      await preferences.setBool(_dailyReminderEnabledKey, enabled);

      notifyListeners();

      LoggerService.info(
        'Daily reminders ${enabled ? 'enabled' : 'disabled'}.',
      );
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to update daily reminder preference.',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // Default Reminder Preference
  // ===========================================================================

  Future<void> setDefaultReminderEnabled(bool enabled) async {
    try {
      _defaultReminderEnabled = enabled;

      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      await preferences.setBool(_defaultReminderEnabledKey, enabled);

      notifyListeners();

      LoggerService.info(
        'Default reminder ${enabled ? 'enabled' : 'disabled'}.',
      );
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to update default reminder preference.',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // Test Notification
  // ===========================================================================

  Future<void> sendTestNotification() async {
    if (!_notificationsEnabled) {
      LoggerService.warning(
        'Test notification skipped because notifications are disabled.',
      );
      return;
    }

    try {
      await _notificationService.show(
        id: 1,
        title: 'Notes App',
        body: 'Notifications are working successfully!',
        payload: 'test_notification',
      );

      LoggerService.info('Test notification sent successfully.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to send test notification.',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // Cancel All Notifications
  // ===========================================================================

  Future<void> cancelAllNotifications() async {
    try {
      await _notificationService.cancelAll();

      LoggerService.info('All notifications cancelled.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to cancel notifications.',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // Reset Preferences
  // ===========================================================================

  Future<void> resetPreferences() async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      _notificationsEnabled = true;
      _dailyReminderEnabled = false;
      _defaultReminderEnabled = true;

      await preferences.setBool(
        _notificationsEnabledKey,
        _notificationsEnabled,
      );

      await preferences.setBool(
        _dailyReminderEnabledKey,
        _dailyReminderEnabled,
      );

      await preferences.setBool(
        _defaultReminderEnabledKey,
        _defaultReminderEnabled,
      );

      notifyListeners();

      LoggerService.info('Notification preferences reset successfully.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to reset notification preferences.',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // Dispose
  // ===========================================================================

  @override
  void dispose() {
    LoggerService.info('NotificationProvider disposed.');

    super.dispose();
  }
}
