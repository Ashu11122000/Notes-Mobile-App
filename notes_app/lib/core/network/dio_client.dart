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
/// • Provides a singleton Dio instance.
/// • Configures base options.
/// • Applies global HTTP headers.
/// • Registers application interceptors.
/// • Enables request logging in debug builds.
/// • Centralizes networking configuration.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// Repository
///      ↓
/// DioClient
///      ↓
/// Dio
///      ↓
/// FastAPI
///
/// This client intentionally owns only HTTP configuration.
/// Business logic belongs inside repositories.
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
      baseUrl: AppConfig.apiBaseUrl,

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
      DioInterceptor(tokenProvider: () async => SessionManager.getAccessToken()),
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
          logPrint: (Object object) => debugPrint(object.toString()),
        ),
      );
    }
  }
}
