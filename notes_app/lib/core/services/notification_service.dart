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
/// • Handles notification permissions.
/// • Creates notification channels.
/// • Shows instant notifications.
/// • Schedules reminders.
/// • Cancels notifications.
/// • Contains no UI/business logic.
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

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          );

      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
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

      await requestPermission();

      _initialized = true;

      LoggerService.info('NotificationService initialized successfully.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Notification initialization failed.',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // Permission Handling
  // ===========================================================================

  Future<bool> requestPermission() async {
    try {
      bool granted = true;

      final AndroidFlutterLocalNotificationsPlugin? androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      final bool? androidResult = await androidPlugin
          ?.requestNotificationsPermission();

      if (androidResult != null) {
        granted = granted && androidResult;
      }

      final IOSFlutterLocalNotificationsPlugin? iosPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();

      final bool? iosResult = await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      if (iosResult != null) {
        granted = granted && iosResult;
      }

      return granted;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Notification permission request failed.',
        error: exception,
        stackTrace: stackTrace,
      );

      return false;
    }
  }

  Future<bool> areNotificationsEnabled() async {
    try {
      final AndroidFlutterLocalNotificationsPlugin? androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      return await androidPlugin?.areNotificationsEnabled() ?? true;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed checking notification status.',
        error: exception,
        stackTrace: stackTrace,
      );

      return false;
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

      iOS: DarwinNotificationDetails(),
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

      LoggerService.info(
        'Notification shown successfully. '
        '(id: $id)',
      );
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

      LoggerService.info(
        'Notification scheduled successfully. '
        '(id: $id)',
      );
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to schedule notification.',
        error: exception,
        stackTrace: stackTrace,
      );
    }
  }

  // ===========================================================================
  // Schedule Daily Notification
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

      LoggerService.info(
        'Daily notification scheduled successfully. '
        '(id: $id)',
      );
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
  // Cancel Single Notification
  // ===========================================================================

  Future<void> cancel(int id) async {
    try {
      await _plugin.cancel(id: id);

      LoggerService.info(
        'Notification cancelled successfully. '
        '(id: $id)',
      );
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
