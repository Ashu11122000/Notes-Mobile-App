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
/// • Implements the domain [NotesRepository] contract.
/// • Coordinates data source communication.
/// • Converts data models into domain entities.
/// • Keeps presentation independent from networking.
/// • Contains only data-layer logic.
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
  // Private Helpers
  // ===========================================================================

  Note _mapModelToEntity(NoteModel model) {
    return model.toEntity();
  }

  List<Note> _mapModelsToEntities(List<NoteModel> models) {
    return models.map(_mapModelToEntity).toList(growable: false);
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

    return _mapModelsToEntities(models);
  }

  // ===========================================================================
  // Get Note By Id
  // ===========================================================================

  @override
  Future<Note> getNoteById(int noteId) async {
    final NoteModel model = await _remoteDataSource.getNoteById(noteId);

    return _mapModelToEntity(model);
  }

  // ===========================================================================
  // Create Note
  // ===========================================================================

  @override
  Future<Note> createNote(CreateNoteRequest request) async {
    final NoteModel model = await _remoteDataSource.createNote(request);

    return _mapModelToEntity(model);
  }

  // ===========================================================================
  // Update Note (PUT)
  // ===========================================================================

  @override
  Future<Note> updateNote(int noteId, UpdateNoteRequest request) async {
    final NoteModel model = await _remoteDataSource.updateNote(noteId, request);

    return _mapModelToEntity(model);
  }

  // ===========================================================================
  // Patch Note (PATCH)
  // ===========================================================================

  @override
  Future<Note> patchNote(int noteId, UpdateNoteRequest request) async {
    final NoteModel model = await _remoteDataSource.patchNote(noteId, request);

    return _mapModelToEntity(model);
  }

  // ===========================================================================
  // Delete Note
  // ===========================================================================

  @override
  Future<void> deleteNote(int noteId) {
    return _remoteDataSource.deleteNote(noteId);
  }
}
