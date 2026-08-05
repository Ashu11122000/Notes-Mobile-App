import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/services/logger_service.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';
import '../models/user_model.dart';

/// ============================================================================
/// File: auth_remote_data_source.dart
/// ============================================================================
///
/// Authentication Remote Data Source
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Communicates with FastAPI authentication endpoints.
/// • Converts JSON into strongly typed models.
/// • Contains no business logic.
/// • Uses the centralized DioClient.
/// • Supports request cancellation.
/// • Provides consistent request logging.
/// • Performs lightweight response validation.
/// ============================================================================

abstract interface class AuthRemoteDataSource {
  Future<RegisterResponseModel> register(
    RegisterRequestModel request, {
    CancelToken? cancelToken,
  });

  Future<LoginResponseModel> login(
    LoginRequestModel request, {
    CancelToken? cancelToken,
  });

  Future<UserModel> getCurrentUser({CancelToken? cancelToken});
}

final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({Dio? dio}) : _dio = dio ?? DioClient.instance;

  final Dio _dio;

  static const String _registerOperation = 'Register';
  static const String _loginOperation = 'Login';
  static const String _currentUserOperation = 'Current User';

  // ===========================================================================
  // Register
  // ===========================================================================

  @override
  Future<RegisterResponseModel> register(
    RegisterRequestModel request, {
    CancelToken? cancelToken,
  }) async {
    final json = await _request(
      method: _HttpMethod.post,
      endpoint: ApiConstants.register,
      operation: _registerOperation,
      data: request.toJson(),
      cancelToken: cancelToken,
    );

    debugPrint('Register JSON: $json');

    final model = RegisterResponseModel.fromJson(json);

    debugPrint('Register Model: $model');

    return model;
  }

  // ===========================================================================
  // Login
  // ===========================================================================

  @override
  Future<LoginResponseModel> login(
    LoginRequestModel request, {
    CancelToken? cancelToken,
  }) async {
    final json = await _request(
      method: _HttpMethod.post,
      endpoint: ApiConstants.login,
      operation: _loginOperation,
      data: request.toJson(),
      cancelToken: cancelToken,
    );

    debugPrint('Login JSON: $json');

    return LoginResponseModel.fromJson(json);
  }

  // ===========================================================================
  // Current User
  // ===========================================================================

  @override
  Future<UserModel> getCurrentUser({CancelToken? cancelToken}) async {
    final json = await _request(
      method: _HttpMethod.get,
      endpoint: ApiConstants.currentUser,
      operation: _currentUserOperation,
      cancelToken: cancelToken,
    );

    debugPrint('Current User JSON: $json');

    return UserModel.fromJson(json);
  }

  // ===========================================================================
  // Generic Request Handler
  // ===========================================================================

  Future<Map<String, dynamic>> _request({
    required _HttpMethod method,
    required String endpoint,
    required String operation,
    Object? data,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    try {
      _logRequest(
        operation: operation,
        method: method.name,
        endpoint: endpoint,
      );

      final Response<dynamic> response;

      switch (method) {
        case _HttpMethod.get:
          response = await _dio.get<dynamic>(
            endpoint,
            cancelToken: cancelToken,
            options: options,
          );

        case _HttpMethod.post:
          response = await _dio.post<dynamic>(
            endpoint,
            data: data,
            cancelToken: cancelToken,
            options: options,
          );
      }

      debugPrint('');
      debugPrint('========== HTTP RESPONSE ==========');
      debugPrint('Operation : $operation');
      debugPrint('URL       : ${response.requestOptions.uri}');
      debugPrint('Status    : ${response.statusCode}');
      debugPrint('Headers   : ${response.headers.map}');
      debugPrint('Body      : ${response.data}');
      debugPrint('===================================');
      debugPrint('');

      _logSuccess(operation: operation, statusCode: response.statusCode);

      return _parseResponse(response);
    } on DioException catch (exception, stackTrace) {
      debugPrint('');
      debugPrint('========== DIO EXCEPTION ==========');
      debugPrint('Operation : $operation');
      debugPrint('Type      : ${exception.type}');
      debugPrint('Message   : ${exception.message}');
      debugPrint('Status    : ${exception.response?.statusCode}');
      debugPrint('Response  : ${exception.response?.data}');
      debugPrint('Request   : ${exception.requestOptions.uri}');
      debugPrint('===================================');
      debugPrint('');

      LoggerService.error(
        '$operation request failed.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    } catch (exception, stackTrace) {
      debugPrint('');
      debugPrint('======= UNEXPECTED EXCEPTION =======');
      debugPrint('Operation : $operation');
      debugPrint('Error     : $exception');
      debugPrint('Type      : ${exception.runtimeType}');
      debugPrint('====================================');
      debugPrint('');

      LoggerService.error(
        'Unexpected error during $operation.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  // ===========================================================================
  // Logging Helpers
  // ===========================================================================

  void _logRequest({
    required String operation,
    required String method,
    required String endpoint,
  }) {
    LoggerService.info('$operation started. [$method] $endpoint');
  }

  void _logSuccess({required String operation, required int? statusCode}) {
    LoggerService.info(
      '$operation completed successfully. '
      'Status: ${statusCode ?? "Unknown"}',
    );
  }

  // ===========================================================================
  // Response Parser
  // ===========================================================================

  Map<String, dynamic> _parseResponse(Response<dynamic> response) {
    final statusCode = response.statusCode;

    if (statusCode == null || statusCode < 200 || statusCode >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Unexpected HTTP status code: $statusCode',
      );
    }

    final dynamic data = response.data;

    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error: 'Invalid response format received from the server.',
    );
  }
}

enum _HttpMethod {
  get('GET'),
  post('POST');

  const _HttpMethod(this.name);

  final String name;
}
