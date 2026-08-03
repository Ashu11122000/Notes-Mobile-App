/// ============================================================================
/// File: test/unit/models/register_response_model_test.dart
/// ============================================================================
///
/// Unit Tests
///
/// RegisterResponseModel
///
/// Tests:
/// • JSON deserialization
/// • JSON serialization
/// • copyWith
/// • Equality
/// • hashCode
/// • Default values
/// • toString()
///
/// ============================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:notes_app/features/auth/data/models/register_response_model.dart';

import '../../helpers/mock_data.dart';
import '../../helpers/test_constants.dart';

void main() {
  group('RegisterResponseModel', () {
    //---------------------------------------------------------------------------
    // fromJson
    //---------------------------------------------------------------------------

    test('fromJson should correctly parse valid JSON', () {
      final response = RegisterResponseModel.fromJson(
        MockData.registerResponseJson,
      );

      expect(response.message, 'User registered successfully.');

      expect(response.userId, TestConstants.userId);
    });

    test('fromJson should return default values for missing fields', () {
      final response = RegisterResponseModel.fromJson(
        const <String, dynamic>{},
      );

      expect(response.message, '');
      expect(response.userId, 0);
    });

    //---------------------------------------------------------------------------
    // toJson
    //---------------------------------------------------------------------------

    test('toJson should serialize correctly', () {
      final json = MockData.registerResponse.toJson();

      expect(json['message'], 'User registered successfully.');

      expect(json['user_id'], TestConstants.userId);
    });

    //---------------------------------------------------------------------------
    // copyWith
    //---------------------------------------------------------------------------

    test('copyWith should replace provided values', () {
      final updated = MockData.registerResponse.copyWith(
        message: 'Registration completed.',
        userId: 999,
      );

      expect(updated.message, 'Registration completed.');

      expect(updated.userId, 999);
    });

    test('copyWith should preserve values when omitted', () {
      final copied = MockData.registerResponse.copyWith();

      expect(copied, equals(MockData.registerResponse));
    });

    //---------------------------------------------------------------------------
    // Equality
    //---------------------------------------------------------------------------

    test('two identical models should be equal', () {
      final model1 = MockData.registerResponse;

      final model2 = RegisterResponseModel.fromJson(
        MockData.registerResponseJson,
      );

      expect(model1, equals(model2));
    });

    test('models with different values should not be equal', () {
      final updated = MockData.registerResponse.copyWith(userId: 500);

      expect(updated, isNot(equals(MockData.registerResponse)));
    });

    //---------------------------------------------------------------------------
    // hashCode
    //---------------------------------------------------------------------------

    test('equal models should have identical hashCode', () {
      final model1 = MockData.registerResponse;

      final model2 = RegisterResponseModel.fromJson(
        MockData.registerResponseJson,
      );

      expect(model1.hashCode, model2.hashCode);
    });

    //---------------------------------------------------------------------------
    // toString
    //---------------------------------------------------------------------------

    test('toString should contain useful information', () {
      final value = MockData.registerResponse.toString();

      expect(value, contains('RegisterResponseModel'));

      expect(value, contains('User registered successfully.'));

      expect(value, contains(TestConstants.userId.toString()));
    });
  });
}
