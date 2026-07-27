/// ============================================================================
/// File: test/unit/models/create_note_request_test.dart
/// ============================================================================
///
/// Unit Tests
///
/// CreateNoteRequest
///
/// Tests:
/// • Constructor
/// • Title normalization
/// • Content normalization
/// • Validation
/// • JSON serialization
/// • copyWith
/// • Equality
/// • hashCode
/// • toString()
///
/// ============================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:notes_app/features/notes/data/models/create_note_request.dart';

import '../../helpers/mock_data.dart';
import '../../helpers/test_constants.dart';

void main() {
  group('CreateNoteRequest', () {
    //---------------------------------------------------------------------------
    // Constructor
    //---------------------------------------------------------------------------

    test('should create a valid request', () {
      expect(MockData.createRequest.title, TestConstants.noteTitle);

      expect(MockData.createRequest.content, TestConstants.noteContent);
    });

    //---------------------------------------------------------------------------
    // normalizedTitle
    //---------------------------------------------------------------------------

    test('normalizedTitle should trim whitespace', () {
      const request = CreateNoteRequest(title: '   Shopping List   ');

      expect(request.normalizedTitle, 'Shopping List');
    });

    //---------------------------------------------------------------------------
    // normalizedContent
    //---------------------------------------------------------------------------

    test('normalizedContent should trim whitespace', () {
      const request = CreateNoteRequest(
        title: 'Title',
        content: '   Hello World   ',
      );

      expect(request.normalizedContent, 'Hello World');
    });

    test('normalizedContent returns null for blank content', () {
      const request = CreateNoteRequest(title: 'Title', content: '      ');

      expect(request.normalizedContent, isNull);
    });

    test('normalizedContent returns null when content is null', () {
      const request = CreateNoteRequest(title: 'Title');

      expect(request.normalizedContent, isNull);
    });

    //---------------------------------------------------------------------------
    // Validation
    //---------------------------------------------------------------------------

    test('isValid returns true for valid title', () {
      expect(MockData.createRequest.isValid, isTrue);
    });

    test('isValid returns false for blank title', () {
      const request = CreateNoteRequest(title: '      ');

      expect(request.isValid, isFalse);
    });

    test('hasContent returns true when content exists', () {
      expect(MockData.createRequest.hasContent, isTrue);
    });

    test('hasContent returns false when content is null', () {
      const request = CreateNoteRequest(title: 'Title');

      expect(request.hasContent, isFalse);
    });

    test('canSubmit mirrors isValid', () {
      expect(MockData.createRequest.canSubmit, isTrue);

      const invalid = CreateNoteRequest(title: '    ');

      expect(invalid.canSubmit, isFalse);
    });

    //---------------------------------------------------------------------------
    // toJson
    //---------------------------------------------------------------------------

    test('toJson should include title and content', () {
      final json = MockData.createRequest.toJson();

      expect(json['title'], TestConstants.noteTitle);

      expect(json['content'], TestConstants.noteContent);
    });

    test('toJson should omit null content', () {
      const request = CreateNoteRequest(title: 'Shopping');

      final json = request.toJson();

      expect(json.containsKey('content'), isFalse);
    });

    test('toJson should omit blank content', () {
      const request = CreateNoteRequest(title: 'Shopping', content: '      ');

      final json = request.toJson();

      expect(json.containsKey('content'), isFalse);
    });

    //---------------------------------------------------------------------------
    // copyWith
    //---------------------------------------------------------------------------

    test('copyWith should replace provided values', () {
      final updated = MockData.createRequest.copyWith(
        title: TestConstants.updatedNoteTitle,
        content: TestConstants.updatedNoteContent,
      );

      expect(updated.title, TestConstants.updatedNoteTitle);

      expect(updated.content, TestConstants.updatedNoteContent);
    });

    test('copyWith should preserve existing values', () {
      final copied = MockData.createRequest.copyWith();

      expect(copied, equals(MockData.createRequest));
    });

    //---------------------------------------------------------------------------
    // Equality
    //---------------------------------------------------------------------------

    test('identical requests should be equal', () {
      const request = CreateNoteRequest(
        title: TestConstants.noteTitle,
        content: TestConstants.noteContent,
      );

      expect(request, equals(MockData.createRequest));
    });

    test('different requests should not be equal', () {
      const request = CreateNoteRequest(
        title: 'Different',
        content: TestConstants.noteContent,
      );

      expect(request, isNot(equals(MockData.createRequest)));
    });

    //---------------------------------------------------------------------------
    // hashCode
    //---------------------------------------------------------------------------

    test('equal requests should have identical hashCode', () {
      const request = CreateNoteRequest(
        title: TestConstants.noteTitle,
        content: TestConstants.noteContent,
      );

      expect(request.hashCode, MockData.createRequest.hashCode);
    });

    //---------------------------------------------------------------------------
    // toString
    //---------------------------------------------------------------------------

    test('toString should contain useful information', () {
      final value = MockData.createRequest.toString();

      expect(value, contains('CreateNoteRequest'));

      expect(value, contains(TestConstants.noteTitle));
    });
  });
}
