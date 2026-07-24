import 'package:flutter/foundation.dart';

/// =============================================================================
/// File: login_response_model.dart
/// =============================================================================
///
/// Login Response Model
///
/// Responsibilities
/// -----------------------------------------------------------------------------
/// - Represents the response returned by the FastAPI login endpoint.
/// - Stores the JWT access token.
/// - Stores the token type.
/// - Supports JSON serialization/deserialization.
/// - Provides immutable data handling.
///
/// FastAPI Endpoint
/// -----------------------------------------------------------------------------
/// POST /api/v1/auth/login
///
/// Response Body
/// -----------------------------------------------------------------------------
/// {
///   "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
///   "token_type": "bearer"
/// }
///
/// Notes
/// -----------------------------------------------------------------------------
/// - This model intentionally contains only authentication data.
/// - User information should be retrieved separately using:
///   GET /api/v1/auth/me
/// - Fully compatible with the FastAPI authentication response.
/// =============================================================================

@immutable
class LoginResponseModel {
  /// Creates an immutable login response model.
  const LoginResponseModel({
    required this.accessToken,
    required this.tokenType,
  });

  /// JWT access token returned by the backend.
  final String accessToken;

  /// Authentication token type.
  ///
  /// Example: "bearer"
  final String tokenType;

  /// Creates a new instance with updated values.
  LoginResponseModel copyWith({String? accessToken, String? tokenType}) {
    return LoginResponseModel(
      accessToken: accessToken ?? this.accessToken,
      tokenType: tokenType ?? this.tokenType,
    );
  }

  /// Creates a model from JSON.
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
    );
  }

  /// Converts this model to JSON.
  Map<String, dynamic> toJson() {
    return {'access_token': accessToken, 'token_type': tokenType};
  }

  @override
  String toString() {
    return 'LoginResponseModel(tokenType: $tokenType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is LoginResponseModel &&
        other.accessToken == accessToken &&
        other.tokenType == tokenType;
  }

  @override
  int get hashCode => Object.hash(accessToken, tokenType);
}
