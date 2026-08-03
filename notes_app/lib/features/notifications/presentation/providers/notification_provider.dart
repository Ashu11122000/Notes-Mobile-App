import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/logger_service.dart';
import '../../../../core/services/notification_service.dart';

/// ============================================================================
/// File: notification_provider.dart
/// ============================================================================
///
/// Enterprise Notification Provider
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Manages notification preferences.
/// • Persists settings locally.
/// • Coordinates NotificationService.
/// • Exposes notification state to UI.
/// • Optimized for minimal rebuilds.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///      ↓
/// NotificationProvider
///      ↓
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
  // Preference Keys
  // ===========================================================================

  static const String _notificationsEnabledKey = 'notifications_enabled';

  static const String _dailyReminderEnabledKey = 'daily_reminder_enabled';

  static const String _defaultReminderEnabledKey = 'default_reminder_enabled';

  static const int _testNotificationId = 999;

  // ===========================================================================
  // State
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

  bool get notificationsEnabled => _notificationsEnabled;

  bool get dailyReminderEnabled => _dailyReminderEnabled;

  bool get defaultReminderEnabled => _defaultReminderEnabled;

  String? get errorMessage => _errorMessage;

  bool get hasError => _errorMessage != null;

  // ===========================================================================
  // Initialization
  // ===========================================================================

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      _setLoading(true);

      await _ensurePreferences();

      final SharedPreferences preferences = _preferences!;

      _notificationsEnabled =
          preferences.getBool(_notificationsEnabledKey) ?? true;

      _dailyReminderEnabled =
          preferences.getBool(_dailyReminderEnabledKey) ?? false;

      _defaultReminderEnabled =
          preferences.getBool(_defaultReminderEnabledKey) ?? true;

      _isInitialized = true;

      LoggerService.info('NotificationProvider initialized.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to initialize NotificationProvider.',
        error: exception,
        stackTrace: stackTrace,
      );

      _setError(exception.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ===========================================================================
  // SharedPreferences
  // ===========================================================================

  Future<void> _ensurePreferences() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  Future<void> _savePreference(String key, bool value) async {
    await _ensurePreferences();

    await _preferences!.setBool(key, value);
  }

  // ===========================================================================
  // Internal State Helpers
  // ===========================================================================

  bool _updateBool({
    required bool currentValue,
    required bool newValue,
    required ValueSetter<bool> setter,
  }) {
    if (currentValue == newValue) {
      return false;
    }

    setter(newValue);

    return true;
  }

  void _setLoading(bool value) {
    if (_isLoading == value) {
      return;
    }

    _isLoading = value;

    notifyListeners();
  }

  void _setError(String message) {
    if (_errorMessage == message) {
      return;
    }

    _errorMessage = message;

    notifyListeners();
  }

  void _clearError() {
    if (_errorMessage == null) {
      return;
    }

    _errorMessage = null;
  }

  /// Public API for clearing the current error.
  void clearError() {
    if (_errorMessage == null) {
      return;
    }

    _errorMessage = null;

    notifyListeners();
  }

  // ===========================================================================
  // Notification Preferences
  // ===========================================================================

  Future<void> setNotificationsEnabled(bool enabled) async {
    if (!_updateBool(
      currentValue: _notificationsEnabled,
      newValue: enabled,
      setter: (bool value) => _notificationsEnabled = value,
    )) {
      return;
    }

    try {
      _clearError();

      await _savePreference(_notificationsEnabledKey, enabled);

      notifyListeners();

      LoggerService.info('Notifications ${enabled ? 'enabled' : 'disabled'}.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to update notification preference.',
        error: exception,
        stackTrace: stackTrace,
      );

      _notificationsEnabled = !enabled;

      _setError(exception.toString());
    }
  }

  // ===========================================================================
  // Daily Reminder
  // ===========================================================================

  Future<void> setDailyReminderEnabled(bool enabled) async {
    if (!_updateBool(
      currentValue: _dailyReminderEnabled,
      newValue: enabled,
      setter: (bool value) => _dailyReminderEnabled = value,
    )) {
      return;
    }

    try {
      _clearError();

      await _savePreference(_dailyReminderEnabledKey, enabled);

      notifyListeners();

      LoggerService.info('Daily reminder ${enabled ? 'enabled' : 'disabled'}.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to update daily reminder preference.',
        error: exception,
        stackTrace: stackTrace,
      );

      _dailyReminderEnabled = !enabled;

      _setError(exception.toString());
    }
  }

  // ===========================================================================
  // Default Reminder
  // ===========================================================================

  Future<void> setDefaultReminderEnabled(bool enabled) async {
    if (!_updateBool(
      currentValue: _defaultReminderEnabled,
      newValue: enabled,
      setter: (bool value) => _defaultReminderEnabled = value,
    )) {
      return;
    }

    try {
      _clearError();

      await _savePreference(_defaultReminderEnabledKey, enabled);

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

      _defaultReminderEnabled = !enabled;

      _setError(exception.toString());
    }
  }

  // ===========================================================================
  // Test Notification
  // ===========================================================================

  Future<void> sendTestNotification() async {
    if (!_notificationsEnabled) {
      LoggerService.warning(
        'Skipped test notification because notifications are disabled.',
      );

      return;
    }

    try {
      _clearError();

      await _notificationService.show(
        id: _testNotificationId,
        title: 'Notes App',
        body: 'Notification system is working successfully.',
        payload: 'test_notification',
      );

      LoggerService.info('Test notification sent successfully.');
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
  // Notification Availability
  // ===========================================================================

  /// Returns whether notifications are available on this device.
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

  // ===========================================================================
  // Permission
  // ===========================================================================

  /// Requests notification permission.
  ///
  /// Required on:
  /// • Android 13+
  /// • iOS
  Future<bool> requestPermission() async {
    try {
      _clearError();

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

      _setError(exception.toString());

      return false;
    }
  }

  // ===========================================================================
  // Refresh
  // ===========================================================================

  /// Reloads notification preferences from SharedPreferences.
  Future<void> refresh() async {
    _isInitialized = false;

    await initialize();
  }

  // ===========================================================================
  // Reset Provider
  // ===========================================================================

  /// Clears all in-memory state.
  ///
  /// Used during:
  /// • Logout
  /// • User switching
  /// • Session reset
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
    _preferences = null;

    LoggerService.info('NotificationProvider disposed.');

    super.dispose();
  }
}
