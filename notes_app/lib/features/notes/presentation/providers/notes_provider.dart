import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../../../core/services/logger_service.dart';
import '../../../notifications/models/reminder_model.dart';
import '../../../notifications/utils/reminder_manager.dart';
import '../../data/models/create_note_request.dart';
import '../../data/models/update_note_request.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../../services/image_picker_service.dart';

/// ============================================================================
/// File: notes_provider.dart
/// ============================================================================
///
/// Notes Provider.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Manages Notes UI state.
/// • Coordinates CRUD operations.
/// • Handles pagination.
/// • Handles searching.
/// • Manages selected images.
/// • Coordinates reminders.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///    ↓
/// NotesProvider
///    ↓
/// NotesRepository
///    ↓
/// FastAPI
///
/// ============================================================================

final class NotesProvider extends ChangeNotifier {
  NotesProvider({
    required NotesRepository repository,
    ImagePickerService? imagePickerService,
    ReminderManager? reminderManager,
  }) : _repository = repository,
       _imagePickerService = imagePickerService ?? ImagePickerService(),
       _reminderManager = reminderManager ?? ReminderManager.instance;

  // ===========================================================================
  // Dependencies
  // ===========================================================================

  final NotesRepository _repository;

  final ImagePickerService _imagePickerService;

  final ReminderManager _reminderManager;

  // ===========================================================================
  // Notes State
  // ===========================================================================

  final List<Note> _allNotes = <Note>[];

  final List<Note> _notes = <Note>[];

  Note? _selectedNote;

  // ===========================================================================
  // Image State
  // ===========================================================================

  File? _selectedImage;

  // ===========================================================================
  // Loading State
  // ===========================================================================

  bool _isLoading = false;

  bool _isLoadingMore = false;

  // ===========================================================================
  // Error State
  // ===========================================================================

  String? _errorMessage;

  // ===========================================================================
  // Pagination
  // ===========================================================================

  static const int _pageSize = 10;

  int _currentPage = 1;

  bool _hasMore = true;

  // ===========================================================================
  // Search
  // ===========================================================================

  String _searchQuery = '';

  // ===========================================================================
  // Public Getters
  // ===========================================================================

  List<Note> get notes => List<Note>.unmodifiable(_notes);

  List<Note> get allNotes => List<Note>.unmodifiable(_allNotes);

  Note? get selectedNote => _selectedNote;

  // ===========================================================================
  // Image Getters
  // ===========================================================================

  File? get selectedImage => _selectedImage;

  bool get hasSelectedImage => _imagePickerService.exists(_selectedImage);

  String? get selectedImagePath => _imagePickerService.getPath(_selectedImage);

  // ===========================================================================
  // Loading Getters
  // ===========================================================================

  bool get isLoading => _isLoading;

  bool get isLoadingMore => _isLoadingMore;

  // ===========================================================================
  // Error Getters
  // ===========================================================================

  String? get errorMessage => _errorMessage;

  bool get hasError => _errorMessage != null;

  // ===========================================================================
  // Pagination Getters
  // ===========================================================================

  bool get hasMore => _hasMore;

  int get currentPage => _currentPage;

  // ===========================================================================
  // Search Getters
  // ===========================================================================

  String get searchQuery => _searchQuery;

  // ===========================================================================
  // Utility Getters
  // ===========================================================================

  bool get isEmpty => _notes.isEmpty;

  bool get isNotEmpty => _notes.isNotEmpty;

  // ===========================================================================
  // Load Notes
  // ===========================================================================

