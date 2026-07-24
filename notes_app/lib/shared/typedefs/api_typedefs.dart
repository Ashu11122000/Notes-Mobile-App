import 'dart:async';

/// Generic asynchronous operation.
///
/// Used for repository and remote data source methods that return a value.
///
/// Example:
/// ```dart
/// AsyncValue<UserModel> getCurrentUser();
/// ```
typedef AsyncValue<T> = Future<T>;

/// Generic asynchronous operation with no return value.
///
/// Example:
/// ```dart
/// AsyncVoid logout();
/// ```
typedef AsyncVoid = Future<void>;

/// Generic JSON map.
///
/// Used for request and response serialization.
typedef JsonMap = Map<String, dynamic>;

/// Generic JSON list.
///
/// Used for collections of JSON objects.
typedef JsonList = List<JsonMap>;
