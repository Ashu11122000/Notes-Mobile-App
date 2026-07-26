/// =============================================================================
/// File: callback_typedefs.dart
/// =============================================================================
///
/// Shared callback type aliases used throughout the application.
///
/// This file centralizes commonly used callback signatures to improve
/// readability, consistency, and discoverability across the codebase.
///
/// Flutter's built-in [VoidCallback] should be used instead of redefining it.
/// Only callback signatures that are not provided by the Flutter SDK are
/// declared here.
///
/// These aliases remain framework-independent and can be reused across:
///
/// - Core
/// - Domain
/// - Data
/// - Presentation
/// - Services
/// - Repositories
/// - Reusable Widgets
/// =============================================================================

/// Represents a callback that accepts a single value.
///
/// Example:
///
/// ```dart
/// ValueCallback<String> onChanged;
/// ```
typedef ValueCallback<T> = void Function(T value);

/// Represents a callback that accepts two values.
///
/// Useful for reusable widgets, filters, or range selectors.
///
/// Example:
///
/// ```dart
/// ValueChanged2<double, double> onRangeChanged;
/// ```
typedef ValueChanged2<T1, T2> = void Function(T1 first, T2 second);

/// Represents a callback that accepts three values.
///
/// Useful when multiple related values need to be returned without creating
/// an intermediate model.
///
/// Example:
///
/// ```dart
/// ValueChanged3<int, int, bool> onSelectionChanged;
/// ```
typedef ValueChanged3<T1, T2, T3> =
    void Function(T1 first, T2 second, T3 third);

/// Represents a synchronous callback returning a boolean.
///
/// Common use cases include:
///
/// - Validation
/// - Confirmation
/// - Permission checks
/// - Feature availability
typedef BoolCallback = bool Function();

/// Represents an asynchronous callback.
///
/// Useful for:
///
/// - Button actions
/// - Retry operations
/// - Network requests
/// - Form submission
///
/// Example:
///
/// ```dart
/// AsyncCallback onRefresh;
/// ```
typedef AsyncCallback = Future<void> Function();

/// Represents an asynchronous callback that accepts a single value.
///
/// Useful for asynchronous operations requiring an input parameter.
///
/// Example:
///
/// ```dart
/// AsyncValueCallback<LoginRequestModel> onSubmit;
/// ```
typedef AsyncValueCallback<T> = Future<void> Function(T value);
