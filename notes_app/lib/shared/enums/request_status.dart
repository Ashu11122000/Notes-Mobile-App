/// Represents the lifecycle of an asynchronous request.
///
/// This enum is shared across the application and is primarily used by
/// Providers to expose the current state of API operations such as:
///
/// - Login
/// - Register
/// - Fetch Current User
/// - Create Note
/// - Update Note
/// - Delete Note
///
/// It intentionally represents the state of a request only and should not
/// be confused with the user's authentication state. Authentication is
/// represented by [AuthStatus].
enum RequestStatus {
  /// No request has started yet.
  initial,

  /// A request is currently in progress.
  loading,

  /// The request completed successfully.
  success,

  /// The request failed.
  failure,
}
