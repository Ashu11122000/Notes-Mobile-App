import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../notifications/models/reminder_model.dart';
import '../../domain/entities/note.dart';
import '../providers/notes_provider.dart';
import '../widgets/note_form.dart';

/// ============================================================================
/// File: edit_note_screen.dart
/// ============================================================================
///
/// Edit Note Screen
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays a pre-filled form for editing a note.
/// • Delegates note updates to NotesProvider.
/// • Passes reminder information.
/// • Shows loading state.
/// • Displays success and error feedback.
/// • Clears temporary image selection.
/// • Navigates back after a successful update.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///     ↓
/// NotesProvider
///     ↓
/// NotesRepository
///     ↓
/// FastAPI
///
/// Reminder Flow
/// ----------------------------------------------------------------------------
/// UI
///     ↓
/// NotesProvider
///     ↓
/// ReminderManager
///     ↓
/// NotificationService
///
/// ============================================================================

final class EditNoteScreen extends StatelessWidget {
  const EditNoteScreen({super.key, required this.note});

  /// Note being edited.
  final Note note;

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (context, provider, child) {
        return PopScope(
          onPopInvokedWithResult: (_, __) {
            provider.clearSelectedImage();
          },
          child: Scaffold(
            appBar: AppBar(title: const Text('Edit Note'), centerTitle: true),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: NoteForm(
                  initialTitle: note.title,
                  initialContent: note.content ?? '',
                  submitLabel: 'Update Note',
                  isLoading: provider.isLoading,
                  onSubmit:
                      (
                        String title,
                        String? content,
                        ReminderModel? reminder,
                      ) async {
                        await _updateNote(
                          context,
                          provider,
                          title,
                          content,
                          reminder,
                        );
                      },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // Update Note
  // ===========================================================================

  Future<void> _updateNote(
    BuildContext context,
    NotesProvider provider,
    String title,
    String? content,
    ReminderModel? reminder,
  ) async {
    provider.clearError();

    await provider.updateNote(
      noteId: note.id,
      title: title,
      content: content,
      reminder: reminder,
    );

    if (!context.mounted) {
      return;
    }

    if (provider.hasError) {
      _showErrorSnackBar(
        context,
        provider.errorMessage ?? 'Failed to update note.',
      );
      return;
    }

    provider.clearSelectedImage();

    _showSuccessSnackBar(context);

    context.pop();
  }

  // ===========================================================================
  // SnackBars
  // ===========================================================================

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note updated successfully.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
