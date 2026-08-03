/// ============================================================================
/// File: test/unit/models/login_response_model_test.dart
/// ============================================================================
///
/// Unit Tests
///
/// LoginResponseModel
///
/// Tests:
/// • JSON deserialization
/// • JSON serialization
/// • copyWith
/// • Equality
/// • hashCode
/// • Default values
/// • Secure toString()
///
/// ============================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:notes_app/features/auth/data/models/login_response_model.dart';

import '../../helpers/mock_data.dart';
import '../../helpers/test_constants.dart';

void main() {
  group('LoginResponseModel', () {
    //---------------------------------------------------------------------------
    // fromJson
    //---------------------------------------------------------------------------

    test('fromJson should correctly parse valid JSON', () {
      final response = LoginResponseModel.fromJson(MockData.loginResponseJson);

      expect(response.accessToken, TestConstants.authToken);
      expect(response.tokenType, 'bearer');
    });

    test('fromJson should return default values for missing fields', () {
      final response = LoginResponseModel.fromJson(const <String, dynamic>{});

      expect(response.accessToken, '');
      expect(response.tokenType, '');
    });

    //---------------------------------------------------------------------------
    // toJson
    //---------------------------------------------------------------------------

    test('toJson should serialize correctly', () {
      final json = MockData.loginResponse.toJson();

      expect(json['access_token'], TestConstants.authToken);

      expect(json['token_type'], 'bearer');
    });

    //---------------------------------------------------------------------------
    // copyWith
    //---------------------------------------------------------------------------

    test('copyWith should replace provided values', () {
      final updated = MockData.loginResponse.copyWith(
        accessToken: 'NEW_TOKEN',
        tokenType: 'Bearer',
      );

      expect(updated.accessToken, 'NEW_TOKEN');
      expect(updated.tokenType, 'Bearer');
    });

    test('copyWith should preserve values when omitted', () {
      final copied = MockData.loginResponse.copyWith();

      expect(copied, equals(MockData.loginResponse));
    });

    //---------------------------------------------------------------------------
    // Equality
    //---------------------------------------------------------------------------

    test('two identical models should be equal', () {
      final model1 = MockData.loginResponse;

      final model2 = LoginResponseModel.fromJson(MockData.loginResponseJson);

      expect(model1, equals(model2));
    });

    test('models with different values should not be equal', () {
      final updated = MockData.loginResponse.copyWith(
        accessToken: 'DIFFERENT_TOKEN',
      );

      expect(updated, isNot(equals(MockData.loginResponse)));
    });

    //---------------------------------------------------------------------------
    // hashCode
    //---------------------------------------------------------------------------

    test('equal models should have identical hashCode', () {
      final model1 = MockData.loginResponse;

      final model2 = LoginResponseModel.fromJson(MockData.loginResponseJson);

      expect(model1.hashCode, model2.hashCode);
    });

    //---------------------------------------------------------------------------
    // toString
    //---------------------------------------------------------------------------

    test('toString should contain token type', () {
      final value = MockData.loginResponse.toString();

      expect(value, contains('LoginResponseModel'));
      expect(value, contains('bearer'));
    });

    test('toString should not expose JWT token', () {
      final value = MockData.loginResponse.toString();

      expect(value.contains(TestConstants.authToken), isFalse);
    });
  });
}
