import 'package:flutter/foundation.dart';

/// ============================================================================
/// File: note.dart
/// ============================================================================
///
/// Domain entity representing a Note.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Represents the core business object for the Notes feature.
/// - Independent of API, JSON serialization, Dio, and database.
/// - Used throughout the domain and presentation layers.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// Presentation
///      ↓
/// Provider
///      ↓
/// Repository
///      ↓
/// Note (Entity)
///
/// ============================================================================

@immutable
class Note {
  const Note({
    required this.id,
    required this.ownerId,
    required this.title,
    this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Unique note identifier.
  final int id;

  /// Owner (User) identifier.
  final int ownerId;

  /// Note title.
  final String title;

  /// Optional note content.
  final String? content;

  /// Creation timestamp.
  final DateTime createdAt;

  /// Last update timestamp.
  final DateTime updatedAt;

  /// Creates a copy of this entity with updated values.
  Note copyWith({
    int? id,
    int? ownerId,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Note &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            ownerId == other.ownerId &&
            title == other.title &&
            content == other.content &&
            createdAt == other.createdAt &&
            updatedAt == other.updatedAt;
  }

  @override
  int get hashCode =>
      Object.hash(id, ownerId, title, content, createdAt, updatedAt);

  @override
  String toString() {
    return 'Note('
        'id: $id, '
        'ownerId: $ownerId, '
        'title: $title, '
        'content: $content, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt'
        ')';
  }
}
