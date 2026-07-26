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
/// Notes Provider
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Manages Notes UI state.
/// • Coordinates CRUD operations.
/// • Handles pagination.
/// • Supports local searching.
/// • Manages temporary selected image.
/// • Coordinates reminder persistence.
/// • Coordinates reminder scheduling.
/// • Exposes loading/error states.
/// • Notifies listeners.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///      ↓
/// NotesProvider
///      ↓
/// NotesRepository
///      ↓
/// FastAPI
///
/// Reminder Flow
/// ----------------------------------------------------------------------------
/// NotesProvider
///      ↓
/// ReminderManager
///      ↓
/// NotificationService
///
/// ============================================================================

final class NotesProvider extends ChangeNotifier {
  NotesProvider({
    required NotesRepository repository,
    ImagePickerService? imagePickerService,
    ReminderManager? reminderManager,
  })  : _repository = repository,
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

  /// Complete list received from the repository.
  final List<Note> _allNotes = <Note>[];

  /// Filtered list exposed to the UI.
  final List<Note> _notes = <Note>[];

  /// Currently selected note.
  Note? _selectedNote;

  // ===========================================================================
  // Image State
  // ===========================================================================

  /// Temporary image selected by the user.
  File? _selectedImage;

  // ===========================================================================
  // Loading State
  // ===========================================================================

  bool _isLoading = false;

  bool _isLoadingMore = false;

  String? _errorMessage;

  // ===========================================================================
  // Pagination
  // ===========================================================================

  int _currentPage = 1;

  static const int _pageSize = 10;

  bool _hasMore = true;

  // ===========================================================================
  // Search
  // ===========================================================================

  String _searchQuery = '';

  // ===========================================================================
  // Getters
  // ===========================================================================

  List<Note> get notes =>
      List<Note>.unmodifiable(_notes);

  List<Note> get allNotes =>
      List<Note>.unmodifiable(_allNotes);

  Note? get selectedNote =>
      _selectedNote;

  File? get selectedImage =>
      _selectedImage;

  bool get hasSelectedImage =>
      _imagePickerService.exists(_selectedImage);

  String? get selectedImagePath =>
      _imagePickerService.getPath(_selectedImage);

  bool get isLoading =>
      _isLoading;

  bool get isLoadingMore =>
      _isLoadingMore;

  bool get hasMore =>
      _hasMore;

  String? get errorMessage =>
      _errorMessage;

  bool get hasError =>
      _errorMessage != null;

  bool get isEmpty =>
      _notes.isEmpty;

  String get searchQuery =>
      _searchQuery;

    // ===========================================================================
  // Load Notes
  // ===========================================================================

