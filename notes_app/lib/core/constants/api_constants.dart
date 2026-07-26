import 'package:flutter/material.dart';

import '../config/app_config.dart';

/// ============================================================================
/// File: api_constants.dart
/// ============================================================================
///
/// Centralized API constants.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Defines REST API endpoints.
/// • Defines standard HTTP headers.
/// • Defines MIME types.
/// • Provides helper methods for dynamic endpoints.
/// • Centralizes HTTP-related constants.
///
/// This class intentionally does **not** contain environment configuration
/// (base URL, build environment, or network timeouts). Those belong in
/// [AppConfig] to ensure a single source of truth.
///
/// Keeping endpoints separate from runtime configuration improves
/// maintainability, testability, and scalability while preserving compatibility
/// with the existing FastAPI backend.
/// ============================================================================
@immutable
final class ApiConstants {
  const ApiConstants._();

  // ===========================================================================
  // API
  // ===========================================================================

  /// REST API version.
  ///
  /// Delegated to [AppConfig] so configuration exists in one place.
  static const String apiVersion = AppConfig.apiVersion;

  // ===========================================================================
  // HTTP Headers
  // ===========================================================================

  /// Authorization header.
  static const String authorizationHeader = 'Authorization';

  /// Content-Type header.
  static const String contentTypeHeader = 'Content-Type';

  /// Accept header.
  static const String acceptHeader = 'Accept';

  /// User-Agent header.
  static const String userAgentHeader = 'User-Agent';

  /// Cache-Control header.
  static const String cacheControlHeader = 'Cache-Control';

  /// ETag header.
  static const String eTagHeader = 'ETag';

  /// If-None-Match header.
  static const String ifNoneMatchHeader = 'If-None-Match';

  // ===========================================================================
  // MIME Types
  // ===========================================================================

  static const String applicationJson = 'application/json';

  static const String multipartFormData = 'multipart/form-data';

  static const String textPlain = 'text/plain';

  // ===========================================================================
  // Authorization
  // ===========================================================================

  static const String bearerPrefix = 'Bearer';

  static const String bearerTokenPrefix = '$bearerPrefix ';

  // ===========================================================================
  // Authentication Endpoints
  // ===========================================================================

  /// User registration.
  static const String register = '$apiVersion/auth/register';

  /// User login.
  static const String login = '$apiVersion/auth/login';

  /// Current authenticated user.
  static const String currentUser = '$apiVersion/auth/me';

  // ===========================================================================
  // Notes Endpoints
  // ===========================================================================

  /// Notes collection.
  static const String notes = '$apiVersion/notes';

  /// Returns the endpoint for a specific note.
  static String noteById(int noteId) => '$notes/$noteId';

  // ===========================================================================
  // Health
  // ===========================================================================

  /// Backend health endpoint.
  static const String health = '/health';

  // ===========================================================================
  // Helpers
  // ===========================================================================

  /// Creates a bearer authorization value.
  ///
  /// Example:
  ///
  /// ```dart
  /// headers[ApiConstants.authorizationHeader] =
  ///     ApiConstants.bearerToken(accessToken);
  /// ```
  static String bearerToken(String token) => '$bearerTokenPrefix$token';

  /// Returns whether the endpoint requires authentication.
  ///
  /// This helper can be expanded in the future if public endpoints
  /// are introduced.
  static bool requiresAuthentication(String endpoint) {
    switch (endpoint) {
      case register:
      case login:
      case health:
        return false;

      default:
        return true;
    }
  }
}
