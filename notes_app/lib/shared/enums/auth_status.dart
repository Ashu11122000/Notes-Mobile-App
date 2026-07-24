/// Represents the current authentication state of the application.
///
/// This enum is shared across the application and is primarily used by
/// [AuthProvider] to determine the user's authentication lifecycle.
///
/// States:
/// - [initial] : Authentication has not been evaluated yet.
/// - [checking]: The app is validating an existing session or token.
/// - [authenticated]: The user is successfully authenticated.
/// - [unauthenticated]: No valid session exists.
enum AuthStatus {
  /// Initial state before authentication is evaluated.
  initial,

  /// Authentication/session validation is currently in progress.
  checking,

  /// User is successfully authenticated.
  authenticated,

  /// User is not authenticated.
  unauthenticated,
}
