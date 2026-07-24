/// Represents the semantic type of an application snackbar.
///
/// This enum is shared across the application and is used by
/// [CustomSnackBar] to determine the appropriate visual style,
/// including colors, icons, and behavior.
///
/// The enum intentionally contains no UI-specific logic.
/// Presentation concerns are handled by the snackbar widget.
enum SnackbarType {
  /// Indicates a successful operation.
  ///
  /// Examples:
  /// - Login successful
  /// - Registration completed
  /// - Note saved
  success,

  /// Indicates an informational message.
  ///
  /// Examples:
  /// - Session restored
  /// - App update available
  info,

  /// Indicates a warning that does not prevent the user
  /// from continuing.
  ///
  /// Examples:
  /// - Weak internet connection
  /// - Unsaved changes
  warning,

  /// Indicates an operation failed.
  ///
  /// Examples:
  /// - Invalid credentials
  /// - Network error
  /// - Server error
  error,
}
