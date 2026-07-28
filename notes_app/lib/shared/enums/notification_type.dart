/// =============================================================================
/// File: notification_type.dart
/// =============================================================================
///
/// Defines the categories of notifications supported by the application.
///
/// This enum belongs to the domain layer and intentionally remains independent
/// of platform-specific notification frameworks.
///
/// The infrastructure layer is responsible for translating these values into:
/// - Android notification channels
/// - iOS notification categories
/// - Notification priority
/// - Sounds
/// - Icons
/// - Scheduling behavior
///
/// This separation preserves Clean Architecture boundaries and keeps the
/// domain model portable and testable.
enum NotificationType {
  /// General-purpose application notification.
  general(value: 'general', displayName: 'General'),

  /// Reminder notification.
  reminder(value: 'reminder', displayName: 'Reminder'),

  /// Informational notification.
  info(value: 'info', displayName: 'Information');

  /// Creates a notification type.
  const NotificationType({required this.value, required this.displayName});

  /// Stable value used for persistence and serialization.
  final String value;

  /// Human-readable label displayed in the user interface.
  ///
  /// Note: When localization is introduced, UI should provide localized
  /// strings while this enum continues to expose stable identifiers.
  final String displayName;

  /// Returns whether this is a general-purpose notification.
  bool get isGeneral => this == NotificationType.general;

  /// Returns whether this is a reminder notification.
  bool get isReminder => this == NotificationType.reminder;

  /// Returns whether this is an informational notification.
  bool get isInfo => this == NotificationType.info;

  /// Converts a persisted value into a [NotificationType].
  ///
  /// Returns [NotificationType.general] for `null`, empty, or unsupported
  /// values.
  static NotificationType fromValue(String? value) {
    final normalized = value?.trim().toLowerCase();

    if (normalized == null || normalized.isEmpty) {
      return NotificationType.general;
    }

    return values.firstWhere(
      (type) => type.value == normalized,
      orElse: () => NotificationType.general,
    );
  }

  /// Returns whether the supplied value represents a supported
  /// notification type.
  static bool isSupported(String? value) {
    final normalized = value?.trim().toLowerCase();

    if (normalized == null || normalized.isEmpty) {
      return false;
    }

    return values.any((type) => type.value == normalized);
  }

  /// Returns the display name for a persisted notification type.
  static String displayNameOf(String? value) => fromValue(value).displayName;

  /// All supported persisted values.
  static List<String> get supportedValues =>
      values.map((type) => type.value).toList(growable: false);
}
