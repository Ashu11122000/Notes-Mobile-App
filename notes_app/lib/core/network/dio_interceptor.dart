import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../services/logger_service.dart';

/// ============================================================================
/// File: dio_interceptor.dart
/// ============================================================================
///
/// Centralized Dio Interceptor
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Adds common HTTP headers.
/// - Attaches JWT access token when available.
/// - Logs all HTTP requests.
/// - Logs all HTTP responses.
/// - Logs all HTTP errors.
/// - Does NOT contain business logic.
/// - Does NOT perform navigation.
/// - Does NOT perform logout.
/// - Does NOT retry requests.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// DioClient
///      ↓
/// DioInterceptor
///      ↓
/// FastAPI
///
/// ============================================================================

final class DioInterceptor extends Interceptor {
  const DioInterceptor({Future<String?> Function()? tokenProvider})
    : _tokenProvider = tokenProvider;

  final Future<String?> Function()? _tokenProvider;

  // ===========================================================================
  // Request
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
      // Authorization Header
      // -----------------------------------------------------------------------

      if (_tokenProvider != null) {
        final String? token = await _tokenProvider();

        if (token != null && token.isNotEmpty) {
          options.headers[ApiConstants.authorizationHeader] =
              '${ApiConstants.bearerTokenPrefix}$token';
        }
      }

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
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logResponse(response);

    handler.next(response);
  }

  // ===========================================================================
  // Error
  // ===========================================================================

  @override
  void onError(DioException exception, ErrorInterceptorHandler handler) {
    _logError(exception);

    handler.next(exception);
  }

  // ===========================================================================
  // Private Logging Helpers
  // ===========================================================================

  void _logRequest(RequestOptions options) {
    LoggerService.info('''
==================== HTTP REQUEST ====================

Method : ${options.method}
URL    : ${options.uri}

Headers:
${options.headers}

Body:
${options.data}

======================================================
''');
  }

  void _logResponse(Response<dynamic> response) {
    LoggerService.info('''
==================== HTTP RESPONSE ====================

Status : ${response.statusCode}
URL    : ${response.requestOptions.uri}

Response:
${response.data}

=======================================================
''');
  }

  void _logError(DioException exception) {
    LoggerService.error(
      '''
===================== HTTP ERROR ======================

Type    : ${exception.type}
Status  : ${exception.response?.statusCode}
URL     : ${exception.requestOptions.uri}

Message :
${exception.message}

Response :
${exception.response?.data}

=======================================================
''',
      error: exception,
      stackTrace: exception.stackTrace,
    );
  }
}
