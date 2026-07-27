/// ============================================================================
/// File: test/helpers/mock_data.dart
/// ============================================================================
///
/// Shared mock models and JSON fixtures.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Provides reusable DTOs.
/// • Provides reusable JSON payloads.
/// • Provides reusable domain objects.
/// • Avoids duplicated setup across tests.
/// • Contains no mocking or business logic.
///
/// ============================================================================

import 'package:notes_app/features/auth/data/models/login_response_model.dart';
import 'package:notes_app/features/auth/data/models/register_response_model.dart';
import 'package:notes_app/features/auth/data/models/user_model.dart';
import 'package:notes_app/features/notes/data/models/create_note_request.dart';
import 'package:notes_app/features/notes/data/models/note_model.dart';
import 'package:notes_app/features/notes/data/models/paginated_notes_response.dart';
import 'package:notes_app/features/notes/data/models/update_note_request.dart';
import 'package:notes_app/features/notifications/models/reminder_model.dart';
import 'package:notes_app/shared/models/pagination_meta.dart';
import 'package:notes_app/shared/models/pagination_response.dart';

import 'test_constants.dart';
import 'test_helpers.dart';

/// Shared mock objects for the entire test suite.
final class MockData {
  MockData._();

  // ===========================================================================
  // Authentication JSON
  // ===========================================================================

  static final Map<String, dynamic> loginResponseJson = {
    'access_token': TestConstants.authToken,
    'token_type': 'bearer',
  };

  static final Map<String, dynamic> registerResponseJson = {
    'message': 'User registered successfully.',
    'user_id': TestConstants.userId,
  };

  static final Map<String, dynamic> userJson = {
    'id': TestConstants.userId,
    'email': TestConstants.testEmail,
    'role': 'user',
    'is_active': true,
  };

  // ===========================================================================
  // Authentication Models
  // ===========================================================================

  static final LoginResponseModel loginResponse = LoginResponseModel.fromJson(
    loginResponseJson,
  );

  static final RegisterResponseModel registerResponse =
      RegisterResponseModel.fromJson(registerResponseJson);

  static final UserModel user = UserModel.fromJson(userJson);

  // ===========================================================================
  // Note JSON
  // ===========================================================================

  static final Map<String, dynamic> noteJson = {
    'id': TestConstants.noteId,
    'owner_id': TestConstants.userId,
    'title': TestConstants.noteTitle,
    'content': TestConstants.noteContent,
    'created_at': TestHelpers.fixedDate().toIso8601String(),
    'updated_at': TestHelpers.fixedDate().toIso8601String(),
  };

  static final Map<String, dynamic> secondNoteJson = {
    'id': TestConstants.anotherNoteId,
    'owner_id': TestConstants.userId,
    'title': 'Work Tasks',
    'content': 'Prepare presentation',
    'created_at': TestHelpers.fixedDate().toIso8601String(),
    'updated_at': TestHelpers.fixedDate().toIso8601String(),
  };

  // ===========================================================================
  // Note Models
  // ===========================================================================

  static final NoteModel note = NoteModel.fromJson(noteJson);

  static final NoteModel secondNote = NoteModel.fromJson(secondNoteJson);

  static final List<NoteModel> notes = [note, secondNote];

  // ===========================================================================
  // Create / Update Requests
  // ===========================================================================

  static const CreateNoteRequest createRequest = CreateNoteRequest(
    title: TestConstants.noteTitle,
    content: TestConstants.noteContent,
  );

  static const UpdateNoteRequest updateRequest = UpdateNoteRequest(
    title: TestConstants.updatedNoteTitle,
    content: TestConstants.updatedNoteContent,
  );

  // ===========================================================================
  // Reminder JSON
  // ===========================================================================

  static final Map<String, dynamic> reminderJson = {
    'notification_id': TestConstants.notificationId,
    'note_id': TestConstants.noteId,
    'title': TestConstants.notificationTitle,
    'body': TestConstants.notificationBody,
    'scheduled_at': TestHelpers.futureDate().toIso8601String(),
    'payload': 'note/${TestConstants.noteId}',
    'is_enabled': true,
    'repeat_daily': false,
  };

  // ===========================================================================
  // Reminder Model
  // ===========================================================================

  static final ReminderModel reminder = ReminderModel.fromJson(reminderJson);

  // ===========================================================================
  // Pagination
  // ===========================================================================

  static const PaginationMeta paginationMeta = PaginationMeta(
    page: 1,
    size: 10,
    total: 2,
    pages: 1,
  );

  static final PaginationResponse<NoteModel> paginationResponse =
      PaginationResponse<NoteModel>(items: notes, meta: paginationMeta);

  static final PaginatedNotesResponse paginatedNotes = PaginatedNotesResponse(
    response: paginationResponse,
  );

  // ===========================================================================
  // Collections
  // ===========================================================================

  static final List<Map<String, dynamic>> notesJson = [
    noteJson,
    secondNoteJson,
  ];

  static final Map<String, dynamic> paginatedResponseJson = {
    'items': notesJson,
    'meta': paginationMeta.toJson(),
  };

  // ===========================================================================
  // Empty Responses
  // ===========================================================================

  static const PaginationMeta emptyPaginationMeta = PaginationMeta(
    page: 1,
    size: 10,
    total: 0,
    pages: 0,
  );

  static final PaginatedNotesResponse emptyPaginatedNotes =
      PaginatedNotesResponse.empty();

  // ===========================================================================
  // Error Responses
  // ===========================================================================

  static const Map<String, dynamic> unauthorizedError = {
    'detail': 'Unauthorized',
  };

  static const Map<String, dynamic> validationError = {
    'detail': 'Validation failed',
  };

  static const Map<String, dynamic> serverError = {
    'detail': 'Internal server error',
  };
}
