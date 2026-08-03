import 'package:flutter/material.dart';

import '../../domain/entities/note.dart';
import 'note_card.dart';
import 'pagination_loader.dart';

/// ============================================================================
/// File: note_grid.dart
/// ============================================================================
///
/// Responsive Notes Grid.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays notes in a performant grid.
/// • Supports pagination footer.
/// • Delegates interactions through callbacks.
/// • Contains no business logic.
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
    this.crossAxisSpacing = 16.0,
    this.mainAxisSpacing = 16.0,
    this.padding = const EdgeInsets.all(16.0),
    this.onNoteTap,
    this.onEdit,
    this.onDelete,
  });

  /// Notes collection.
  final List<Note> notes;

  /// Optional scroll controller.
  final ScrollController? controller;

  /// Displays pagination loader.
  final bool isLoadingMore;

  /// Number of columns.
  final int crossAxisCount;

  /// Child aspect ratio.
  final double childAspectRatio;

  /// Horizontal spacing.
  final double crossAxisSpacing;

  /// Vertical spacing.
  final double mainAxisSpacing;

  /// Grid padding.
  final EdgeInsetsGeometry padding;

  /// Note tapped.
  final ValueChanged<Note>? onNoteTap;

  /// Edit note.
  final ValueChanged<Note>? onEdit;

  /// Delete note.
  final ValueChanged<Note>? onDelete;

  // ===========================================================================
  // Constants
  // ===========================================================================

  static const double _cacheExtent = 500.0;

  @override
  Widget build(BuildContext context) {
    final int columns = crossAxisCount.clamp(1, 8);

    return GridView.builder(
      controller: controller,

      padding: padding,

      cacheExtent: _cacheExtent,

      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

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

        return KeyedSubtree(
          key: ValueKey<int>(note.id),
          child: NoteCard(
            note: note,

            onTap: onNoteTap == null ? null : () => onNoteTap!(note),

            onEdit: onEdit == null ? null : () => onEdit!(note),

            onDelete: onDelete == null ? null : () => onDelete!(note),
          ),
        );
      },
    );
  }
}
