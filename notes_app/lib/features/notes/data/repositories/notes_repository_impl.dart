import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_remote_data_source.dart';
import '../models/create_note_request.dart';
import '../models/note_model.dart';
import '../models/update_note_request.dart';

/// ============================================================================
/// File: notes_repository_impl.dart
/// ============================================================================
///
/// Notes Repository Implementation.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Implements the domain [NotesRepository].
/// • Delegates data retrieval to the remote data source.
/// • Converts data models into domain entities.
/// • Keeps networking details out of the domain and presentation layers.
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
  // Mapping Helpers
  // ===========================================================================

  static Note _toEntity(NoteModel model) => model.toEntity();

  static List<Note> _toEntities(List<NoteModel> models) {
    return List<Note>.unmodifiable(models.map(_toEntity));
  }

  // ===========================================================================
  // Get Notes
  // ===========================================================================

  @override
  Future<List<Note>> getNotes({int page = 1, int limit = 10}) async {
    final List<NoteModel> models = await _remoteDataSource.getNotes(
      page: page,
      limit: limit,
    );

    return _toEntities(models);
  }

  // ===========================================================================
  // Get Note By Id
  // ===========================================================================

  @override
  Future<Note> getNoteById(int noteId) async {
    return _toEntity(await _remoteDataSource.getNoteById(noteId));
  }

  // ===========================================================================
  // Create Note
  // ===========================================================================

  @override
  Future<Note> createNote(CreateNoteRequest request) async {
    return _toEntity(await _remoteDataSource.createNote(request));
  }

  // ===========================================================================
  // Update Note (PUT)
  // ===========================================================================

  @override
  Future<Note> updateNote(int noteId, UpdateNoteRequest request) async {
    return _toEntity(await _remoteDataSource.updateNote(noteId, request));
  }

  // ===========================================================================
  // Patch Note (PATCH)
  // ===========================================================================

  @override
  Future<Note> patchNote(int noteId, UpdateNoteRequest request) async {
    return _toEntity(await _remoteDataSource.patchNote(noteId, request));
  }

  // ===========================================================================
  // Delete Note
  // ===========================================================================

  @override
  Future<void> deleteNote(int noteId) {
    return _remoteDataSource.deleteNote(noteId);
  }
}
