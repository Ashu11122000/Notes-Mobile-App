/// =============================================================================
/// File: auth_status.dart
/// =============================================================================
///
/// Represents the authentication lifecycle of the application.
///
/// This enum serves as the single source of truth for authentication state
/// across the app. It is intentionally framework-agnostic so it can be used
/// by Providers, Riverpod, Bloc, Cubit, or any future state management
/// solution without introducing additional dependencies.
///
/// Typical lifecycle:
///
/// ```text
/// initial
///     │
///     ▼
/// checking
///     │
///     ├──────────────► authenticated
///     │
///     └──────────────► unauthenticated
/// ```
///
/// Responsibilities:
/// - Drive authentication-aware navigation.
/// - Control loading indicators during session restoration.
/// - Determine whether protected resources may be accessed.
/// - Provide a strongly typed authentication state throughout the app.
enum AuthStatus {
  /// Initial application state before authentication has been evaluated.
  ///
  /// This state typically exists only during application startup.
  initial,

  /// Authentication validation is currently in progress.
  ///
  /// Examples:
  /// - Restoring a persisted session.
  /// - Validating an access token.
  /// - Refreshing user information.
  checking,

  /// A valid authenticated session exists.
  authenticated,

  /// No valid authenticated session exists.
  unauthenticated;

  /// Returns `true` while authentication is being resolved.
  ///
  /// Useful for displaying splash screens or loading indicators.
  bool get isLoading =>
      this == AuthStatus.initial || this == AuthStatus.checking;

  /// Returns `true` when the user has a valid authenticated session.
  bool get isAuthenticated => this == AuthStatus.authenticated;

  /// Returns `true` when no authenticated session exists.
  bool get isUnauthenticated => this == AuthStatus.unauthenticated;

  /// Returns `true` once the authentication process has completed.
  ///
  /// A resolved state is either:
  /// - [authenticated]
  /// - [unauthenticated]
  bool get isResolved =>
      this == AuthStatus.authenticated || this == AuthStatus.unauthenticated;
}
