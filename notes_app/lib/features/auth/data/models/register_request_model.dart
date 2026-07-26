import 'package:flutter/foundation.dart';

/// ============================================================================
/// File: register_request_model.dart
/// ============================================================================
///
/// Register Request Model (DTO)
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Represents the request payload sent to the FastAPI registration endpoint.
/// • Converts between Dart objects and JSON.
/// • Remains immutable and free of business logic.
/// • Supports lightweight state updates through [copyWith].
///
/// FastAPI Endpoint
/// ----------------------------------------------------------------------------
/// POST /api/v1/auth/register
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
/// • Fully compatible with the FastAPI UserCreate schema.
/// • Password is intentionally excluded from [toString] for security.
/// ============================================================================

@immutable
final class RegisterRequestModel {
  /// Creates an immutable registration request model.
  const RegisterRequestModel({required this.email, required this.password});

  static const String _emailKey = 'email';
  static const String _passwordKey = 'password';

  /// User's email address.
  final String email;

  /// User's account password.
  final String password;

  /// Returns a new instance with the provided values replaced.
  RegisterRequestModel copyWith({String? email, String? password}) {
    return RegisterRequestModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  /// Creates a model from a JSON object.
  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    return RegisterRequestModel(
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
  String toString() => 'RegisterRequestModel(email: $email)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RegisterRequestModel &&
            other.email == email &&
            other.password == password);
  }

  @override
  int get hashCode => Object.hash(email, password);
}
