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
/// • Displays a pre-filled note form.
/// • Creates UpdateNoteRequest.
/// • Delegates update to NotesProvider.
/// • Handles navigation after success.
/// • Shows user feedback.
///
/// Contains no business logic.
///
/// ============================================================================

final class EditNoteScreen extends StatelessWidget {
  const EditNoteScreen({super.key, required this.note});

  /// Note being edited.
  final Note note;

  static const EdgeInsets _pagePadding = EdgeInsets.all(16);

  @override
  Widget build(BuildContext context) {
    final bool isLoading = context.select<NotesProvider, bool>(
      (NotesProvider provider) => provider.isLoading,
    );

    return PopScope(
      onPopInvokedWithResult: (_, __) {
        context.read<NotesProvider>().clearSelectedImage();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Note'), centerTitle: true),
        body: SafeArea(
          child: Padding(
            padding: _pagePadding,
            child: NoteForm(
              initialTitle: note.title,
              initialContent: note.content ?? '',
              submitLabel: 'Update Note',
              isLoading: isLoading,
              onSubmit:
                  (String title, String? content, ReminderModel? reminder) =>
                      _updateNote(context, title, content, reminder),
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

    provider.clearError();

    final UpdateNoteRequest request = UpdateNoteRequest(
      title: title,
      content: content,
    );

    final Note? updatedNote = await provider.updateNote(note.id, request);

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

    if (reminder != null) {
      try {
        await provider.scheduleNoteReminder(
          note: updatedNote,
          reminderTime: reminder.scheduledAt,
        );
      } catch (_) {
        // Reminder scheduling failure should not prevent
        // successful note update.
      }
    }

    provider.clearSelectedImage();

    if (!context.mounted) {
      return;
    }

    CustomSnackBar.show(
      context,
      message: 'Note updated successfully.',
      type: SnackbarType.success,
    );

    context.pop(updatedNote);
  }
}
