import 'package:flutter/material.dart';

/// ============================================================================
/// File: empty_notes_widget.dart
/// ============================================================================
///
/// Empty Notes Widget
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Displays an empty state when no notes are available.
/// - Encourages the user to create their first note.
/// - Contains no business logic.
/// - Reusable across multiple screens.
///
/// ============================================================================
class EmptyNotesWidget extends StatelessWidget {
  const EmptyNotesWidget({super.key, this.onCreatePressed});

  /// Called when the user taps the "Create Note" button.
  final VoidCallback? onCreatePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //------------------------------------------------------------------
            // Illustration
            //------------------------------------------------------------------
            Icon(
              Icons.sticky_note_2_outlined,
              size: 96,
              color: theme.colorScheme.primary,
            ),

            const SizedBox(height: 24),

            //------------------------------------------------------------------
            // Title
            //------------------------------------------------------------------
            Text(
              'No Notes Yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            //------------------------------------------------------------------
            // Description
            //------------------------------------------------------------------
            Text(
              'Create your first note to start organizing your ideas, '
              'tasks, and reminders.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            //------------------------------------------------------------------
            // Action Button
            //------------------------------------------------------------------
            FilledButton.icon(
              onPressed: onCreatePressed,
              icon: const Icon(Icons.add),
              label: const Text('Create Note'),
            ),
          ],
        ),
      ),
    );
  }
}
