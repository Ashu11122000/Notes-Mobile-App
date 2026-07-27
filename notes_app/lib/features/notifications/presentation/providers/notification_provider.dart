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
/// • Handles notification settings persistence.
/// • Controls notification availability.
/// • Provides notification state to UI.
/// • Sends test notifications.
/// • Coordinates NotificationService.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///     ↓
/// NotificationProvider
///     ↓
/// NotificationService
///
/// Reminder scheduling:
///
/// NotesProvider
///     ↓
/// ReminderManager
///     ↓
/// NotificationService
///
/// ============================================================================

final class NotificationProvider extends ChangeNotifier {
  NotificationProvider({NotificationService? notificationService})
    : _notificationService =
          notificationService ?? NotificationService.instance;

  // ===========================================================================
  // Dependencies
  // ===========================================================================

  final NotificationService _notificationService;

  SharedPreferences? _preferences;

  // ===========================================================================
  // Storage Keys
  // ===========================================================================

  static const String _notificationsEnabledKey = 'notifications_enabled';

  static const String _dailyReminderEnabledKey = 'daily_reminder_enabled';

  static const String _defaultReminderEnabledKey = 'default_reminder_enabled';

  // ===========================================================================
  // Internal State
  // ===========================================================================

  bool _isInitialized = false;

  bool _isLoading = false;

  String? _errorMessage;

  bool _notificationsEnabled = true;

  bool _dailyReminderEnabled = false;

  bool _defaultReminderEnabled = true;

  // ===========================================================================
  // Public Getters
  // ===========================================================================

  bool get isInitialized => _isInitialized;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  bool get hasError => _errorMessage != null;

  bool get notificationsEnabled => _notificationsEnabled;

  bool get dailyReminderEnabled => _dailyReminderEnabled;

  bool get defaultReminderEnabled => _defaultReminderEnabled;

  // ===========================================================================
  // Initialization
  // ===========================================================================

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      _setLoading(true);

      _preferences = await SharedPreferences.getInstance();

      _notificationsEnabled =
          _preferences!.getBool(_notificationsEnabledKey) ?? true;

      _dailyReminderEnabled =
          _preferences!.getBool(_dailyReminderEnabledKey) ?? false;

      _defaultReminderEnabled =
          _preferences!.getBool(_defaultReminderEnabledKey) ?? true;

      _isInitialized = true;

      LoggerService.info('NotificationProvider initialized.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to initialize notifications.',
        error: exception,
        stackTrace: stackTrace,
      );

      _setError(exception.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ===========================================================================
  // Notification Enable / Disable
  // ===========================================================================

  Future<void> setNotificationsEnabled(bool enabled) async {
    try {
      _clearError();

      _notificationsEnabled = enabled;

      await _savePreference(_notificationsEnabledKey, enabled);

      notifyListeners();

      LoggerService.info(
        'Notifications '
        '${enabled ? 'enabled' : 'disabled'}.',
      );
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to update notification setting.',
        error: exception,
        stackTrace: stackTrace,
      );

      _setError(exception.toString());
    }
  }

  // ===========================================================================
  // Daily Reminder Preference
  // ===========================================================================

