import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/services/logger_service.dart';
import '../models/create_note_request.dart';
import '../models/note_model.dart';
import '../models/update_note_request.dart';

/// ============================================================================
/// File: notes_remote_data_source.dart
/// ============================================================================
///
/// Notes Remote Data Source
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Communicates with FastAPI Notes endpoints.
/// - Converts JSON into strongly typed models.
/// - Contains no UI or business logic.
/// - Uses the centralized DioClient.
/// - Logs request lifecycle for debugging.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// Provider
///      ↓
/// Repository
///      ↓
/// NotesRemoteDataSource
///      ↓
/// FastAPI
///
/// ============================================================================

abstract interface class NotesRemoteDataSource {
  /// Retrieves paginated notes.
  Future<List<NoteModel>> getNotes({
    int page = 1,
    int limit = 10,
  });

  /// Retrieves a note by its identifier.
  Future<NoteModel> getNoteById(int noteId);

  /// Creates a new note.
  Future<NoteModel> createNote(
    CreateNoteRequest request,
  );

  /// Replaces an existing note.
  Future<NoteModel> updateNote(
    int noteId,
    UpdateNoteRequest request,
  );

  /// Partially updates an existing note.
  Future<NoteModel> patchNote(
    int noteId,
    UpdateNoteRequest request,
  );

  /// Deletes a note.
  Future<void> deleteNote(int noteId);
}

final class NotesRemoteDataSourceImpl
    implements NotesRemoteDataSource {
  NotesRemoteDataSourceImpl({
    Dio? dio,
  }) : _dio = dio ?? DioClient.instance;

  final Dio _dio;

  // ===========================================================================
  // Get Notes
  // ===========================================================================

  @override
  Future<List<NoteModel>> getNotes({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      LoggerService.info(
        'Get Notes API request started. '
        'Page: $page, Limit: $limit',
      );

      final Response<dynamic> response =
          await _dio.get<dynamic>(
        ApiConstants.notes,
        queryParameters: <String, dynamic>{
          'page': page,
          'limit': limit,
        },
      );

      LoggerService.info(
        'Get Notes API completed successfully. '
        'Status: ${response.statusCode}',
      );

      final List<dynamic> data =
          response.data as List<dynamic>;

      return data
          .map(
            (dynamic item) => NoteModel.fromJson(
              Map<String, dynamic>.from(
                item as Map,
              ),
            ),
          )
          .toList(growable: false);
    } on DioException catch (
      exception,
      stackTrace
    ) {
      LoggerService.error(
        'Get Notes API failed.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Unexpected get notes error.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  // ===========================================================================
  // Get Note By Id
  // ===========================================================================

  @override
  Future<NoteModel> getNoteById(
    int noteId,
  ) async {
    try {
      LoggerService.info(
        'Get Note API request started. '
        'Note ID: $noteId',
      );

      final Response<dynamic> response =
          await _dio.get<dynamic>(
        '${ApiConstants.notes}/$noteId',
      );

      LoggerService.info(
        'Get Note API completed successfully. '
        'Status: ${response.statusCode}',
      );

      return NoteModel.fromJson(
        Map<String, dynamic>.from(
          response.data as Map,
        ),
      );
    } on DioException catch (
      exception,
      stackTrace
    ) {
      LoggerService.error(
        'Get Note API failed.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    } catch (
      exception,
      stackTrace
    ) {
      LoggerService.error(
        'Unexpected get note error.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  // ===========================================================================
  // Create Note
  // ===========================================================================

  @override
  Future<NoteModel> createNote(
    CreateNoteRequest request,
  ) async {
    try {
      LoggerService.info(
        'Create Note API request started.',
      );

      final Response<dynamic> response =
          await _dio.post<dynamic>(
        ApiConstants.notes,
        data: request.toJson(),
      );

      LoggerService.info(
        'Create Note API completed successfully. '
        'Status: ${response.statusCode}',
      );

      return NoteModel.fromJson(
        Map<String, dynamic>.from(
          response.data as Map,
        ),
      );
    } on DioException catch (
      exception,
      stackTrace
    ) {
      LoggerService.error(
        'Create Note API failed.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    } catch (
      exception,
      stackTrace
    ) {
      LoggerService.error(
        'Unexpected create note error.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

    // ===========================================================================
  // Update Note (PUT)
  // ===========================================================================

  @override
  Future<NoteModel> updateNote(
    int noteId,
    UpdateNoteRequest request,
  ) async {
    try {
      LoggerService.info(
        'Update Note API request started. '
        'Note ID: $noteId',
      );

      final Response<dynamic> response = await _dio.put<dynamic>(
        '${ApiConstants.notes}/$noteId',
        data: request.toJson(),
      );

      LoggerService.info(
        'Update Note API completed successfully. '
        'Status: ${response.statusCode}',
      );

      return NoteModel.fromJson(
        Map<String, dynamic>.from(
          response.data as Map,
        ),
      );
    } on DioException catch (
      exception,
      stackTrace
    ) {
      LoggerService.error(
        'Update Note API failed.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    } catch (
      exception,
      stackTrace
    ) {
      LoggerService.error(
        'Unexpected update note error.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  // ===========================================================================
  // Patch Note (PATCH)
  // ===========================================================================

  @override
  Future<NoteModel> patchNote(
    int noteId,
    UpdateNoteRequest request,
  ) async {
    try {
      LoggerService.info(
        'Patch Note API request started. '
        'Note ID: $noteId',
      );

      final Response<dynamic> response = await _dio.patch<dynamic>(
        '${ApiConstants.notes}/$noteId',
        data: request.toJson(),
      );

      LoggerService.info(
        'Patch Note API completed successfully. '
        'Status: ${response.statusCode}',
      );

      return NoteModel.fromJson(
        Map<String, dynamic>.from(
          response.data as Map,
        ),
      );
    } on DioException catch (
      exception,
      stackTrace
    ) {
      LoggerService.error(
        'Patch Note API failed.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    } catch (
      exception,
      stackTrace
    ) {
      LoggerService.error(
        'Unexpected patch note error.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  // ===========================================================================
  // Delete Note
  // ===========================================================================

  @override
  Future<void> deleteNote(
    int noteId,
  ) async {
    try {
      LoggerService.info(
        'Delete Note API request started. '
        'Note ID: $noteId',
      );

      final Response<dynamic> response = await _dio.delete<dynamic>(
        '${ApiConstants.notes}/$noteId',
      );

      LoggerService.info(
        'Delete Note API completed successfully. '
        'Status: ${response.statusCode}',
      );
    } on DioException catch (
      exception,
      stackTrace
    ) {
      LoggerService.error(
        'Delete Note API failed.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    } catch (
      exception,
      stackTrace
    ) {
      LoggerService.error(
        'Unexpected delete note error.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }
}