import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
/// - Displays the form for creating a new note.
/// - Validates user input.
/// - Delegates note creation to NotesProvider.
/// - Shows loading state while creating a note.
/// - Displays success and error feedback.
/// - Navigates back on successful creation.
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
/// ============================================================================

final class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Create Note'), centerTitle: true),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: NoteForm(
                submitLabel: 'Create Note',
                isLoading: provider.isLoading,
                onSubmit: (title, content) async {
                  await _createNote(context, provider, title, content);
                },
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
  ) async {
    provider.clearError();

    await provider.createNote(title: title, content: content);

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
