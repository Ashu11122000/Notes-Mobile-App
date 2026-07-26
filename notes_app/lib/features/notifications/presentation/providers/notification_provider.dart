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
/// - Manages notification settings.
/// - Persists notification preferences.
/// - Enables/disables notifications.
/// - Triggers test notifications.
/// - Notifies listeners of state changes.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///     ↓
/// NotificationProvider
///     ↓
/// NotificationService
///
/// ============================================================================

final class NotificationProvider extends ChangeNotifier {
  NotificationProvider({NotificationService? notificationService})
    : _notificationService =
          notificationService ?? NotificationService.instance;

  static const String _notificationsEnabledKey = 'notifications_enabled';

  final NotificationService _notificationService;

  bool _enabled = true;

  bool _initialized = false;

  // ===========================================================================
  // Getters
  // ===========================================================================

  bool get enabled => _enabled;

  bool get initialized => _initialized;

  // ===========================================================================
  // Initialize
  // ===========================================================================

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    final SharedPreferences preferences = await SharedPreferences.getInstance();

    _enabled = preferences.getBool(_notificationsEnabledKey) ?? true;

    _initialized = true;

    notifyListeners();

    LoggerService.info('NotificationProvider initialized.');
  }

  // ===========================================================================
  // Enable / Disable
  // ===========================================================================

  Future<void> setEnabled(bool value) async {
    _enabled = value;

    notifyListeners();

    final SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.setBool(_notificationsEnabledKey, value);

    LoggerService.info('Notifications ${value ? 'enabled' : 'disabled'}.');
  }

  // ===========================================================================
  // Test Notification
  // ===========================================================================

  Future<void> sendTestNotification() async {
    if (!_enabled) {
      return;
    }

    await _notificationService.show(
      id: 1,
      title: 'Notes App',
      body: 'Notifications are working successfully!',
      payload: 'test_notification',
    );
  }

  // ===========================================================================
  // Cancel All
  // ===========================================================================

  Future<void> cancelAllNotifications() async {
    await _notificationService.cancelAll();
  }
}
