/// =============================================================================
/// File: notification_type.dart
/// =============================================================================
///
/// Defines the categories of notifications supported by the application.
///
/// This enum belongs to the domain layer and intentionally remains independent
/// of platform-specific notification frameworks such as
/// `flutter_local_notifications`.
///
/// The infrastructure or service layer is responsible for translating these
/// business notification types into platform-specific implementations,
/// including:
///
/// - Android notification channels
/// - iOS notification categories
/// - Notification priority
/// - Sounds
/// - Icons
/// - Scheduling behavior
///
/// Keeping this enum framework-agnostic preserves Clean Architecture
/// boundaries and improves maintainability, portability, and testability.
///
/// Example:
///
/// ```dart
/// final type = NotificationType.reminder;
///
/// switch (type) {
///   case NotificationType.general:
///     break;
///
///   case NotificationType.reminder:
///     break;
///
///   case NotificationType.info:
///     break;
/// }
/// ```
enum NotificationType {
  /// General-purpose application notification.
  ///
  /// Suitable for messages that do not belong to a more specific category.
  general(value: 'general', displayName: 'General'),

  /// Reminder notification.
  ///
  /// Typically used for scheduled note reminders or user-created reminders.
  reminder(value: 'reminder', displayName: 'Reminder'),

  /// Informational notification.
  ///
  /// Used for informational messages such as completed operations,
  /// application updates, or non-critical events.
  info(value: 'info', displayName: 'Information');

  /// Creates a notification type.
  const NotificationType({required this.value, required this.displayName});

  /// Persisted value used for serialization.
  ///
  /// Examples:
  /// - `general`
  /// - `reminder`
  /// - `info`
  final String value;

  /// Human-readable label displayed in the user interface.
  final String displayName;

  /// Returns whether this is a general-purpose notification.
  bool get isGeneral => this == NotificationType.general;

  /// Returns whether this notification represents a reminder.
  bool get isReminder => this == NotificationType.reminder;

  /// Returns whether this notification is informational.
  bool get isInfo => this == NotificationType.info;

  /// Converts a persisted value into a [NotificationType].
  ///
  /// If the supplied value is:
  /// - `null`
  /// - empty
  /// - unsupported
  ///
  /// the default value ([NotificationType.general]) is returned.
  static NotificationType fromValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return NotificationType.general;
    }

    final normalizedValue = value.trim().toLowerCase();

    return NotificationType.values.firstWhere(
      (type) => type.value == normalizedValue,
      orElse: () => NotificationType.general,
    );
  }

  /// Returns whether the supplied value represents a supported
  /// notification type.
  static bool isSupported(String? value) {
    if (value == null || value.trim().isEmpty) {
      return false;
    }

    final normalizedValue = value.trim().toLowerCase();

    return NotificationType.values.any((type) => type.value == normalizedValue);
  }

  /// List of all supported persisted values.
  ///
  /// Useful for:
  /// - validation
  /// - serialization
  /// - analytics
  /// - testing
  static const List<String> supportedValues = ['general', 'reminder', 'info'];
}
