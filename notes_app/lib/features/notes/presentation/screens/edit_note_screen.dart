import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../shared/enums/snackbar_type.dart';
import '../../../../shared/widgets/custom_snackbar.dart';
import '../../../notifications/models/reminder_model.dart';
import '../../data/models/update_note_request.dart';
import '../../domain/entities/note.dart';
import '../providers/notes_provider.dart';
import '../widgets/note_form.dart';

/// ============================================================================
/// File: edit_note_screen.dart
/// ============================================================================
///
/// Edit Note Screen.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays pre-filled note form.
/// • Creates UpdateNoteRequest.
/// • Delegates update to NotesProvider.
/// • Handles navigation after success.
/// • Shows user feedback.
///
/// Does NOT:
/// ----------------------------------------------------------------------------
/// • Call API.
/// • Access repository.
/// • Handle business rules.
///
/// ============================================================================

final class EditNoteScreen extends StatelessWidget {
  const EditNoteScreen({super.key, required this.note});

  /// Note being edited.
  final Note note;

  @override
  Widget build(BuildContext context) {
    final NotesProvider provider = context.watch<NotesProvider>();

    return PopScope(
      onPopInvokedWithResult: (_, __) {
        context.read<NotesProvider>().clearSelectedImage();
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
                    await _updateNote(context, title, content, reminder);
                  },
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Update Note
  // ===========================================================================

  Future<void> _updateNote(
    BuildContext context,
    String title,
    String? content,
    ReminderModel? reminder,
  ) async {
    final NotesProvider provider = context.read<NotesProvider>();

    // Clear previous error state.
    provider.clearError();

    final Note? updatedNote = await provider.updateNote(
      note.id,

      UpdateNoteRequest(title: title, content: content),
    );

    if (!context.mounted) {
      return;
    }

    if (updatedNote == null) {
      CustomSnackBar.show(
        context,

        message: provider.errorMessage ?? 'Failed to update note.',

        type: SnackbarType.error,
      );

      return;
    }

    // ===============================================================
    // Reminder Handling
    // ===============================================================

    if (reminder != null) {
      await provider.scheduleNoteReminder(
        note: updatedNote,

        reminderTime: reminder.scheduledAt,
      );
    }

    provider.clearSelectedImage();

    CustomSnackBar.show(
      context,

      message: 'Note updated successfully.',

      type: SnackbarType.success,
    );

    context.pop();
  }
}
