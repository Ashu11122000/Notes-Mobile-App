import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../notifications/models/reminder_model.dart';
import '../providers/notes_provider.dart';
import '../widgets/note_form.dart';

/// ============================================================================
/// File: add_note_screen.dart
/// ============================================================================
///
/// Add Note Screen
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays the form for creating a new note.
/// • Delegates note creation to NotesProvider.
/// • Passes reminder information.
/// • Shows loading state.
/// • Displays success and error feedback.
/// • Clears temporary image selection.
/// • Navigates back after successful creation.
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

final class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (context, provider, child) {
        return PopScope(
          onPopInvokedWithResult: (_, __) {
            provider.clearSelectedImage();
          },
          child: Scaffold(
            appBar: AppBar(title: const Text('Create Note'), centerTitle: true),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: NoteForm(
                  submitLabel: 'Create Note',
                  isLoading: provider.isLoading,
                  onSubmit:
                      (
                        String title,
                        String? content,
                        ReminderModel? reminder,
                      ) async {
                        await _createNote(
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
  // Create Note
  // ===========================================================================

  Future<void> _createNote(
    BuildContext context,
    NotesProvider provider,
    String title,
    String? content,
    ReminderModel? reminder,
  ) async {
    provider.clearError();

    await provider.createNote(
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
        provider.errorMessage ?? 'Failed to create note.',
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
        content: Text('Note created successfully.'),
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
