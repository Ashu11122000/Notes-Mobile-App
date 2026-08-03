import 'package:flutter/foundation.dart';

/// =============================================================================
/// File: app_user.dart
/// =============================================================================
///
/// Represents the authenticated user within the application.
///
/// This is a shared domain model that can safely be used across multiple
/// features without introducing dependencies on data-transfer objects (DTOs)
/// or backend response models.
///
/// Typical consumers include:
/// - Authentication
/// - Authorization
/// - Notes
/// - Profile
/// - Settings
/// - Notifications
///
/// This model intentionally contains **no JSON serialization logic**.
/// Serialization belongs to feature-specific data models in the data layer,
/// preserving Clean Architecture boundaries.
///
/// This class should represent only the information required by the domain
/// and presentation layers.
@immutable
final class AppUser {
  /// Creates an immutable application user.
  const AppUser({
    required this.id,
    required this.email,
    required this.role,
    required this.isActive,
  });

  /// Unique identifier of the authenticated user.
  final int id;

  /// User email address.
  final String email;

  /// User role.
  ///
  /// Examples:
  /// - `user`
  /// - `admin`
  final String role;

  /// Indicates whether the user account is active.
  final bool isActive;

  /// Returns the normalized role.
  String get normalizedRole => role.trim().toLowerCase();

  /// Returns `true` if the authenticated user has the administrator role.
  bool get isAdmin => normalizedRole == 'admin';

  /// Returns `true` if the authenticated user has the standard user role.
  bool get isRegularUser => normalizedRole == 'user';

  /// Returns `true` if the account is inactive.
  bool get isInactive => !isActive;

  /// Returns `true` if the user has a valid identifier.
  ///
  /// Useful for lightweight domain checks.
  bool get isAuthenticatedUser => id > 0;

  /// Returns `true` if the email is not empty.
  ///
  /// This is intentionally lightweight and is not a full email validator.
  bool get hasValidEmail => email.trim().isNotEmpty;

  /// A user-friendly identifier suitable for display.
  ///
  /// Currently returns the email address. This getter allows future
  /// enhancements (for example, supporting a full name) without changing
  /// consumers.
  String get displayName => email;

  /// Returns whether the user matches the supplied role.
  ///
  /// Comparison is case-insensitive and ignores surrounding whitespace.
  bool hasRole(String roleName) =>
      normalizedRole == roleName.trim().toLowerCase();

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
    return identical(this, other) ||
        other is AppUser &&
            other.id == id &&
            other.email == email &&
            other.role == role &&
            other.isActive == isActive;
  }

  @override
  int get hashCode => Object.hash(id, email, role, isActive);
}
