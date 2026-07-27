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
/// • Loads current authenticated user.
/// • Exposes authentication state to UI.
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
    if (_disposed) {
      return;
    }

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

      final dynamic message = data['message'];

      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }

    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timed out.';

      case DioExceptionType.sendTimeout:
        return 'Request sending timed out.';

      case DioExceptionType.receiveTimeout:
        return 'Server response timed out.';

      case DioExceptionType.connectionError:
        return 'Unable to connect to server.';

      case DioExceptionType.badResponse:
        switch (exception.response?.statusCode) {
          case 401:
            return 'Invalid email or password.';

          case 403:
            return 'Access denied.';

          case 404:
            return 'Resource not found.';

          case 422:
            return 'Invalid information provided.';

          case 500:
            return 'Server error.';

          default:
            return 'Request failed.';
        }

      default:
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

      LoggerService.info('Registration successful.');

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
      final LoginResponseModel response = await _repository.login(request);

      final String token = response.accessToken.trim();

      if (token.isEmpty) {
        throw Exception('Authentication token was not received from server.');
      }

      final bool saved = await SessionManager.saveAccessToken(token);

      if (!saved) {
        throw Exception('Unable to save authentication session.');
      }

      _setAuthenticationState(authenticated: true);

      LoggerService.info('Login successful. JWT stored successfully.');

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
      final UserModel user = await _repository.getCurrentUser();

      _setAuthenticationState(
        authenticated: true,
        user: user,
        updateUser: true,
      );

      LoggerService.info('Current user loaded successfully.');
    } catch (error, stackTrace) {
      LoggerService.error(
        'Current user loading failed. Clearing session.',
        error: error,
        stackTrace: stackTrace,
      );

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
    final bool hasSession = SessionManager.isLoggedIn();

    if (!hasSession) {
      LoggerService.info('No existing session found.');

      return false;
    }

    try {
      await loadCurrentUser();

      return _isAuthenticated;
    } catch (error, stackTrace) {
      LoggerService.error(
        'Auto login failed.',
        error: error,
        stackTrace: stackTrace,
      );

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
