import 'package:flutter/material.dart';

/// ============================================================================
/// File: delete_note_dialog.dart
/// ============================================================================
///
/// Delete Note Confirmation Dialog.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays delete confirmation UI.
/// • Handles only user interaction.
/// • Contains no business logic.
/// • Returns:
///
///     true  → User confirmed deletion.
///     false → User cancelled.
///     null  → Dialog dismissed.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///  ↓
/// DeleteNoteDialog
///  ↓
/// User Decision
///  ↓
/// NotesProvider
///
/// ============================================================================

final class DeleteNoteDialog {
  const DeleteNoteDialog._();

  // ===========================================================================
  // Show Dialog
  // ===========================================================================

  /// Displays the delete confirmation dialog.
  static Future<bool?> show(BuildContext context, {String? noteTitle}) {
    final ThemeData theme = Theme.of(context);

    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          icon: Icon(
            Icons.delete_outline_rounded,
            size: 36,
            color: theme.colorScheme.error,
          ),

          title: const Text('Delete Note'),

          content: Text(
            _buildMessage(noteTitle),
            style: theme.textTheme.bodyMedium,
          ),

          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),

          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),

            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),

              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },

              icon: const Icon(Icons.delete_rounded),

              label: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // ===========================================================================
  // Private Helpers
  // ===========================================================================

  static String _buildMessage(String? noteTitle) {
    final String title = noteTitle?.trim() ?? '';

    if (title.isEmpty) {
      return 'Are you sure you want to delete this note?\n\n'
          'This action cannot be undone.';
    }

    return 'Are you sure you want to delete '
        '"$title"?\n\n'
        'This action cannot be undone.';
  }
}
