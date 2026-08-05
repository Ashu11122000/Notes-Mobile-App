import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';
import '../services/logger_service.dart';

/// =============================================================================
/// File: dio_interceptor.dart
/// =============================================================================
///
/// Enterprise Dio Interceptor.
///
/// Responsibilities
/// -----------------------------------------------------------------------------
/// • Adds default HTTP headers.
/// • Attaches JWT access token.
/// • Measures request duration.
/// • Logs requests, responses, and errors (Debug only).
/// • Sanitizes sensitive headers before logging.
/// • Contains no business logic.
///
/// =============================================================================
@immutable
final class DioInterceptor extends Interceptor {
  const DioInterceptor({required this.tokenProvider});

  /// Returns the current JWT access token.
  final Future<String?> Function() tokenProvider;

  static const String _requestIdKey = '_request_id';
  static const String _stopwatchKey = '_stopwatch';

  static const int _maxLogLength = 1500;

  // ===========================================================================
  // REQUEST
  // ===========================================================================

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // -----------------------------------------------------------------------
      // Default Headers
      // -----------------------------------------------------------------------

      options.headers.putIfAbsent(
        ApiConstants.acceptHeader,
        () => ApiConstants.applicationJson,
      );

      options.headers.putIfAbsent(
        ApiConstants.contentTypeHeader,
        () => ApiConstants.applicationJson,
      );

      // -----------------------------------------------------------------------
      // Authorization
      // -----------------------------------------------------------------------

      final String? token = await tokenProvider();

      if (token != null && token.trim().isNotEmpty) {
        options.headers[ApiConstants.authorizationHeader] =
            ApiConstants.bearerToken(token);
      }

      // -----------------------------------------------------------------------
      // Request Metadata
      // -----------------------------------------------------------------------

      options.extra[_requestIdKey] = DateTime.now().microsecondsSinceEpoch
          .toString();

      options.extra[_stopwatchKey] = Stopwatch()..start();

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
  void onResponse(
  Response<dynamic> response,
  ResponseInterceptorHandler handler,
) {
    _logResponse(response);

    handler.next(response);
  }

  // ===========================================================================
  // ERROR
  // ===========================================================================

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logError(err);

    handler.next(err);
  }

  // ===========================================================================
  // REQUEST LOGGING
  // ===========================================================================

  void _logRequest(RequestOptions options) {
    if (!kDebugMode) return;

    LoggerService.info('''
────────────────── HTTP REQUEST ──────────────────

ID       : ${options.extra[_requestIdKey]}
Method   : ${options.method}
URL      : ${options.uri}

Headers:
${_sanitizeHeaders(options.headers)}

Body:
${_truncate(options.data)}

──────────────────────────────────────────────────
''');
  }

  // ===========================================================================
  // RESPONSE LOGGING
  // ===========================================================================

  void _logResponse(Response<dynamic> response) {
    if (!kDebugMode) return;

    final Stopwatch? stopwatch =
        response.requestOptions.extra[_stopwatchKey] as Stopwatch?;

    stopwatch?.stop();

    LoggerService.info('''
────────────────── HTTP RESPONSE ─────────────────

ID       : ${response.requestOptions.extra[_requestIdKey]}
Status   : ${response.statusCode}
Method   : ${response.requestOptions.method}
URL      : ${response.requestOptions.uri}
Elapsed  : ${stopwatch?.elapsedMilliseconds ?? '-'} ms

Response:
${_truncate(response.data)}

──────────────────────────────────────────────────
''');
  }

  // ===========================================================================
  // ERROR LOGGING
  // ===========================================================================

  void _logError(DioException exception) {
    if (!kDebugMode) return;

    final Stopwatch? stopwatch =
        exception.requestOptions.extra[_stopwatchKey] as Stopwatch?;

    stopwatch?.stop();

    LoggerService.error(
      '''
──────────────────── HTTP ERROR ──────────────────

ID       : ${exception.requestOptions.extra[_requestIdKey]}
Type     : ${exception.type}
Status   : ${exception.response?.statusCode}
Method   : ${exception.requestOptions.method}
URL      : ${exception.requestOptions.uri}
Elapsed  : ${stopwatch?.elapsedMilliseconds ?? '-'} ms

Message:
${exception.message}

Response:
${_truncate(exception.response?.data)}

──────────────────────────────────────────────────
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
          '${ApiConstants.bearerPrefix} ********';
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

    return '${text.substring(0, math.min(text.length, _maxLogLength))}\n... <truncated>';
  }
}
