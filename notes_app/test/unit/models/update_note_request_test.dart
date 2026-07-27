/// ============================================================================
/// File: test/unit/models/update_note_request_test.dart
/// ============================================================================
///
/// Unit Tests
///
/// UpdateNoteRequest
///
/// Tests:
/// • Constructor
/// • Title normalization
/// • Content normalization
/// • Update detection
/// • JSON serialization
/// • copyWith
/// • Equality
/// • hashCode
/// • toString()
///
/// ============================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:notes_app/features/notes/data/models/update_note_request.dart';

import '../../helpers/mock_data.dart';
import '../../helpers/test_constants.dart';

void main() {
  group('UpdateNoteRequest', () {
    //---------------------------------------------------------------------------
    // Constructor
    //---------------------------------------------------------------------------

    test('should create a valid request', () {
      expect(MockData.updateRequest.title, TestConstants.updatedNoteTitle);

      expect(MockData.updateRequest.content, TestConstants.updatedNoteContent);
    });

    //---------------------------------------------------------------------------
    // normalizedTitle
    //---------------------------------------------------------------------------

    test('normalizedTitle should trim whitespace', () {
      const request = UpdateNoteRequest(title: '   Updated Title   ');

      expect(request.normalizedTitle, 'Updated Title');
    });

    test('normalizedTitle returns null for blank title', () {
      const request = UpdateNoteRequest(title: '      ');

      expect(request.normalizedTitle, isNull);
    });

    //---------------------------------------------------------------------------
    // normalizedContent
    //---------------------------------------------------------------------------

    test('normalizedContent should trim whitespace', () {
      const request = UpdateNoteRequest(content: '   Updated Content   ');

      expect(request.normalizedContent, 'Updated Content');
    });

    test('normalizedContent returns null for blank content', () {
      const request = UpdateNoteRequest(content: '     ');

      expect(request.normalizedContent, isNull);
    });

    test('normalizedContent returns null when content is null', () {
      const request = UpdateNoteRequest();

      expect(request.normalizedContent, isNull);
    });

    //---------------------------------------------------------------------------
    // hasTitleUpdate
    //---------------------------------------------------------------------------

    test('hasTitleUpdate returns true when title exists', () {
      expect(MockData.updateRequest.hasTitleUpdate, isTrue);
    });

    test('hasTitleUpdate returns false for blank title', () {
      const request = UpdateNoteRequest(title: '    ');

      expect(request.hasTitleUpdate, isFalse);
    });

    //---------------------------------------------------------------------------
    // hasContentUpdate
    //---------------------------------------------------------------------------

    test('hasContentUpdate returns true when content exists', () {
      expect(MockData.updateRequest.hasContentUpdate, isTrue);
    });

    test('hasContentUpdate returns false when content is null', () {
      const request = UpdateNoteRequest();

      expect(request.hasContentUpdate, isFalse);
    });

    test('hasContentUpdate returns false for blank content', () {
      const request = UpdateNoteRequest(content: '    ');

      expect(request.hasContentUpdate, isFalse);
    });

    //---------------------------------------------------------------------------
    // hasUpdates
    //---------------------------------------------------------------------------

    test('hasUpdates returns true when title is updated', () {
      const request = UpdateNoteRequest(title: 'Updated');

      expect(request.hasUpdates, isTrue);
    });

    test('hasUpdates returns true when content is updated', () {
      const request = UpdateNoteRequest(content: 'Updated');

      expect(request.hasUpdates, isTrue);
    });

    test('hasUpdates returns false when nothing is updated', () {
      const request = UpdateNoteRequest();

      expect(request.hasUpdates, isFalse);
    });

    //---------------------------------------------------------------------------
    // toJson
    //---------------------------------------------------------------------------

    test('toJson should include both title and content', () {
      final json = MockData.updateRequest.toJson();

      expect(json['title'], TestConstants.updatedNoteTitle.trim());

      expect(json['content'], TestConstants.updatedNoteContent.trim());
    });

    test('toJson should omit null fields', () {
      const request = UpdateNoteRequest();

      final json = request.toJson();

      expect(json, isEmpty);
    });

    test('toJson should include only title when content is null', () {
      const request = UpdateNoteRequest(title: 'Updated');

      final json = request.toJson();

      expect(json['title'], 'Updated');
      expect(json.containsKey('content'), isFalse);
    });

    test('toJson should include only content when title is null', () {
      const request = UpdateNoteRequest(content: 'Updated');

      final json = request.toJson();

      expect(json['content'], 'Updated');
      expect(json.containsKey('title'), isFalse);
    });

    //---------------------------------------------------------------------------
    // copyWith
    //---------------------------------------------------------------------------

    test('copyWith should replace provided values', () {
      final updated = MockData.updateRequest.copyWith(
        title: 'Another Title',
        content: 'Another Content',
      );

      expect(updated.title, 'Another Title');
      expect(updated.content, 'Another Content');
    });

    test('copyWith should preserve existing values', () {
      final copied = MockData.updateRequest.copyWith();

      expect(copied, equals(MockData.updateRequest));
    });

    //---------------------------------------------------------------------------
    // Equality
    //---------------------------------------------------------------------------

    test('identical requests should be equal', () {
      const request = UpdateNoteRequest(
        title: TestConstants.updatedNoteTitle,
        content: TestConstants.updatedNoteContent,
      );

      expect(request, equals(MockData.updateRequest));
    });

    test('different requests should not be equal', () {
      const request = UpdateNoteRequest(title: 'Different');

      expect(request, isNot(equals(MockData.updateRequest)));
    });

    //---------------------------------------------------------------------------
    // hashCode
    //---------------------------------------------------------------------------

    test('equal requests should have identical hashCode', () {
      const request = UpdateNoteRequest(
        title: TestConstants.updatedNoteTitle,
        content: TestConstants.updatedNoteContent,
      );

      expect(request.hashCode, MockData.updateRequest.hashCode);
    });

    //---------------------------------------------------------------------------
    // toString
    //---------------------------------------------------------------------------

    test('toString should contain useful information', () {
      final value = MockData.updateRequest.toString();

      expect(value, contains('UpdateNoteRequest'));
      expect(value, contains(TestConstants.updatedNoteTitle));
    });
  });
}
