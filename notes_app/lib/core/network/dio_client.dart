import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import '../constants/api_constants.dart';
import '../services/logger_service.dart';
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
/// • Registers global interceptors.
/// • Shares one Dio instance across the application.
/// • Provides production-ready networking configuration.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///      ↓
/// Repository
///      ↓
/// DioClient
///      ↓
/// DioInterceptor
///      ↓
/// FastAPI
///
/// ============================================================================

final class DioClient {
  DioClient._internal() {
    _dio = Dio(_baseOptions());

    _registerInterceptors();

    if (kDebugMode) {
      LoggerService.info(
        'Dio initialized successfully.\n'
        'Base URL : ${AppConfig.baseUrl}',
      );
    }
  }

  static final DioClient _instance = DioClient._internal();

  late final Dio _dio;

  /// Shared singleton instance.
  static Dio get instance => _instance._dio;

  // ===========================================================================
  // Base Options
  // ===========================================================================

  static BaseOptions _baseOptions() {
    return BaseOptions(
      baseUrl: AppConfig.baseUrl,

      connectTimeout: AppConfig.connectTimeout,

      receiveTimeout: AppConfig.receiveTimeout,

      sendTimeout: AppConfig.sendTimeout,

      responseType: ResponseType.json,

      contentType: ApiConstants.applicationJson,

      followRedirects: false,

      persistentConnection: true,

      validateStatus: (status) =>
          status != null && status >= 200 && status < 300,

      headers: const <String, dynamic>{
        ApiConstants.acceptHeader: ApiConstants.applicationJson,
        ApiConstants.contentTypeHeader: ApiConstants.applicationJson,
        ApiConstants.userAgentHeader: 'NotesApp/1.0',
        'Accept-Encoding': 'gzip',
        'Connection': 'keep-alive',
      },
    );
  }

  // ===========================================================================
  // Interceptors
  // ===========================================================================

  void _registerInterceptors() {
    _dio.interceptors.clear();

    _dio.interceptors.add(
      DioInterceptor(
        tokenProvider: () async {
          final token = SessionManager.getAccessToken();

          if (kDebugMode) {
            LoggerService.info(
              'SessionManager returned token: '
              '${token == null ? "NULL" : "Length ${token.length}"}',
            );
          }

          return token;
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

      LoggerService.info('Dio interceptors registered successfully.');
    }
  }
}
