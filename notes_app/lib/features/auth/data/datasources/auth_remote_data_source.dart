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
/// - Communicates with FastAPI authentication endpoints.
/// - Converts JSON into strongly typed models.
/// - Contains no UI or business logic.
/// - Uses the centralized DioClient.
/// - Logs request lifecycle for debugging.
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

  // ===========================================================================
  // Register
  // ===========================================================================

  @override
  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    try {
      LoggerService.info('Register API request started.');

      final Response<dynamic> response = await _dio.post<dynamic>(
        ApiConstants.register,
        data: request.toJson(),
      );

      LoggerService.info(
        'Register API completed successfully. '
        'Status: ${response.statusCode}',
      );

      return RegisterResponseModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (exception, stackTrace) {
      LoggerService.error(
        'Register API failed.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Unexpected register error.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  // ===========================================================================
  // Login
  // ===========================================================================

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      LoggerService.info('Login API request started.');

      final Response<dynamic> response = await _dio.post<dynamic>(
        ApiConstants.login,
        data: request.toJson(),
      );

      LoggerService.info(
        'Login API completed successfully. '
        'Status: ${response.statusCode}',
      );

      return LoginResponseModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (exception, stackTrace) {
      LoggerService.error(
        'Login API failed.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Unexpected login error.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  // ===========================================================================
  // Current User
  // ===========================================================================

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      LoggerService.info('Current User API request started.');

      final Response<dynamic> response = await _dio.get<dynamic>(
        ApiConstants.currentUser,
      );

      LoggerService.info(
        'Current User API completed successfully. '
        'Status: ${response.statusCode}',
      );

      return UserModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (exception, stackTrace) {
      LoggerService.error(
        'Current User API failed.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Unexpected current user error.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }
}
