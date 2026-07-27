import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import '../constants/api_constants.dart';
import '../storage/session_manager.dart';
import 'dio_interceptor.dart';

/// ============================================================================
/// File: dio_client.dart
/// ============================================================================
///
/// Enterprise Dio Client.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Provides singleton Dio instance.
/// • Configures HTTP client.
/// • Applies global headers.
/// • Registers interceptors.
/// • Handles debug logging.
///
/// Base URL comes from AppConfig.
/// Endpoint paths come from ApiConstants.
///
/// ============================================================================

final class DioClient {
  DioClient._internal() {
    _dio = Dio(_baseOptions());

    _registerInterceptors();
  }

  static final DioClient _instance = DioClient._internal();

  late final Dio _dio;

  /// Shared Dio instance.
  static Dio get instance => _instance._dio;

  // ===========================================================================
  // Base Options
  // ===========================================================================

  static BaseOptions _baseOptions() {
    return BaseOptions(
      // IMPORTANT:
      // Do NOT use AppConfig.apiBaseUrl here.
      //
      // ApiConstants already contains /api/v1.
      //
      baseUrl: AppConfig.baseUrl,

      connectTimeout: AppConfig.connectTimeout,

      receiveTimeout: AppConfig.receiveTimeout,

      sendTimeout: AppConfig.sendTimeout,

      responseType: ResponseType.json,

      contentType: ApiConstants.applicationJson,

      headers: const <String, String>{
        ApiConstants.acceptHeader: ApiConstants.applicationJson,

        ApiConstants.contentTypeHeader: ApiConstants.applicationJson,

        ApiConstants.userAgentHeader: 'NotesApp/1.0',
      },

      followRedirects: true,

      validateStatus: (status) {
        return status != null && status >= 200 && status < 300;
      },
    );
  }

  // ===========================================================================
  // Interceptors
  // ===========================================================================

  void _registerInterceptors() {
    if (_dio.interceptors.isNotEmpty) {
      return;
    }

    _dio.interceptors.add(
      DioInterceptor(
        tokenProvider: () async {
          return SessionManager.getAccessToken();
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,

          requestHeader: true,

          requestBody: true,

          responseHeader: false,

          responseBody: true,

          error: true,

          logPrint: (Object object) {
            debugPrint(object.toString());
          },
        ),
      );
    }
  }
}
