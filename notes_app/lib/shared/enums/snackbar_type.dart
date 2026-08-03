/// =============================================================================
/// File: snackbar_type.dart
/// =============================================================================
///
/// Defines the semantic categories of snackbars displayed throughout the
/// application.
///
/// This enum represents **what** happened rather than **how** it should be
/// presented.
///
/// The presentation layer is responsible for mapping these semantic values to
/// visual properties such as:
///
/// - Colors
/// - Icons
/// - Elevation
/// - Animations
/// - Border styles
/// - Display duration
/// - Haptic feedback
///
/// Keeping this enum independent of Flutter widgets preserves Clean
/// Architecture boundaries and allows the application's visual design to evolve
/// without affecting business logic.
enum SnackbarType {
  /// Indicates that an operation completed successfully.
  success,

  /// Indicates an informational message.
  info,

  /// Indicates a non-blocking warning.
  warning,

  /// Indicates that an operation failed.
  error;

  /// Stable string representation.
  ///
  /// Useful for logging, analytics, debugging, and telemetry.
  String get value => name;

  /// Returns `true` if this snackbar represents a successful operation.
  bool get isSuccess => this == SnackbarType.success;

  /// Returns `true` if this snackbar provides informational feedback.
  bool get isInfo => this == SnackbarType.info;

  /// Returns `true` if this snackbar represents a warning.
  bool get isWarning => this == SnackbarType.warning;

  /// Returns `true` if this snackbar represents an error.
  bool get isError => this == SnackbarType.error;

  /// Returns whether the snackbar represents a warning or error.
  bool get isNegative =>
      this == SnackbarType.warning || this == SnackbarType.error;

  /// Returns whether the snackbar represents a success or informational message.
  bool get isNonNegative =>
      this == SnackbarType.success || this == SnackbarType.info;

  /// Converts a persisted string into a [SnackbarType].
  ///
  /// Returns [SnackbarType.info] for `null`, empty, or unsupported values.
  static SnackbarType fromValue(String? value) {
    final normalized = value?.trim().toLowerCase();

    if (normalized == null || normalized.isEmpty) {
      return SnackbarType.info;
    }

    return values.firstWhere(
      (type) => type.name == normalized,
      orElse: () => SnackbarType.info,
    );
  }
}
