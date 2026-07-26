import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'logger_service.dart';
import 'timezone_service.dart';

/// ============================================================================
/// File: notification_service.dart
/// ============================================================================
///
/// Local Notification Service
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Initializes flutter_local_notifications.
/// • Requests notification permissions.
/// • Creates Android notification channel.
/// • Shows instant notifications.
/// • Schedules one-time notifications.
/// • Schedules recurring notifications.
/// • Cancels notifications.
/// • Returns pending notifications.
/// • Contains no UI/business logic.
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

  bool get isInitialized => _initialized;

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

      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
      );

      await _plugin.initialize(
        settings: settings,
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
  // Show Notification Immediately
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

      LoggerService.info('Notification shown successfully. (id: $id)');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to show notification.',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // Schedule One-Time Notification
  // ===========================================================================

  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    String? payload,
  }) async {
    try {
      final tz.TZDateTime scheduledDate = TimezoneService.instance.toTZDateTime(
        scheduledAt,
      );

      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: _notificationDetails,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      LoggerService.info('Notification scheduled successfully. (id: $id)');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to schedule notification.',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // Schedule Daily Notification (Stretch Goal)
  // ===========================================================================

  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    String? payload,
  }) async {
    try {
      final tz.TZDateTime scheduledDate = TimezoneService.instance.toTZDateTime(
        scheduledAt,
      );

      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: _notificationDetails,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      LoggerService.info('Daily notification scheduled. (id: $id)');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to schedule daily notification.',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // Pending Notifications
  // ===========================================================================

  Future<List<PendingNotificationRequest>> pendingNotificationRequests() async {
    try {
      return await _plugin.pendingNotificationRequests();
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to fetch pending notifications.',
        error: exception,
        stackTrace: stackTrace,
      );

      return <PendingNotificationRequest>[];
    }
  }

  // ===========================================================================
  // Cancel Notification
  // ===========================================================================

  Future<void> cancel(int id) async {
    try {
      await _plugin.cancel(id: id);

      LoggerService.info('Notification cancelled successfully. (id: $id)');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to cancel notification.',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // Cancel All Pending Notifications
  // ===========================================================================

  Future<void> cancelAllPending() async {
    try {
      await _plugin.cancelAllPendingNotifications();

      LoggerService.info('All pending notifications cancelled.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to cancel pending notifications.',
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
  // Active Notifications
  // ===========================================================================

  Future<List<ActiveNotification>> getActiveNotifications() async {
    try {
      return await _plugin.getActiveNotifications();
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to retrieve active notifications.',
        error: exception,
        stackTrace: stackTrace,
      );

      return <ActiveNotification>[];
    }
  }

  // ===========================================================================
  // Dispose
  // ===========================================================================

  void dispose() {
    _initialized = false;

    LoggerService.info('NotificationService disposed.');
  }
}
