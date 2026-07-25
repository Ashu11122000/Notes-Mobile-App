import 'package:flutter/material.dart';

/// ============================================================================
/// File: delete_note_dialog.dart
/// ============================================================================
///
/// Delete Note Dialog
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Displays a confirmation dialog before deleting a note.
/// - Contains no business logic.
/// - Returns:
///     true  -> User confirmed deletion.
///     false -> User cancelled.
///     null  -> Dialog dismissed.
///
/// ============================================================================
final class DeleteNoteDialog {
  const DeleteNoteDialog._();

  /// Shows the delete confirmation dialog.
  static Future<bool?> show(BuildContext context, {String? noteTitle}) {
    final theme = Theme.of(context);

    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.delete_outline_rounded, size: 32),
          title: const Text('Delete Note'),
          content: Text(
            noteTitle == null || noteTitle.trim().isEmpty
                ? 'Are you sure you want to delete this note?\n\n'
                      'This action cannot be undone.'
                : 'Are you sure you want to delete '
                      '"$noteTitle"?\n\n'
                      'This action cannot be undone.',
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              icon: const Icon(Icons.delete),
              label: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
