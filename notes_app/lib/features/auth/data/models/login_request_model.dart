import 'package:flutter/foundation.dart';

/// ============================================================================
/// File: login_request_model.dart
/// ============================================================================
///
/// Login Request Model (DTO)
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Represents the request payload sent to the FastAPI login endpoint.
/// • Converts between Dart objects and JSON.
/// • Remains immutable and free of business logic.
/// • Supports lightweight state updates through [copyWith].
///
/// FastAPI Endpoint
/// ----------------------------------------------------------------------------
/// POST /api/v1/auth/login
///
/// Request Body
/// ----------------------------------------------------------------------------
/// {
///   "email": "ashish@example.com",
///   "password": "Password@123"
/// }
///
/// Notes
/// ----------------------------------------------------------------------------
/// • This model intentionally contains no validation logic.
/// • Validation belongs to the presentation layer (Forms/Validators).
/// • Fully compatible with the FastAPI UserLogin schema.
/// • Password is intentionally excluded from [toString] for security.
/// ============================================================================

@immutable
final class LoginRequestModel {
  /// Creates an immutable login request model.
  const LoginRequestModel({required this.email, required this.password});

  static const String _emailKey = 'email';
  static const String _passwordKey = 'password';

  /// User's registered email address.
  final String email;

  /// User's account password.
  final String password;

  /// Returns a new instance with the provided values replaced.
  LoginRequestModel copyWith({String? email, String? password}) {
    return LoginRequestModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  /// Creates a model from a JSON object.
  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      email: (json[_emailKey] ?? '') as String,
      password: (json[_passwordKey] ?? '') as String,
    );
  }

  /// Converts this model into a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
    _emailKey: email,
    _passwordKey: password,
  };

  @override
  String toString() => 'LoginRequestModel(email: $email)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LoginRequestModel &&
            other.email == email &&
            other.password == password);
  }

  @override
  int get hashCode => Object.hash(email, password);
}
