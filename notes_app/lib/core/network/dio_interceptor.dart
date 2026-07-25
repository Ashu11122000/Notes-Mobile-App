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

class DioInterceptor extends Interceptor {
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
      // Default headers
      options.headers.putIfAbsent(
        ApiConstants.acceptHeader,
        () => ApiConstants.applicationJson,
      );

      options.headers.putIfAbsent(
        ApiConstants.contentTypeHeader,
        () => ApiConstants.applicationJson,
      );

      // JWT Token
      if (_tokenProvider != null) {
        final String? token = await _tokenProvider();

        if (token != null && token.isNotEmpty) {
          options.headers[ApiConstants.authorizationHeader] =
              '${ApiConstants.bearerPrefix} $token';
        }
      }

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

      handler.next(options);
    } catch (error, stackTrace) {
      LoggerService.error(
        'Request interceptor failed.',
        error: error,
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
    LoggerService.info('''
==================== HTTP RESPONSE ====================

Status : ${response.statusCode}
URL    : ${response.requestOptions.uri}

Response:
${response.data}

=======================================================
''');

    handler.next(response);
  }

  // ===========================================================================
  // Error
  // ===========================================================================

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    LoggerService.error(
      '''
===================== HTTP ERROR ======================

Type    : ${err.type}
Status  : ${err.response?.statusCode}
URL     : ${err.requestOptions.uri}

Message :
${err.message}

Response :
${err.response?.data}

=======================================================
''',
      error: err,
      stackTrace: err.stackTrace,
    );

    handler.next(err);
  }
}
