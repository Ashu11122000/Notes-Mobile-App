import 'package:flutter/foundation.dart';

/// =============================================================================
/// File: api_response.dart
/// =============================================================================
///
/// Represents the outcome of an application operation.
///
/// This model is intentionally independent of backend response models and
/// serves as a lightweight wrapper for repository and service results.
///
/// It communicates only three things:
///
/// - Whether the operation succeeded.
/// - The resulting data (if any).
/// - An optional human-readable message.
///
/// This class should **not** be used for JSON serialization or to mirror
/// backend response bodies.
///
/// Example:
///
/// ```dart
/// final response = await repository.getCurrentUser();
///
/// if (response.hasData) {
///   final user = response.requireData();
/// }
/// ```
@immutable
final class ApiResponse<T> {
  /// Creates an immutable response.
  const ApiResponse({required this.isSuccess, this.data, this.message});

  /// Creates a successful response.
  const ApiResponse.success(this.data, {this.message}) : isSuccess = true;

  /// Creates a failed response.
  const ApiResponse.failure(this.message) : isSuccess = false, data = null;

  /// Indicates whether the operation completed successfully.
  final bool isSuccess;

  /// Data returned from the operation.
  ///
  /// This is typically `null` for failed responses, but may also be `null`
  /// for successful operations that intentionally return no payload
  /// (for example, DELETE requests).
  final T? data;

  /// Optional success or error message.
  final String? message;

  /// Returns `true` if the operation completed successfully.
  bool get isSuccessful => isSuccess;

  /// Returns `true` if the operation failed.
  bool get isFailure => !isSuccess;

  /// Returns `true` if the response succeeded and contains data.
  bool get hasData => isSuccess && data != null;

  /// Alias for [hasData].
  bool get hasResult => hasData;

  /// Returns whether a non-empty message exists.
  bool get hasMessage => message != null && message!.trim().isNotEmpty;

  /// Returns the contained data.
  ///
  /// Throws a [StateError] if no data exists.
  T requireData() {
    final value = data;

    if (value == null) {
      throw StateError('ApiResponse<$T> does not contain any data.');
    }

    return value;
  }

  /// Maps the contained data into another type while preserving the response
  /// status and message.
  ///
  /// Useful for converting DTOs into domain entities inside repositories.
  ApiResponse<R> map<R>(R Function(T value) mapper) {
    final value = data;

    return ApiResponse<R>(
      isSuccess: isSuccess,
      data: value == null ? null : mapper(value),
      message: message,
    );
  }

  /// Executes [action] only when the response contains successful data.
  void whenSuccess(void Function(T value) action) {
    final value = data;

    if (isSuccess && value != null) {
      action(value);
    }
  }

  /// Executes [action] only when the response represents a failure.
  void whenFailure(void Function(String? message) action) {
    if (isFailure) {
      action(message);
    }
  }

  /// Transforms this response into a single value.
  R fold<R>({
    required R Function(T value, String? message) onSuccess,
    required R Function(String? message) onFailure,
  }) {
    if (hasData) {
      return onSuccess(requireData(), message);
    }

    return onFailure(message);
  }

  static const Object _sentinel = Object();

  /// Creates a copy of this response.
  ///
  /// Pass `null` explicitly to clear nullable fields.
  ///
  /// Example:
  ///
  /// ```dart
  /// response.copyWith(message: null);
  /// response.copyWith(data: null);
  /// ```
  ApiResponse<T> copyWith({
    bool? isSuccess,
    Object? data = _sentinel,
    Object? message = _sentinel,
  }) {
    return ApiResponse<T>(
      isSuccess: isSuccess ?? this.isSuccess,
      data: identical(data, _sentinel) ? this.data : data as T?,
      message: identical(message, _sentinel)
          ? this.message
          : message as String?,
    );
  }

  @override
  String toString() {
    return 'ApiResponse<$T>('
        'isSuccess: $isSuccess, '
        'data: $data, '
        'message: $message'
        ')';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ApiResponse<T> &&
            other.isSuccess == isSuccess &&
            other.data == data &&
            other.message == message;
  }

  @override
  int get hashCode => Object.hash(isSuccess, data, message);
}
