import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'logger_service.dart';
import 'timezone_service.dart';

/// ============================================================================
/// File: notification_service.dart
/// ============================================================================
///
/// Enterprise Local Notification Service
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Initializes flutter_local_notifications.
/// • Handles notification permissions.
/// • Creates notification channels.
/// • Shows instant notifications.
/// • Schedules reminders.
/// • Cancels notifications.
/// • Exposes a testable singleton.
/// • Contains no UI/business logic.
///
/// ============================================================================
final class NotificationService {
  NotificationService._({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  // ===========================================================================
  // Singleton
  // ===========================================================================

  static NotificationService _instance = NotificationService._();

  /// Production singleton.
  static NotificationService get instance => _instance;

  /// Replaces the singleton during tests.
  ///
  /// Example:
  /// ```dart
  /// NotificationService.setInstanceForTesting(mockService);
  /// ```
  @visibleForTesting
  static void setInstanceForTesting(NotificationService service) {
    _instance = service;
  }

  /// Restores the default production singleton.
  @visibleForTesting
  static void resetForTesting() {
    _instance = NotificationService._();
  }

  // ===========================================================================
  // Fields
  // ===========================================================================

  final FlutterLocalNotificationsPlugin _plugin;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'notes_channel',
    'Notes Notifications',
    description: 'Notifications for note reminders.',
    importance: Importance.high,
  );

  bool _initialized = false;

  /// Returns whether this service has already been initialized.
  bool get isInitialized => _initialized;

  // ===========================================================================
  // Initialization
  // ===========================================================================

  /// Initializes flutter_local_notifications.
  ///
  /// Safe to call multiple times.
  Future<void> initialize({
    void Function(NotificationResponse response)? onNotificationTap,
  }) async {
    if (_initialized) {
      LoggerService.info('NotificationService already initialized.');
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

  /// Requests notification permissions on all supported platforms.
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
        granted &= androidResult;
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
        granted &= iosResult;
      }

      LoggerService.info('Notification permission granted: $granted');

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

  /// Returns whether notifications are enabled on the device.
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

  /// Default notification configuration used throughout the application.
  @protected
  NotificationDetails get notificationDetails {
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

  /// Displays an immediate local notification.
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
        notificationDetails: notificationDetails,
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

  /// Schedules a notification for a specific date and time.
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
        notificationDetails: notificationDetails,
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
  // Schedule Daily Notification
  // ===========================================================================

  /// Schedules a notification that repeats every day.
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
        notificationDetails: notificationDetails,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      LoggerService.info(
        'Daily notification scheduled successfully. (id: $id)',
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

  /// Returns all pending scheduled notifications.
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

  /// Cancels a scheduled notification.
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

  /// Cancels every pending scheduled notification.
  Future<void> cancelAllPending() async {
    try {
      final pending = await _plugin.pendingNotificationRequests();

      for (final notification in pending) {
        await _plugin.cancel(id: notification.id);
      }

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

  /// Cancels all notifications.
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

  /// Returns currently active notifications.
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

  /// Releases in-memory state.
  ///
  /// This does not cancel notifications. Use [cancelAll] when notifications
  /// should also be removed.
  void dispose() {
    _initialized = false;

    LoggerService.info('NotificationService disposed.');
  }
}
