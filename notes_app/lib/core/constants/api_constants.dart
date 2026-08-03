import 'package:flutter/material.dart';

import '../config/app_config.dart';

/// =============================================================================
/// File: api_constants.dart
/// =============================================================================
///
/// Centralized REST API definitions.
///
/// Responsibilities
/// -----------------------------------------------------------------------------
/// • Defines REST endpoints.
/// • Defines HTTP headers.
/// • Defines MIME types.
/// • Provides authorization helpers.
/// • Provides endpoint helper methods.
///
/// Base URL belongs to AppConfig.
/// Endpoint paths belong here.
///
/// =============================================================================

@immutable
final class ApiConstants {
  const ApiConstants._();

  // ===========================================================================
  // API
  // ===========================================================================

  static const String apiVersion = AppConfig.apiVersion;

  /// Complete API root.
  ///
  /// Example:
  /// http://10.0.2.2:8000/api/v1
  static String get apiBaseUrl => AppConfig.apiBaseUrl;

  // ===========================================================================
  // HTTP HEADERS
  // ===========================================================================

  static const String authorizationHeader = 'Authorization';

  static const String contentTypeHeader = 'Content-Type';

  static const String acceptHeader = 'Accept';

  static const String cacheControlHeader = 'Cache-Control';

  static const String userAgentHeader = 'User-Agent';

  static const String ifNoneMatchHeader = 'If-None-Match';

  static const String etagHeader = 'ETag';

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

  static String bearerToken(String token) => '$bearerTokenPrefix$token';

  // ===========================================================================
  // AUTH
  // ===========================================================================

  static const String auth = '$apiVersion/auth';

  static const String register = '$auth/register';

  static const String login = '$auth/login';

  static const String currentUser = '$auth/me';

  // ===========================================================================
  // NOTES
  // ===========================================================================

  static const String notes = '$apiVersion/notes';

  static String noteById(int noteId) => '$notes/$noteId';

  // ===========================================================================
  // HEALTH
  // ===========================================================================

  static const String health = '/health';

  // ===========================================================================
  // AUTH HELPERS
  // ===========================================================================

  static const Set<String> _publicEndpoints = <String>{register, login, health};

  static bool requiresAuthentication(String endpoint) {
    return !_publicEndpoints.contains(endpoint);
  }

  // ===========================================================================
  // URL HELPERS
  // ===========================================================================

  /// Returns a normalized endpoint path.
  ///
  /// Example:
  ///
  /// notes
  /// ->
  /// /notes
  static String normalizeEndpoint(String endpoint) {
    return endpoint.startsWith('/') ? endpoint : '/$endpoint';
  }

  /// Builds a complete request URL.
  ///
  /// Example:
  ///
  /// buildUrl(login)
  ///
  /// ->
  /// http://10.0.2.2:8000/api/v1/auth/login
  static String buildUrl(String endpoint) {
    return '$apiBaseUrl${normalizeEndpoint(endpoint)}';
  }
}
