import 'package:flutter/foundation.dart';

/// Represents the authenticated user within the application.
///
/// Unlike the feature-specific `UserModel`, this class is a shared
/// application model that can be used across multiple features such as:
///
/// - Authentication
/// - Notes
/// - Settings
/// - Notifications
///
/// It intentionally contains no JSON serialization logic because JSON
/// mapping belongs to the feature data models.
@immutable
class AppUser {
  /// Creates an immutable application user.
  const AppUser({
    required this.id,
    required this.email,
    required this.role,
    required this.isActive,
  });

  /// Unique identifier of the user.
  final int id;

  /// User email address.
  final String email;

  /// User role.
  ///
  /// Example:
  /// - user
  /// - admin
  final String role;

  /// Indicates whether the user account is active.
  final bool isActive;

  /// Creates a copy of this user with updated values.
  AppUser copyWith({int? id, String? email, String? role, bool? isActive}) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'AppUser('
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

    return other is AppUser &&
        other.id == id &&
        other.email == email &&
        other.role == role &&
        other.isActive == isActive;
  }

  @override
  int get hashCode => Object.hash(id, email, role, isActive);
}
