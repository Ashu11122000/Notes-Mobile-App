/// Represents the different categories of notifications supported by the
/// application.
///
/// This enum is shared across the application and is primarily used by
/// NotificationService to determine the purpose of a notification.
///
/// The enum is intentionally independent of any notification package.
/// Mapping to platform-specific implementations should be handled inside
/// the service layer.
enum NotificationType {
  /// General application notification.
  general(value: 'general', displayName: 'General'),

  /// Reminder notification for notes.
  reminder(value: 'reminder', displayName: 'Reminder'),

  /// Informational notification.
  info(value: 'info', displayName: 'Information');

  /// Creates a notification type.
  const NotificationType({required this.value, required this.displayName});

  /// Value used for serialization or persistence.
  final String value;

  /// Human-readable name displayed in the UI.
  final String displayName;

  /// Returns a [NotificationType] from its stored value.
  ///
  /// Defaults to [NotificationType.general] if the value is null or invalid.
  static NotificationType fromValue(String? value) {
    return NotificationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => NotificationType.general,
    );
  }
}
