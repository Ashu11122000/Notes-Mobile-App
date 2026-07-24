import 'package:flutter/foundation.dart';

/// =============================================================================
/// File: login_request_model.dart
/// =============================================================================
///
/// Login Request Model
///
/// Responsibilities
/// -----------------------------------------------------------------------------
/// - Represents the request payload for user login.
/// - Converts Dart object to JSON for the FastAPI login endpoint.
/// - Provides immutable data handling.
/// - Supports copyWith for state updates.
///
/// FastAPI Endpoint
/// -----------------------------------------------------------------------------
/// POST /api/v1/auth/login
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
/// - Fully compatible with the FastAPI UserLogin schema.
/// =============================================================================

@immutable
class LoginRequestModel {
  /// Creates a new immutable login request model.
  const LoginRequestModel({required this.email, required this.password});

  /// User's registered email address.
  final String email;

  /// User's account password.
  final String password;

  /// Creates a copy of this model with updated fields.
  LoginRequestModel copyWith({String? email, String? password}) {
    return LoginRequestModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  /// Creates a model from JSON.
  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  /// Converts this model into JSON.
  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }

  @override
  String toString() {
    return 'LoginRequestModel(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoginRequestModel &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => Object.hash(email, password);
}
