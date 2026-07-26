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
/// • Acts as the single source of authentication data.
/// • Delegates authentication operations to the remote data source.
/// • Exposes strongly typed models to higher layers.
/// • Hides networking implementation details from the presentation layer.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// Presentation
///        ↓
/// Provider
///        ↓
/// Repository
///        ↓
/// Remote Data Source
///        ↓
/// FastAPI
///
/// Notes
/// ----------------------------------------------------------------------------
/// • This repository intentionally remains thin.
/// • Networking, request logging, and response parsing are delegated to the
///   remote data source.
/// • The repository never communicates with Dio directly.
/// • The repository never imports Flutter widgets.
/// • The repository never performs navigation.
/// • The repository never manages authentication state.
/// • Session persistence is handled separately by SessionManager.
/// ============================================================================

abstract interface class AuthRepository {
  /// Registers a new user.
  Future<RegisterResponseModel> register(RegisterRequestModel request);

  /// Authenticates a user.
  Future<LoginResponseModel> login(LoginRequestModel request);

  /// Retrieves the currently authenticated user.
  Future<UserModel> getCurrentUser();
}

final class AuthRepositoryImpl implements AuthRepository {
  /// Creates an authentication repository.
  const AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<RegisterResponseModel> register(RegisterRequestModel request) =>
      _remoteDataSource.register(request);

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) =>
      _remoteDataSource.login(request);

  @override
  Future<UserModel> getCurrentUser() => _remoteDataSource.getCurrentUser();
}
