import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/note.dart';

/// ============================================================================
/// File: note_card.dart
/// ============================================================================
///
/// Reusable Note Card.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Displays a single note.
/// - Handles user interactions through callbacks.
/// - Contains no business logic.
/// - Supports Material 3.
///
/// ============================================================================
class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  /// Note to display.
  final Note note;

  /// Called when the card is tapped.
  final VoidCallback? onTap;

  /// Called when edit is selected.
  final VoidCallback? onEdit;

  /// Called when delete is selected.
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final date = DateFormat.yMMMd().add_jm().format(note.updatedAt);

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //----------------------------------------------------------------
              // Header
              //----------------------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  PopupMenuButton<_NoteCardAction>(
                    tooltip: 'More',
                    onSelected: (action) {
                      switch (action) {
                        case _NoteCardAction.edit:
                          onEdit?.call();
                          break;

                        case _NoteCardAction.delete:
                          onDelete?.call();
                          break;
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: _NoteCardAction.edit,
                        child: ListTile(
                          leading: Icon(Icons.edit_outlined),
                          title: Text('Edit'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      PopupMenuItem(
                        value: _NoteCardAction.delete,
                        child: ListTile(
                          leading: Icon(Icons.delete_outline),
                          title: Text('Delete'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              //----------------------------------------------------------------
              // Content
              //----------------------------------------------------------------
              Text(
                note.content?.trim().isNotEmpty == true
                    ? note.content!
                    : 'No content',
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium,
              ),

              const Spacer(),

              //----------------------------------------------------------------
              // Footer
              //----------------------------------------------------------------
              const Divider(),

              Row(
                children: [
                  const Icon(Icons.schedule_outlined, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      date,
                      style: theme.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _NoteCardAction { edit, delete }
