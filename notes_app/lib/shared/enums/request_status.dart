/// =============================================================================
/// File: request_status.dart
/// =============================================================================
///
/// Represents the lifecycle of an asynchronous operation.
///
/// This enum provides a framework-agnostic way to expose the current state of
/// API calls and other asynchronous tasks throughout the application.
///
/// It intentionally models only the request state. Any associated data
/// (response models, exceptions, validation messages, etc.) should live in the
/// surrounding state object.
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
enum RequestStatus {
  /// No asynchronous operation has started.
  initial,

  /// An asynchronous operation is currently executing.
  loading,

  /// The asynchronous operation completed successfully.
  success,

  /// The asynchronous operation completed with an error.
  failure;

  /// Stable string representation.
  ///
  /// Useful for logging, debugging and analytics.
  String get value => name;

  /// Returns `true` when no request has been initiated.
  bool get isInitial => this == RequestStatus.initial;

  /// Returns `true` while an asynchronous operation is executing.
  bool get isLoading => this == RequestStatus.loading;

  /// Returns `true` when the operation completed successfully.
  bool get isSuccess => this == RequestStatus.success;

  /// Returns `true` when the operation completed with an error.
  bool get isFailure => this == RequestStatus.failure;

  /// Returns `true` once the request has completed.
  bool get isCompleted =>
      this == RequestStatus.success || this == RequestStatus.failure;

  /// Returns `true` if another request can safely be started.
  bool get canStartRequest => this != RequestStatus.loading;

  /// Converts a persisted string into a [RequestStatus].
  ///
  /// Returns [RequestStatus.initial] for `null`, empty, or unsupported values.
  static RequestStatus fromValue(String? value) {
    final normalized = value?.trim().toLowerCase();

    if (normalized == null || normalized.isEmpty) {
      return RequestStatus.initial;
    }

    return values.firstWhere(
      (status) => status.name == normalized,
      orElse: () => RequestStatus.initial,
    );
  }
}
