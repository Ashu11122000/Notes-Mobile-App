import 'package:flutter/foundation.dart';

/// =============================================================================
/// File: callback_typedefs.dart
/// =============================================================================
///
/// Shared callback type aliases used throughout the application.
///
/// Flutter's built-in callback typedefs should be preferred whenever
/// available:
///
/// - [VoidCallback]
/// - [ValueChanged]
/// - [AsyncCallback]
///
/// This file only defines callback signatures that are not provided by the
/// Flutter SDK.
///
/// These aliases are lightweight, framework-friendly, and reusable across:
///
/// - Core
/// - Domain
/// - Data
/// - Presentation
/// - Services
/// - Repositories
/// - Shared Widgets
/// =============================================================================

/// Represents a callback that accepts two values.
///
/// Example:
///
/// ```dart
/// ValueChanged2<double, double> onRangeChanged;
/// ```
typedef ValueChanged2<T1, T2> = void Function(T1 first, T2 second);

/// Represents a callback that accepts three values.
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
/// Useful for:
/// - Validation
/// - Permission checks
/// - Feature availability
/// - Confirmation dialogs
typedef BoolCallback = bool Function();

/// Represents an asynchronous callback that accepts a single value.
///
/// Example:
///
/// ```dart
/// AsyncValueChanged<LoginRequestModel> onSubmit;
/// ```
typedef AsyncValueChanged<T> = Future<void> Function(T value);
