import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../constants/api_constants.dart';

/// Centralized Dio interceptor.
///
/// Responsibilities:
/// - Attach common headers
/// - Attach JWT token (when available)
/// - Log requests
/// - Log responses
/// - Log errors
///
/// It must NOT contain:
/// - Navigation
/// - Business logic
/// - Logout logic
/// - UI logic
class DioInterceptor extends Interceptor {
  DioInterceptor({Logger? logger, Future<String?> Function()? tokenProvider})
    : _logger = logger ?? Logger(),
      _tokenProvider = tokenProvider;

  final Logger _logger;
  final Future<String?> Function()? _tokenProvider;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers.putIfAbsent(
      ApiConstants.acceptHeader,
      () => ApiConstants.applicationJson,
    );

    options.headers.putIfAbsent(
      ApiConstants.contentTypeHeader,
      () => ApiConstants.applicationJson,
    );

    if (_tokenProvider != null) {
      final token = await _tokenProvider();

      if (token != null && token.isNotEmpty) {
        options.headers[ApiConstants.authorizationHeader] =
            '${ApiConstants.bearerPrefix} $token';
      }
    }

    _logger.i('[REQUEST] ${options.method} ${options.uri}');

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.i(
      '[RESPONSE] ${response.statusCode} ${response.requestOptions.uri}',
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      '[ERROR] ${err.response?.statusCode ?? 'NO_STATUS'} '
      '${err.requestOptions.uri}',
      error: err.message,
      stackTrace: err.stackTrace,
    );

    handler.next(err);
  }
}
