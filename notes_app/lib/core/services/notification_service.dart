import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Centralized local notification service.
///
/// Responsibilities:
/// - Initialize flutter_local_notifications
/// - Show instant notifications
/// - Schedule notifications (future)
/// - Cancel notifications (future)
///
/// This service should be the only place interacting with the
/// flutter_local_notifications package.
final class NotificationService {
  NotificationService._();

  static final NotificationService _instance = NotificationService._();

  /// Shared singleton instance.
  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// Initializes the notification plugin.
  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(settings: initializationSettings);
  }

  /// Displays an instant local notification.
  Future<void> show({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'notes_channel',
      'Notes Notifications',
      channelDescription: 'General notifications for the Notes application.',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }

  /// Cancels a notification by its ID.
  Future<void> cancel(int id) {
    return _notifications.cancel(id: id);
  }

  /// Cancels all notifications.
  Future<void> cancelAll() {
    return _notifications.cancelAll();
  }
}
