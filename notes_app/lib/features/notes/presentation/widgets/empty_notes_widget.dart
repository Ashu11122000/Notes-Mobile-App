import 'package:flutter/material.dart';

/// ============================================================================
/// File: empty_notes_widget.dart
/// ============================================================================
///
/// Empty Notes Widget.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays empty state UI when no notes exist.
/// • Provides a create note action.
/// • Contains no business logic.
/// • Fully reusable across Notes screens.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///  ↓
/// EmptyNotesWidget
///  ↓
/// Callback
///  ↓
/// NotesProvider / Navigation
///
/// ============================================================================

final class EmptyNotesWidget extends StatelessWidget {
  const EmptyNotesWidget({
    super.key,
    this.onCreatePressed,
    this.title = 'No Notes Yet',
    this.description =
        'Create your first note to start organizing your ideas, '
        'tasks, and reminders.',
  });

  /// Triggered when user taps create button.
  final VoidCallback? onCreatePressed;

  /// Empty state title.
  final String title;

  /// Empty state description.
  final String description;

  // ===========================================================================
  // Constants
  // ===========================================================================

  static const double _horizontalPadding = 32;

  static const double _iconSize = 96;

  static const double _titleSpacing = 24;

  static const double _descriptionSpacing = 12;

  static const double _buttonSpacing = 32;

  static const double _maxTextWidth = 360;

  // ===========================================================================
  // Build
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            // =================================================================
            // Illustration
            // =================================================================
            Semantics(
              label: 'No notes available',
              child: Icon(
                Icons.sticky_note_2_outlined,
                size: _iconSize,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(height: _titleSpacing),

            // =================================================================
            // Title
            // =================================================================
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: _descriptionSpacing),

            // =================================================================
            // Description
            // =================================================================
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxTextWidth),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),

            const SizedBox(height: _buttonSpacing),

            // =================================================================
            // Action
            // =================================================================
            FilledButton.icon(
              onPressed: onCreatePressed,

              icon: const Icon(Icons.add_rounded),

              label: const Text('Create Note'),
            ),
          ],
        ),
      ),
    );
  }
}
