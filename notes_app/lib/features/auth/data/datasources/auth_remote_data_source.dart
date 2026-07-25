import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/services/logger_service.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';
import '../models/user_model.dart';

/// =============================================================================
/// File: auth_remote_data_source.dart
/// =============================================================================
///
/// Authentication Remote Data Source
///
/// Responsibilities
/// -----------------------------------------------------------------------------
///
/// - Communicates with the FastAPI authentication endpoints.
/// - Converts JSON into strongly typed models.
/// - Never contains UI logic.
/// - Never stores authentication state.
/// - Never communicates with Provider directly.
/// - Uses the centralized DioClient.
/// - Uses the centralized LoggerService.
///
/// =============================================================================

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
      LoggerService.info('================ REGISTER REQUEST ================');
      LoggerService.info('Base URL : ${_dio.options.baseUrl}');
      LoggerService.info('Endpoint : ${ApiConstants.register}');
      LoggerService.info(
        'Full URL : ${_dio.options.baseUrl}${ApiConstants.register}',
      );
      LoggerService.info('Request Body : ${request.toJson()}');

      final Response<dynamic> response = await _dio.post<dynamic>(
        ApiConstants.register,
        data: request.toJson(),
      );

      LoggerService.info('================ REGISTER RESPONSE ================');
      LoggerService.info('Status Code : ${response.statusCode}');
      LoggerService.info('Response Data : ${response.data}');
      LoggerService.info('Response Type : ${response.data.runtimeType}');

      return RegisterResponseModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (exception, stackTrace) {
      LoggerService.error(
        'Register API failed.',
        error: exception,
        stackTrace: stackTrace,
      );

      if (exception.response != null) {
        LoggerService.error('Status Code : ${exception.response?.statusCode}');

        LoggerService.error('Response Body : ${exception.response?.data}');
      }

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
      LoggerService.info('================ LOGIN REQUEST ================');
      LoggerService.info('Base URL : ${_dio.options.baseUrl}');
      LoggerService.info('Endpoint : ${ApiConstants.login}');
      LoggerService.info('Request Body : ${request.toJson()}');

      final Response<dynamic> response = await _dio.post<dynamic>(
        ApiConstants.login,
        data: request.toJson(),
      );

      LoggerService.info('================ LOGIN RESPONSE ================');
      LoggerService.info('Status Code : ${response.statusCode}');
      LoggerService.info('Response Data : ${response.data}');

      return LoginResponseModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (exception, stackTrace) {
      LoggerService.error(
        'Login API failed.',
        error: exception,
        stackTrace: stackTrace,
      );

      if (exception.response != null) {
        LoggerService.error('Status Code : ${exception.response?.statusCode}');

        LoggerService.error('Response Body : ${exception.response?.data}');
      }

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
      LoggerService.info(
        '================ CURRENT USER REQUEST ================',
      );
      LoggerService.info('Base URL : ${_dio.options.baseUrl}');
      LoggerService.info('Endpoint : ${ApiConstants.currentUser}');

      final Response<dynamic> response = await _dio.get<dynamic>(
        ApiConstants.currentUser,
      );

      LoggerService.info(
        '================ CURRENT USER RESPONSE ================',
      );
      LoggerService.info('Status Code : ${response.statusCode}');
      LoggerService.info('Response Data : ${response.data}');

      return UserModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (exception, stackTrace) {
      LoggerService.error(
        'Current user API failed.',
        error: exception,
        stackTrace: stackTrace,
      );

      if (exception.response != null) {
        LoggerService.error('Status Code : ${exception.response?.statusCode}');

        LoggerService.error('Response Body : ${exception.response?.data}');
      }

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
