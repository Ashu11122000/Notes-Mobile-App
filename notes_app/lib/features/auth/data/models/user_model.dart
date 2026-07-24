import 'package:flutter/foundation.dart';

/// =============================================================================
/// File: user_model.dart
/// =============================================================================
///
/// User Model
///
/// Responsibilities
/// -----------------------------------------------------------------------------
/// - Represents the authenticated user.
/// - Maps the response returned by the FastAPI `/auth/me` endpoint.
/// - Provides JSON serialization/deserialization.
/// - Provides immutable data handling.
///
/// FastAPI Endpoint
/// -----------------------------------------------------------------------------
/// GET /api/v1/auth/me
///
/// Response Body
/// -----------------------------------------------------------------------------
/// {
///   "id": 1,
///   "email": "ashish@example.com",
///   "role": "user",
///   "is_active": true
/// }
///
/// Notes
/// -----------------------------------------------------------------------------
/// - This model contains only user information.
/// - Authentication tokens are handled separately by
///   LoginResponseModel and SessionManager.
/// - Fully compatible with the FastAPI UserResponse schema.
/// =============================================================================

@immutable
class UserModel {
  /// Creates an immutable user model.
  const UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.isActive,
  });

  /// Unique user identifier.
  final int id;

  /// User email address.
  final String email;

  /// User role.
  ///
  /// Example:
  /// - admin
  /// - user
  final String role;

  /// Indicates whether the user account is active.
  final bool isActive;

  /// Creates a copy of this model with updated values.
  UserModel copyWith({int? id, String? email, String? role, bool? isActive}) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Creates a [UserModel] from JSON.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      role: json['role'] as String,
      isActive: json['is_active'] as bool,
    );
  }

  /// Converts this model to JSON.
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'role': role, 'is_active': isActive};
  }

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
    if (identical(this, other)) {
      return true;
    }

    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.role == role &&
        other.isActive == isActive;
  }

  @override
  int get hashCode => Object.hash(id, email, role, isActive);
}
