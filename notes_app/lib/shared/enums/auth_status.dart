/// =============================================================================
/// File: auth_status.dart
/// =============================================================================
///
/// Represents the authentication lifecycle of the application.
///
/// This enum is the single source of truth for authentication state across
/// the app. It is intentionally framework-agnostic so it can be used with
/// Riverpod, Bloc, Cubit, Provider, or any future state management solution.
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
/// - Determine access to protected resources.
/// - Provide a strongly typed authentication state throughout the app.
enum AuthStatus {
  /// Initial application state before authentication has been evaluated.
  initial,

  /// Authentication validation is currently in progress.
  checking,

  /// A valid authenticated session exists.
  authenticated,

  /// No valid authenticated session exists.
  unauthenticated;

  /// Stable string representation.
  ///
  /// Useful for logging, debugging, analytics, and serialization.
  String get value => name;

  /// Returns `true` while authentication is being resolved.
  bool get isLoading =>
      this == AuthStatus.initial || this == AuthStatus.checking;

  /// Returns `true` when authentication validation is in progress.
  bool get isChecking => this == AuthStatus.checking;

  /// Returns `true` when the user has a valid authenticated session.
  bool get isAuthenticated => this == AuthStatus.authenticated;

  /// Returns `true` when no authenticated session exists.
  bool get isUnauthenticated => this == AuthStatus.unauthenticated;

  /// Returns `true` once authentication has completed.
  ///
  /// A resolved state is either:
  /// - [authenticated]
  /// - [unauthenticated]
  bool get isResolved =>
      this == AuthStatus.authenticated || this == AuthStatus.unauthenticated;

  /// Indicates whether protected application routes may be accessed.
  bool get canAccessProtectedRoutes => isAuthenticated;

  /// Converts a persisted string into an [AuthStatus].
  ///
  /// Returns [initial] for `null`, empty, or unsupported values.
  static AuthStatus fromValue(String? value) {
    final normalized = value?.trim().toLowerCase();

    if (normalized == null || normalized.isEmpty) {
      return AuthStatus.initial;
    }

    return values.firstWhere(
      (status) => status.name == normalized,
      orElse: () => AuthStatus.initial,
    );
  }
}
