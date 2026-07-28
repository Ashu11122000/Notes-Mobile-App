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
/// • Uses the centralized DioClient.
/// • Validates API responses.
/// • Performs request/response logging.
/// • Contains no UI or business logic.
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
  Future<List<NoteModel>> getNotes({
    int page,
    int limit,
    CancelToken? cancelToken,
  });

  Future<NoteModel> getNoteById(int noteId, {CancelToken? cancelToken});

  Future<NoteModel> createNote(
    CreateNoteRequest request, {
    CancelToken? cancelToken,
  });

  Future<NoteModel> updateNote(
    int noteId,
    UpdateNoteRequest request, {
    CancelToken? cancelToken,
  });

  Future<NoteModel> patchNote(
    int noteId,
    UpdateNoteRequest request, {
    CancelToken? cancelToken,
  });

  Future<void> deleteNote(int noteId, {CancelToken? cancelToken});
}

/// ============================================================================
/// Implementation
/// ============================================================================

final class NotesRemoteDataSourceImpl implements NotesRemoteDataSource {
  NotesRemoteDataSourceImpl({Dio? dio}) : _dio = dio ?? DioClient.instance;

  final Dio _dio;

  // ===========================================================================
  // Endpoint Helpers
  // ===========================================================================

  static String _noteEndpoint(int noteId) => ApiConstants.noteById(noteId);

  // ===========================================================================
  // JSON Helpers
  // ===========================================================================

  static Map<String, dynamic> _asJsonMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    throw const FormatException('Expected JSON object.');
  }

  static List<dynamic> _asJsonList(dynamic value) {
    if (value is List<dynamic>) {
      return value;
    }

    if (value is List) {
      return List<dynamic>.from(value);
    }

    throw const FormatException('Expected JSON array.');
  }

  static NoteModel _parseNote(dynamic json) {
    return NoteModel.fromJson(_asJsonMap(json));
  }

  static List<NoteModel> _parseNotes(dynamic json) {
    dynamic data = json;

    if (data is Map) {
      data = data['items'] ?? data['data'] ?? data;
    }

    final List<dynamic> notes = _asJsonList(data);

    return List<NoteModel>.unmodifiable(
      notes.map((dynamic item) => NoteModel.fromJson(_asJsonMap(item))),
    );
  }

  // ===========================================================================
  // Logging Helpers
  // ===========================================================================

  static String _preview(Object? value) {
    if (value == null) {
      return 'null';
    }

    try {
      final String json = jsonEncode(value);

      return json.length <= 400 ? json : '${json.substring(0, 400)}...';
    } catch (_) {
      return value.toString();
    }
  }

  void _logRequest({
    required String operation,
    required String method,
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Object? body,
  }) {
    LoggerService.info('''
==================== NOTES REQUEST ====================

Operation : $operation
Method    : $method
Endpoint  : $endpoint
Query     : ${queryParameters ?? 'none'}
Body      : ${_preview(body)}

=======================================================
''');
  }

  void _logResponse({
    required String operation,
    required Response<dynamic> response,
  }) {
    LoggerService.info('''
==================== NOTES RESPONSE ===================

Operation : $operation
Status    : ${response.statusCode}
Endpoint  : ${response.requestOptions.uri}
Response  : ${_preview(response.data)}

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
  // Shared Request Executor
  // ===========================================================================

  Future<Response<dynamic>> _executeRequest({
    required String operation,
    required Future<Response<dynamic>> Function() request,
  }) async {
    try {
      final Response<dynamic> response = await request();

      _logResponse(operation: operation, response: response);

      return response;
    } on DioException catch (error, stackTrace) {
      _logError(operation, error, stackTrace);

      rethrow;
    } catch (error, stackTrace) {
      _logError(operation, error, stackTrace);

      rethrow;
    }
  }

  // ===========================================================================
  // CRUD METHODS
  // ===========================================================================
  @override
  Future<List<NoteModel>> getNotes({
    int page = 1,
    int limit = 10,
    CancelToken? cancelToken,
  }) async {
    const String operation = 'Get Notes';

    final Map<String, dynamic> queryParameters = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    _logRequest(
      operation: operation,
      method: 'GET',
      endpoint: ApiConstants.notes,
      queryParameters: queryParameters,
    );

    final Response<dynamic> response = await _executeRequest(
      operation: operation,
      request: () => _dio.get<dynamic>(
        ApiConstants.notes,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      ),
    );

    try {
      return _parseNotes(response.data);
    } on FormatException catch (error, stackTrace) {
      _logError('Invalid notes response format', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<NoteModel> getNoteById(int noteId, {CancelToken? cancelToken}) async {
    const String operation = 'Get Note';

    final String endpoint = _noteEndpoint(noteId);

    _logRequest(operation: operation, method: 'GET', endpoint: endpoint);

    final Response<dynamic> response = await _executeRequest(
      operation: operation,
      request: () => _dio.get<dynamic>(endpoint, cancelToken: cancelToken),
    );

    try {
      return _parseNote(response.data);
    } on FormatException catch (error, stackTrace) {
      _logError('Invalid note response format', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<NoteModel> createNote(
    CreateNoteRequest request, {
    CancelToken? cancelToken,
  }) async {
    const String operation = 'Create Note';

    final Map<String, dynamic> payload = request.toJson();

    _logRequest(
      operation: operation,
      method: 'POST',
      endpoint: ApiConstants.notes,
      body: payload,
    );

    final Response<dynamic> response = await _executeRequest(
      operation: operation,
      request: () => _dio.post<dynamic>(
        ApiConstants.notes,
        data: payload,
        cancelToken: cancelToken,
      ),
    );

    try {
      return _parseNote(response.data);
    } on FormatException catch (error, stackTrace) {
      _logError('Invalid create note response format', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<NoteModel> updateNote(
    int noteId,
    UpdateNoteRequest request, {
    CancelToken? cancelToken,
  }) async {
    const String operation = 'Update Note';

    final String endpoint = _noteEndpoint(noteId);
    final Map<String, dynamic> payload = request.toJson();

    _logRequest(
      operation: operation,
      method: 'PUT',
      endpoint: endpoint,
      body: payload,
    );

    final Response<dynamic> response = await _executeRequest(
      operation: operation,
      request: () =>
          _dio.put<dynamic>(endpoint, data: payload, cancelToken: cancelToken),
    );

    try {
      return _parseNote(response.data);
    } on FormatException catch (error, stackTrace) {
      _logError('Invalid update note response format', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<NoteModel> patchNote(
    int noteId,
    UpdateNoteRequest request, {
    CancelToken? cancelToken,
  }) async {
    const String operation = 'Patch Note';

    final String endpoint = _noteEndpoint(noteId);
    final Map<String, dynamic> payload = request.toJson();

    _logRequest(
      operation: operation,
      method: 'PATCH',
      endpoint: endpoint,
      body: payload,
    );

    final Response<dynamic> response = await _executeRequest(
      operation: operation,
      request: () => _dio.patch<dynamic>(
        endpoint,
        data: payload,
        cancelToken: cancelToken,
      ),
    );

    try {
      return _parseNote(response.data);
    } on FormatException catch (error, stackTrace) {
      _logError('Invalid patch note response format', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteNote(int noteId, {CancelToken? cancelToken}) async {
    const String operation = 'Delete Note';

    final String endpoint = _noteEndpoint(noteId);

    _logRequest(operation: operation, method: 'DELETE', endpoint: endpoint);

    await _executeRequest(
      operation: operation,
      request: () => _dio.delete<dynamic>(endpoint, cancelToken: cancelToken),
    );
  }
}
