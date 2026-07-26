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
///
/// Typical mapping:
///
/// ```text
/// success  → Green + Check icon
/// info     → Blue + Info icon
/// warning  → Amber + Warning icon
/// error    → Red + Error icon
/// ```
///
/// This enum should remain lightweight and framework-agnostic.
enum SnackbarType {
  /// Indicates that an operation completed successfully.
  ///
  /// Examples:
  /// - User logged in successfully.
  /// - Registration completed.
  /// - Note created.
  /// - Note updated.
  /// - Note deleted.
  success,

  /// Indicates an informational message.
  ///
  /// Examples:
  /// - Session restored.
  /// - Synchronization completed.
  /// - New application version available.
  info,

  /// Indicates a non-blocking warning.
  ///
  /// The user may continue using the application, but some attention may be
  /// required.
  ///
  /// Examples:
  /// - Weak internet connection.
  /// - Unsaved changes.
  /// - Storage almost full.
  warning,

  /// Indicates that an operation failed.
  ///
  /// Examples:
  /// - Invalid credentials.
  /// - Network request failed.
  /// - Server error.
  /// - Validation failed.
  error;

  /// Returns `true` if this snackbar represents a successful operation.
  bool get isSuccess => this == SnackbarType.success;

  /// Returns `true` if this snackbar provides informational feedback.
  bool get isInfo => this == SnackbarType.info;

  /// Returns `true` if this snackbar represents a warning.
  bool get isWarning => this == SnackbarType.warning;

  /// Returns `true` if this snackbar represents an error.
  bool get isError => this == SnackbarType.error;

  /// Returns whether the snackbar represents a negative outcome.
  ///
  /// Useful when applying shared styling or analytics to warning and error
  /// notifications.
  bool get isNegative =>
      this == SnackbarType.warning || this == SnackbarType.error;

  /// Returns whether the snackbar represents a positive or neutral outcome.
  ///
  /// Useful for applying shared styling to success and informational messages.
  bool get isPositive =>
      this == SnackbarType.success || this == SnackbarType.info;
}
