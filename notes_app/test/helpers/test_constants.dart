/// =============================================================================
/// File: test/helpers/test_constants.dart
/// =============================================================================
///
/// Centralized constants used across the test suite.
///
/// This file acts as the single source of truth for reusable test values.
/// It prevents duplicated literals and keeps tests easy to maintain.
///
/// =============================================================================

import 'package:flutter/material.dart';

/// Shared constants used throughout the test suite.
class TestConstants {
  /// Prevent instantiation.
  TestConstants._();

  // ===========================================================================
  // Authentication
  // ===========================================================================

  static const String testEmail = 'john.doe@example.com';
  static const String anotherEmail = 'jane.doe@example.com';
  static const String invalidEmail = 'invalid-email';

  static const String testPassword = 'Password@123';
  static const String wrongPassword = 'WrongPassword@123';
  static const String shortPassword = '123';

  static const String authToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.TEST_TOKEN';

  static const String refreshToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkXVCJ9.REFRESH_TOKEN';

  // ===========================================================================
  // User
  // ===========================================================================

  static const int userId = 1;

  static const String username = 'John Doe';
  static const String updatedUsername = 'John Smith';

  // ===========================================================================
  // Notes
  // ===========================================================================

  static const int noteId = 101;
  static const int anotherNoteId = 102;

  static const String noteTitle = 'Shopping List';
  static const String updatedNoteTitle = 'Updated Shopping List';

  static const String noteContent = '''
Milk
Bread
Eggs
Butter
''';

  static const String updatedNoteContent = '''
Milk
Bread
Eggs
Butter
Coffee
''';

  static const String searchQuery = 'shopping';
  static const String emptySearch = '';

  // ===========================================================================
  // Pagination
  // ===========================================================================

  static const int page = 1;
  static const int nextPage = 2;
  static const int pageSize = 10;
  static const int totalItems = 25;

  // ===========================================================================
  // Notifications
  // ===========================================================================

  static const int notificationId = 1001;
  static const int reminderId = 2001;

  static const String notificationTitle = 'Reminder';
  static const String notificationBody =
      "Don't forget to review your notes.";

  static const String imagePath = '/storage/emulated/0/Pictures/test_image.jpg';

  // ===========================================================================
  // Theme
  // ===========================================================================

  static const ThemeMode defaultThemeMode = ThemeMode.system;
  static const ThemeMode lightThemeMode = ThemeMode.light;
  static const ThemeMode darkThemeMode = ThemeMode.dark;

  // ===========================================================================
  // Storage Keys
  // ===========================================================================

  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user';
  static const String themeModeKey = 'theme_mode';

  // ===========================================================================
  // Network
  // ===========================================================================

  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration shortDelay = Duration(milliseconds: 100);
  static const Duration animationDuration = Duration(milliseconds: 300);

  // ===========================================================================
  // Error Messages
  // ===========================================================================

  static const String networkError = 'Network connection failed';
  static const String unauthorizedError = 'Unauthorized';
  static const String serverError = 'Internal server error';
  static const String unknownError = 'Something went wrong';

  // ===========================================================================
  // Validation
  // ===========================================================================

  static const String requiredFieldMessage = 'This field is required';
  static const String invalidEmailMessage =
      'Please enter a valid email address';
  static const String invalidPasswordMessage = 'Password is too short';
}