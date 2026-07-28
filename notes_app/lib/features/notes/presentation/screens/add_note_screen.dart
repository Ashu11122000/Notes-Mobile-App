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
/// Contains no business logic.
///
/// ============================================================================

final class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({super.key});

  static const EdgeInsets _padding = EdgeInsets.all(16);

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
        appBar: AppBar(title: const Text('Create Note'), centerTitle: true),
        body: SafeArea(
          child: Padding(
            padding: _padding,
            child: NoteForm(
              submitLabel: 'Create Note',
              isLoading: isLoading,
              onSubmit:
                  (String title, String? content, ReminderModel? reminder) =>
                      _createNote(context, title, content, reminder),
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

    provider.clearError();

    final CreateNoteRequest request = CreateNoteRequest(
      title: title,
      content: content,
    );

    final Note? createdNote = await provider.createNote(request);

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

    if (reminder != null) {
      try {
        await provider.scheduleNoteReminder(
          note: createdNote,
          reminderTime: reminder.scheduledAt,
        );
      } catch (_) {
        // Reminder failure should not block successful note creation.
      }
    }

    provider.clearSelectedImage();

    if (!context.mounted) {
      return;
    }

    CustomSnackBar.show(
      context,
      message: 'Note created successfully.',
      type: SnackbarType.success,
    );

    context.pop(createdNote);
  }
}
