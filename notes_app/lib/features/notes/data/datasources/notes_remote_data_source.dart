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
  /// Retrieves paginated notes.
  Future<List<NoteModel>> getNotes({int page = 1, int limit = 10});

  /// Retrieves note by id.
  Future<NoteModel> getNoteById(int noteId);

  /// Creates note.
  Future<NoteModel> createNote(CreateNoteRequest request);

  /// Updates note using PUT.
  Future<NoteModel> updateNote(int noteId, UpdateNoteRequest request);

  /// Updates note partially using PATCH.
  Future<NoteModel> patchNote(int noteId, UpdateNoteRequest request);

  /// Deletes note.
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

  /// Supports:
  ///
  /// Response:
  ///
  /// [
  ///   {...},
  ///   {...}
  /// ]
  ///
  /// AND
  ///
  /// {
  ///   "items":[...],
  ///   "total":100
  /// }
  ///
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

  void _logRequest({
    required String operation,
    required String method,
    required String endpoint,
    Map<String, dynamic>? queryParameters,
  }) {
    LoggerService.info('''
$operation started.

Method:
$method

Endpoint:
$endpoint

Query:
${queryParameters ?? 'none'}
''');
  }

  void _logResponse({required String operation, required Response response}) {
    LoggerService.info('''
$operation successful.

Status:
${response.statusCode}

Response:
${_preview(response.data)}
''');
  }

  void _logError(String operation, Object error, StackTrace stackTrace) {
    LoggerService.error(
      '$operation failed.',
      error: error,
      stackTrace: stackTrace,
    );
  }

  Options get _jsonOptions {
    return Options(
      headers: <String, String>{
        ApiConstants.contentTypeHeader: ApiConstants.applicationJson,

        ApiConstants.acceptHeader: ApiConstants.applicationJson,
      },
    );
  }

  // ===========================================================================
  // Get Notes
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
  // Get Note By ID
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
  // Create Note
  // ===========================================================================

  @override
  Future<NoteModel> createNote(CreateNoteRequest request) async {
    const String operation = 'Create Note';

    try {
      _logRequest(
        operation: operation,
        method: 'POST',
        endpoint: ApiConstants.notes,
      );

      final Response<dynamic> response = await _dio.post<dynamic>(
        ApiConstants.notes,

        data: request.toJson(),

        options: _jsonOptions,
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
  // Update Note PUT
  // ===========================================================================

  @override
  Future<NoteModel> updateNote(int noteId, UpdateNoteRequest request) async {
    const String operation = 'Update Note';

    try {
      final String endpoint = _noteEndpoint(noteId);

      _logRequest(operation: operation, method: 'PUT', endpoint: endpoint);

      final Response<dynamic> response = await _dio.put<dynamic>(
        endpoint,

        data: request.toJson(),

        options: _jsonOptions,
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
  // Patch Note PATCH
  // ===========================================================================

  @override
  Future<NoteModel> patchNote(int noteId, UpdateNoteRequest request) async {
    const String operation = 'Patch Note';

    try {
      final String endpoint = _noteEndpoint(noteId);

      _logRequest(operation: operation, method: 'PATCH', endpoint: endpoint);

      final Response<dynamic> response = await _dio.patch<dynamic>(
        endpoint,
        data: request.toJson(),
        options: _jsonOptions,
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
  // Delete Note
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
