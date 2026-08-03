import 'package:flutter/foundation.dart';

/// ============================================================================
/// File: login_response_model.dart
/// ============================================================================
///
/// Login Response Model (DTO)
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Represents the authentication response returned by FastAPI.
/// • Stores the JWT access token.
/// • Stores the authentication token type.
/// • Converts between Map/JSON and Dart objects.
/// • Remains immutable.
/// • Contains no business logic.
///
/// FastAPI Endpoint
/// ----------------------------------------------------------------------------
/// POST /api/v1/auth/login
///
/// Example Response
/// ----------------------------------------------------------------------------
/// {
///   "access_token": "<jwt_token>",
///   "token_type": "bearer"
/// }
///
/// Notes
/// ----------------------------------------------------------------------------
/// • User profile information is retrieved separately from:
///     GET /api/v1/auth/me
///
/// • JWT values are intentionally excluded from [toString]
///   to prevent accidental logging.
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

  /// JWT access token.
  final String accessToken;

  /// Authentication token type.
  ///
  /// Example:
  /// bearer
  final String tokenType;

  /// Returns true when a non-empty access token exists.
  bool get hasAccessToken => accessToken.isNotEmpty;

  /// Returns the Authorization header value.
  ///
  /// Example:
  /// Bearer eyJhbGciOi...
  ///
  /// Returns null if no access token is available.
  String? get authorizationHeader {
    if (!hasAccessToken) {
      return null;
    }

    return '${_capitalizeTokenType(tokenType)} $accessToken';
  }

  /// Returns a new immutable instance with updated values.
  LoginResponseModel copyWith({String? accessToken, String? tokenType}) {
    return LoginResponseModel(
      accessToken: accessToken ?? this.accessToken,
      tokenType: tokenType ?? this.tokenType,
    );
  }

  /// Creates a model from a Map.
  factory LoginResponseModel.fromMap(Map<String, dynamic> map) {
    return LoginResponseModel(
      accessToken: map[_accessTokenKey]?.toString() ?? '',
      tokenType: map[_tokenTypeKey]?.toString() ?? '',
    );
  }

  /// Alias for [fromMap].
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel.fromMap(json);
  }

  /// Converts this model into a Map.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      _accessTokenKey: accessToken,
      _tokenTypeKey: tokenType,
    };
  }

  /// Alias for [toMap].
  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() {
    return 'LoginResponseModel(tokenType: $tokenType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LoginResponseModel &&
            other.accessToken == accessToken &&
            other.tokenType == tokenType);
  }

  @override
  int get hashCode => Object.hash(accessToken, tokenType);

  static String _capitalizeTokenType(String value) {
    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }
}
