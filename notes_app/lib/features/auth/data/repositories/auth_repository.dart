import 'package:notes_app/features/auth/data/datasources/auth_remote_data_source.dart';
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
/// - Acts as the single source of authentication data.
/// - Delegates network operations to the remote data source.
/// - Returns strongly typed models.
/// - Hides networking implementation from the presentation layer.
/// - Contains authentication-related business flow.
///
/// Architecture
/// ----------------------------------------------------------------------------
///
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
/// - Repository never communicates with Dio directly.
/// - Repository never imports Flutter widgets.
/// - Repository never performs navigation.
/// - Repository never stores authentication state.
/// - Session management is handled by SessionManager in the Provider layer.
/// ============================================================================

abstract interface class AuthRepository {
  /// Registers a new user.
  Future<RegisterResponseModel> register(RegisterRequestModel request);

  /// Authenticates a user.
  Future<LoginResponseModel> login(LoginRequestModel request);

  /// Returns the currently authenticated user.
  Future<UserModel> getCurrentUser();
}

final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required this._remoteDataSource});

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<RegisterResponseModel> register(RegisterRequestModel request) {
    return _remoteDataSource.register(request);
  }

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) {
    return _remoteDataSource.login(request);
  }

  @override
  Future<UserModel> getCurrentUser() {
    return _remoteDataSource.getCurrentUser();
  }
}
