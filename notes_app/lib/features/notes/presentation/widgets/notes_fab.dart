import 'package:flutter/material.dart';

import '../../constants/notes_constants.dart';

/// ============================================================================
/// File: notes_fab.dart
/// ============================================================================
///
/// Notes Floating Action Button
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Displays the primary action for creating a new note.
/// - Contains no business logic.
/// - Contains no navigation logic.
/// - Uses Material 3 FloatingActionButton.
/// - Reusable across the Notes feature.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///     ↓
/// NotesFab
///     ↓
/// Callback
///
/// ============================================================================

class NotesFab extends StatelessWidget {
  const NotesFab({
    super.key,
    required this.onPressed,
    this.tooltip = 'Create Note',
    this.label = 'New Note',
    this.icon = Icons.add,
    this.extended = true,
  });

  /// Called when the FAB is pressed.
  final VoidCallback onPressed;

  /// Tooltip displayed on long press.
  final String tooltip;

  /// Label shown by the extended FAB.
  final String label;

  /// FAB icon.
  final IconData icon;

  /// Whether to display an Extended FAB.
  final bool extended;

  @override
  Widget build(BuildContext context) {
    if (extended) {
      return FloatingActionButton.extended(
        heroTag: NotesConstants.notesFabHeroTag,
        onPressed: onPressed,
        tooltip: tooltip,
        icon: Icon(icon),
        label: Text(label),
      );
    }

    return FloatingActionButton(
      heroTag: NotesConstants.notesFabHeroTag,
      onPressed: onPressed,
      tooltip: tooltip,
      child: Icon(icon),
    );
  }
}
