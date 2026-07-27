import 'dart:convert';

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
/// • Communicates with FastAPI Notes endpoints.
/// • Converts JSON responses into strongly typed models.
/// • Contains no UI or business logic.
/// • Uses the centralized DioClient.
/// • Performs lightweight response validation.
/// • Provides consistent request logging.
/// • Keeps backend contracts unchanged.
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
  /// Retrieves a paginated list of notes.
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
  Future<void> deleteNote(
    int noteId,
  );
}

final class NotesRemoteDataSourceImpl
    implements NotesRemoteDataSource {
  NotesRemoteDataSourceImpl({
    Dio? dio,
  }) : _dio = dio ?? DioClient.instance;

  final Dio _dio;

  // ===========================================================================
  // Private Helpers
  // ===========================================================================

  static String _noteEndpoint(int noteId) =>
      '${ApiConstants.notes}/$noteId';

  static Map<String, dynamic> _asJsonMap(
    dynamic value,
  ) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    throw const FormatException(
      'Expected a JSON object.',
    );
  }

  static List<dynamic> _asJsonList(
    dynamic value,
  ) {
    if (value is List<dynamic>) {
      return value;
    }

    if (value is List) {
      return List<dynamic>.from(value);
    }

    throw const FormatException(
      'Expected a JSON array.',
    );
  }

  static NoteModel _parseNote(
    dynamic value,
  ) {
    return NoteModel.fromJson(
      _asJsonMap(value),
    );
  }

  static List<NoteModel> _parseNotes(
    dynamic value,
  ) {
    final List<dynamic> list = _asJsonList(value);

    return List<NoteModel>.unmodifiable(
      list.map(_parseNote),
    );
  }

  static String _safePreview(
    Object? value,
  ) {
    if (value == null) {
      return 'null';
    }

    try {
      final String encoded = jsonEncode(value);

      if (encoded.length <= 300) {
        return encoded;
      }

      return '${encoded.substring(0, 300)}...';
    } catch (_) {
      return value.toString();
    }
  }

  void _logRequest({
    required String operation,
    required String method,
    required String endpoint,
    Map<String, dynamic>? queryParameters,
  }) {
    final String queryText = queryParameters == null
        ? ''
        : ' query=${jsonEncode(queryParameters)}';

    LoggerService.info(
      '$operation started. method=$method endpoint=$endpoint$queryText',
    );
  }

  void _logSuccess({
    required String operation,
    required Response<dynamic> response,
  }) {
    LoggerService.info(
      '$operation completed successfully. statusCode=${response.statusCode}',
    );
  }

  void _logFailure({
    required String operation,
    required Object error,
    required StackTrace stackTrace,
  }) {
    LoggerService.error(
      '$operation failed.',
      error: error,
      stackTrace: stackTrace,
    );
  }

  // ===========================================================================
  // Get Notes
  // ===========================================================================

  @override
  Future<List<NoteModel>> getNotes({
    int page = 1,
    int limit = 10,
  }) async {
    const String operation = 'Get Notes';

    try {
      _logRequest(
        operation: operation,
        method: 'GET',
        endpoint: ApiConstants.notes,
        queryParameters: <String, dynamic>{
          'page': page,
          'limit': limit,
        },
      );

      final Response<dynamic> response =
          await _dio.get<dynamic>(
        ApiConstants.notes,
        queryParameters: <String, dynamic>{
          'page': page,
          'limit': limit,
        },
      );

      _logSuccess(
        operation: operation,
        response: response,
      );

      return _parseNotes(response.data);
    } on DioException catch (
      exception,
      stackTrace
    ) {
      _logFailure(
        operation: operation,
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    } on FormatException catch (
      exception,
      stackTrace
    ) {
      LoggerService.error(
        'Invalid notes response format.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    } catch (
      exception,
      stackTrace
    ) {
      _logFailure(
        operation: operation,
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
    const String operation = 'Get Note';

    try {
      final String endpoint =
          _noteEndpoint(noteId);

      _logRequest(
        operation: operation,
        method: 'GET',
        endpoint: endpoint,
      );

      final Response<dynamic> response =
          await _dio.get<dynamic>(
        endpoint,
      );

      _logSuccess(
        operation: operation,
        response: response,
      );

      return _parseNote(response.data);
    } on DioException catch (
      exception,
      stackTrace
    ) {
      _logFailure(
        operation: operation,
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    } on FormatException catch (
      exception,
      stackTrace
    ) {
      LoggerService.error(
        'Invalid note response format.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    } catch (
      exception,
      stackTrace
    ) {
      _logFailure(
        operation: operation,
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
    const String operation = 'Create Note';

    try {
      _logRequest(
        operation: operation,
        method: 'POST',
        endpoint: ApiConstants.notes,
      );

      final Response<dynamic> response =
          await _dio.post<dynamic>(
        ApiConstants.notes,
        data: request.toJson(),
      );

      _logSuccess(
        operation: operation,
        response: response,
      );

      return _parseNote(response.data);
    } on DioException catch (
      exception,
      stackTrace
    ) {
      _logFailure(
        operation: operation,
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    } on FormatException catch (
      exception,
      stackTrace
    ) {
      LoggerService.error(
        'Invalid create note response format.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    } catch (
      exception,
      stackTrace
    ) {
      _logFailure(
        operation: operation,
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
    const String operation = 'Update Note';

    try {
      final String endpoint =
          _noteEndpoint(noteId);

      _logRequest(
        operation: operation,
        method: 'PUT',
        endpoint: endpoint,
      );

      final Response<dynamic> response =
          await _dio.put<dynamic>(
        endpoint,
        data: request.toJson(),
      );

      _logSuccess(
        operation: operation,
        response: response,
      );

      return _parseNote(response.data);
    } on DioException catch (
      exception,
      stackTrace
    ) {
      _logFailure(
        operation: operation,
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    } on FormatException catch (
      exception,
      stackTrace
    ) {
      LoggerService.error(
        'Invalid update note response format.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    } catch (
      exception,
      stackTrace
    ) {
      _logFailure(
        operation: operation,
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
    const String operation = 'Patch Note';

    try {
      final String endpoint =
          _noteEndpoint(noteId);

      _logRequest(
        operation: operation,
        method: 'PATCH',
        endpoint: endpoint,
      );

      final Response<dynamic> response =
          await _dio.patch<dynamic>(
        endpoint,
        data: request.toJson(),
      );

      _logSuccess(
        operation: operation,
        response: response,
      );

      return _parseNote(response.data);
    } on DioException catch (
      exception,
      stackTrace
    ) {
      _logFailure(
        operation: operation,
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    } on FormatException catch (
      exception,
      stackTrace
    ) {
      LoggerService.error(
        'Invalid patch note response format.',
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    } catch (
      exception,
      stackTrace
    ) {
      _logFailure(
        operation: operation,
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
    const String operation = 'Delete Note';

    try {
      final String endpoint =
          _noteEndpoint(noteId);

      _logRequest(
        operation: operation,
        method: 'DELETE',
        endpoint: endpoint,
      );

      final Response<dynamic> response =
          await _dio.delete<dynamic>(
        endpoint,
      );

      _logSuccess(
        operation: operation,
        response: response,
      );
    } on DioException catch (
      exception,
      stackTrace
    ) {
      _logFailure(
        operation: operation,
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    } catch (
      exception,
      stackTrace
    ) {
      _logFailure(
        operation: operation,
        error: exception,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }
}
