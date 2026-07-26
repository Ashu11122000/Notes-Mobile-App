import 'package:flutter/foundation.dart';

/// ============================================================================
/// File: login_response_model.dart
/// ============================================================================
///
/// Login Response Model (DTO)
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Represents the response returned by the FastAPI login endpoint.
/// • Stores the JWT access token.
/// • Stores the authentication token type.
/// • Converts between JSON and Dart objects.
/// • Remains immutable and free of business logic.
///
/// FastAPI Endpoint
/// ----------------------------------------------------------------------------
/// POST /api/v1/auth/login
///
/// Response Body
/// ----------------------------------------------------------------------------
/// {
///   "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
///   "token_type": "bearer"
/// }
///
/// Notes
/// ----------------------------------------------------------------------------
/// • This model intentionally contains only authentication data.
/// • User information should be retrieved separately using:
///   GET /api/v1/auth/me
/// • Fully compatible with the FastAPI authentication response.
/// • The JWT access token is intentionally excluded from [toString] to avoid
///   accidental exposure in logs.
/// ============================================================================

@immutable
final class LoginResponseModel {
  /// Creates an immutable login response model.
  const LoginResponseModel({
    required this.accessToken,
    required this.tokenType,
  });

  static const String _accessTokenKey = 'access_token';
  static const String _tokenTypeKey = 'token_type';

  /// JWT access token returned by the backend.
  final String accessToken;

  /// Authentication token type.
  ///
  /// Example:
  /// `"bearer"`
  final String tokenType;

  /// Returns a copy of this model with updated values.
  LoginResponseModel copyWith({String? accessToken, String? tokenType}) {
    return LoginResponseModel(
      accessToken: accessToken ?? this.accessToken,
      tokenType: tokenType ?? this.tokenType,
    );
  }

  /// Creates a model from a JSON object.
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: (json[_accessTokenKey] ?? '') as String,
      tokenType: (json[_tokenTypeKey] ?? '') as String,
    );
  }

  /// Converts this model into a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
    _accessTokenKey: accessToken,
    _tokenTypeKey: tokenType,
  };

  @override
  String toString() => 'LoginResponseModel(tokenType: $tokenType)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LoginResponseModel &&
            other.accessToken == accessToken &&
            other.tokenType == tokenType);
  }

  @override
  int get hashCode => Object.hash(accessToken, tokenType);
}
