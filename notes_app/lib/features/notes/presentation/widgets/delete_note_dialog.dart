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
/// • Returns:
///     true  → User confirmed deletion.
///     false → User cancelled.
///     null  → Dialog dismissed.
///
/// Contains no business logic.
///
/// ============================================================================

final class DeleteNoteDialog {
  const DeleteNoteDialog._();

  // ===========================================================================
  // Show Dialog
  // ===========================================================================

  static Future<bool?> show(BuildContext context, {String? noteTitle}) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          icon: Semantics(
            label: 'Delete note warning',
            child: Icon(
              Icons.delete_outline_rounded,
              size: 36,
              color: colorScheme.error,
            ),
          ),

          title: const Text('Delete Note'),

          content: Text(_buildMessage(noteTitle), style: textTheme.bodyMedium),

          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),

          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),

            FilledButton.icon(
              onPressed: () => Navigator.of(dialogContext).pop(true),

              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),

              icon: const Icon(Icons.delete_rounded),

              label: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // ===========================================================================
  // Helpers
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
