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
/// • Persists authentication session.
/// • Loads authenticated user.
/// • Exposes authentication state to the UI.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///     ↓
/// AuthProvider
///     ↓
/// AuthRepository
///     ↓
/// AuthRemoteDataSource
///     ↓
/// FastAPI
///
/// Notes
/// ----------------------------------------------------------------------------
/// • Contains presentation state only.
/// • No networking implementation.
/// • No navigation.
/// • No widget dependencies.
/// • Optimized for minimal rebuilds.
/// ============================================================================

class AuthProvider extends ChangeNotifier {
  AuthProvider({required AuthRepository repository}) : _repository = repository;

  final AuthRepository _repository;

  // ===========================================================================
  // Lifecycle
  // ===========================================================================

  bool _disposed = false;

  CancelToken? _cancelToken;

  @override
  void dispose() {
    _disposed = true;

    _cancelOngoingRequest();

    super.dispose();
  }

  // ===========================================================================
  // State
  // ===========================================================================

  bool _isLoading = false;

  bool _isAuthenticated = false;

  String? _errorMessage;

  UserModel? _currentUser;

  // ===========================================================================
  // Public Getters
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
  // Notification Helpers
  // ===========================================================================

  void _notifySafely() {
    if (_disposed) {
      return;
    }

    notifyListeners();
  }

  // ===========================================================================
  // Cancel Token Helpers
  // ===========================================================================

  CancelToken _createCancelToken() {
    _cancelOngoingRequest();

    final token = CancelToken();

    _cancelToken = token;

    return token;
  }

  void _cancelOngoingRequest() {
    final token = _cancelToken;

    if (token != null && !token.isCancelled) {
      token.cancel('Request cancelled.');
    }

    _cancelToken = null;
  }

  // ===========================================================================
  // Loading Helpers
  // ===========================================================================

  void _setLoading(bool value) {
    if (_isLoading == value) {
      return;
    }

    _isLoading = value;

    _notifySafely();
  }

  // ===========================================================================
  // Error Helpers
  // ===========================================================================

  void clearError() {
    if (_errorMessage == null) {
      return;
    }

    _errorMessage = null;

    _notifySafely();
  }

  void _setError(String? message) {
    if (_errorMessage == message) {
      return;
    }

    _errorMessage = message;

    _notifySafely();
  }

  // ===========================================================================
  // Authentication State Helpers
  // ===========================================================================

  void _setAuthenticationState({
    required bool authenticated,
    UserModel? user,
    bool updateUser = false,
  }) {
    var changed = false;

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
    _cancelOngoingRequest();

    _isAuthenticated = false;
    _currentUser = null;
    _errorMessage = null;

    _notifySafely();
  }

  // ===========================================================================
  // Exception Handling
  // ===========================================================================

  void _handleException(String operation, Object error, StackTrace stackTrace) {
    if (error is DioException && error.type == DioExceptionType.cancel) {
      LoggerService.info('$operation cancelled.');

      return;
    }

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

  // ===========================================================================
  // API Error Extraction
  // ===========================================================================

  String _extractErrorMessage(DioException exception) {
    final responseData = exception.response?.data;

    if (responseData is Map<String, dynamic>) {
      final detail = responseData['detail'];

      if (detail is String && detail.trim().isNotEmpty) {
        return detail;
      }

      final message = responseData['message'];

      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }

    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timed out.';

      case DioExceptionType.sendTimeout:
        return 'Request timed out while sending data.';

      case DioExceptionType.receiveTimeout:
        return 'Server response timed out.';

      case DioExceptionType.connectionError:
        return 'Unable to connect to the server.';

      case DioExceptionType.badCertificate:
        return 'Secure connection failed.';

      case DioExceptionType.badResponse:
        return _statusCodeMessage(exception.response?.statusCode);

      case DioExceptionType.cancel:
        return 'Request cancelled.';

      case DioExceptionType.transformTimeout:
        return 'Request timed out during response transformation.';

      case DioExceptionType.unknown:
        return exception.message ?? 'Something went wrong. Please try again.';
    }
  }

  // ===========================================================================
  // HTTP Status Messages
  // ===========================================================================

  String _statusCodeMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid request.';

      case 401:
        return 'Invalid email or password.';

      case 403:
        return 'Access denied.';

      case 404:
        return 'Requested resource was not found.';

      case 409:
        return 'Account already exists.';

      case 422:
        return 'Please check the entered information.';

      case 429:
        return 'Too many requests. Please try again later.';

      case 500:
        return 'Internal server error.';

      case 502:
        return 'Service temporarily unavailable.';

      case 503:
        return 'Server is currently unavailable.';

