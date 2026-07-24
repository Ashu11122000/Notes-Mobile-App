/// A callback with no parameters and no return value.
///
/// Example:
/// ```dart
/// PrimaryButton(
///   onPressed: onLogin,
/// )
/// ```
typedef VoidCallback = void Function();

/// A callback that accepts a single value.
///
/// Example:
/// ```dart
/// onChanged(String value)
/// ```
typedef ValueCallback<T> = void Function(T value);

/// A callback that accepts two values.
///
/// Example:
/// ```dart
/// onRangeChanged(min, max)
/// ```
typedef ValueChanged2<T1, T2> = void Function(T1 first, T2 second);

/// A callback that accepts three values.
///
/// Useful for reusable widgets requiring multiple values.
typedef ValueChanged3<T1, T2, T3> =
    void Function(T1 first, T2 second, T3 third);

/// A callback that returns a boolean.
///
/// Commonly used for validation or confirmation.
typedef BoolCallback = bool Function();

/// A callback that returns a Future.
///
/// Useful for asynchronous button actions and retry operations.
typedef AsyncCallback = Future<void> Function();

/// A callback that accepts a value and returns a Future.
///
/// Example:
/// ```dart
/// onSubmit(LoginRequestModel request)
/// ```
typedef AsyncValueCallback<T> = Future<void> Function(T value);
