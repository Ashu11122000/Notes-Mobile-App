import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:notes_app/features/auth/data/repositories/auth_repository.dart';

import '../../../../core/services/logger_service.dart';
import '../../../../core/storage/session_manager.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/login_response_model.dart';
import '../../data/models/register_request_model.dart';
import '../../data/models/register_response_model.dart';
import '../../data/models/user_model.dart';

/// ============================================================================
/// File: auth_provider.dart
/// ============================================================================
///
/// Authentication Provider
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Manages authentication state.
/// - Coordinates authentication workflows.
/// - Persists JWT using SessionManager.
/// - Exposes authentication state to the UI.
/// - Never communicates with Dio directly.
///
/// Architecture
/// ----------------------------------------------------------------------------
///
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
  AuthProvider({required this._repository});

  final AuthRepository _repository;

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

  String? get errorMessage => _errorMessage;

  UserModel? get currentUser => _currentUser;

  // ===========================================================================
  // Helpers
  // ===========================================================================

  void _setLoading(bool value) {
    if (_isLoading == value) return;

    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    if (_errorMessage == message) return;

    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _setError(null);
  }

  String _extractErrorMessage(DioException exception) {
    final dynamic data = exception.response?.data;

    if (data is Map<String, dynamic>) {
      final dynamic detail = data['detail'];

      if (detail is String && detail.isNotEmpty) {
        return detail;
      }

      final dynamic message = data['message'];

      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timed out. Please try again.';

      case DioExceptionType.sendTimeout:
        return 'Request timed out while sending data.';

      case DioExceptionType.receiveTimeout:
        return 'Server took too long to respond.';

      case DioExceptionType.connectionError:
        return 'Unable to connect to the server.';

      case DioExceptionType.cancel:
        return 'Request was cancelled.';

      case DioExceptionType.badCertificate:
        return 'Invalid SSL certificate.';

      case DioExceptionType.badResponse:
        return 'Request failed.';

      case DioExceptionType.transformTimeout:
        return 'Request transformation timed out.';

      case DioExceptionType.unknown:
        return exception.message ?? 'Something went wrong.';
    }
  }

  // ===========================================================================
  // Register
  // ===========================================================================

  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    _setLoading(true);
    _setError(null);

    try {
      final RegisterResponseModel response = await _repository.register(
        request,
      );

      LoggerService.info(
        'User registered successfully. User ID: ${response.userId}',
      );

      return response;
    } on DioException catch (error, stackTrace) {
      LoggerService.error(
        'Registration failed.',
        error: error,
        stackTrace: stackTrace,
      );

      _setError(_extractErrorMessage(error));

      rethrow;
    } catch (error, stackTrace) {
      LoggerService.error(
        'Registration failed.',
        error: error,
        stackTrace: stackTrace,
      );

      _setError('Registration failed. Please try again.');

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
    _setError(null);

    try {
      final LoginResponseModel response = await _repository.login(request);

      await SessionManager.saveAccessToken(response.accessToken);

      _isAuthenticated = true;

      notifyListeners();

      LoggerService.info('Login successful.');

      return response;
    } on DioException catch (error, stackTrace) {
      LoggerService.error(
        'Login failed.',
        error: error,
        stackTrace: stackTrace,
      );

      _setError(_extractErrorMessage(error));

      rethrow;
    } catch (error, stackTrace) {
      LoggerService.error(
        'Login failed.',
        error: error,
        stackTrace: stackTrace,
      );

      _setError('Login failed. Please try again.');

      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // ===========================================================================
  // Current User
  // ===========================================================================

  Future<void> loadCurrentUser() async {
    try {
      _currentUser = await _repository.getCurrentUser();

      _isAuthenticated = true;

      notifyListeners();
    } on DioException catch (error, stackTrace) {
      LoggerService.error(
        'Failed to load current user.',
        error: error,
        stackTrace: stackTrace,
      );

      await logout();
    } catch (error, stackTrace) {
      LoggerService.error(
        'Failed to load current user.',
        error: error,
        stackTrace: stackTrace,
      );

      await logout();
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
      return true;
    } catch (_) {
      return false;
    }
  }

  // ===========================================================================
  // Logout
  // ===========================================================================

  Future<void> logout() async {
    await SessionManager.clearSession();

    _currentUser = null;
    _isAuthenticated = false;
    _errorMessage = null;

    notifyListeners();

    LoggerService.info('User logged out.');
  }
}
