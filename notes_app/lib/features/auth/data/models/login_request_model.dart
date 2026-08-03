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
/// • Remains immutable.
/// • Contains no business logic or validation.
/// • Supports lightweight updates through [copyWith].
///
/// FastAPI Endpoint
/// ----------------------------------------------------------------------------
/// POST /api/v1/auth/login
///
/// Notes
/// ----------------------------------------------------------------------------
/// • Validation belongs to the presentation layer.
/// • Fully compatible with the FastAPI login schema.
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

  /// Returns true when both fields are empty.
  bool get isEmpty => email.isEmpty && password.isEmpty;

  /// Returns true when at least one field contains a value.
  bool get isNotEmpty => !isEmpty;

  /// Returns a new immutable instance with updated values.
  LoginRequestModel copyWith({String? email, String? password}) {
    return LoginRequestModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  /// Creates a model from a Map.
  factory LoginRequestModel.fromMap(Map<String, dynamic> map) {
    return LoginRequestModel(
      email: map[_emailKey]?.toString() ?? '',
      password: map[_passwordKey]?.toString() ?? '',
    );
  }

  /// Alias for [fromMap].
  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel.fromMap(json);
  }

  /// Converts this model into a Map.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{_emailKey: email, _passwordKey: password};
  }

  /// Alias for [toMap].
  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() {
    return 'LoginRequestModel(email: $email)';
  }

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