      default:
        return 'Request failed.';
    }
  }

  // ===========================================================================
  // Session Helpers
  // ===========================================================================

  Future<void> _saveSession(LoginResponseModel response) async {
    final token = response.accessToken.trim();

    if (token.isEmpty) {
      throw const FormatException('Authentication token is missing.');
    }

    final saved = await SessionManager.saveAccessToken(token);

    if (!saved) {
      throw Exception('Unable to save authentication session.');
    }
  }

  Future<void> _clearSession() async {
    await SessionManager.clearSession();
  }

  // ===========================================================================
  // Register
  // ===========================================================================

  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    _setLoading(true);
    clearError();

    try {
      final response = await _repository.register(
        request,
        cancelToken: _createCancelToken(),
      );

      LoggerService.info('User registration completed successfully.');

      return response;
    } on DioException catch (error, stackTrace) {
      _handleException('Registration', error, stackTrace);

      rethrow;
    } catch (error, stackTrace) {
      _handleException('Registration', error, stackTrace);

      rethrow;
    } finally {
      _cancelToken = null;
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
      final response = await _repository.login(
        request,
        cancelToken: _createCancelToken(),
      );

      await _saveSession(response);

      _setAuthenticationState(authenticated: true);

      LoggerService.info('Authentication completed successfully.');

      return response;
    } on DioException catch (error, stackTrace) {
      _handleException('Login', error, stackTrace);

      rethrow;
    } catch (error, stackTrace) {
      _handleException('Login', error, stackTrace);

      rethrow;
    } finally {
      _cancelToken = null;
      _setLoading(false);
    }
  }

  // ===========================================================================
  // Current User
  // ===========================================================================

  Future<void> loadCurrentUser() async {
    _setLoading(true);

    try {
      final user = await _repository.getCurrentUser(
        cancelToken: _createCancelToken(),
      );

      _setAuthenticationState(
        authenticated: true,
        user: user,
        updateUser: true,
      );

      LoggerService.info('Authenticated user loaded successfully.');
    } on DioException catch (error, stackTrace) {
      LoggerService.error(
        'Unable to load authenticated user.',
        error: error,
        stackTrace: stackTrace,
      );

      _handleException('Load current user', error, stackTrace);

      await logout();

      rethrow;
    } catch (error, stackTrace) {
      LoggerService.error(
        'Unexpected error while loading authenticated user.',
        error: error,
        stackTrace: stackTrace,
      );

      _handleException('Load current user', error, stackTrace);

      await logout();

      rethrow;
    } finally {
      _cancelToken = null;
      _setLoading(false);
    }
  }

  // ===========================================================================
  // Auto Login
  // ===========================================================================

  Future<bool> autoLogin() async {
    final hasSession = SessionManager.isLoggedIn() == true;

    if (!hasSession) {
      LoggerService.info('No stored authentication session found.');

      return false;
    }

    try {
      await loadCurrentUser();

      return _isAuthenticated;
    } on DioException catch (error, stackTrace) {
      LoggerService.error(
        'Automatic login failed.',
        error: error,
        stackTrace: stackTrace,
      );

      return false;
    } catch (error, stackTrace) {
      LoggerService.error(
        'Unexpected error during automatic login.',
        error: error,
        stackTrace: stackTrace,
      );

      return false;
    }
  }

  // ===========================================================================
  // Logout
  // ===========================================================================

  /// Clears the current authentication session and resets all provider state.
  Future<void> logout() async {
    _setLoading(true);

    try {
      _cancelOngoingRequest();

      await _clearSession();

      _resetState();

      LoggerService.info('User logged out successfully.');
    } catch (error, stackTrace) {
      LoggerService.error(
        'Logout failed.',
        error: error,
        stackTrace: stackTrace,
      );

      _setError('Unable to logout. Please try again.');

      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // ===========================================================================
  // Public Helpers
  // ===========================================================================

  /// Clears the current error message.
  ///
  /// Safe to call multiple times.
  void resetError() {
    clearError();
  }

  /// Refreshes the authenticated user.
  ///
  /// Useful after:
  /// • Profile update
  /// • Password change
  /// • Role update
  Future<void> refreshCurrentUser() async {
    await loadCurrentUser();
  }

  /// Returns whether a request is currently active.
  bool get hasRunningRequest =>
      _cancelToken != null && !_cancelToken!.isCancelled;

  // ===========================================================================
  // Debug Helpers
  // ===========================================================================

  @override
  String toString() {
    return 'AuthProvider('
        'isLoading: $_isLoading, '
        'isAuthenticated: $_isAuthenticated, '
        'hasUser: ${_currentUser != null}, '
        'hasError: ${_errorMessage != null}'
        ')';
  }
}