  /// Loads notes from backend.
  ///
  /// When [refresh] is true:
  /// - resets pagination
  /// - clears previous cache
  /// - loads first page again
  Future<void> loadNotes({bool refresh = false}) async {
    if (_isLoading && !refresh) {
      return;
    }

    try {
      _setLoading(true);

      clearError();

      if (refresh) {
        _resetPagination();
      }

      final List<Note> response = await _repository.getNotes(
        page: _currentPage,
        limit: _pageSize,
      );

      if (refresh) {
        _allNotes
          ..clear()
          ..addAll(response);
      } else {
        _allNotes.addAll(response);
      }

      _updatePagination(receivedCount: response.length);

      _applySearchFilter();

      LoggerService.info(
        'Notes loaded successfully. '
        'Count: ${response.length}',
      );
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to load notes.',
        error: exception,
        stackTrace: stackTrace,
      );

      _setError(exception.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ===========================================================================
  // Load More Notes
  // ===========================================================================

  /// Loads next pagination page.
  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) {
      return;
    }

    try {
      _isLoadingMore = true;

      notifyListeners();

      final int nextPage = _currentPage + 1;

      final List<Note> response = await _repository.getNotes(
        page: nextPage,
        limit: _pageSize,
      );

      _allNotes.addAll(response);

      _currentPage = nextPage;

      _updatePagination(receivedCount: response.length);

      _applySearchFilter();

      LoggerService.info(
        'More notes loaded successfully. '
        'Page: $_currentPage',
      );
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to load more notes.',
        error: exception,
        stackTrace: stackTrace,
      );

      _setError(exception.toString());
    } finally {
      _isLoadingMore = false;

      notifyListeners();
    }
  }

  // ===========================================================================
  // Get Single Note
  // ===========================================================================

  /// Fetches a single note by id.
  Future<Note?> getNote(int noteId) async {
    try {
      clearError();

      final Note note = await _repository.getNoteById(noteId);

      _selectedNote = note;

      notifyListeners();

      return note;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to get note.',
        error: exception,
        stackTrace: stackTrace,
      );

      _setError(exception.toString());

      return null;
    }
  }

  // ===========================================================================
  // Pagination Helpers
  // ===========================================================================

  void _resetPagination() {
    _currentPage = 1;

    _hasMore = true;

    _allNotes.clear();

    _notes.clear();
  }

  void _updatePagination({required int receivedCount}) {
    if (receivedCount < _pageSize) {
      _hasMore = false;
    }
  }

  // ===========================================================================
  // Create Note
  // ===========================================================================

  /// Creates a new note.
  Future<Note?> createNote(CreateNoteRequest request) async {
    try {
      clearError();

      if (!request.isValid) {
        throw Exception('Invalid note title.');
      }

      final Note note = await _repository.createNote(request);

      _allNotes.insert(0, note);

      _applySearchFilter();

      _clearSelectedImage();

      notifyListeners();

      LoggerService.info(
        'Note created successfully. '
        'ID: ${note.id}',
      );

      return note;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to create note.',
        error: exception,
        stackTrace: stackTrace,
      );

      _setError(exception.toString());

      return null;
    }
  }

  // ===========================================================================
  // Update Note
  // ===========================================================================

  /// Updates existing note using PUT.
  Future<Note?> updateNote(int noteId, UpdateNoteRequest request) async {
    try {
      clearError();

      if (!request.hasUpdates) {
        throw Exception('No changes provided.');
      }

      final Note updatedNote = await _repository.updateNote(noteId, request);

      _replaceNote(updatedNote);

      notifyListeners();

      LoggerService.info(
        'Note updated successfully. '
        'ID: ${updatedNote.id}',
      );

      return updatedNote;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to update note.',
        error: exception,
        stackTrace: stackTrace,
      );

      _setError(exception.toString());

      return null;
    }
  }

  // ===========================================================================
  // Patch Note
  // ===========================================================================

  /// Partially updates an existing note.
  ///
  /// Uses PATCH API operation.
  Future<Note?> patchNote(int noteId, UpdateNoteRequest request) async {
    try {
      clearError();

      if (!request.hasUpdates) {
        throw Exception('No changes provided.');
      }

      final Note updatedNote = await _repository.patchNote(noteId, request);

      _replaceNote(updatedNote);

      notifyListeners();

      LoggerService.info(
        'Note patched successfully. '
        'ID: ${updatedNote.id}',
      );

      return updatedNote;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to patch note.',
        error: exception,
        stackTrace: stackTrace,
      );

      _setError(exception.toString());

      return null;
    }
  }

  // ===========================================================================
  // Delete Note
  // ===========================================================================

  /// Deletes a note permanently.
  Future<bool> deleteNote(int noteId) async {
    try {
      clearError();

      await _repository.deleteNote(noteId);

      _removeNoteFromCache(noteId);

      notifyListeners();

      LoggerService.info(
        'Note deleted successfully. '
        'ID: $noteId',
      );

      return true;
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to delete note.',
        error: exception,
        stackTrace: stackTrace,
      );

      _setError(exception.toString());

      return false;
    }
  }

  // ===========================================================================
  // Local Cache Helpers
  // ===========================================================================

  /// Replaces updated note in local cache.
  void _replaceNote(Note updatedNote) {
    final int index = _allNotes.indexWhere((note) => note.id == updatedNote.id);

    if (index == -1) {
      _allNotes.add(updatedNote);
    } else {
      _allNotes[index] = updatedNote;
    }

    if (_selectedNote?.id == updatedNote.id) {
      _selectedNote = updatedNote;
    }

    _applySearchFilter();
  }

  /// Removes deleted note from cache.
  void _removeNoteFromCache(int noteId) {
    _allNotes.removeWhere((note) => note.id == noteId);

    _notes.removeWhere((note) => note.id == noteId);

    if (_selectedNote?.id == noteId) {
      _selectedNote = null;
    }
  }

  // ===========================================================================
  // Search
  // ===========================================================================

  /// Public search method used by UI.
  ///
  /// Example:
  ///
  /// NotesSearchBar
  ///       ↓
  /// provider.search(query)
  ///       ↓
  /// local filtering
  void search(String query) {
    _searchQuery = query.trim();

    _applySearchFilter();

    notifyListeners();
  }

  /// Existing alias for compatibility.
  void searchNotes(String query) {
    search(query);
  }

  /// Clears current search.
  void clearSearch() {
    if (_searchQuery.isEmpty) {
      return;
    }

    _searchQuery = '';

    _applySearchFilter();

    notifyListeners();
  }

  /// Applies local filtering.
  void _applySearchFilter() {
    if (_searchQuery.isEmpty) {
      _notes
        ..clear()
        ..addAll(_allNotes);

      return;
    }

    final String query = _searchQuery.toLowerCase();

    _notes
      ..clear()
      ..addAll(
        _allNotes.where((Note note) {
          final String title = note.title.toLowerCase();

          final String content = note.content?.toLowerCase() ?? '';

          return title.contains(query) || content.contains(query);
        }),
      );
  }

  // ===========================================================================
  // Image Picker
  // ===========================================================================

  /// Picks image from gallery.
  Future<void> pickImageFromGallery() async {
    try {
      final File? image = await _imagePickerService.pickFromGallery();

      if (image == null) {
        return;
      }

      _selectedImage = image;

      notifyListeners();

      LoggerService.info('Image selected successfully.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to pick image.',
        error: exception,
        stackTrace: stackTrace,
      );

      _setError(exception.toString());
    }
  }

  /// Picks image from camera.
  Future<void> pickImageFromCamera() async {
    try {
      final File? image = await _imagePickerService.pickFromCamera();

      if (image == null) {
        return;
      }

      _selectedImage = image;

      notifyListeners();

      LoggerService.info('Camera image selected successfully.');
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to capture image.',
        error: exception,
        stackTrace: stackTrace,
      );

      _setError(exception.toString());
    }
  }

  /// Removes selected image.
  void removeSelectedImage() {
    if (_selectedImage == null) {
      return;
    }

    _selectedImage = null;

    notifyListeners();
  }

  /// Public method used by screens.
  ///
  /// Example:
  /// AddNoteScreen.onPop
  /// EditNoteScreen.onPop
  void clearSelectedImage() {
    if (_selectedImage == null) {
      return;
    }

    _selectedImage = null;

    notifyListeners();
  }

  /// Internal cleanup helper.
  void _clearSelectedImage() {
    _selectedImage = null;
  }

  // ===========================================================================
  // Reminder Management
  // ===========================================================================

  /// Schedules a local reminder for a note.
  Future<void> scheduleNoteReminder({
    required Note note,
    required DateTime reminderTime,
  }) async {
    try {
      final ReminderModel reminder = ReminderModel(
        notificationId: note.id,

        noteId: note.id,

        title: note.title,

        body: note.content ?? 'Reminder for your note',

        scheduledAt: reminderTime,

        payload: null,
      );

      await _reminderManager.scheduleReminder(reminder);

      LoggerService.info(
        'Reminder scheduled successfully. '
        'Note ID: ${note.id}',
      );
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to schedule reminder.',
        error: exception,
        stackTrace: stackTrace,
      );

      _setError(exception.toString());
    }
  }

  /// Cancels a note reminder.
  Future<void> cancelNoteReminder(int noteId) async {
    try {
      await _reminderManager.deleteReminderByNote(noteId);

      LoggerService.info(
        'Reminder cancelled successfully. '
        'Note ID: $noteId',
      );
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to cancel reminder.',
        error: exception,
        stackTrace: stackTrace,
      );

      _setError(exception.toString());
    }
  }

  // ===========================================================================
  // Public Error Handling
  // ===========================================================================

  /// Clears current provider error.
  ///
  /// Used by screens before starting operations.
  void clearError() {
    if (_errorMessage == null) {
      return;
    }

    _errorMessage = null;

    notifyListeners();
  }

  // ===========================================================================
  // Internal State Helpers
  // ===========================================================================

  /// Updates loading state.
  void _setLoading(bool value) {
    if (_isLoading == value) {
      return;
    }

    _isLoading = value;

    notifyListeners();
  }

  /// Updates error state.
  void _setError(String message) {
    _errorMessage = message;

    notifyListeners();
  }

  /// Internal error clear.
  ///
  /// Used inside provider operations.
  void _clearError() {
    if (_errorMessage == null) {
      return;
    }

    _errorMessage = null;
  }

  // ===========================================================================
  // Refresh
  // ===========================================================================

  /// Refreshes notes list.
  Future<void> refreshNotes() async {
    await loadNotes(refresh: true);
  }

  // ===========================================================================
  // Reset
  // ===========================================================================

  /// Clears complete provider state.
  ///
  /// Used:
  /// - logout
  /// - user switch
  /// - session reset
  void reset() {
    _allNotes.clear();

    _notes.clear();

    _selectedNote = null;

    _selectedImage = null;

    _searchQuery = '';

    _currentPage = 1;

    _hasMore = true;

    _errorMessage = null;

    _isLoading = false;

    _isLoadingMore = false;

    notifyListeners();
  }

  // ===========================================================================
  // Dispose
  // ===========================================================================

  @override
  void dispose() {
    _allNotes.clear();

    _notes.clear();

    super.dispose();
  }
}
