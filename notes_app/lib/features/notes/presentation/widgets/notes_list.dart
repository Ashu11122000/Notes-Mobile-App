import 'package:flutter/material.dart';

import '../../domain/entities/note.dart';
import 'note_card.dart';
import 'pagination_loader.dart';

/// ============================================================================
/// File: notes_list.dart
/// ============================================================================
///
/// Reusable Notes List.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays a scrollable list of notes.
/// • Supports infinite scrolling.
/// • Displays pagination loading state.
/// • Delegates user interactions.
/// • Contains no business logic.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// NotesScreen
///        ↓
///     NoteList
///        ↓
///     NoteCard
///
/// ============================================================================

final class NoteList extends StatelessWidget {
  const NoteList({
    super.key,
    required this.notes,
    this.controller,
    this.isLoadingMore = false,
    this.padding = const EdgeInsets.all(16),
    this.onNoteTap,
    this.onEdit,
    this.onDelete,
  });

  /// Notes collection.
  final List<Note> notes;

  /// Optional scroll controller.
  final ScrollController? controller;

  /// Indicates pagination loading.
  final bool isLoadingMore;

  /// Outer list padding.
  final EdgeInsetsGeometry padding;

  /// Note tap callback.
  final ValueChanged<Note>? onNoteTap;

  /// Edit callback.
  final ValueChanged<Note>? onEdit;

  /// Delete callback.
  final ValueChanged<Note>? onDelete;

  // ===========================================================================
  // Constants
  // ===========================================================================

  static const double _cacheExtent = 800;

  static const double _itemSpacing = 12;

  // ===========================================================================
  // Build
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,

      padding: padding,

      cacheExtent: _cacheExtent,

      physics: const AlwaysScrollableScrollPhysics(),

      itemCount: notes.length + (isLoadingMore ? 1 : 0),

      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: _itemSpacing);
      },

      itemBuilder: (BuildContext context, int index) {
        if (index >= notes.length) {
          return const PaginationLoader();
        }

        final Note note = notes[index];

        return Semantics(
          label: 'Note item ${index + 1}',

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
