/// ============================================================================
/// File: test/unit/models/user_model_test.dart
/// ============================================================================
///
/// Unit Tests
///
/// UserModel
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

import 'package:notes_app/features/auth/data/models/user_model.dart';

import '../../helpers/mock_data.dart';
import '../../helpers/test_constants.dart';

void main() {
  group('UserModel', () {
    //---------------------------------------------------------------------------
    // fromJson
    //---------------------------------------------------------------------------

    test('fromJson should correctly parse valid JSON', () {
      final user = UserModel.fromJson(MockData.userJson);

      expect(user.id, TestConstants.userId);
      expect(user.email, TestConstants.testEmail);
      expect(user.role, 'user');
      expect(user.isActive, isTrue);
    });

    test('fromJson should return default values for missing fields', () {
      final user = UserModel.fromJson(const <String, dynamic>{});

      expect(user.id, 0);
      expect(user.email, '');
      expect(user.role, '');
      expect(user.isActive, isFalse);
    });

    //---------------------------------------------------------------------------
    // toJson
    //---------------------------------------------------------------------------

    test('toJson should serialize correctly', () {
      final json = MockData.user.toJson();

      expect(json['id'], TestConstants.userId);
      expect(json['email'], TestConstants.testEmail);
      expect(json['role'], 'user');
      expect(json['is_active'], true);
    });

    //---------------------------------------------------------------------------
    // copyWith
    //---------------------------------------------------------------------------

    test('copyWith should replace provided values', () {
      final updated = MockData.user.copyWith(
        email: TestConstants.anotherEmail,
        role: 'admin',
        isActive: false,
      );

      expect(updated.id, TestConstants.userId);
      expect(updated.email, TestConstants.anotherEmail);
      expect(updated.role, 'admin');
      expect(updated.isActive, isFalse);
    });

    test('copyWith should preserve existing values when omitted', () {
      final copied = MockData.user.copyWith();

      expect(copied.id, MockData.user.id);
      expect(copied.email, MockData.user.email);
      expect(copied.role, MockData.user.role);
      expect(copied.isActive, MockData.user.isActive);
    });

    //---------------------------------------------------------------------------
    // Equality
    //---------------------------------------------------------------------------

    test('two identical models should be equal', () {
      final user1 = MockData.user;

      final user2 = UserModel.fromJson(MockData.userJson);

      expect(user1, equals(user2));
    });

    test('models with different values should not be equal', () {
      final updated = MockData.user.copyWith(email: TestConstants.anotherEmail);

      expect(MockData.user, isNot(equals(updated)));
    });

    //---------------------------------------------------------------------------
    // hashCode
    //---------------------------------------------------------------------------

    test('equal objects should have identical hashCode', () {
      final user1 = MockData.user;

      final user2 = UserModel.fromJson(MockData.userJson);

      expect(user1.hashCode, user2.hashCode);
    });

    //---------------------------------------------------------------------------
    // toString
    //---------------------------------------------------------------------------

    test('toString should contain useful information', () {
      final value = MockData.user.toString();

      expect(value, contains('UserModel'));
      expect(value, contains(TestConstants.testEmail));
      expect(value, contains('user'));
    });
  });
}
