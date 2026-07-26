import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/services/logger_service.dart';
import '../../../../core/storage/session_manager.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/login_response_model.dart';
import '../../data/models/register_request_model.dart';
import '../../data/models/register_response_model.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

/// ============================================================================
/// File: auth_provider.dart
/// ============================================================================
///
/// Authentication Provider
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Manages authentication state.
/// • Coordinates authentication workflows.
/// • Persists JWT using SessionManager.
/// • Exposes authentication state to the presentation layer.
/// • Never communicates with Dio directly.
/// • Never contains networking implementation.
/// • Minimizes unnecessary widget rebuilds.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///      ↓
/// AuthProvider
///      ↓
/// AuthRepository
///      ↓
/// AuthRemoteDataSource
///      ↓
/// FastAPI
///
/// ============================================================================

class AuthProvider extends ChangeNotifier {
  AuthProvider({required AuthRepository repository}) : _repository = repository;

  final AuthRepository _repository;

  // ===========================================================================
  // Lifecycle
  // ===========================================================================

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _notifySafely() {
    if (_disposed) return;
    notifyListeners();
  }

  // ===========================================================================
  // State
  // ===========================================================================

  bool _isLoading = false;
  bool _isAuthenticated = false;

  String? _errorMessage;

  UserModel? _currentUser;

  // ===========================================================================
  // Getters
  // ===========================================================================

  bool get isLoading => _isLoading;

  bool get isAuthenticated => _isAuthenticated;

  bool get isLoggedIn => _isAuthenticated;

  bool get hasUser => _currentUser != null;

  bool get hasError => _errorMessage != null;

  String? get errorMessage => _errorMessage;

  UserModel? get currentUser => _currentUser;

  // ===========================================================================
  // Initialization
  // ===========================================================================

  /// Initializes the authentication state when the application starts.
  Future<bool> initialize() async {
    return autoLogin();
  }

  // ===========================================================================
  // State Helpers
  // ===========================================================================

  void _setLoading(bool value) {
    if (_isLoading == value) {
      return;
    }

    _isLoading = value;
    _notifySafely();
  }

  void _setError(String? message) {
    if (_errorMessage == message) {
      return;
    }

    _errorMessage = message;
    _notifySafely();
  }

  void clearError() {
    _setError(null);
  }

  void _setAuthenticationState({
    required bool authenticated,
    UserModel? user,
    bool updateUser = false,
  }) {
    bool changed = false;

    if (_isAuthenticated != authenticated) {
      _isAuthenticated = authenticated;
      changed = true;
    }

    if (updateUser && _currentUser != user) {
      _currentUser = user;
      changed = true;
    }

    if (changed) {
      _notifySafely();
    }
  }

  void _resetState() {
    _currentUser = null;
    _isAuthenticated = false;
    _errorMessage = null;

    _notifySafely();
  }

  // ===========================================================================
  // Error Handling
  // ===========================================================================

  void _handleException(String operation, Object error, StackTrace stackTrace) {
    LoggerService.error(
      '$operation failed.',
      error: error,
      stackTrace: stackTrace,
    );

    if (error is DioException) {
      _setError(_extractErrorMessage(error));
      return;
    }

    _setError('$operation failed. Please try again.');
  }

  String _extractErrorMessage(DioException exception) {
    final dynamic data = exception.response?.data;

    if (data is Map<String, dynamic>) {
      final dynamic detail = data['detail'];

      if (detail is String && detail.trim().isNotEmpty) {
        return detail;
      }

      if (detail is List && detail.isNotEmpty) {
        final first = detail.first;

        if (first is Map<String, dynamic>) {
          final message = first['msg'];

          if (message is String && message.trim().isNotEmpty) {
            return message;
          }
        }
      }

      final dynamic message = data['message'];

      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }

    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timed out. Please try again.';

      case DioExceptionType.sendTimeout:
        return 'Sending request timed out.';

      case DioExceptionType.receiveTimeout:
        return 'Server response timed out.';

      case DioExceptionType.connectionError:
        return 'Unable to connect to the server.';

      case DioExceptionType.cancel:
        return 'Request was cancelled.';

      case DioExceptionType.badCertificate:
        return 'Secure connection failed.';

      case DioExceptionType.badResponse:
        switch (exception.response?.statusCode) {
          case 400:
            return 'Invalid request.';

          case 401:
            return 'Invalid email or password.';

          case 403:
            return 'You are not authorized to perform this action.';

          case 404:
            return 'Requested resource was not found.';

          case 409:
            return 'An account with this email already exists.';

          case 422:
            return 'Please check the entered information.';

          case 500:
            return 'Internal server error. Please try again later.';

          default:
            return 'Request failed.';
        }

      case DioExceptionType.transformTimeout:
        return 'Request processing timed out. Please try again.';

      case DioExceptionType.unknown:
        return exception.message ?? 'Something went wrong.';
    }
  }

  // ===========================================================================
  // Register
  // ===========================================================================

  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    _setLoading(true);
    clearError();

    try {
      final response = await _repository.register(request);

      LoggerService.info(
        'User registration completed successfully. User ID: ${response.userId}',
      );

      return response;
    } catch (error, stackTrace) {
      _handleException('Registration', error, stackTrace);

      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // ===========================================================================
  // Login
  // ===========================================================================

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    _setLoading(true);
    clearError();

    try {
      final response = await _repository.login(request);

      await SessionManager.saveAccessToken(response.accessToken);

      _setAuthenticationState(authenticated: true);

      LoggerService.info(
        'Authentication state updated after successful login.',
      );

      return response;
    } catch (error, stackTrace) {
      _handleException('Login', error, stackTrace);

      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // ===========================================================================
  // Current User
  // ===========================================================================

  Future<void> loadCurrentUser() async {
    _setLoading(true);

    try {
      final user = await _repository.getCurrentUser();

      _setAuthenticationState(
        authenticated: true,
        user: user,
        updateUser: true,
      );

      LoggerService.info('Authenticated user profile loaded successfully.');
    } catch (error, stackTrace) {
      _handleException('Load current user', error, stackTrace);

      await logout();
    } finally {
      _setLoading(false);
    }
  }

  // ===========================================================================
  // Auto Login
  // ===========================================================================

  Future<bool> autoLogin() async {
    if (!SessionManager.isLoggedIn()) {
      return false;
    }

    try {
      await loadCurrentUser();

      return _isAuthenticated;
    } catch (_) {
      return false;
    }
  }

  // ===========================================================================
  // Logout
  // ===========================================================================

  Future<void> logout() async {
    await SessionManager.clearSession();

    _resetState();

    LoggerService.info('User logged out successfully.');
  }
}
