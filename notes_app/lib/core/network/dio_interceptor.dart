import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';
import '../services/logger_service.dart';

/// ============================================================================
/// File: dio_interceptor.dart
/// ============================================================================
///
/// Enterprise Dio interceptor.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Adds common HTTP headers.
/// • Attaches JWT access token.
/// • Logs HTTP requests.
/// • Logs HTTP responses.
/// • Logs HTTP errors.
/// • Measures request duration.
/// • Does NOT contain business logic.
/// • Does NOT perform navigation.
/// • Does NOT refresh tokens.
/// • Does NOT retry failed requests.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// DioClient
///      ↓
/// DioInterceptor
///      ↓
/// FastAPI
/// ============================================================================
@immutable
final class DioInterceptor extends Interceptor {
  const DioInterceptor({this.tokenProvider});

  /// Provides the latest JWT access token.
  final Future<String?> Function()? tokenProvider;

  static const String _requestStartKey = '_request_start_time';

  static const String _requestIdKey = '_request_id';

  static const int _maxLogLength = 2000;

  // ===========================================================================
  // Request
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

      if (tokenProvider != null) {
        final token = await tokenProvider!();

        if (token != null && token.isNotEmpty) {
          options.headers[ApiConstants.authorizationHeader] =
              ApiConstants.bearerToken(token);
        }
      }

      options.extra[_requestStartKey] = DateTime.now();

      options.extra[_requestIdKey] = DateTime.now().microsecondsSinceEpoch
          .toString();

      _logRequest(options);

      handler.next(options);
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed during request interception.',
        error: exception,
        stackTrace: stackTrace,
      );

      handler.next(options);
    }
  }

  // ===========================================================================
  // Response
  // ===========================================================================

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logResponse(response);

    handler.next(response);
  }

  // ===========================================================================
  // Error
  // ===========================================================================

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logError(err);

    handler.next(err);
  }

  // ===========================================================================
  // Logging
  // ===========================================================================

  void _logRequest(RequestOptions options) {
    if (!kDebugMode) return;

    LoggerService.info('''
==================== HTTP REQUEST ====================

ID      : ${options.extra[_requestIdKey]}
Method  : ${options.method}
URL     : ${options.uri}

Headers :
${_sanitizeHeaders(options.headers)}

Body :
${_truncate(options.data)}

======================================================
''');
  }

  void _logResponse(Response response) {
    if (!kDebugMode) return;

    final started =
        response.requestOptions.extra[_requestStartKey] as DateTime?;

    final elapsed = started == null
        ? '-'
        : '${DateTime.now().difference(started).inMilliseconds} ms';

    LoggerService.info('''
==================== HTTP RESPONSE ===================

ID      : ${response.requestOptions.extra[_requestIdKey]}
Status  : ${response.statusCode}
Method  : ${response.requestOptions.method}
URL     : ${response.requestOptions.uri}
Elapsed : $elapsed

Response :
${_truncate(response.data)}

======================================================
''');
  }

  void _logError(DioException exception) {
    if (!kDebugMode) return;

    final started =
        exception.requestOptions.extra[_requestStartKey] as DateTime?;

    final elapsed = started == null
        ? '-'
        : '${DateTime.now().difference(started).inMilliseconds} ms';

    LoggerService.error(
      '''
===================== HTTP ERROR =====================

ID      : ${exception.requestOptions.extra[_requestIdKey]}
Type    : ${exception.type}
Status  : ${exception.response?.statusCode}
Method  : ${exception.requestOptions.method}
URL     : ${exception.requestOptions.uri}
Elapsed : $elapsed

Message :
${exception.message}

Response :
${_truncate(exception.response?.data)}

======================================================
''',
      error: exception,
      stackTrace: exception.stackTrace,
    );
  }

  // ===========================================================================
  // Helpers
  // ===========================================================================

  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    final sanitized = Map<String, dynamic>.from(headers);

    if (sanitized.containsKey(ApiConstants.authorizationHeader)) {
      sanitized[ApiConstants.authorizationHeader] = 'Bearer ********';
    }

    return sanitized;
  }

  String _truncate(Object? value) {
    if (value == null) {
      return 'null';
    }

    final text = value.toString();

    if (text.length <= _maxLogLength) {
      return text;
    }

    return '${text.substring(0, math.min(text.length, _maxLogLength))}\n...<truncated>';
  }
}
