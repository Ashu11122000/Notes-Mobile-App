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
/// • Uses Material 3 Floating Action Button.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// UI
///   ↓
/// NotesFab
///   ↓
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
    this.iconSize = 24.0,
  });

  /// Called when FAB is pressed.
  final VoidCallback onPressed;

  /// Tooltip shown on long press.
  final String tooltip;

  /// Extended FAB label.
  final String label;

  /// FAB icon.
  final IconData icon;

  /// Displays an extended FAB when true.
  final bool extended;

  /// Enables/disables the FAB.
  final bool enabled;

  /// Hero animation tag.
  final Object heroTag;

  /// Icon size.
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final Widget fabIcon = Icon(icon, size: iconSize);

    final VoidCallback? callback = enabled ? onPressed : null;

    return Semantics(
      button: true,
      enabled: enabled,
      label: tooltip,
      child: extended
          ? FloatingActionButton.extended(
              heroTag: heroTag,
              tooltip: tooltip,
              onPressed: callback,
              icon: fabIcon,
              label: Text(label),
            )
          : FloatingActionButton(
              heroTag: heroTag,
              tooltip: tooltip,
              onPressed: callback,
              child: fabIcon,
            ),
    );
  }
}
