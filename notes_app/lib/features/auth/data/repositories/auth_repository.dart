import 'package:dio/dio.dart';

import '../datasources/auth_remote_data_source.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';
import '../models/user_model.dart';

/// ============================================================================
/// File: auth_repository.dart
/// ============================================================================
///
/// Authentication Repository
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Serves as the single entry point for authentication data.
/// • Delegates authentication operations to the remote data source.
/// • Hides networking implementation details.
/// • Exposes strongly typed models.
/// • Contains no business logic.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///   ↓
/// Riverpod Provider / Notifier
///   ↓
/// Repository
///   ↓
/// Remote Data Source
///   ↓
/// FastAPI
///
/// Notes
/// ----------------------------------------------------------------------------
/// • This repository intentionally remains thin.
/// • Networking is delegated to the remote data source.
/// • Authentication state is managed elsewhere.
/// • Session persistence is handled by SessionManager.
/// • The repository never communicates with Dio directly.
/// ============================================================================

abstract interface class AuthRepository {
  /// Registers a new user.
  Future<RegisterResponseModel> register(
    RegisterRequestModel request, {
    CancelToken? cancelToken,
  });

  /// Authenticates an existing user.
  Future<LoginResponseModel> login(
    LoginRequestModel request, {
    CancelToken? cancelToken,
  });

  /// Retrieves the currently authenticated user.
  Future<UserModel> getCurrentUser({CancelToken? cancelToken});
}

final class AuthRepositoryImpl implements AuthRepository {
  /// Creates an authentication repository.
  const AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<RegisterResponseModel> register(
    RegisterRequestModel request, {
    CancelToken? cancelToken,
  }) {
    return _remoteDataSource.register(request, cancelToken: cancelToken);
  }

  @override
  Future<LoginResponseModel> login(
    LoginRequestModel request, {
    CancelToken? cancelToken,
  }) {
    return _remoteDataSource.login(request, cancelToken: cancelToken);
  }

  @override
  Future<UserModel> getCurrentUser({CancelToken? cancelToken}) {
    return _remoteDataSource.getCurrentUser(cancelToken: cancelToken);
  }
}
