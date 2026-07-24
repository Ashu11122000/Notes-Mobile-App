import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../constants/api_constants.dart';

/// Singleton wrapper around Dio.
///
/// This class is the application's single entry point for all HTTP
/// communication with the FastAPI backend.
final class DioClient {
  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: <String, String>{
          ApiConstants.acceptHeader: ApiConstants.applicationJson,
          ApiConstants.contentTypeHeader: ApiConstants.applicationJson,
        },
        responseType: ResponseType.json,
      ),
    );
  }

  static final DioClient _instance = DioClient._internal();

  late final Dio _dio;

  /// Returns the shared Dio instance.
  static Dio get instance => _instance._dio;
}
