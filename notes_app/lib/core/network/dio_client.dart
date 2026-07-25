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
/// Singleton Dio Client
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Provides a single Dio instance.
/// - Configures the base URL.
/// - Configures default headers.
/// - Configures request timeouts.
/// - Registers global interceptors.
/// - Enables request/response logging in debug mode.
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
      baseUrl: AppConfig.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      sendTimeout: ApiConstants.sendTimeout,
      responseType: ResponseType.json,
      headers: const <String, String>{
        ApiConstants.acceptHeader: ApiConstants.applicationJson,
        ApiConstants.contentTypeHeader: ApiConstants.applicationJson,
      },
    );
  }

  // ===========================================================================
  // Interceptors
  // ===========================================================================

  void _registerInterceptors() {
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
        ),
      );
    }
  }
}
