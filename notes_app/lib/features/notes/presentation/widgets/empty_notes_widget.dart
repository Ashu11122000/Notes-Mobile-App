import 'package:flutter/material.dart';

/// ============================================================================
/// File: empty_notes_widget.dart
/// ============================================================================
///
/// Empty Notes Widget.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays an empty state when no notes exist.
/// • Provides an optional create note action.
/// • Contains no business logic.
/// • Fully reusable across Notes screens.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///   ↓
/// EmptyNotesWidget
///   ↓
/// Callback
///   ↓
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
    this.buttonText = 'Create Note',
    this.icon = Icons.sticky_note_2_outlined,
  });

  /// Invoked when the user presses the create button.
  final VoidCallback? onCreatePressed;

  /// Empty state title.
  final String title;

  /// Empty state description.
  final String description;

  /// Action button label.
  final String buttonText;

  /// Empty state icon.
  final IconData icon;

  // ===========================================================================
  // Layout Constants
  // ===========================================================================

  static const double _horizontalPadding = 32.0;
  static const double _iconSize = 96.0;
  static const double _titleSpacing = 24.0;
  static const double _descriptionSpacing = 12.0;
  static const double _buttonSpacing = 32.0;
  static const double _maxTextWidth = 360.0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Semantics(
              label: 'No notes available',
              image: true,
              child: Icon(icon, size: _iconSize, color: colorScheme.primary),
            ),

            const SizedBox(height: _titleSpacing),

            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: _descriptionSpacing),

            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxTextWidth),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),

            if (onCreatePressed != null) ...<Widget>[
              const SizedBox(height: _buttonSpacing),
              FilledButton.icon(
                onPressed: onCreatePressed,
                icon: const Icon(Icons.add_rounded),
                label: Text(buttonText),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
