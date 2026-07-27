import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../shared/enums/snackbar_type.dart';
import '../../../../shared/widgets/custom_snackbar.dart';
import '../../../notifications/models/reminder_model.dart';
import '../../data/models/create_note_request.dart';
import '../../domain/entities/note.dart';
import '../providers/notes_provider.dart';
import '../widgets/note_form.dart';

/// ============================================================================
/// File: add_note_screen.dart
/// ============================================================================
///
/// Add Note Screen.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays note creation form.
/// • Creates CreateNoteRequest.
/// • Delegates creation to NotesProvider.
/// • Handles navigation after success.
/// • Shows user feedback.
///
/// Does NOT:
/// ----------------------------------------------------------------------------
/// • Call API directly.
/// • Access repository.
/// • Handle business rules.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///   ↓
/// NotesProvider
///   ↓
/// NotesRepository
///   ↓
/// FastAPI
///
/// ============================================================================

final class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotesProvider provider = context.watch<NotesProvider>();

    return PopScope(
      onPopInvokedWithResult: (_, __) {
        context.read<NotesProvider>().clearSelectedImage();
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
                    await _createNote(context, title, content, reminder);
                  },
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Create Note
  // ===========================================================================

  Future<void> _createNote(
    BuildContext context,
    String title,
    String? content,
    ReminderModel? reminder,
  ) async {
    final NotesProvider provider = context.read<NotesProvider>();

    // Clear old error before new operation.
    provider.clearError();

    final Note? createdNote = await provider.createNote(
      CreateNoteRequest(title: title, content: content),
    );

    if (!context.mounted) {
      return;
    }

    if (createdNote == null) {
      CustomSnackBar.show(
        context,

        message: provider.errorMessage ?? 'Failed to create note.',

        type: SnackbarType.error,
      );

      return;
    }

    // ===============================================================
    // Reminder Handling
    // ===============================================================

    if (reminder != null) {
      await provider.scheduleNoteReminder(
        note: createdNote,

        reminderTime: reminder.scheduledAt,
      );
    }

    provider.clearSelectedImage();

    CustomSnackBar.show(
      context,

      message: 'Note created successfully.',

      type: SnackbarType.success,
    );

    context.pop();
  }
}