  /// Loads the first page of notes.
  ///
  /// When [refresh] is true:
  /// - Pagination is reset.
  /// - Cached notes are cleared.
  /// - Selected note is cleared.
  /// - Search is reapplied after loading.
  Future<void> loadNotes({
    bool refresh = false,
  }) async {
    if (_isLoading) {
      LoggerService.info(
        'Skipping loadNotes because another request is already running.',
      );
      return;
    }

    if (refresh) {
      LoggerService.info(
        'Refreshing notes.',
      );

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
      LoggerService.info(
        'Loading notes (page: $_currentPage, limit: $_pageSize).',
      );

      final List<Note> result = await _repository.getNotes(
        page: _currentPage,
        limit: _pageSize,
      );

      _allNotes
        ..clear()
        ..addAll(result);

      _applySearch();

      _hasMore = result.length >= _pageSize;

      LoggerService.info(
        'Loaded ${result.length} note(s).',
      );
    } catch (exception, stackTrace) {
      _errorMessage = exception.toString();

      LoggerService.error(
        'Failed to load notes.',
        error: exception,
        stackTrace: stackTrace,
      );
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

    // ===========================================================================
  // Load More Notes
  // ===========================================================================

  /// Loads the next page of notes.
  ///
  /// Duplicate notes are ignored.
  /// Search filters are automatically reapplied.
  Future<void> loadMore() async {
    if (_isLoading) {
      LoggerService.info(
        'Skipping loadMore because loadNotes is currently running.',
      );
      return;
    }

    if (_isLoadingMore) {
      LoggerService.info(
        'Skipping loadMore because another pagination request is already running.',
      );
      return;
    }

    if (!_hasMore) {
      LoggerService.info(
        'No more notes available to load.',
      );
      return;
    }

    _isLoadingMore = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final int nextPage = _currentPage + 1;

      LoggerService.info(
        'Loading more notes (page: $nextPage, limit: $_pageSize).',
      );

      final List<Note> result = await _repository.getNotes(
        page: nextPage,
        limit: _pageSize,
      );

      for (final Note note in result) {
        final bool exists = _allNotes.any(
          (existing) => existing.id == note.id,
        );

        if (!exists) {
          _allNotes.add(note);
        }
      }

      _currentPage = nextPage;

      _hasMore = result.length >= _pageSize;

      _applySearch();

      LoggerService.info(
        'Loaded ${result.length} additional note(s). '
        'Total cached notes: ${_allNotes.length}.',
      );
    } catch (exception, stackTrace) {
      _errorMessage = exception.toString();

      LoggerService.error(
        'Failed to load more notes.',
        error: exception,
        stackTrace: stackTrace,
      );
    } finally {
      _isLoadingMore = false;

      notifyListeners();
    }
  }

    // ===========================================================================
  // Get Note
  // ===========================================================================

  /// Loads a single note by its identifier.
  ///
  /// The retrieved note is stored in [_selectedNote] for use by the
  /// details and edit screens.
  Future<void> getNote(int noteId) async {
    if (_isLoading) {
      LoggerService.info(
        'Skipping getNote because another request is already running.',
      );
      return;
    }

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      LoggerService.info(
        'Loading note. (id: $noteId)',
      );

      final Note note = await _repository.getNoteById(noteId);

      _selectedNote = note;

      LoggerService.info(
        'Note loaded successfully. (id: ${note.id})',
      );
    } catch (exception, stackTrace) {
      _selectedNote = null;

      _errorMessage = exception.toString();

      LoggerService.error(
        'Failed to load note. (id: $noteId)',
        error: exception,
        stackTrace: stackTrace,
      );
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

    // ===========================================================================
  // Create Note
  // ===========================================================================

  /// Creates a new note.
  ///
  /// If a reminder is supplied, it is updated with the newly created note ID,
  /// persisted locally and scheduled using ReminderManager.
  Future<void> createNote({
    required String title,
    String? content,
    ReminderModel? reminder,
  }) async {
    if (_isLoading) {
      LoggerService.info(
        'Skipping createNote because another request is already running.',
      );
      return;
    }

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      LoggerService.info(
        'Creating note.',
      );

      final Note createdNote = await _repository.createNote(
        CreateNoteRequest(
          title: title,
          content: content,
        ),
      );

      _allNotes.insert(
        0,
        createdNote,
      );

      _selectedNote = createdNote;

      if (reminder != null) {
        final ReminderModel reminderForNote = reminder.copyWith(
          noteId: createdNote.id,
          title: createdNote.title,
          body: (createdNote.content?.trim().isNotEmpty ?? false)
              ? createdNote.content
              : 'Reminder for "${createdNote.title}"',
          payload: createdNote.id.toString(),
        );

        await _reminderManager.saveReminder(
          reminderForNote,
        );

        LoggerService.info(
          'Reminder scheduled for note '
          '(noteId: ${createdNote.id}, '
          'notificationId: ${reminderForNote.notificationId}).',
        );
      }

      _selectedImage = null;

      _applySearch();

      LoggerService.info(
        'Note created successfully. (id: ${createdNote.id})',
      );
    } catch (exception, stackTrace) {
      _errorMessage = exception.toString();

      LoggerService.error(
        'Failed to create note.',
        error: exception,
        stackTrace: stackTrace,
      );
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

    // ===========================================================================
  // Update Note
  // ===========================================================================

  /// Updates an existing note.
  ///
  /// Reminder behavior:
  /// - If a reminder is supplied, it is updated and rescheduled.
  /// - If reminder is null, any existing reminder is removed.
  Future<void> updateNote({
    required int noteId,
    String? title,
    String? content,
    ReminderModel? reminder,
  }) async {
    if (_isLoading) {
      LoggerService.info(
        'Skipping updateNote because another request is already running.',
      );
      return;
    }

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      LoggerService.info(
        'Updating note. (id: $noteId)',
      );

      final Note updatedNote = await _repository.updateNote(
        noteId,
        UpdateNoteRequest(
          title: title,
          content: content,
        ),
      );

      final int index = _allNotes.indexWhere(
        (note) => note.id == noteId,
      );

      if (index != -1) {
        _allNotes[index] = updatedNote;
      }

      if (_selectedNote?.id == noteId) {
        _selectedNote = updatedNote;
      }

      // ===============================================================
      // Reminder Handling
      // ===============================================================

      final ReminderModel? existingReminder =
          await _reminderManager.getReminderByNote(
        noteId,
      );

      if (reminder != null) {
        final ReminderModel updatedReminder = reminder.copyWith(
          noteId: noteId,
          notificationId:
              existingReminder?.notificationId ??
              reminder.notificationId,
          title: updatedNote.title,
          body: (updatedNote.content?.trim().isNotEmpty ?? false)
              ? updatedNote.content
              : 'Reminder for "${updatedNote.title}"',
          payload: noteId.toString(),
        );

        await _reminderManager.updateReminder(
          updatedReminder,
        );

        LoggerService.info(
          'Reminder updated. '
          '(noteId: $noteId, '
          'notificationId: ${updatedReminder.notificationId})',
        );
      } else if (existingReminder != null) {
        await _reminderManager.deleteReminder(
          existingReminder.notificationId,
        );

        LoggerService.info(
          'Reminder removed. '
          '(noteId: $noteId)',
        );
      }

      _selectedImage = null;

      _applySearch();

      LoggerService.info(
        'Note updated successfully. (id: $noteId)',
      );
    } catch (exception, stackTrace) {
      _errorMessage = exception.toString();

      LoggerService.error(
        'Failed to update note. (id: $noteId)',
        error: exception,
        stackTrace: stackTrace,
      );
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

    // ===========================================================================
  // Patch Note
  // ===========================================================================

  /// Partially updates an existing note.
  ///
  /// Reminder behavior:
  /// - Updates and reschedules the reminder if supplied.
  /// - Removes the existing reminder if reminder is null.
  Future<void> patchNote({
    required int noteId,
    String? title,
    String? content,
    ReminderModel? reminder,
  }) async {
    if (_isLoading) {
      LoggerService.info(
        'Skipping patchNote because another request is already running.',
      );
      return;
    }

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      LoggerService.info(
        'Patching note. (id: $noteId)',
      );

      final Note patchedNote = await _repository.patchNote(
        noteId,
        UpdateNoteRequest(
          title: title,
          content: content,
        ),
      );

      final int index = _allNotes.indexWhere(
        (note) => note.id == noteId,
      );

      if (index != -1) {
        _allNotes[index] = patchedNote;
      }

      if (_selectedNote?.id == noteId) {
        _selectedNote = patchedNote;
      }

      // ===============================================================
      // Reminder Handling
      // ===============================================================

      final ReminderModel? existingReminder =
          await _reminderManager.getReminderByNote(
        noteId,
      );

      if (reminder != null) {
        final ReminderModel patchedReminder = reminder.copyWith(
          noteId: noteId,
          notificationId:
              existingReminder?.notificationId ??
                  reminder.notificationId,
          title: patchedNote.title,
          body:
              (patchedNote.content?.trim().isNotEmpty ?? false)
                  ? patchedNote.content
                  : 'Reminder for "${patchedNote.title}"',
          payload: noteId.toString(),
        );

        await _reminderManager.updateReminder(
          patchedReminder,
        );

        LoggerService.info(
          'Reminder patched successfully. '
          '(noteId: $noteId, '
          'notificationId: ${patchedReminder.notificationId})',
        );
      } else if (existingReminder != null) {
        await _reminderManager.deleteReminder(
          existingReminder.notificationId,
        );

        LoggerService.info(
          'Reminder removed after patch. '
          '(noteId: $noteId)',
        );
      }

      _selectedImage = null;

      _applySearch();

      LoggerService.info(
        'Note patched successfully. (id: $noteId)',
      );
    } catch (exception, stackTrace) {
      _errorMessage = exception.toString();

      LoggerService.error(
        'Failed to patch note. (id: $noteId)',
        error: exception,
        stackTrace: stackTrace,
      );
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

    // ===========================================================================
  // Delete Note
  // ===========================================================================

  /// Deletes a note.
  ///
  /// Also removes any locally stored reminder and cancels its scheduled
  /// notification.
  Future<void> deleteNote(int noteId) async {
    if (_isLoading) {
      LoggerService.info(
        'Skipping deleteNote because another request is already running.',
      );
      return;
    }

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      LoggerService.info(
        'Deleting note. (id: $noteId)',
      );

      // ===============================================================
      // Delete note from backend
      // ===============================================================

      await _repository.deleteNote(noteId);

      // ===============================================================
      // Delete associated reminder (if any)
      // ===============================================================

      final ReminderModel? reminder =
          await _reminderManager.getReminderByNote(
        noteId,
      );

      if (reminder != null) {
        await _reminderManager.deleteReminder(
          reminder.notificationId,
        );

        LoggerService.info(
          'Reminder deleted. '
          '(noteId: $noteId, '
          'notificationId: ${reminder.notificationId})',
        );
      }

      // ===============================================================
      // Remove note from cache
      // ===============================================================

      _allNotes.removeWhere(
        (note) => note.id == noteId,
      );

      if (_selectedNote?.id == noteId) {
        _selectedNote = null;
      }

      // ===============================================================
      // Clear temporary image
      // ===============================================================

      _selectedImage = null;

      // ===============================================================
      // Refresh filtered list
      // ===============================================================

      _applySearch();

      LoggerService.info(
        'Note deleted successfully. (id: $noteId)',
      );
    } catch (exception, stackTrace) {
      _errorMessage = exception.toString();

      LoggerService.error(
        'Failed to delete note. (id: $noteId)',
        error: exception,
        stackTrace: stackTrace,
      );
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

    // ===========================================================================
  // Search
  // ===========================================================================

  /// Searches notes locally by title or content.
  ///
  /// This operation does not trigger an API request. It filters the locally
  /// cached notes and updates the exposed list.
  void search(String query) {
    final String normalizedQuery = query.trim();

    if (_searchQuery == normalizedQuery) {
      return;
    }

    _searchQuery = normalizedQuery;

    _applySearch();

    LoggerService.info(
      'Search updated. '
      'Query: "${_searchQuery.isEmpty ? "(empty)" : _searchQuery}". '
      'Results: ${_notes.length}.',
    );

    notifyListeners();
  }

  /// Clears the current search query and restores the complete cached list.
  void clearSearch() {
    if (_searchQuery.isEmpty) {
      return;
    }

    _searchQuery = '';

    _applySearch();

    LoggerService.info(
      'Search cleared.',
    );

    notifyListeners();
  }

    // ===========================================================================
  // Image Picker
  // ===========================================================================

  /// Opens the gallery and stores the selected image locally.
  Future<void> pickImageFromGallery() async {
    try {
      LoggerService.info(
        'Opening gallery image picker.',
      );

      final File? image =
          await _imagePickerService.pickFromGallery();

      if (image == null) {
        LoggerService.info(
          'Gallery image selection cancelled.',
        );
        return;
      }

      _selectedImage = image;

      LoggerService.info(
        'Gallery image selected. '
        'Path: ${image.path}',
      );

      notifyListeners();
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to pick image from gallery.',
        error: exception,
        stackTrace: stackTrace,
      );

      _errorMessage = 'Unable to select image.';

      notifyListeners();
    }
  }

  /// Opens the camera and stores the captured image locally.
  Future<void> pickImageFromCamera() async {
    try {
      LoggerService.info(
        'Opening camera.',
      );

      final File? image =
          await _imagePickerService.pickFromCamera();

      if (image == null) {
        LoggerService.info(
          'Camera image capture cancelled.',
        );
        return;
      }

      _selectedImage = image;

      LoggerService.info(
        'Camera image captured. '
        'Path: ${image.path}',
      );

      notifyListeners();
    } catch (exception, stackTrace) {
      LoggerService.error(
        'Failed to capture image.',
        error: exception,
        stackTrace: stackTrace,
      );

      _errorMessage = 'Unable to capture image.';

      notifyListeners();
    }
  }

  /// Removes the currently selected temporary image.
  void removeSelectedImage() {
    if (_selectedImage == null) {
      return;
    }

    LoggerService.info(
      'Removing selected image.',
    );

    _selectedImage =
        _imagePickerService.removeImage();

    notifyListeners();
  }

    // ===========================================================================
  // Private Helpers
  // ===========================================================================

  /// Applies the current search query to the cached notes.
  ///
  /// This method never performs an API request. It filters the locally cached
  /// notes by title and content.
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

  /// Clears the currently selected note.
  void clearSelection() {
    if (_selectedNote == null) {
      return;
    }

    _selectedNote = null;

    LoggerService.info(
      'Selected note cleared.',
    );

    notifyListeners();
  }

  /// Clears the currently selected temporary image.
  void clearSelectedImage() {
    if (_selectedImage == null) {
      return;
    }

    _selectedImage = null;

    LoggerService.info(
      'Selected image cleared.',
    );

    notifyListeners();
  }

  /// Clears the current error message.
  void clearError() {
    if (_errorMessage == null) {
      return;
    }

    _errorMessage = null;

    LoggerService.info(
      'Error state cleared.',
    );

    notifyListeners();
  }

  /// Resets the provider back to its initial state.
  void reset() {
    LoggerService.info(
      'Resetting NotesProvider.',
    );

    _allNotes.clear();
    _notes.clear();

    _selectedNote = null;
    _selectedImage = null;

    _isLoading = false;
    _isLoadingMore = false;

    _errorMessage = null;

    _currentPage = 1;
    _hasMore = true;

    _searchQuery = '';

    notifyListeners();
  }

  // ===========================================================================
  // Dispose
  // ===========================================================================

  @override
  void dispose() {
    _titleSafeDispose();

    LoggerService.info(
      'NotesProvider disposed.',
    );

    super.dispose();
  }

  /// Reserved for future cleanup if additional resources (streams, controllers,
  /// etc.) are added to this provider.
  void _titleSafeDispose() {
    // No resources to dispose currently.
  }
}

