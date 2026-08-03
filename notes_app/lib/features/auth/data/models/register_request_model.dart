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
/// • Converts between Map/JSON and Dart objects.
/// • Remains immutable.
/// • Contains no business logic or validation.
/// • Supports lightweight updates through [copyWith].
///
/// FastAPI Endpoint
/// ----------------------------------------------------------------------------
/// POST /api/v1/auth/register
///
/// Example Request
/// ----------------------------------------------------------------------------
/// {
///   "email": "ashish@example.com",
///   "password": "Password@123"
/// }
///
/// Notes
/// ----------------------------------------------------------------------------
/// • Validation belongs to the presentation layer.
/// • Fully compatible with the FastAPI UserCreate schema.
/// • Password is intentionally excluded from [toString]
///   to prevent accidental logging.
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

  /// Returns true when both fields are empty.
  bool get isEmpty => email.isEmpty && password.isEmpty;

  /// Returns true when at least one field contains a value.
  bool get isNotEmpty => !isEmpty;

  /// Returns a new immutable instance with updated values.
  RegisterRequestModel copyWith({String? email, String? password}) {
    return RegisterRequestModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  /// Creates a model from a Map.
  factory RegisterRequestModel.fromMap(Map<String, dynamic> map) {
    return RegisterRequestModel(
      email: map[_emailKey]?.toString() ?? '',
      password: map[_passwordKey]?.toString() ?? '',
    );
  }

  /// Alias for [fromMap].
  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    return RegisterRequestModel.fromMap(json);
  }

  /// Converts this model into a Map.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{_emailKey: email, _passwordKey: password};
  }

  /// Alias for [toMap].
  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() {
    return 'RegisterRequestModel(email: $email)';
  }

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
