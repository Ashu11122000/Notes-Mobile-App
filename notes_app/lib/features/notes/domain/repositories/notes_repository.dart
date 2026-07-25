import '../../data/models/create_note_request.dart';
import '../../data/models/update_note_request.dart';
import '../entities/note.dart';

/// ============================================================================
/// File: notes_repository.dart
/// ============================================================================
///
/// Abstract contract for the Notes repository.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Expose business operations for the Notes feature.
/// - Hide the underlying data source implementation.
/// - Keep the presentation layer independent of networking.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// Presentation
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

abstract interface class NotesRepository {
  /// Retrieves paginated notes.
  Future<List<Note>> getNotes({int page = 1, int limit = 10});

  /// Retrieves a note by its identifier.
  Future<Note> getNoteById(int noteId);

  /// Creates a new note.
  Future<Note> createNote(CreateNoteRequest request);

  /// Replaces an existing note (PUT).
  Future<Note> updateNote(int noteId, UpdateNoteRequest request);

  /// Partially updates an existing note (PATCH).
  Future<Note> patchNote(int noteId, UpdateNoteRequest request);

  /// Deletes a note.
  Future<void> deleteNote(int noteId);
}
