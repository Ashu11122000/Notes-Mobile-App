import 'package:flutter/foundation.dart';

/// =============================================================================
/// File: register_request_model.dart
/// =============================================================================
///
/// Register Request Model
///
/// Responsibilities
/// -----------------------------------------------------------------------------
/// - Represents the request payload for user registration.
/// - Converts Dart object to JSON for the FastAPI register endpoint.
/// - Provides immutable data handling.
/// - Supports copyWith for state updates.
///
/// FastAPI Endpoint
/// -----------------------------------------------------------------------------
/// POST /api/v1/auth/register
///
/// Request Body
/// -----------------------------------------------------------------------------
/// {
///   "email": "ashish@example.com",
///   "password": "Password@123"
/// }
///
/// Notes
/// -----------------------------------------------------------------------------
/// - This model intentionally contains no validation logic.
/// - Input validation should be handled by the presentation layer (Forms).
/// - Fully compatible with the FastAPI UserCreate schema.
/// =============================================================================

@immutable
class RegisterRequestModel {
  /// Creates a new immutable register request model.
  const RegisterRequestModel({required this.email, required this.password});

  /// User's email address.
  final String email;

  /// User's account password.
  final String password;

  /// Creates a copy of this model with updated values.
  RegisterRequestModel copyWith({String? email, String? password}) {
    return RegisterRequestModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  /// Creates a [RegisterRequestModel] from JSON.
  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    return RegisterRequestModel(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  /// Converts this model to JSON.
  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }

  @override
  String toString() {
    return 'RegisterRequestModel(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RegisterRequestModel &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => Object.hash(email, password);
}
