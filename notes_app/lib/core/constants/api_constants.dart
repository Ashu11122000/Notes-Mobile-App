import 'package:flutter/material.dart';

import '../config/app_config.dart';

/// ============================================================================
/// File: api_constants.dart
/// ============================================================================
///
/// Centralized API endpoint constants.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Defines backend REST endpoints.
/// • Defines HTTP headers.
/// • Defines MIME types.
/// • Provides endpoint helpers.
/// • Keeps API paths separated from environment configuration.
///
/// Base URL belongs to AppConfig.
/// Endpoints belong here.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// DioClient
///      ↓
/// AppConfig (Base URL)
///      ↓
/// ApiConstants (Paths)
///      ↓
/// FastAPI
///
/// ============================================================================

@immutable
final class ApiConstants {
  const ApiConstants._();

  // ===========================================================================
  // API VERSION
  // ===========================================================================

  /// API version prefix.
  ///
  /// Example:
  /// /api/v1
  ///
  static const String apiVersion = AppConfig.apiVersion;

  // ===========================================================================
  // HTTP HEADERS
  // ===========================================================================

  static const String authorizationHeader = 'Authorization';

  static const String contentTypeHeader = 'Content-Type';

  static const String acceptHeader = 'Accept';

  static const String userAgentHeader = 'User-Agent';

  static const String cacheControlHeader = 'Cache-Control';

  // ===========================================================================
  // MIME TYPES
  // ===========================================================================

  static const String applicationJson = 'application/json';

  static const String multipartFormData = 'multipart/form-data';

  static const String textPlain = 'text/plain';

  // ===========================================================================
  // AUTHORIZATION
  // ===========================================================================

  static const String bearerPrefix = 'Bearer';

  static const String bearerTokenPrefix = '$bearerPrefix ';

  static String bearerToken(String token) {
    return '$bearerTokenPrefix$token';
  }

  // ===========================================================================
  // AUTHENTICATION ENDPOINTS
  // ===========================================================================
  //
  // FastAPI:
  //
  // /api/v1/auth/register
  // /api/v1/auth/login
  // /api/v1/auth/me
  //
  // ===========================================================================

  static const String auth = '$apiVersion/auth';

  /// Register user.
  static const String register = '$auth/register';

  /// Login user.
  static const String login = '$auth/login';

  /// Current logged-in user.
  static const String currentUser = '$auth/me';

  // ===========================================================================
  // NOTES ENDPOINTS
  // ===========================================================================
  //
  // FastAPI:
  //
  // GET    /api/v1/notes
  // POST   /api/v1/notes
  // PUT    /api/v1/notes/{id}
  // PATCH  /api/v1/notes/{id}
  // DELETE /api/v1/notes/{id}
  //
  // ===========================================================================

  static const String notes = '$apiVersion/notes';

  static String noteById(int noteId) {
    return '$notes/$noteId';
  }

  // ===========================================================================
  // HEALTH CHECK
  // ===========================================================================

  static const String health = '/health';

  // ===========================================================================
  // ENDPOINT SECURITY HELPERS
  // ===========================================================================

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

  // ===========================================================================
  // DEBUG HELPERS
  // ===========================================================================

  static String fullEndpoint(String endpoint) {
    if (endpoint.startsWith('/')) {
      return endpoint;
    }

    return '/$endpoint';
  }
}
