import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import '../constants/api_constants.dart';
import '../services/logger_service.dart';
import '../storage/session_manager.dart';
import 'dio_interceptor.dart';

/// =============================================================================
/// File: dio_client.dart
/// =============================================================================
///
/// Enterprise Dio client.
///
/// Responsibilities
/// -----------------------------------------------------------------------------
/// • Provides a singleton Dio instance.
/// • Configures global networking options.
/// • Registers global interceptors.
/// • Applies default headers.
/// • Optimized for FastAPI backend.
///
/// Architecture
/// -----------------------------------------------------------------------------
/// UI
///     ↓
/// Repository
///     ↓
/// DioClient
///     ↓
/// DioInterceptor
///     ↓
/// FastAPI
///
/// =============================================================================
final class DioClient {
  DioClient._internal() {
    _dio = Dio(_createBaseOptions());

    _configureInterceptors();

    if (AppConfig.isDebug) {
      LoggerService.info(
        'Dio initialized successfully.\n'
        'Base URL: ${AppConfig.baseUrl}',
      );
    }
  }

  static final DioClient _singleton = DioClient._internal();

  late final Dio _dio;

  /// Shared Dio instance.
  static Dio get instance => _singleton._dio;

  // ===========================================================================
  // Base Options
  // ===========================================================================

  static BaseOptions _createBaseOptions() {
    return BaseOptions(
      // NOTE:
      // Using baseUrl instead of apiBaseUrl because ApiConstants
      // already contains /api/v1.
      baseUrl: AppConfig.baseUrl,

      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      sendTimeout: AppConfig.sendTimeout,

      responseType: ResponseType.json,

      contentType: ApiConstants.applicationJson,

      headers: const <String, dynamic>{
        ApiConstants.acceptHeader: ApiConstants.applicationJson,
        ApiConstants.contentTypeHeader: ApiConstants.applicationJson,
        ApiConstants.userAgentHeader: 'NotesApp/1.0',
      },

      followRedirects: false,

      persistentConnection: true,

      receiveDataWhenStatusError: true,

      listFormat: ListFormat.multiCompatible,

      validateStatus: (int? status) {
        return status != null;
      },
    );
  }

  // ===========================================================================
  // Interceptors
  // ===========================================================================

  void _configureInterceptors() {
    _dio.interceptors.add(
      DioInterceptor(
        tokenProvider: () async {
          return SessionManager.getAccessToken();
        },
      ),
    );

    if (AppConfig.isDebug) {
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
