import 'package:flutter/foundation.dart';

/// ============================================================================
/// File: register_response_model.dart
/// ============================================================================
///
/// Register Response Model (DTO)
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Represents the response returned by the FastAPI registration endpoint.
/// • Stores the success message.
/// • Stores the newly created user identifier.
/// • Converts between Map/JSON and Dart objects.
/// • Remains immutable.
/// • Contains no business logic.
///
/// FastAPI Endpoint
/// ----------------------------------------------------------------------------
/// POST /api/v1/auth/register
///
/// Example Response
/// ----------------------------------------------------------------------------
/// {
///   "message": "User registered successfully.",
///   "user_id": 4
/// }
///
/// Notes
/// ----------------------------------------------------------------------------
/// • This model intentionally contains no authentication tokens.
/// • Users must authenticate separately after successful registration.
/// • Fully compatible with the FastAPI registration response.
/// ============================================================================

@immutable
final class RegisterResponseModel {
  /// Creates an immutable registration response model.
  const RegisterResponseModel({required this.message, required this.userId});

  static const String _messageKey = 'message';
  static const String _userIdKey = 'user_id';

  /// Success message returned by the backend.
  final String message;

  /// Identifier of the newly created user.
  final int userId;

  /// Returns true when the backend returned a valid user identifier.
  bool get hasUserId => userId > 0;

  /// Returns true when the backend returned a non-empty message.
  bool get hasMessage => message.isNotEmpty;

  /// Returns a new immutable instance with updated values.
  RegisterResponseModel copyWith({String? message, int? userId}) {
    return RegisterResponseModel(
      message: message ?? this.message,
      userId: userId ?? this.userId,
    );
  }

  /// Creates a model from a Map.
  factory RegisterResponseModel.fromMap(Map<String, dynamic> map) {
    return RegisterResponseModel(
      message: map[_messageKey]?.toString() ?? '',
      userId: switch (map[_userIdKey]) {
        final int value => value,
        final num value => value.toInt(),
        final String value => int.tryParse(value) ?? 0,
        _ => 0,
      },
    );
  }

  /// Alias for [fromMap].
  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel.fromMap(json);
  }

  /// Converts this model into a Map.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{_messageKey: message, _userIdKey: userId};
  }

  /// Alias for [toMap].
  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() {
    return 'RegisterResponseModel('
        'message: $message, '
        'userId: $userId'
        ')';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RegisterResponseModel &&
            other.message == message &&
            other.userId == userId);
  }

  @override
  int get hashCode => Object.hash(message, userId);
}
