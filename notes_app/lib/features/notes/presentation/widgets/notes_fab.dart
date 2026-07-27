import 'package:flutter/material.dart';

import '../../constants/notes_constants.dart';

/// ============================================================================
/// File: notes_fab.dart
/// ============================================================================
///
/// Notes Floating Action Button.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays the primary create-note action.
/// • Emits user interaction through callback.
/// • Contains no navigation logic.
/// • Contains no business logic.
/// • Uses Material 3 FAB.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///  ↓
/// NotesFab
///  ↓
/// Callback
///
/// ============================================================================

final class NotesFab extends StatelessWidget {
  const NotesFab({
    super.key,
    required this.onPressed,
    this.tooltip = 'Create Note',
    this.label = 'New Note',
    this.icon = Icons.add_rounded,
    this.extended = true,
    this.enabled = true,
    this.heroTag = NotesConstants.notesFabHeroTag,
    this.iconSize = 24,
  });

  /// Called when FAB is pressed.
  final VoidCallback onPressed;

  /// Tooltip shown on long press.
  final String tooltip;

  /// Extended FAB label.
  final String label;

  /// FAB icon.
  final IconData icon;

  /// Displays extended FAB when true.
  final bool extended;

  /// Enables/disables FAB.
  final bool enabled;

  /// Hero animation tag.
  final Object heroTag;

  /// Icon size.
  final double iconSize;

  // ===========================================================================
  // Build
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    if (extended) {
      return Semantics(
        button: true,
        label: tooltip,

        child: FloatingActionButton.extended(
          heroTag: heroTag,

          onPressed: enabled ? onPressed : null,

          tooltip: tooltip,

          icon: Icon(icon, size: iconSize),

          label: Text(label),
        ),
      );
    }

    return Semantics(
      button: true,
      label: tooltip,

      child: FloatingActionButton(
        heroTag: heroTag,

        onPressed: enabled ? onPressed : null,

        tooltip: tooltip,

        child: Icon(icon, size: iconSize),
      ),
    );
  }
}
