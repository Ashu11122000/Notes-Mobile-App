import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_remote_data_source.dart';
import '../models/create_note_request.dart';
import '../models/update_note_request.dart';

/// ============================================================================
/// File: notes_repository_impl.dart
/// ============================================================================
///
/// Notes Repository Implementation
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Implements the [NotesRepository] contract.
/// - Coordinates communication with the remote data source.
/// - Contains business logic (if required).
/// - Maps data models to domain entities.
/// - Keeps the presentation layer independent of networking.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// Provider
///      ↓
/// NotesRepository
///      ↓
/// NotesRepositoryImpl
///      ↓
/// NotesRemoteDataSource
///      ↓
/// FastAPI
///
/// ============================================================================

final class NotesRepositoryImpl implements NotesRepository {
  const NotesRepositoryImpl({required NotesRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final NotesRemoteDataSource _remoteDataSource;

  // ===========================================================================
  // Get Notes
  // ===========================================================================

  @override
  Future<List<Note>> getNotes({int page = 1, int limit = 10}) async {
    final models = await _remoteDataSource.getNotes(page: page, limit: limit);

    return models.map((model) => model.toEntity()).toList(growable: false);
  }

  // ===========================================================================
  // Get Note By Id
  // ===========================================================================

  @override
  Future<Note> getNoteById(int noteId) async {
    final model = await _remoteDataSource.getNoteById(noteId);

    return model.toEntity();
  }

  // ===========================================================================
  // Create Note
  // ===========================================================================

  @override
  Future<Note> createNote(CreateNoteRequest request) async {
    final model = await _remoteDataSource.createNote(request);

    return model.toEntity();
  }

  // ===========================================================================
  // Update Note (PUT)
  // ===========================================================================

  @override
  Future<Note> updateNote(int noteId, UpdateNoteRequest request) async {
    final model = await _remoteDataSource.updateNote(noteId, request);

    return model.toEntity();
  }

  // ===========================================================================
  // Patch Note (PATCH)
  // ===========================================================================

  @override
  Future<Note> patchNote(int noteId, UpdateNoteRequest request) async {
    final model = await _remoteDataSource.patchNote(noteId, request);

    return model.toEntity();
  }

  // ===========================================================================
  // Delete Note
  // ===========================================================================

  @override
  Future<void> deleteNote(int noteId) {
    return _remoteDataSource.deleteNote(noteId);
  }
}
