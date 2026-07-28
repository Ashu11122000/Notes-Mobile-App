import '../../data/models/create_note_request.dart';
import '../../data/models/update_note_request.dart';
import '../entities/note.dart';

/// ============================================================================
/// File: notes_repository.dart
/// ============================================================================
///
/// Contract for the Notes repository.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Defines all Notes-related business operations.
/// • Hides data source implementation details.
/// • Keeps the presentation layer independent from networking.
/// • Serves as the abstraction implemented by the data layer.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// Presentation
///      ↓
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

abstract interface class NotesRepository {
  // ===========================================================================
  // Read Operations
  // ===========================================================================

  /// Retrieves a paginated list of notes.
  Future<List<Note>> getNotes({int page = 1, int limit = 10});

  /// Retrieves a single note by its identifier.
  Future<Note> getNoteById(int noteId);

  // ===========================================================================
  // Create
  // ===========================================================================

  /// Creates a new note.
  Future<Note> createNote(CreateNoteRequest request);

  // ===========================================================================
  // Update
  // ===========================================================================

  /// Replaces an existing note.
  ///
  /// Uses the HTTP PUT operation.
  Future<Note> updateNote(int noteId, UpdateNoteRequest request);

  /// Partially updates an existing note.
  ///
  /// Uses the HTTP PATCH operation.
  Future<Note> patchNote(int noteId, UpdateNoteRequest request);

  // ===========================================================================
  // Delete
  // ===========================================================================

  /// Permanently deletes a note.
  Future<void> deleteNote(int noteId);
}
