import 'package:flutter/foundation.dart';

import '../../data/models/create_note_request.dart';
import '../../data/models/update_note_request.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';

/// ============================================================================
/// File: notes_provider.dart
/// ============================================================================
///
/// Notes Provider
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Manages Notes UI state.
/// - Coordinates CRUD operations.
/// - Handles pagination.
/// - Supports local searching.
/// - Exposes loading and error states.
/// - Notifies listeners when state changes.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///     ↓
/// NotesProvider
///     ↓
/// NotesRepository
///     ↓
/// NotesRemoteDataSource
///
/// ============================================================================

final class NotesProvider extends ChangeNotifier {
  NotesProvider({required NotesRepository repository})
    : _repository = repository;

  final NotesRepository _repository;

  // ===========================================================================
  // State
  // ===========================================================================

  /// Complete list received from the repository.
  final List<Note> _allNotes = <Note>[];

  /// Filtered list exposed to the UI.
  final List<Note> _notes = <Note>[];

  /// Currently selected note.
  Note? _selectedNote;

  /// Loading state for most operations.
  bool _isLoading = false;

  /// Loading state for pagination.
  bool _isLoadingMore = false;

  /// Latest error message.
  String? _errorMessage;

  /// Current pagination page.
  int _currentPage = 1;

  /// Items per page.
  static const int _pageSize = 10;

  /// Indicates whether another page exists.
  bool _hasMore = true;

  /// Current search query.
  String _searchQuery = '';

  // ===========================================================================
  // Getters
  // ===========================================================================

  List<Note> get notes => List<Note>.unmodifiable(_notes);

  List<Note> get allNotes => List<Note>.unmodifiable(_allNotes);

  Note? get selectedNote => _selectedNote;

  bool get isLoading => _isLoading;

  bool get isLoadingMore => _isLoadingMore;

  bool get hasMore => _hasMore;

  String? get errorMessage => _errorMessage;

  bool get hasError => _errorMessage != null;

  bool get isEmpty => _notes.isEmpty;

  String get searchQuery => _searchQuery;

  // ===========================================================================
  // Load Notes
  // ===========================================================================

  Future<void> loadNotes({bool refresh = false}) async {
    if (_isLoading) {
      return;
    }

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _selectedNote = null;

      _allNotes.clear();
      _notes.clear();
    }

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final List<Note> result = await _repository.getNotes(
        page: _currentPage,
        limit: _pageSize,
      );

      _allNotes
        ..clear()
        ..addAll(result);

      _applySearch();

      _hasMore = result.length == _pageSize;
    } catch (exception) {
      _errorMessage = exception.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ===========================================================================
  // Load More
  // ===========================================================================

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore || _isLoading) {
      return;
    }

    _isLoadingMore = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final int nextPage = _currentPage + 1;

      final List<Note> result = await _repository.getNotes(
        page: nextPage,
        limit: _pageSize,
      );

      for (final Note note in result) {
        final bool exists = _allNotes.any((existing) => existing.id == note.id);

        if (!exists) {
          _allNotes.add(note);
        }
      }

      _currentPage = nextPage;
      _hasMore = result.length == _pageSize;

      _applySearch();
    } catch (exception) {
      _errorMessage = exception.toString();
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // ===========================================================================
  // Get Note
  // ===========================================================================

  Future<void> getNote(int noteId) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _selectedNote = await _repository.getNoteById(noteId);
    } catch (exception) {
      _errorMessage = exception.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ===========================================================================
  // Create Note
  // ===========================================================================

  Future<void> createNote({required String title, String? content}) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final Note note = await _repository.createNote(
        CreateNoteRequest(title: title, content: content),
      );

      _allNotes.insert(0, note);

      _applySearch();
    } catch (exception) {
      _errorMessage = exception.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ===========================================================================
  // Update Note
  // ===========================================================================

  Future<void> updateNote({
    required int noteId,
    String? title,
    String? content,
  }) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final Note updated = await _repository.updateNote(
        noteId,
        UpdateNoteRequest(title: title, content: content),
      );

      final int index = _allNotes.indexWhere((note) => note.id == noteId);

      if (index != -1) {
        _allNotes[index] = updated;
      }

      if (_selectedNote?.id == noteId) {
        _selectedNote = updated;
      }

      _applySearch();
    } catch (exception) {
      _errorMessage = exception.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ===========================================================================
  // Patch Note
  // ===========================================================================

  Future<void> patchNote({
    required int noteId,
    String? title,
    String? content,
  }) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final Note updated = await _repository.patchNote(
        noteId,
        UpdateNoteRequest(title: title, content: content),
      );

      final int index = _allNotes.indexWhere((note) => note.id == noteId);

      if (index != -1) {
        _allNotes[index] = updated;
      }

      if (_selectedNote?.id == noteId) {
        _selectedNote = updated;
      }

      _applySearch();
    } catch (exception) {
      _errorMessage = exception.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ===========================================================================
  // Delete Note
  // ===========================================================================

  Future<void> deleteNote(int noteId) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      await _repository.deleteNote(noteId);

      _allNotes.removeWhere((note) => note.id == noteId);

      if (_selectedNote?.id == noteId) {
        _selectedNote = null;
      }

      _applySearch();
    } catch (exception) {
      _errorMessage = exception.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ===========================================================================
  // Search
  // ===========================================================================

  /// Searches notes locally by title or content.
  void search(String query) {
    _searchQuery = query.trim();

    _applySearch();

    notifyListeners();
  }

  /// Clears the current search query.
  void clearSearch() {
    _searchQuery = '';

    _applySearch();

    notifyListeners();
  }

  // ===========================================================================
  // Private Helpers
  // ===========================================================================

  /// Applies the current search query to the cached notes.
  void _applySearch() {
    _notes.clear();

    if (_searchQuery.isEmpty) {
      _notes.addAll(_allNotes);
      return;
    }

    final String query = _searchQuery.toLowerCase();

    _notes.addAll(
      _allNotes.where(
        (note) =>
            note.title.toLowerCase().contains(query) ||
            (note.content ?? '').toLowerCase().contains(query),
      ),
    );
  }

  // ===========================================================================
  // Public Helpers
  // ===========================================================================

  /// Clears the selected note.
  void clearSelection() {
    _selectedNote = null;
    notifyListeners();
  }

  /// Clears the current error.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Resets the provider to its initial state.
  void reset() {
    _allNotes.clear();
    _notes.clear();

    _selectedNote = null;

    _isLoading = false;
    _isLoadingMore = false;

    _errorMessage = null;

    _currentPage = 1;
    _hasMore = true;

    _searchQuery = '';

    notifyListeners();
  }
}
