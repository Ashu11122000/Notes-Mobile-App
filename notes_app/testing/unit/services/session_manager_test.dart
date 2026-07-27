/// ============================================================================
/// File: test/unit/services/session_manager_test.dart
/// ============================================================================
///
/// Unit Tests
///
/// SessionManager
///
/// Tests:
/// • Access token persistence
/// • Refresh token persistence
/// • Authentication state
/// • Session clearing
/// • Storage cleanup
/// • Debug helper
///
/// ============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:notes_app/core/storage/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:notes_app/core/constants/storage_constants.dart';
import 'package:notes_app/core/storage/shared_preferences_service.dart';

import '../../helpers/test_constants.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    await SharedPreferencesService.initialize();
  });

  group('SessionManager - Access Token', () {
    test('saveAccessToken stores token successfully', () async {
      final result = await SessionManager.saveAccessToken(
        TestConstants.authToken,
      );

      expect(result, isTrue);

      expect(SessionManager.getAccessToken(), TestConstants.authToken);

      expect(SessionManager.hasAccessToken, isTrue);
    });

    test('saveAccessToken rejects empty token', () async {
      final result = await SessionManager.saveAccessToken('');

      expect(result, isFalse);

      expect(SessionManager.getAccessToken(), isNull);

      expect(SessionManager.hasAccessToken, isFalse);
    });

    test('getAccessToken returns null when no token exists', () {
      expect(SessionManager.getAccessToken(), isNull);
    });

    test('removeAccessToken removes stored token', () async {
      await SessionManager.saveAccessToken(TestConstants.authToken);

      final removed = await SessionManager.removeAccessToken();

      expect(removed, isTrue);

      expect(SessionManager.getAccessToken(), isNull);

      expect(SessionManager.hasAccessToken, isFalse);
    });
  });

  group('SessionManager - Refresh Token', () {
    test('saveRefreshToken stores refresh token', () async {
      final result = await SessionManager.saveRefreshToken(
        TestConstants.refreshToken,
      );

      expect(result, isTrue);

      expect(SessionManager.getRefreshToken(), TestConstants.refreshToken);
    });

    test('removeRefreshToken removes refresh token', () async {
      await SessionManager.saveRefreshToken(TestConstants.refreshToken);

      final removed = await SessionManager.removeRefreshToken();

      expect(removed, isTrue);

      expect(SessionManager.getRefreshToken(), isNull);
    });
  });

  group('SessionManager - Authentication', () {
    test('isLoggedIn returns false initially', () {
      expect(SessionManager.isLoggedIn(), isFalse);
    });

    test('isLoggedIn returns true after saving token', () async {
      await SessionManager.saveAccessToken(TestConstants.authToken);

      expect(SessionManager.isLoggedIn(), isTrue);
    });

    test('setLoggedIn stores login flag', () async {
      final result = await SessionManager.setLoggedIn(true);

      expect(result, isTrue);

      expect(
        SharedPreferencesService.getBool(StorageConstants.isLoggedIn),
        isTrue,
      );
    });

    test('setLoggedIn(false) updates login flag', () async {
      await SessionManager.setLoggedIn(true);

      await SessionManager.setLoggedIn(false);

      expect(
        SharedPreferencesService.getBool(StorageConstants.isLoggedIn),
        isFalse,
      );
    });
  });

  group('SessionManager - Session', () {
    test('clearSession removes all authentication data', () async {
      await SessionManager.saveAccessToken(TestConstants.authToken);

      await SessionManager.saveRefreshToken(TestConstants.refreshToken);

      await SessionManager.setLoggedIn(true);

      final cleared = await SessionManager.clearSession();

      expect(cleared, isTrue);

      expect(SessionManager.getAccessToken(), isNull);

      expect(SessionManager.getRefreshToken(), isNull);

      expect(
        SharedPreferencesService.containsKey(StorageConstants.accessToken),
        isFalse,
      );

      expect(
        SharedPreferencesService.containsKey(StorageConstants.refreshToken),
        isFalse,
      );

      expect(
        SharedPreferencesService.containsKey(StorageConstants.isLoggedIn),
        isFalse,
      );

      expect(SessionManager.isLoggedIn(), isFalse);
    });
  });

  group('SessionManager - Debug', () {
    test('debugSession executes without throwing', () {
      expect(SessionManager.debugSession, returnsNormally);
    });
  });

  group('SessionManager - Storage Verification', () {
    test('stored keys are present after saving tokens', () async {
      await SessionManager.saveAccessToken(TestConstants.authToken);

      await SessionManager.saveRefreshToken(TestConstants.refreshToken);

      final keys = SharedPreferencesService.getKeys();

      expect(keys, contains(StorageConstants.accessToken));

      expect(keys, contains(StorageConstants.refreshToken));

      expect(keys, contains(StorageConstants.isLoggedIn));
    });

    test('storage is empty after clearSession', () async {
      await SessionManager.saveAccessToken(TestConstants.authToken);

      await SessionManager.clearSession();

      expect(SharedPreferencesService.getKeys(), isEmpty);
    });
  });
}
