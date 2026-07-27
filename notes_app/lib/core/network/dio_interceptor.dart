import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';
import '../services/logger_service.dart';

/// ============================================================================
/// File: dio_interceptor.dart
/// ============================================================================
///
/// Enterprise Dio Interceptor
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Adds common HTTP headers.
/// • Attaches JWT access token.
/// • Provides detailed JWT debugging.
/// • Logs requests/responses/errors.
/// • Measures request duration.
/// • No business logic.
/// ============================================================================

@immutable
final class DioInterceptor extends Interceptor {
  const DioInterceptor({required this.tokenProvider});

  final Future<String?> Function() tokenProvider;

  static const String _requestStartKey = '_request_start_time';
  static const String _requestIdKey = '_request_id';
  static const int _maxLogLength = 2000;

  // ===========================================================================
  // REQUEST
  // ===========================================================================

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      options.headers.putIfAbsent(
        ApiConstants.acceptHeader,
        () => ApiConstants.applicationJson,
      );

      options.headers.putIfAbsent(
        ApiConstants.contentTypeHeader,
        () => ApiConstants.applicationJson,
      );

      final String? token = await tokenProvider();

      if (token != null && token.trim().isNotEmpty) {
        final String authHeader = ApiConstants.bearerToken(token);

        options.headers[ApiConstants.authorizationHeader] = authHeader;

        if (kDebugMode) {
          LoggerService.info('''
==================== JWT DEBUG ====================

Token Exists:
YES

Token Length:
${token.length}

Token Preview:
${token.substring(0, math.min(token.length, 40))}...

Authorization Header:
$authHeader

Authorization Header Length:
${authHeader.length}

Request URL:
${options.uri}

Request Path:
${options.path}

===================================================
''');
        }
      } else {
        LoggerService.warning('''
==================== JWT DEBUG ====================

NO ACCESS TOKEN FOUND

Request:
${options.uri}

This request will be sent WITHOUT Authorization header.

===================================================
''');
      }

      final String requestId = DateTime.now().microsecondsSinceEpoch.toString();

      options.extra[_requestStartKey] = DateTime.now();
      options.extra[_requestIdKey] = requestId;

      _logRequest(options);

      handler.next(options);
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Request interceptor failed.',
        error: exception,
        stackTrace: stackTrace,
      );

      handler.next(options);
    }
  }

  // ===========================================================================
  // RESPONSE
  // ===========================================================================

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logResponse(response);

    handler.next(response);
  }

  // ===========================================================================
  // ERROR
  // ===========================================================================

  @override
  void onError(DioException exception, ErrorInterceptorHandler handler) {
    _logError(exception);

    handler.next(exception);
  }

  // ===========================================================================
  // REQUEST LOG
  // ===========================================================================

  void _logRequest(RequestOptions options) {
    if (!kDebugMode) return;

    LoggerService.info('''
==================== HTTP REQUEST ====================

ID:
${options.extra[_requestIdKey]}

Method:
${options.method}

URL:
${options.uri}

Headers:
${_sanitizeHeaders(options.headers)}

Body:
${_truncate(options.data)}

======================================================
''');
  }

  // ===========================================================================
  // RESPONSE LOG
  // ===========================================================================

  void _logResponse(Response response) {
    if (!kDebugMode) return;

    final DateTime? started =
        response.requestOptions.extra[_requestStartKey] as DateTime?;

    final String elapsed = started == null
        ? '-'
        : '${DateTime.now().difference(started).inMilliseconds} ms';

    LoggerService.info('''
==================== HTTP RESPONSE ===================

ID:
${response.requestOptions.extra[_requestIdKey]}

Status:
${response.statusCode}

Method:
${response.requestOptions.method}

URL:
${response.requestOptions.uri}

Elapsed:
$elapsed

Response:
${_truncate(response.data)}

======================================================
''');
  }

  // ===========================================================================
  // ERROR LOG
  // ===========================================================================

  void _logError(DioException exception) {
    if (!kDebugMode) return;

    final DateTime? started =
        exception.requestOptions.extra[_requestStartKey] as DateTime?;

    final String elapsed = started == null
        ? '-'
        : '${DateTime.now().difference(started).inMilliseconds} ms';

    LoggerService.error(
      '''
===================== HTTP ERROR =====================

ID:
${exception.requestOptions.extra[_requestIdKey]}

Type:
${exception.type}

Status:
${exception.response?.statusCode}

Method:
${exception.requestOptions.method}

URL:
${exception.requestOptions.uri}

Elapsed:
$elapsed

Message:
${exception.message}

Response:
${_truncate(exception.response?.data)}

======================================================
''',
      error: exception,
      stackTrace: exception.stackTrace,
    );
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    final Map<String, dynamic> sanitized = Map<String, dynamic>.from(headers);

    if (sanitized.containsKey(ApiConstants.authorizationHeader)) {
      sanitized[ApiConstants.authorizationHeader] =
          'Bearer ****************************';
    }

    return sanitized;
  }

  String _truncate(Object? value) {
    if (value == null) {
      return 'null';
    }

    final String text = value.toString();

    if (text.length <= _maxLogLength) {
      return text;
    }

    return '${text.substring(0, math.min(text.length, _maxLogLength))}\n...<truncated>';
  }
}
