import 'dart:collection';
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
/// Enterprise Notes Provider
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Manages Notes UI state.
/// • Coordinates CRUD operations.
/// • Handles pagination.
/// • Performs local searching.
/// • Coordinates image selection.
/// • Coordinates local reminders.
///
/// This provider intentionally contains no networking logic.
/// All API communication flows through:
///
/// UI
///   ↓
/// NotesProvider
///   ↓
/// NotesRepository
///   ↓
/// NotesRemoteDataSource
///   ↓
/// FastAPI
///
/// Optimized For
/// ----------------------------------------------------------------------------
/// • Flutter Stable
/// • Provider
/// • Material 3
/// • FastAPI
/// • Dell Inspiron 5590
/// • 8 GB RAM
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
  // Constants
  // ===========================================================================

  static const int _pageSize = 10;

  // ===========================================================================
  // Cache
  // ===========================================================================

  /// Complete notes cache.
  final List<Note> _allNotes = <Note>[];

  /// Visible notes after filtering.
  final List<Note> _notes = <Note>[];

  /// Cached read-only views.
  ///
  /// Avoids allocating
  /// List.unmodifiable(...)
  /// on every getter call.
  late final UnmodifiableListView<Note> _notesView = UnmodifiableListView<Note>(
    _notes,
  );

  late final UnmodifiableListView<Note> _allNotesView =
      UnmodifiableListView<Note>(_allNotes);

  // ===========================================================================
  // Selection
  // ===========================================================================

  Note? _selectedNote;

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

  int _currentPage = 1;

  bool _hasMore = true;

  // ===========================================================================
  // Search
  // ===========================================================================

  String _searchQuery = '';

  // ===========================================================================
  // Public Getters
  // ===========================================================================

  /// Visible notes.
  UnmodifiableListView<Note> get notes => _notesView;

  /// Complete notes cache.
  UnmodifiableListView<Note> get allNotes => _allNotesView;

  /// Selected note.
  Note? get selectedNote => _selectedNote;

  /// Selected image.
  File? get selectedImage => _selectedImage;

  /// Selected image path.
  String? get selectedImagePath => _imagePickerService.getPath(_selectedImage);

  /// Returns true if the file exists.
  bool exists(File? file) {
    return file?.existsSync() ?? false;
  }

  /// Loading indicator.
  bool get isLoading => _isLoading;

  /// Pagination loading indicator.
  bool get isLoadingMore => _isLoadingMore;

  /// Current error.
  String? get errorMessage => _errorMessage;

  /// Returns true when an error exists.
  bool get hasError => _errorMessage != null;

  /// Returns true when another page exists.
  bool get hasMore => _hasMore;

  /// Current page.
  int get currentPage => _currentPage;

  /// Current search query.
  String get searchQuery => _searchQuery;

  /// Returns true when no notes are visible.
  bool get isEmpty => _notes.isEmpty;

  /// Returns true when notes are visible.
  bool get isNotEmpty => _notes.isNotEmpty;

  /// Total cached notes.
  int get totalNotes => _allNotes.length;

  /// Visible notes count.
  int get visibleNotes => _notes.length;

  // ===========================================================================
  // Internal Helpers
  // ===========================================================================

  /// Notifies listeners only when this provider
  /// has not been disposed.
  ///
  /// This protects against asynchronous callbacks
  /// completing after disposal.
  @protected
  void notifySafely() {
    if (hasListeners) {
      notifyListeners();
    }
  }

  /// Clears current error without notifying.
  void _clearErrorInternal() {
    _errorMessage = null;
  }

  // ===========================================================================
  // State Helpers
  // ===========================================================================

  /// Updates the loading state.
  ///
  /// Prevents duplicate notifications.
  bool _setLoading(bool value) {
    if (_isLoading == value) {
      return false;
    }

    _isLoading = value;
    notifySafely();
    return true;
  }

  /// Updates the pagination loading state.
  ///
  /// Prevents unnecessary rebuilds.
  bool _setLoadingMore(bool value) {
    if (_isLoadingMore == value) {
      return false;
    }

    _isLoadingMore = value;
    notifySafely();
    return true;
  }

  /// Updates the current error message.
  ///
  /// Does not notify when the value is unchanged.
  bool _setError(String? message) {
    if (_errorMessage == message) {
      return false;
    }

    _errorMessage = message;
    notifySafely();
    return true;
  }

  /// Clears the current error.
  void clearError() {
    if (_errorMessage == null) {
      return;
    }

    _errorMessage = null;
    notifySafely();
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
    _hasMore = receivedCount >= _pageSize;
  }

  // ===========================================================================
  // Cache Helpers
  // ===========================================================================

  void _replaceNote(Note note) {
    final int index = _allNotes.indexWhere((Note item) => item.id == note.id);

    if (index >= 0) {
      _allNotes[index] = note;
    } else {
      _allNotes.insert(0, note);
    }

    if (_selectedNote?.id == note.id) {
      _selectedNote = note;
    }

    _applySearchFilter();
  }

  void _removeNoteFromCache(int noteId) {
    _allNotes.removeWhere((Note note) => note.id == noteId);

    _notes.removeWhere((Note note) => note.id == noteId);

    if (_selectedNote?.id == noteId) {
      _selectedNote = null;
    }
  }

  // ===========================================================================
  // Search Helpers
  // ===========================================================================

  void _applySearchFilter() {
    _notes.clear();

    if (_searchQuery.isEmpty) {
      _notes.addAll(_allNotes);
      return;
    }

    final String query = _searchQuery.toLowerCase();

    for (final Note note in _allNotes) {
      final bool titleMatch = note.title.toLowerCase().contains(query);

      if (titleMatch) {
        _notes.add(note);
        continue;
      }

      final String? content = note.content;

      if (content != null && content.toLowerCase().contains(query)) {
        _notes.add(note);
      }
    }
  }

  // ===========================================================================
  // Image Helpers
  // ===========================================================================

  void _setSelectedImage(File? image) {
    if (_selectedImage?.path == image?.path) {
      return;
    }

    _selectedImage = image;
    notifySafely();
  }

  void removeSelectedImage() {
    if (_selectedImage == null) {
      return;
    }

    _selectedImage = null;
    notifySafely();
  }

  void clearSelectedImage() {
    removeSelectedImage();
  }

  void _clearSelectedImageInternal() {
    _selectedImage = null;
  }

  // ===========================================================================
  // Selection Helpers
  // ===========================================================================

  void _setSelectedNote(Note? note) {
    if (identical(_selectedNote, note)) {
      return;
    }

    _selectedNote = note;
    notifySafely();
  }

  // ===========================================================================
  // Refresh
  // ===========================================================================

  Future<void> refreshNotes() {
    return loadNotes(refresh: true);
  }

  // ===========================================================================
  // Load Notes
  // ===========================================================================

  /// Loads notes from the backend.
  ///
  /// When [refresh] is true:
  /// • Clears the local cache.
  /// • Resets pagination.
  /// • Reloads the first page.
  Future<void> loadNotes({bool refresh = false}) async {
    if (_isLoading && !refresh) {
      return;
    }

    _setLoading(true);
    _clearErrorInternal();

    try {
      if (refresh) {
        _resetPagination();
      }

      final List<Note> notes = await _repository.getNotes(
        page: _currentPage,
        limit: _pageSize,
      );

      if (refresh) {
        _allNotes
          ..clear()
          ..addAll(notes);
      } else {
        _allNotes.addAll(notes);
      }

      _updatePagination(receivedCount: notes.length);

      _applySearchFilter();

      LoggerService.info(
        'Loaded ${notes.length} notes '
        '(page: $_currentPage).',
      );

      notifyListeners();
    } catch (error, stackTrace) {
      LoggerService.error(
        'Failed to load notes.',
        error: error,
        stackTrace: stackTrace,
      );

      _setError(error.toString());
    } finally {
      _setLoading(false);
    }
  }

  // ===========================================================================
  // Load More
  // ===========================================================================

  /// Loads the next page.
  ///
  /// Duplicate pagination requests are ignored.
  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore || _isLoading) {
      return;
    }

    _setLoadingMore(true);

    try {
      final int nextPage = _currentPage + 1;

      final List<Note> notes = await _repository.getNotes(
        page: nextPage,
        limit: _pageSize,
      );

      if (notes.isEmpty) {
        _hasMore = false;

        LoggerService.info('No additional notes available.');

        notifyListeners();
        return;
      }

      _currentPage = nextPage;

      _allNotes.addAll(notes);

      _updatePagination(receivedCount: notes.length);

      _applySearchFilter();

      LoggerService.info(
        'Loaded page $_currentPage '
        '(${notes.length} notes).',
      );

      notifyListeners();
    } catch (error, stackTrace) {
      LoggerService.error(
        'Failed to load more notes.',
        error: error,
        stackTrace: stackTrace,
      );

      _setError(error.toString());
    } finally {
      _setLoadingMore(false);
    }
  }

  // ===========================================================================
  // Get Single Note
  // ===========================================================================

  /// Retrieves a single note by its identifier.
  Future<Note?> getNote(int noteId) async {
    _clearErrorInternal();

    try {
      final Note note = await _repository.getNoteById(noteId);

      _selectedNote = note;

      LoggerService.info('Loaded note $noteId.');

      notifyListeners();

      return note;
    } catch (error, stackTrace) {
      LoggerService.error(
        'Failed to retrieve note.',
        error: error,
        stackTrace: stackTrace,
      );

      _setError(error.toString());

      return null;
    }
  }

  // ===========================================================================
  // Create Note
  // ===========================================================================

  /// Creates a new note.
  Future<Note?> createNote(CreateNoteRequest request) async {
    if (!request.isValid) {
      _setError('Invalid note title.');
      return null;
    }

    _setLoading(true);
    _clearErrorInternal();

    try {
      final Note createdNote = await _repository.createNote(request);

      _allNotes.insert(0, createdNote);

      _applySearchFilter();

      _clearSelectedImageInternal();

      LoggerService.info('Created note ${createdNote.id}.');

      notifyListeners();

      return createdNote;
    } catch (error, stackTrace) {
      LoggerService.error(
        'Failed to create note.',
        error: error,
        stackTrace: stackTrace,
      );

      _setError(error.toString());

      return null;
    } finally {
      _setLoading(false);
    }
  }

  // ===========================================================================
  // Update Note (PUT)
  // ===========================================================================

  /// Replaces an existing note.
  Future<Note?> updateNote(int noteId, UpdateNoteRequest request) async {
    if (!request.hasUpdates) {
      _setError('No changes provided.');
      return null;
    }

    _setLoading(true);
    _clearErrorInternal();

    try {
      final Note updatedNote = await _repository.updateNote(noteId, request);

      _replaceNote(updatedNote);

      LoggerService.info('Updated note ${updatedNote.id}.');

      notifyListeners();

      return updatedNote;
    } catch (error, stackTrace) {
      LoggerService.error(
        'Failed to update note.',
        error: error,
        stackTrace: stackTrace,
      );

      _setError(error.toString());

      return null;
    } finally {
      _setLoading(false);
    }
  }

  // ===========================================================================
  // Patch Note (PATCH)
  // ===========================================================================

  /// Partially updates an existing note.
  Future<Note?> patchNote(int noteId, UpdateNoteRequest request) async {
    if (!request.hasUpdates) {
      _setError('No changes provided.');
      return null;
    }

    _setLoading(true);
    _clearErrorInternal();

    try {
      final Note updatedNote = await _repository.patchNote(noteId, request);

      _replaceNote(updatedNote);

      LoggerService.info('Patched note ${updatedNote.id}.');

      notifyListeners();

      return updatedNote;
    } catch (error, stackTrace) {
      LoggerService.error(
        'Failed to patch note.',
        error: error,
        stackTrace: stackTrace,
      );

      _setError(error.toString());

      return null;
    } finally {
      _setLoading(false);
    }
  }

  // ===========================================================================
  // Delete Note
  // ===========================================================================

  /// Permanently deletes a note.
  Future<bool> deleteNote(int noteId) async {
    _setLoading(true);
    _clearErrorInternal();

    try {
      await _repository.deleteNote(noteId);

      _removeNoteFromCache(noteId);

      LoggerService.info('Deleted note $noteId.');

      notifyListeners();

      return true;
    } catch (error, stackTrace) {
      LoggerService.error(
        'Failed to delete note.',
        error: error,
        stackTrace: stackTrace,
      );

      _setError(error.toString());

      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ===========================================================================
  // Search
  // ===========================================================================

  /// Filters notes locally.
  ///
  /// No network request is performed.
  void search(String query) {
    final String normalizedQuery = query.trim();

    if (_searchQuery == normalizedQuery) {
      return;
    }

    _searchQuery = normalizedQuery;

    _applySearchFilter();

    notifyListeners();
  }

  /// Backward-compatible alias.
  void searchNotes(String query) {
    search(query);
  }

  /// Clears the active search.
  void clearSearch() {
    if (_searchQuery.isEmpty) {
      return;
    }

    _searchQuery = '';

    _applySearchFilter();

    notifyListeners();
  }

  // ===========================================================================
  // Image Picker
  // ===========================================================================

  /// Picks an image from the gallery.
  Future<void> pickImageFromGallery() async {
    try {
      final File? image = await _imagePickerService.pickFromGallery();

      if (image == null) {
        return;
      }

      _setSelectedImage(image);

      LoggerService.info('Gallery image selected.');
    } catch (error, stackTrace) {
      LoggerService.error(
        'Failed to pick gallery image.',
        error: error,
        stackTrace: stackTrace,
      );

      _setError(error.toString());
    }
  }

  /// Captures an image using the camera.
  Future<void> pickImageFromCamera() async {
    try {
      final File? image = await _imagePickerService.pickFromCamera();

      if (image == null) {
        return;
      }

      _setSelectedImage(image);

      LoggerService.info('Camera image captured.');
    } catch (error, stackTrace) {
      LoggerService.error(
        'Failed to capture image.',
        error: error,
        stackTrace: stackTrace,
      );

      _setError(error.toString());
    }
  }

  // ===========================================================================
  // Reminder Management
  // ===========================================================================

  /// Schedules a local reminder for a note.
  Future<void> scheduleNoteReminder({
    required Note note,
    required DateTime reminderTime,
  }) async {
    _clearErrorInternal();

    try {
      final ReminderModel reminder = ReminderModel(
        notificationId: note.id,
        noteId: note.id,
        title: note.title,
        body: note.content ?? 'Reminder for your note',
        scheduledAt: reminderTime,
        payload: note.id.toString(),
      );

      await _reminderManager.saveReminder(reminder);

      LoggerService.info('Reminder scheduled. Note: ${note.id}');
    } catch (error, stackTrace) {
      LoggerService.error(
        'Failed to schedule reminder.',
        error: error,
        stackTrace: stackTrace,
      );

      _setError(error.toString());
    }
  }

  /// Cancels a reminder associated with a note.
  Future<void> cancelNoteReminder(int noteId) async {
    _clearErrorInternal();

    try {
      await _reminderManager.deleteReminderByNote(noteId);

      LoggerService.info('Reminder cancelled. Note: $noteId');
    } catch (error, stackTrace) {
      LoggerService.error(
        'Failed to cancel reminder.',
        error: error,
        stackTrace: stackTrace,
      );

      _setError(error.toString());
    }
  }

  // ===========================================================================
  // Reset
  // ===========================================================================

  /// Clears all provider state.
  ///
  /// Intended for:
  /// • Logout
  /// • Session expiration
  /// • User switching
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

    LoggerService.info('NotesProvider reset.');

    notifyListeners();
  }

  // ===========================================================================
  // Dispose
  // ===========================================================================

  @override
  void dispose() {
    _allNotes.clear();
    _notes.clear();

    _selectedNote = null;
    _selectedImage = null;

    LoggerService.info('NotesProvider disposed.');

    super.dispose();
  }
}
