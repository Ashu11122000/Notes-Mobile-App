import 'package:flutter/foundation.dart';

/// Represents the result of an operation performed within the application.
///
/// This model is intentionally independent of the backend response format.
/// It is used by repositories and providers to communicate whether an
/// operation succeeded or failed.
///
/// It should **not** be used for JSON serialization or to mirror FastAPI
/// response bodies.
@immutable
class ApiResponse<T> {
  /// Creates an immutable API response.
  const ApiResponse({required this.isSuccess, this.data, this.message});

  /// Creates a successful response.
  const ApiResponse.success(this.data, {this.message}) : isSuccess = true;

  /// Creates a failed response.
  const ApiResponse.failure(this.message) : isSuccess = false, data = null;

  /// Indicates whether the operation completed successfully.
  final bool isSuccess;

  /// The returned data when the operation succeeds.
  final T? data;

  /// Optional success or error message.
  final String? message;

  /// Returns `true` if the response contains data.
  bool get hasData => data != null;

  /// Returns `true` if the response represents a failure.
  bool get isFailure => !isSuccess;

  /// Creates a copy of this response with updated values.
  ApiResponse<T> copyWith({bool? isSuccess, T? data, String? message}) {
    return ApiResponse<T>(
      isSuccess: isSuccess ?? this.isSuccess,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'ApiResponse('
        'isSuccess: $isSuccess, '
        'data: $data, '
        'message: $message'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ApiResponse<T> &&
        other.isSuccess == isSuccess &&
        other.data == data &&
        other.message == message;
  }

  @override
  int get hashCode => Object.hash(isSuccess, data, message);
}