  Future<void> setDailyReminderEnabled(bool enabled) async {
    try {
      _clearError();

      _dailyReminderEnabled = enabled;

      await _savePreference(_dailyReminderEnabledKey, enabled);

      notifyListeners();

      LoggerService.info(
        'Daily reminders '
        '${enabled ? 'enabled' : 'disabled'}.',
      );
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to update daily reminder setting.',
        error: exception,
        stackTrace: stackTrace,
      );

      _setError(exception.toString());
    }
  }

  // ===========================================================================
  // Default Reminder Preference
  // ===========================================================================

  Future<void> setDefaultReminderEnabled(bool enabled) async {
    try {
      _clearError();

      _defaultReminderEnabled = enabled;

      await _savePreference(_defaultReminderEnabledKey, enabled);

      notifyListeners();

      LoggerService.info(
        'Default reminder '
        '${enabled ? 'enabled' : 'disabled'}.',
      );
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to update default reminder setting.',
        error: exception,
        stackTrace: stackTrace,
      );

      _setError(exception.toString());
    }
  }

  // ===========================================================================
  // Test Notification
  // ===========================================================================

  Future<void> sendTestNotification() async {
    if (!_notificationsEnabled) {
      LoggerService.warning(
        'Test notification skipped. '
        'Notifications are disabled.',
      );

      return;
    }

    try {
      _clearError();

      await _notificationService.show(
        id: 999,
        title: 'Notes App',
        body: 'Notification system is working successfully.',
        payload: 'test_notification',
      );

      LoggerService.info('Test notification sent.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to send test notification.',
        error: exception,
        stackTrace: stackTrace,
      );

      _setError(exception.toString());
    }
  }

  // ===========================================================================
  // Cancel Notifications
  // ===========================================================================

  Future<void> cancelAllNotifications() async {
    try {
      _clearError();

      await _notificationService.cancelAll();

      LoggerService.info('All notifications cancelled.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to cancel notifications.',
        error: exception,
        stackTrace: stackTrace,
      );

      _setError(exception.toString());
    }
  }

  // ===========================================================================
  // Reset Preferences
  // ===========================================================================

  Future<void> resetPreferences() async {
    try {
      _clearError();

      _notificationsEnabled = true;

      _dailyReminderEnabled = false;

      _defaultReminderEnabled = true;

      await _savePreference(_notificationsEnabledKey, _notificationsEnabled);

      await _savePreference(_dailyReminderEnabledKey, _dailyReminderEnabled);

      await _savePreference(
        _defaultReminderEnabledKey,
        _defaultReminderEnabled,
      );

      notifyListeners();

      LoggerService.info('Notification preferences reset.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to reset notification preferences.',
        error: exception,
        stackTrace: stackTrace,
      );

      _setError(exception.toString());
    }
  }

  // ===========================================================================
  // Private Preference Helper
  // ===========================================================================

  Future<void> _savePreference(String key, bool value) async {
    _preferences ??= await SharedPreferences.getInstance();

    await _preferences!.setBool(key, value);
  }

  // ===========================================================================
  // Error Handling
  // ===========================================================================

  /// Clears current error state.
  void clearError() {
    if (_errorMessage == null) {
      return;
    }

    _errorMessage = null;

    notifyListeners();
  }

  /// Internal error setter.
  void _setError(String message) {
    _errorMessage = message;

    notifyListeners();
  }

  /// Internal error reset.
  void _clearError() {
    if (_errorMessage == null) {
      return;
    }

    _errorMessage = null;
  }

  // ===========================================================================
  // Loading Helpers
  // ===========================================================================

  void _setLoading(bool value) {
    if (_isLoading == value) {
      return;
    }

    _isLoading = value;

    notifyListeners();
  }

  // ===========================================================================
  // Permission / Availability Helpers
  // ===========================================================================

  /// Returns whether notifications can be used.
  ///
  /// This keeps permission logic isolated from UI.
  Future<bool> isNotificationAvailable() async {
    try {
      return await _notificationService.areNotificationsEnabled();
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to check notification availability.',
        error: exception,
        stackTrace: stackTrace,
      );

      return false;
    }
  }

  /// Requests notification permission.
  ///
  /// Useful for Android 13+ and iOS.
  Future<bool> requestPermission() async {
    try {
      final bool granted = await _notificationService.requestPermission();

      if (!granted) {
        LoggerService.warning('Notification permission denied.');

        return false;
      }

      LoggerService.info('Notification permission granted.');

      return true;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to request notification permission.',
        error: exception,
        stackTrace: stackTrace,
      );

      return false;
    }
  }

  // ===========================================================================
  // Reset Provider State
  // ===========================================================================

  /// Clears provider state.
  ///
  /// Used after logout or account switching.
  void reset() {
    _isInitialized = false;

    _isLoading = false;

    _errorMessage = null;

    _notificationsEnabled = true;

    _dailyReminderEnabled = false;

    _defaultReminderEnabled = true;

    notifyListeners();

    LoggerService.info('NotificationProvider reset.');
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
