import 'package:dio/dio.dart';

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
/// • Provides consistent request logging.
/// • Performs lightweight response validation.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// Provider
///      ↓
/// Repository
///      ↓
/// AuthRemoteDataSource
///      ↓
/// FastAPI
///
/// ============================================================================

abstract interface class AuthRemoteDataSource {
  Future<RegisterResponseModel> register(RegisterRequestModel request);

  Future<LoginResponseModel> login(LoginRequestModel request);

  Future<UserModel> getCurrentUser();
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
  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    final json = await _post(
      endpoint: ApiConstants.register,
      operation: _registerOperation,
      data: request.toJson(),
    );

    return RegisterResponseModel.fromJson(json);
  }

  // ===========================================================================
  // Login
  // ===========================================================================

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final json = await _post(
      endpoint: ApiConstants.login,
      operation: _loginOperation,
      data: request.toJson(),
    );

    return LoginResponseModel.fromJson(json);
  }

  // ===========================================================================
  // Current User
  // ===========================================================================

  @override
  Future<UserModel> getCurrentUser() async {
    final json = await _get(
      endpoint: ApiConstants.currentUser,
      operation: _currentUserOperation,
    );

    return UserModel.fromJson(json);
  }

  // ===========================================================================
  // POST Helper
  // ===========================================================================

  Future<Map<String, dynamic>> _post({
    required String endpoint,
    required String operation,
    required Object? data,
  }) async {
    try {
      LoggerService.info('$operation API request started. [POST] $endpoint');

      final Response<dynamic> response = await _dio.post<dynamic>(
        endpoint,
        data: data,
      );

      LoggerService.info(
        '$operation API completed successfully. '
        'Status: ${response.statusCode}',
      );

      return _parseResponse(response);
    } on DioException catch (exception, stackTrace) {
      LoggerService.error(
        '$operation API failed.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Unexpected error during $operation API.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  // ===========================================================================
  // GET Helper
  // ===========================================================================

  Future<Map<String, dynamic>> _get({
    required String endpoint,
    required String operation,
  }) async {
    try {
      LoggerService.info('$operation API request started. [GET] $endpoint');

      final Response<dynamic> response = await _dio.get<dynamic>(endpoint);

      LoggerService.info(
        '$operation API completed successfully. '
        'Status: ${response.statusCode}',
      );

      return _parseResponse(response);
    } on DioException catch (exception, stackTrace) {
      LoggerService.error(
        '$operation API failed.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Unexpected error during $operation API.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  // ===========================================================================
  // Response Parser
  // ===========================================================================

  /// Ensures every API response is a JSON object before model conversion.
  ///
  /// This avoids runtime cast exceptions if an unexpected payload is returned
  /// by the server or an upstream proxy.
  Map<String, dynamic> _parseResponse(Response<dynamic> response) {
    final data = response.data;

    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      error: 'Invalid response format received from server.',
      type: DioExceptionType.badResponse,
    );
  }
}
