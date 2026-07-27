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
/// • Uses centralized DioClient.
/// • Handles API response validation.
/// • Contains no UI/business logic.
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
  Future<List<NoteModel>> getNotes({int page, int limit});

  Future<NoteModel> getNoteById(int noteId);

  Future<NoteModel> createNote(CreateNoteRequest request);

  Future<NoteModel> updateNote(int noteId, UpdateNoteRequest request);

  Future<NoteModel> patchNote(int noteId, UpdateNoteRequest request);

  Future<void> deleteNote(int noteId);
}

/// ============================================================================
/// Implementation
/// ============================================================================

final class NotesRemoteDataSourceImpl implements NotesRemoteDataSource {
  NotesRemoteDataSourceImpl({Dio? dio}) : _dio = dio ?? DioClient.instance;

  final Dio _dio;

  // ===========================================================================
  // Helpers
  // ===========================================================================

  static String _noteEndpoint(int noteId) {
    return ApiConstants.noteById(noteId);
  }

  static Map<String, dynamic> _toJsonMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    throw const FormatException('Expected JSON object.');
  }

  static List<dynamic> _toJsonList(dynamic value) {
    if (value is List<dynamic>) {
      return value;
    }

    if (value is List) {
      return List<dynamic>.from(value);
    }

    throw const FormatException('Expected JSON list.');
  }

  static List<NoteModel> _parseNotes(dynamic response) {
    dynamic data = response;

    if (data is Map) {
      if (data.containsKey('items')) {
        data = data['items'];
      } else if (data.containsKey('data')) {
        data = data['data'];
      }
    }

    final List<dynamic> notes = _toJsonList(data);

    return List<NoteModel>.unmodifiable(
      notes.map((item) => NoteModel.fromJson(_toJsonMap(item))),
    );
  }

  static NoteModel _parseNote(dynamic response) {
    return NoteModel.fromJson(_toJsonMap(response));
  }

  static String _preview(Object? value) {
    if (value == null) {
      return 'null';
    }

    try {
      final String json = jsonEncode(value);

      if (json.length <= 500) {
        return json;
      }

      return '${json.substring(0, 500)}...';
    } catch (_) {
      return value.toString();
    }
  }

  // ===========================================================================
  // Logging Helpers
  // ===========================================================================

  void _logRequest({
    required String operation,
    required String method,
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Object? body,
  }) {
    LoggerService.info('''
==================== NOTES REQUEST ====================

Operation:
$operation

Method:
$method

Endpoint:
$endpoint

Query:
${queryParameters ?? 'none'}

Body:
${_preview(body)}

=======================================================
''');
  }

  void _logResponse({required String operation, required Response response}) {
    LoggerService.info('''
==================== NOTES RESPONSE ===================

Operation:
$operation

Status:
${response.statusCode}

Endpoint:
${response.requestOptions.uri}

Response:
${_preview(response.data)}

=======================================================
''');
  }

  void _logError(String operation, Object error, StackTrace stackTrace) {
    LoggerService.error(
      '$operation failed.',
      error: error,
      stackTrace: stackTrace,
    );
  }

  // ===========================================================================
  // GET NOTES
  // ===========================================================================

  @override
  Future<List<NoteModel>> getNotes({int page = 1, int limit = 10}) async {
    const String operation = 'Get Notes';

    try {
      _logRequest(
        operation: operation,
        method: 'GET',
        endpoint: ApiConstants.notes,
        queryParameters: <String, dynamic>{'page': page, 'limit': limit},
      );

      final Response<dynamic> response = await _dio.get<dynamic>(
        ApiConstants.notes,
        queryParameters: <String, dynamic>{'page': page, 'limit': limit},
      );

      _logResponse(operation: operation, response: response);

      return _parseNotes(response.data);
    } on DioException catch (exception, stackTrace) {
      _logError(operation, exception, stackTrace);

      rethrow;
    } on FormatException catch (exception, stackTrace) {
      _logError('Invalid notes response format', exception, stackTrace);

      rethrow;
    } catch (exception, stackTrace) {
      _logError(operation, exception, stackTrace);

      rethrow;
    }
  }

  // ===========================================================================
  // GET NOTE BY ID
  // ===========================================================================

  @override
  Future<NoteModel> getNoteById(int noteId) async {
    const String operation = 'Get Note';

    try {
      final String endpoint = _noteEndpoint(noteId);

      _logRequest(operation: operation, method: 'GET', endpoint: endpoint);

      final Response<dynamic> response = await _dio.get<dynamic>(endpoint);

      _logResponse(operation: operation, response: response);

      return _parseNote(response.data);
    } on DioException catch (exception, stackTrace) {
      _logError(operation, exception, stackTrace);

      rethrow;
    } on FormatException catch (exception, stackTrace) {
      _logError('Invalid note response format', exception, stackTrace);

      rethrow;
    } catch (exception, stackTrace) {
      _logError(operation, exception, stackTrace);

      rethrow;
    }
  }

  // ===========================================================================
  // CREATE NOTE
  // ===========================================================================

  @override
  Future<NoteModel> createNote(CreateNoteRequest request) async {
    const String operation = 'Create Note';

    try {
      _logRequest(
        operation: operation,
        method: 'POST',
        endpoint: ApiConstants.notes,
        body: request.toJson(),
      );

      final Response<dynamic> response = await _dio.post<dynamic>(
        ApiConstants.notes,
        data: request.toJson(),
      );

      _logResponse(operation: operation, response: response);

      return _parseNote(response.data);
    } on DioException catch (exception, stackTrace) {
      _logError(operation, exception, stackTrace);

      rethrow;
    } on FormatException catch (exception, stackTrace) {
      _logError('Invalid create note response format', exception, stackTrace);

      rethrow;
    } catch (exception, stackTrace) {
      _logError(operation, exception, stackTrace);

      rethrow;
    }
  }

  // ===========================================================================
  // UPDATE NOTE (PUT)
  // ===========================================================================

  @override
  Future<NoteModel> updateNote(int noteId, UpdateNoteRequest request) async {
    const String operation = 'Update Note';

    try {
      final String endpoint = _noteEndpoint(noteId);

      _logRequest(
        operation: operation,
        method: 'PUT',
        endpoint: endpoint,
        body: request.toJson(),
      );

      final Response<dynamic> response = await _dio.put<dynamic>(
        endpoint,
        data: request.toJson(),
      );

      _logResponse(operation: operation, response: response);

      return _parseNote(response.data);
    } on DioException catch (exception, stackTrace) {
      _logError(operation, exception, stackTrace);

      rethrow;
    } on FormatException catch (exception, stackTrace) {
      _logError('Invalid update note response format', exception, stackTrace);

      rethrow;
    } catch (exception, stackTrace) {
      _logError(operation, exception, stackTrace);

      rethrow;
    }
  }

  // ===========================================================================
  // PATCH NOTE
  // ===========================================================================

  @override
  Future<NoteModel> patchNote(int noteId, UpdateNoteRequest request) async {
    const String operation = 'Patch Note';

    try {
      final String endpoint = _noteEndpoint(noteId);

      _logRequest(
        operation: operation,
        method: 'PATCH',
        endpoint: endpoint,
        body: request.toJson(),
      );

      final Response<dynamic> response = await _dio.patch<dynamic>(
        endpoint,
        data: request.toJson(),
      );

      _logResponse(operation: operation, response: response);

      return _parseNote(response.data);
    } on DioException catch (exception, stackTrace) {
      _logError(operation, exception, stackTrace);

      rethrow;
    } on FormatException catch (exception, stackTrace) {
      _logError('Invalid patch note response format', exception, stackTrace);

      rethrow;
    } catch (exception, stackTrace) {
      _logError(operation, exception, stackTrace);

      rethrow;
    }
  }

  // ===========================================================================
  // DELETE NOTE
  // ===========================================================================

  @override
  Future<void> deleteNote(int noteId) async {
    const String operation = 'Delete Note';

    try {
      final String endpoint = _noteEndpoint(noteId);

      _logRequest(operation: operation, method: 'DELETE', endpoint: endpoint);

      final Response<dynamic> response = await _dio.delete<dynamic>(endpoint);

      _logResponse(operation: operation, response: response);
    } on DioException catch (exception, stackTrace) {
      _logError(operation, exception, stackTrace);

      rethrow;
    } catch (exception, stackTrace) {
      _logError(operation, exception, stackTrace);

      rethrow;
    }
  }
}
