/// =============================================================================
/// File: request_status.dart
/// =============================================================================
///
/// Represents the lifecycle of an asynchronous operation.
///
/// This enum provides a framework-agnostic way to expose the current state of
/// API calls and other asynchronous tasks throughout the application.
///
/// It is intentionally lightweight and contains **only request state**.
/// Any associated data (response models, exceptions, validation messages,
/// etc.) should live in the surrounding state object rather than in this enum.
///
/// Typical use cases include:
///
/// - User authentication
/// - Registration
/// - Fetching the current user
/// - Loading notes
/// - Creating notes
/// - Updating notes
/// - Deleting notes
/// - Uploading images
/// - Scheduling notifications
///
/// Typical lifecycle:
///
/// ```text
/// initial
///    │
///    ▼
/// loading
///    │
///    ├────────────► success
///    │
///    └────────────► failure
/// ```
///
/// This enum should **not** be confused with [AuthStatus], which represents
/// the application's authentication lifecycle rather than the state of an
/// individual asynchronous request.
enum RequestStatus {
  /// No asynchronous operation has started.
  ///
  /// This is typically the default state when a screen or provider
  /// is first created.
  initial,

  /// An asynchronous operation is currently executing.
  ///
  /// Examples:
  /// - Network request
  /// - Database operation
  /// - Image upload
  /// - Authentication
  loading,

  /// The asynchronous operation completed successfully.
  success,

  /// The asynchronous operation completed with an error.
  failure;

  /// Returns `true` when no request has been initiated.
  bool get isInitial => this == RequestStatus.initial;

  /// Returns `true` while an asynchronous operation is executing.
  bool get isLoading => this == RequestStatus.loading;

  /// Returns `true` when the operation completed successfully.
  bool get isSuccess => this == RequestStatus.success;

  /// Returns `true` when the operation failed.
  bool get isFailure => this == RequestStatus.failure;

  /// Returns `true` once the request has completed.
  ///
  /// A completed request is either:
  /// - [success]
  /// - [failure]
  bool get isCompleted =>
      this == RequestStatus.success || this == RequestStatus.failure;

  /// Returns `true` if another request can safely be started.
  ///
  /// This is useful for preventing duplicate submissions from buttons,
  /// pull-to-refresh actions, or other user interactions.
  bool get canStartRequest => this != RequestStatus.loading;
}
