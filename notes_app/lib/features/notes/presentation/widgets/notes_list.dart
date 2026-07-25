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
/// - Displays a scrollable list of notes.
/// - Supports infinite scrolling.
/// - Displays a pagination loader.
/// - Delegates user interactions through callbacks.
/// - Contains no business logic.
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

class NoteList extends StatelessWidget {
  const NoteList({
    super.key,
    required this.notes,
    this.controller,
    this.isLoadingMore = false,
    this.onNoteTap,
    this.onEdit,
    this.onDelete,
  });

  /// Notes to display.
  final List<Note> notes;

  /// Optional scroll controller.
  final ScrollController? controller;

  /// Indicates whether the next page is loading.
  final bool isLoadingMore;

  /// Called when a note is tapped.
  final ValueChanged<Note>? onNoteTap;

  /// Called when edit is selected.
  final ValueChanged<Note>? onEdit;

  /// Called when delete is selected.
  final ValueChanged<Note>? onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      padding: const EdgeInsets.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: notes.length + (isLoadingMore ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index >= notes.length) {
          return const PaginationLoader();
        }

        final Note note = notes[index];

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
