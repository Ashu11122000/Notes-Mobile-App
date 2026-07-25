import 'package:dio/dio.dart';

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
/// - Configures base URL.
/// - Configures timeouts.
/// - Configures default headers.
/// - Registers global interceptors.
///
/// ============================================================================

final class DioClient {
  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        responseType: ResponseType.json,
        headers: const <String, String>{
          ApiConstants.acceptHeader: ApiConstants.applicationJson,
          ApiConstants.contentTypeHeader: ApiConstants.applicationJson,
        },
      ),
    );

    // Register interceptor
    _dio.interceptors.add(
      DioInterceptor(tokenProvider: () async => SessionManager.getAccessToken()),
    );

    // Uncomment only while debugging.
    //
    // _dio.interceptors.add(
    //   LogInterceptor(
    //     request: true,
    //     requestBody: true,
    //     requestHeader: true,
    //     responseBody: true,
    //     responseHeader: false,
    //     error: true,
    //   ),
    // );
  }

  static final DioClient _instance = DioClient._internal();

  late final Dio _dio;

  static Dio get instance => _instance._dio;
}
