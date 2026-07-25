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
/// - Handles note interactions.
/// - Supports edit and delete actions.
/// - Displays last updated date.
/// - Uses a layout safe for ListView.
///
//// ============================================================================

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

  /// Called when Edit is selected.
  final VoidCallback? onEdit;

  /// Called when Delete is selected.
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String date = DateFormat.yMMMd().add_jm().format(note.updatedAt);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PopupMenuButton<_NoteCardAction>(
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
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined),
                            SizedBox(width: 12),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: _NoteCardAction.delete,
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline),
                            SizedBox(width: 12),
                            Text('Delete'),
                          ],
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
                (note.content?.trim().isNotEmpty ?? false)
                    ? note.content!
                    : 'No content',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium,
              ),

              const SizedBox(height: 16),

              const Divider(height: 1),

              const SizedBox(height: 12),

              //----------------------------------------------------------------
              // Footer
              //----------------------------------------------------------------
              Row(
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      date,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
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
