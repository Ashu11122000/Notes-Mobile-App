/// ============================================================================
/// File: test/unit/models/reminder_model_test.dart
/// ============================================================================
///
/// Unit Tests
///
/// ReminderModel
///
/// Tests:
/// • JSON serialization
/// • JSON deserialization
/// • copyWith
/// • Equality
/// • hashCode
/// • Computed properties
/// • Validation
/// • Date formatting
/// • toString()
///
/// ============================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:notes_app/features/notifications/models/reminder_model.dart';

import '../../helpers/mock_data.dart';
import '../../helpers/test_constants.dart';

void main() {
  group('ReminderModel', () {
    //---------------------------------------------------------------------------
    // fromJson
    //---------------------------------------------------------------------------

    test('fromJson should correctly deserialize JSON', () {
      final reminder = ReminderModel.fromJson(MockData.reminderJson);

      expect(reminder.notificationId, TestConstants.notificationId);
      expect(reminder.noteId, TestConstants.noteId);
      expect(reminder.title, TestConstants.notificationTitle);
      expect(reminder.body, TestConstants.notificationBody);
      expect(reminder.payload, 'note/${TestConstants.noteId}');
      expect(reminder.isEnabled, isTrue);
      expect(reminder.repeatDaily, isFalse);
    });

    test('fromJson should provide default values for missing fields', () {
      final reminder = ReminderModel.fromJson(const {});

      expect(reminder.notificationId, 0);
      expect(reminder.noteId, 0);
      expect(reminder.title, '');
      expect(reminder.body, '');
      expect(reminder.isEnabled, isTrue);
      expect(reminder.repeatDaily, isFalse);
    });

    //---------------------------------------------------------------------------
    // toJson
    //---------------------------------------------------------------------------

    test('toJson should serialize correctly', () {
      final json = MockData.reminder.toJson();

      expect(json['notification_id'], TestConstants.notificationId);
      expect(json['note_id'], TestConstants.noteId);
      expect(json['title'], TestConstants.notificationTitle);
      expect(json['body'], TestConstants.notificationBody);
      expect(json['payload'], 'note/${TestConstants.noteId}');
      expect(json['is_enabled'], true);
      expect(json['repeat_daily'], false);
      expect(json['scheduled_at'], isA<String>());
    });

    //---------------------------------------------------------------------------
    // copyWith
    //---------------------------------------------------------------------------

    test('copyWith should replace provided values', () {
      final updated = MockData.reminder.copyWith(
        title: 'Updated Reminder',
        body: 'Updated Body',
        repeatDaily: true,
      );

      expect(updated.title, 'Updated Reminder');
      expect(updated.body, 'Updated Body');
      expect(updated.repeatDaily, isTrue);

      expect(updated.notificationId, MockData.reminder.notificationId);
      expect(updated.noteId, MockData.reminder.noteId);
    });

    test('copyWith should preserve values when omitted', () {
      final copied = MockData.reminder.copyWith();

      expect(copied, equals(MockData.reminder));
    });

    //---------------------------------------------------------------------------
    // Equality
    //---------------------------------------------------------------------------

    test('identical reminders should be equal', () {
      final reminder1 = MockData.reminder;

      final reminder2 = ReminderModel.fromJson(MockData.reminderJson);

      expect(reminder1, equals(reminder2));
    });

    test('different reminders should not be equal', () {
      final updated = MockData.reminder.copyWith(title: 'Different');

      expect(updated, isNot(equals(MockData.reminder)));
    });

    //---------------------------------------------------------------------------
    // hashCode
    //---------------------------------------------------------------------------

    test('equal reminders should have identical hashCode', () {
      final reminder1 = MockData.reminder;

      final reminder2 = ReminderModel.fromJson(MockData.reminderJson);

      expect(reminder1.hashCode, reminder2.hashCode);
    });

    //---------------------------------------------------------------------------
    // Computed Properties
    //---------------------------------------------------------------------------

    test('future reminder should be upcoming', () {
      final reminder = MockData.reminder.copyWith(
        scheduledAt: DateTime.now().add(const Duration(hours: 1)),
      );

      expect(reminder.isUpcoming, isTrue);
      expect(reminder.isFuture, isTrue);
      expect(reminder.isExpired, isFalse);
      expect(reminder.isPast, isFalse);
    });

    test('past reminder should be expired', () {
      final reminder = MockData.reminder.copyWith(
        scheduledAt: DateTime.now().subtract(const Duration(hours: 1)),
      );

      expect(reminder.isExpired, isTrue);
      expect(reminder.isPast, isTrue);
      expect(reminder.isUpcoming, isFalse);
      expect(reminder.isFuture, isFalse);
    });

    //---------------------------------------------------------------------------
    // Validation
    //---------------------------------------------------------------------------

    test('valid reminder returns true', () {
      expect(MockData.reminder.isValid, isTrue);
    });

    test('empty title is invalid', () {
      final reminder = MockData.reminder.copyWith(title: '');

      expect(reminder.isValid, isFalse);
    });

    test('empty body is invalid', () {
      final reminder = MockData.reminder.copyWith(body: '');

      expect(reminder.isValid, isFalse);
    });

    //---------------------------------------------------------------------------
    // formattedDateTime
    //---------------------------------------------------------------------------

    test('formattedDateTime should not be empty', () {
      expect(MockData.reminder.formattedDateTime, isNotEmpty);
    });

    //---------------------------------------------------------------------------
    // toString
    //---------------------------------------------------------------------------

    test('toString should contain class name', () {
      expect(MockData.reminder.toString(), contains('ReminderModel'));
    });
  });
}
