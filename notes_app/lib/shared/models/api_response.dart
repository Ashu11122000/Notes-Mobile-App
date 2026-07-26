import 'package:flutter/foundation.dart';

/// =============================================================================
/// File: api_response.dart
/// =============================================================================
///
/// Represents the outcome of an application operation.
///
/// This model is intentionally **independent of backend response models** and
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
/// if (response.hasResult) {
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
  /// Will typically be `null` for failed responses.
  final T? data;

  /// Optional success or error message.
  final String? message;

  /// Returns `true` if the response contains data.
  bool get hasData => data != null;

  /// Returns `true` if the operation failed.
  bool get isFailure => !isSuccess;

  /// Returns `true` if the operation both succeeded and contains data.
  bool get hasResult => isSuccess && data != null;

  /// Returns whether a message exists.
  bool get hasMessage => message != null && message!.trim().isNotEmpty;

  /// Returns the contained data.
  ///
  /// Throws a [StateError] if no data exists.
  T requireData() {
    if (data == null) {
      throw StateError('ApiResponse does not contain data.');
    }

    return data as T;
  }

  /// Maps the contained data into another type while preserving the response
  /// status and message.
  ///
  /// This is particularly useful inside repositories when converting DTOs into
  /// domain entities.
  ApiResponse<R> map<R>(R Function(T value) mapper) {
    if (data == null) {
      return ApiResponse<R>(isSuccess: isSuccess, message: message);
    }

    return ApiResponse<R>(
      isSuccess: isSuccess,
      data: mapper(data as T),
      message: message,
    );
  }

  /// Creates a copy of this response with updated values.
  ///
  /// Nullable fields intentionally retain their current value when omitted.
  ApiResponse<T> copyWith({bool? isSuccess, T? data, String? message}) {
    return ApiResponse<T>(
      isSuccess: isSuccess ?? this.isSuccess,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }

  @override
  String toString() =>
      'ApiResponse<$T>('
      'isSuccess: $isSuccess, '
      'data: $data, '
      'message: $message'
      ')';

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
