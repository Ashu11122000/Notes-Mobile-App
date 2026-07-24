import 'package:flutter/foundation.dart';

/// =============================================================================
/// File: register_response_model.dart
/// =============================================================================
///
/// Register Response Model
///
/// Responsibilities
/// -----------------------------------------------------------------------------
/// - Represents the response returned by the FastAPI register endpoint.
/// - Stores the success message.
/// - Stores the newly created user ID.
/// - Supports JSON serialization/deserialization.
/// - Provides immutable data handling.
///
/// FastAPI Endpoint
/// -----------------------------------------------------------------------------
/// POST /api/v1/auth/register
///
/// Response Body
/// -----------------------------------------------------------------------------
/// {
///   "message": "User registered successfully.",
///   "user_id": 4
/// }
///
/// Notes
/// -----------------------------------------------------------------------------
/// - This model does not contain authentication tokens.
/// - Users must log in separately after successful registration.
/// - Fully compatible with the FastAPI register response.
/// =============================================================================

@immutable
class RegisterResponseModel {
  /// Creates an immutable register response model.
  const RegisterResponseModel({required this.message, required this.userId});

  /// Success message returned by the backend.
  final String message;

  /// ID of the newly created user.
  final int userId;

  /// Creates a copy of this model with updated values.
  RegisterResponseModel copyWith({String? message, int? userId}) {
    return RegisterResponseModel(
      message: message ?? this.message,
      userId: userId ?? this.userId,
    );
  }

  /// Creates a model from JSON.
  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      message: json['message'] as String,
      userId: json['user_id'] as int,
    );
  }

  /// Converts this model into JSON.
  Map<String, dynamic> toJson() {
    return {'message': message, 'user_id': userId};
  }

  @override
  String toString() {
    return 'RegisterResponseModel('
        'message: $message, '
        'userId: $userId'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is RegisterResponseModel &&
        other.message == message &&
        other.userId == userId;
  }

  @override
  int get hashCode => Object.hash(message, userId);
}
