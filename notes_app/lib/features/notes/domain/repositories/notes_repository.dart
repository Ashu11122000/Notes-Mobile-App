import '../../data/models/create_note_request.dart';
import '../../data/models/update_note_request.dart';
import '../entities/note.dart';

/// ============================================================================
/// File: notes_repository.dart
/// ============================================================================
///
/// Abstract contract for Notes repository.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Defines Notes business operations.
/// • Hides data source implementation details.
/// • Keeps presentation independent from networking.
/// • Provides a stable contract for the data layer.
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

  /// Retrieves paginated notes.
  Future<List<Note>> getNotes({int page = 1, int limit = 10});

  /// Retrieves a single note by identifier.
  Future<Note> getNoteById(int noteId);

  // ===========================================================================
  // Create Operation
  // ===========================================================================

  /// Creates a new note.
  Future<Note> createNote(CreateNoteRequest request);

  // ===========================================================================
  // Update Operations
  // ===========================================================================

  /// Replaces an existing note.
  ///
  /// Used for PUT requests.
  Future<Note> updateNote(int noteId, UpdateNoteRequest request);

  /// Partially updates an existing note.
  ///
  /// Used for PATCH requests.
  Future<Note> patchNote(int noteId, UpdateNoteRequest request);

  // ===========================================================================
  // Delete Operation
  // ===========================================================================

  /// Deletes a note permanently.
  Future<void> deleteNote(int noteId);
}
