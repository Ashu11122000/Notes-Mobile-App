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
/// • Displays notes in a responsive grid.
/// • Handles pagination footer rendering.
/// • Delegates user actions through callbacks.
/// • Contains no business logic.
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

final class NoteGrid extends StatelessWidget {
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

  /// Notes collection.
  final List<Note> notes;

  /// Optional scroll controller.
  final ScrollController? controller;

  /// Shows pagination loader.
  final bool isLoadingMore;

  /// Number of grid columns.
  final int crossAxisCount;

  /// Card aspect ratio.
  final double childAspectRatio;

  /// Horizontal spacing.
  final double crossAxisSpacing;

  /// Vertical spacing.
  final double mainAxisSpacing;

  /// Grid padding.
  final EdgeInsetsGeometry padding;

  /// Note click callback.
  final ValueChanged<Note>? onNoteTap;

  /// Edit callback.
  final ValueChanged<Note>? onEdit;

  /// Delete callback.
  final ValueChanged<Note>? onDelete;

  // ===========================================================================
  // Constants
  // ===========================================================================

  static const double _cacheExtent = 800;

  @override
  Widget build(BuildContext context) {
    final int columns = crossAxisCount < 1 ? 1 : crossAxisCount;

    return GridView.builder(
      controller: controller,

      cacheExtent: _cacheExtent,

      padding: padding,

      physics: const AlwaysScrollableScrollPhysics(),

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,

        childAspectRatio: childAspectRatio,

        crossAxisSpacing: crossAxisSpacing,

        mainAxisSpacing: mainAxisSpacing,
      ),

      itemCount: notes.length + (isLoadingMore ? 1 : 0),

      itemBuilder: (BuildContext context, int index) {
        if (index >= notes.length) {
          return const PaginationLoader(message: '', padding: EdgeInsets.zero);
        }

        final Note note = notes[index];

        return NoteCard(
          note: note,

          onTap: onNoteTap == null ? null : () => onNoteTap!(note),

          onEdit: onEdit == null ? null : () => onEdit!(note),

          onDelete: onDelete == null ? null : () => onDelete!(note),
        );
      },
    );
  }
}
