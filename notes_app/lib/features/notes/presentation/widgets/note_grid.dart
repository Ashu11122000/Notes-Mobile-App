import 'package:flutter/material.dart';

import '../../domain/entities/note.dart';
import 'note_card.dart';
import 'pagination_loader.dart';

/// ============================================================================
/// File: note_grid.dart
/// ============================================================================
///
/// Reusable Notes Grid.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Displays notes in a responsive grid layout.
/// - Supports pagination.
/// - Delegates user interactions through callbacks.
/// - Contains no business logic.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// NotesListScreen
///        ↓
///     NoteGrid
///        ↓
///     NoteCard
///
/// ============================================================================

class NoteGrid extends StatelessWidget {
  const NoteGrid({
    super.key,
    required this.notes,
    this.controller,
    this.isLoadingMore = false,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.9,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 16,
    this.padding = const EdgeInsets.all(16),
    this.onNoteTap,
    this.onEdit,
    this.onDelete,
  });

  /// Notes to display.
  final List<Note> notes;

  /// Optional scroll controller.
  final ScrollController? controller;

  /// Indicates whether another page is loading.
  final bool isLoadingMore;

  /// Grid columns.
  final int crossAxisCount;

  /// Aspect ratio of each card.
  final double childAspectRatio;

  /// Horizontal spacing.
  final double crossAxisSpacing;

  /// Vertical spacing.
  final double mainAxisSpacing;

  /// Outer padding.
  final EdgeInsetsGeometry padding;

  /// Called when a note is tapped.
  final ValueChanged<Note>? onNoteTap;

  /// Called when edit is selected.
  final ValueChanged<Note>? onEdit;

  /// Called when delete is selected.
  final ValueChanged<Note>? onDelete;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: controller,
      padding: padding,
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemCount: notes.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= notes.length) {
          return const PaginationLoader(message: '', padding: EdgeInsets.zero);
        }

        final note = notes[index];

        return NoteCard(
          note: note,
          onTap: () => onNoteTap?.call(note),
          onEdit: () => onEdit?.call(note),
          onDelete: () => onDelete?.call(note),
        );
      },
    );
  }
}
