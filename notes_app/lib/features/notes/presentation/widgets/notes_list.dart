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
/// • Supports pagination loading.
/// • Delegates user interactions.
/// • Contains no business logic.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// NotesScreen
///      ↓
/// NoteList
///      ↓
/// NoteCard
///
/// ============================================================================

final class NoteList extends StatelessWidget {
  const NoteList({
    super.key,
    required this.notes,
    this.controller,
    this.isLoadingMore = false,
    this.padding = const EdgeInsets.all(16.0),
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

  /// List padding.
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

  /// Optimized for 8 GB RAM laptops.
  static const double _cacheExtent = 500.0;

  static const double _itemSpacing = 12.0;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,

      padding: padding,

      cacheExtent: _cacheExtent,

      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

      physics: const AlwaysScrollableScrollPhysics(),

      itemCount: notes.length + (isLoadingMore ? 1 : 0),

      separatorBuilder: (_, _) => const SizedBox(height: _itemSpacing),

      itemBuilder: (BuildContext context, int index) {
        if (index >= notes.length) {
          return const PaginationLoader();
        }

        final Note note = notes[index];

        return KeyedSubtree(
          key: ValueKey<int>(note.id),
          child: Semantics(
            container: true,
            label: 'Note ${index + 1}: ${note.title}',
            child: NoteCard(
              note: note,

              onTap: onNoteTap == null ? null : () => onNoteTap!(note),

              onEdit: onEdit == null ? null : () => onEdit!(note),

              onDelete: onDelete == null ? null : () => onDelete!(note),
            ),
          ),
        );
      },
    );
  }
}
