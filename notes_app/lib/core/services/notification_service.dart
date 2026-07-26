import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'logger_service.dart';

/// ============================================================================
/// File: notification_service.dart
/// ============================================================================
///
/// Local Notification Service
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Initializes flutter_local_notifications.
/// - Requests notification permissions.
/// - Creates Android notification channel.
/// - Shows instant notifications.
/// - Cancels notifications.
/// - Cancels all notifications.
/// - Handles notification taps.
/// - Logs notification operations.
/// - Contains no UI/business logic.
///
/// ============================================================================

final class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'notes_channel',
    'Notes Notifications',
    description: 'Notifications for note reminders.',
    importance: Importance.high,
  );

  bool _initialized = false;

  // ===========================================================================
  // Initialize
  // ===========================================================================

  Future<void> initialize({
    void Function(NotificationResponse response)? onNotificationTap,
  }) async {
    if (_initialized) {
      return;
    }

    try {
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
          InitializationSettings(android: androidSettings);

      await _plugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
      );

      final AndroidFlutterLocalNotificationsPlugin? androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      await androidPlugin?.createNotificationChannel(_channel);

      await androidPlugin?.requestNotificationsPermission();

      _initialized = true;

      LoggerService.info('NotificationService initialized successfully.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to initialize NotificationService.',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // Notification Details
  // ===========================================================================

  NotificationDetails get _notificationDetails {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'notes_channel',
        'Notes Notifications',
        channelDescription: 'Notifications for note reminders.',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
  }

  // ===========================================================================
  // Show Notification
  // ===========================================================================

  Future<void> show({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: _notificationDetails,
        payload: payload,
      );

      LoggerService.info('Notification shown: $title');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to show notification.',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // Cancel Notification
  // ===========================================================================

  Future<void> cancel(int id) async {
    try {
      await _plugin.cancel(id: id);

      LoggerService.info('Notification cancelled: $id');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to cancel notification.',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // Cancel All Notifications
  // ===========================================================================

  Future<void> cancelAll() async {
    try {
      await _plugin.cancelAll();

      LoggerService.info('All notifications cancelled.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to cancel all notifications.',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // Dispose
  // ===========================================================================

  void dispose() {
    _initialized = false;
  }
}
