/// =============================================================================
/// File: typedefs.dart
/// =============================================================================
///
/// Shared type aliases used throughout the application.
///
/// These aliases improve readability and provide a consistent vocabulary across
/// the codebase while remaining lightweight and framework-independent.
///
/// They intentionally avoid introducing additional abstraction or runtime
/// overhead and should only be added when they improve clarity.
///
/// This file belongs to the shared foundation layer and may be reused by:
///
/// - Core
/// - Data
/// - Domain
/// - Presentation
/// - Services
/// - Repositories
/// - Utilities
/// =============================================================================

/// Represents an asynchronous operation that produces a value.
///
/// This alias improves readability for repository, service, and use-case
/// methods returning a single asynchronous result.
///
/// Example:
///
/// ```dart
/// AsyncValue<UserModel> getCurrentUser();
/// ```
typedef AsyncValue<T> = Future<T>;

/// Represents an asynchronous operation that completes without returning a
/// value.
///
/// Useful for operations whose completion is significant but whose result is
/// not, such as:
///
/// - Logout
/// - Delete
/// - Cache clearing
/// - Synchronization
///
/// Example:
///
/// ```dart
/// AsyncVoid logout();
/// ```
typedef AsyncVoid = Future<void>;

/// Represents a JSON object.
///
/// Centralizing this alias avoids repeatedly writing
/// `Map<String, dynamic>` throughout the project and makes serialization code
/// easier to read.
///
/// Example:
///
/// ```dart
/// JsonMap request = {
///   'email': email,
///   'password': password,
/// };
/// ```
typedef JsonMap = Map<String, dynamic>;

/// Represents a collection of JSON objects.
///
/// This alias is commonly used when working with arrays returned by REST APIs.
///
/// Example:
///
/// ```dart
/// JsonList notes = response['items'] as JsonList;
/// ```
typedef JsonList = List<JsonMap>;
