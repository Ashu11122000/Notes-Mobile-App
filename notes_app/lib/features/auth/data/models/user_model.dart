import 'package:flutter/foundation.dart';

/// ============================================================================
/// File: user_model.dart
/// ============================================================================
///
/// User Model (DTO)
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Represents the authenticated user returned by the FastAPI API.
/// • Converts between JSON and Dart objects.
/// • Remains immutable and free of business logic.
/// • Provides lightweight state updates through [copyWith].
///
/// FastAPI Endpoint
/// ----------------------------------------------------------------------------
/// GET /api/v1/auth/me
///
/// Response Body
/// ----------------------------------------------------------------------------
/// {
///   "id": 1,
///   "email": "ashish@example.com",
///   "role": "user",
///   "is_active": true
/// }
///
/// Notes
/// ----------------------------------------------------------------------------
/// • This model contains only user profile information.
/// • Authentication tokens are managed separately by
///   [LoginResponseModel] and [SessionManager].
/// • Fully compatible with the FastAPI UserResponse schema.
/// ============================================================================

@immutable
final class UserModel {
  /// Creates an immutable user model.
  const UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.isActive,
  });

  static const String _idKey = 'id';
  static const String _emailKey = 'email';
  static const String _roleKey = 'role';
  static const String _isActiveKey = 'is_active';

  /// Unique user identifier.
  final int id;

  /// User email address.
  final String email;

  /// User role.
  ///
  /// Common values:
  /// - admin
  /// - user
  final String role;

  /// Indicates whether the user account is active.
  final bool isActive;

  /// Returns a new instance with the provided values replaced.
  UserModel copyWith({int? id, String? email, String? role, bool? isActive}) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Creates a model from a JSON object.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json[_idKey] as num?)?.toInt() ?? 0,
      email: (json[_emailKey] ?? '') as String,
      role: (json[_roleKey] ?? '') as String,
      isActive: json[_isActiveKey] as bool? ?? false,
    );
  }

  /// Converts this model into a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
    _idKey: id,
    _emailKey: email,
    _roleKey: role,
    _isActiveKey: isActive,
  };

  @override
  String toString() =>
      'UserModel(id: $id, email: $email, role: $role, isActive: $isActive)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserModel &&
            other.id == id &&
            other.email == email &&
            other.role == role &&
            other.isActive == isActive);
  }

  @override
  int get hashCode => Object.hash(id, email, role, isActive);
}
