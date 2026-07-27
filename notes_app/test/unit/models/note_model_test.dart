/// ============================================================================
/// File: test/unit/models/note_model_test.dart
/// ============================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:notes_app/features/notes/data/models/note_model.dart';

import '../../helpers/mock_data.dart';
import '../../helpers/test_constants.dart';

void main() {
  group('NoteModel', () {
    //----------------------------------------------------------------------
    // fromJson
    //----------------------------------------------------------------------

    test('fromJson should parse JSON correctly', () {
      final note = NoteModel.fromJson(MockData.noteJson);

      expect(note.id, TestConstants.noteId);
      expect(note.ownerId, TestConstants.userId);
      expect(note.title, TestConstants.noteTitle);

      // fromJson normalizes content.
      expect(note.content, TestConstants.noteContent.trim());

      expect(note.createdAt, isA<DateTime>());
      expect(note.updatedAt, isA<DateTime>());
    });

    //----------------------------------------------------------------------
    // toJson
    //----------------------------------------------------------------------

    test('toJson should serialize correctly', () {
      final json = MockData.note.toJson();

      expect(json['id'], TestConstants.noteId);
      expect(json['owner_id'], TestConstants.userId);
      expect(json['title'], TestConstants.noteTitle);

      // toJson normalizes content.
      expect(json['content'], TestConstants.noteContent.trim());

      expect(json['created_at'], isNotNull);
      expect(json['updated_at'], isNotNull);
    });

    //----------------------------------------------------------------------
    // fromEntity
    //----------------------------------------------------------------------

    test('fromEntity should create identical model', () {
      final entity = MockData.note.toEntity();

      final model = NoteModel.fromEntity(entity);

      expect(model.id, entity.id);
      expect(model.ownerId, entity.ownerId);
      expect(model.title, entity.title);
      expect(model.content, entity.content);
      expect(model.createdAt, entity.createdAt);
      expect(model.updatedAt, entity.updatedAt);
    });

    //----------------------------------------------------------------------
    // toEntity
    //----------------------------------------------------------------------

    test('toEntity should convert model to domain entity', () {
      final entity = MockData.note.toEntity();

      expect(entity.id, MockData.note.id);
      expect(entity.ownerId, MockData.note.ownerId);
      expect(entity.title, MockData.note.title);
      expect(entity.content, MockData.note.content);
    });

    //----------------------------------------------------------------------
    // copyWith
    //----------------------------------------------------------------------

    test('copyWith should replace provided values', () {
      final updated = MockData.note.copyWith(
        title: TestConstants.updatedNoteTitle,
        content: TestConstants.updatedNoteContent,
      );

      expect(updated.title, TestConstants.updatedNoteTitle);

      // copyWith preserves the value exactly as provided.
      expect(updated.content, TestConstants.updatedNoteContent);

      expect(updated.id, MockData.note.id);
      expect(updated.ownerId, MockData.note.ownerId);
      expect(updated.createdAt, MockData.note.createdAt);
      expect(updated.updatedAt, MockData.note.updatedAt);
    });

    test('copyWith should keep original values when omitted', () {
      final copied = MockData.note.copyWith();

      expect(copied.id, MockData.note.id);
      expect(copied.ownerId, MockData.note.ownerId);
      expect(copied.title, MockData.note.title);
      expect(copied.content, MockData.note.content);
      expect(copied.createdAt, MockData.note.createdAt);
      expect(copied.updatedAt, MockData.note.updatedAt);
    });

    //----------------------------------------------------------------------
    // hasContent
    //----------------------------------------------------------------------

    test('hasContent returns true when content exists', () {
      expect(MockData.note.hasContent, isTrue);
    });

    test('hasContent returns false when content is null', () {
      final note = NoteModel(
        id: 1,
        ownerId: 1,
        title: 'Title',
        content: null,
        createdAt: DateTime.fromMillisecondsSinceEpoch(0),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
      );

      expect(note.hasContent, isFalse);
    });

    //----------------------------------------------------------------------
    // isEmpty / isNotEmpty
    //----------------------------------------------------------------------

    test('isEmpty returns false for valid note', () {
      expect(MockData.note.isEmpty, isFalse);
    });

    test('isNotEmpty returns true for valid note', () {
      expect(MockData.note.isNotEmpty, isTrue);
    });

    test('empty title and content produce empty note', () {
      final note = NoteModel(
        id: 1,
        ownerId: 1,
        title: '',
        content: '',
        createdAt: DateTime.fromMillisecondsSinceEpoch(0),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
      );

      expect(note.isEmpty, isTrue);
      expect(note.isNotEmpty, isFalse);
    });

    //----------------------------------------------------------------------
    // Content normalization
    //----------------------------------------------------------------------

    test('fromJson should trim title', () {
      final json = Map<String, dynamic>.from(MockData.noteJson)
        ..['title'] = '   Shopping List   ';

      final note = NoteModel.fromJson(json);

      expect(note.title, 'Shopping List');
    });

    test('fromJson should trim content', () {
      final json = Map<String, dynamic>.from(MockData.noteJson)
        ..['content'] = '   Hello World   ';

      final note = NoteModel.fromJson(json);

      expect(note.content, 'Hello World');
    });

    test('fromJson should convert blank content to null', () {
      final json = Map<String, dynamic>.from(MockData.noteJson)
        ..['content'] = '     ';

      final note = NoteModel.fromJson(json);

      expect(note.content, isNull);
    });

    //----------------------------------------------------------------------
    // toString
    //----------------------------------------------------------------------

    test('toString contains useful information', () {
      final value = MockData.note.toString();

      expect(value, contains('NoteModel'));
      expect(value, contains(TestConstants.noteTitle));
    });
  });
}
