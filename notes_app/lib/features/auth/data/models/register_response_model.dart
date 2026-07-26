import 'package:flutter/foundation.dart';

/// ============================================================================
/// File: register_response_model.dart
/// ============================================================================
///
/// Register Response Model (DTO)
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Represents the response returned by the FastAPI registration endpoint.
/// • Stores the success message.
/// • Stores the newly created user identifier.
/// • Converts between JSON and Dart objects.
/// • Remains immutable and free of business logic.
///
/// FastAPI Endpoint
/// ----------------------------------------------------------------------------
/// POST /api/v1/auth/register
///
/// Response Body
/// ----------------------------------------------------------------------------
/// {
///   "message": "User registered successfully.",
///   "user_id": 4
/// }
///
/// Notes
/// ----------------------------------------------------------------------------
/// • This model intentionally contains no authentication tokens.
/// • Users must authenticate separately after successful registration.
/// • Fully compatible with the FastAPI registration response.
/// ============================================================================

@immutable
final class RegisterResponseModel {
  /// Creates an immutable registration response model.
  const RegisterResponseModel({required this.message, required this.userId});

  static const String _messageKey = 'message';
  static const String _userIdKey = 'user_id';

  /// Success message returned by the backend.
  final String message;

  /// Identifier of the newly created user.
  final int userId;

  /// Returns a copy of this model with updated values.
  RegisterResponseModel copyWith({String? message, int? userId}) {
    return RegisterResponseModel(
      message: message ?? this.message,
      userId: userId ?? this.userId,
    );
  }

  /// Creates a model from a JSON object.
  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      message: (json[_messageKey] ?? '') as String,
      userId: (json[_userIdKey] as num?)?.toInt() ?? 0,
    );
  }

  /// Converts this model into a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
    _messageKey: message,
    _userIdKey: userId,
  };

  @override
  String toString() =>
      'RegisterResponseModel(message: $message, userId: $userId)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RegisterResponseModel &&
            other.message == message &&
            other.userId == userId);
  }

  @override
  int get hashCode => Object.hash(message, userId);
}
