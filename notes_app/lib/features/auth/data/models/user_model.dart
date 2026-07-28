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
/// • Converts between Map/JSON and Dart objects.
/// • Remains immutable.
/// • Contains no business logic.
/// • Supports lightweight updates through [copyWith].
///
/// FastAPI Endpoint
/// ----------------------------------------------------------------------------
/// GET /api/v1/auth/me
///
/// Example Response
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
/// • Authentication tokens are managed separately.
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
  /// • admin
  /// • user
  final String role;

  /// Indicates whether the account is active.
  final bool isActive;

  /// Returns true when the user has a valid identifier.
  bool get hasValidId => id > 0;

  /// Returns true when the user is an administrator.
  bool get isAdmin => role.toLowerCase() == 'admin';

  /// Returns true when the user is a regular user.
  bool get isUser => role.toLowerCase() == 'user';

  /// Returns a new immutable instance with updated values.
  UserModel copyWith({int? id, String? email, String? role, bool? isActive}) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Creates a model from a Map.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: switch (map[_idKey]) {
        final int value => value,
        final num value => value.toInt(),
        final String value => int.tryParse(value) ?? 0,
        _ => 0,
      },
      email: map[_emailKey]?.toString() ?? '',
      role: map[_roleKey]?.toString() ?? '',
      isActive: switch (map[_isActiveKey]) {
        final bool value => value,
        final String value => value.toLowerCase() == 'true',
        final num value => value != 0,
        _ => false,
      },
    );
  }

  /// Alias for [fromMap].
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel.fromMap(json);
  }

  /// Converts this model into a Map.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      _idKey: id,
      _emailKey: email,
      _roleKey: role,
      _isActiveKey: isActive,
    };
  }

  /// Alias for [toMap].
  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() {
    return 'UserModel('
        'id: $id, '
        'email: $email, '
        'role: $role, '
        'isActive: $isActive'
        ')';
  }

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
