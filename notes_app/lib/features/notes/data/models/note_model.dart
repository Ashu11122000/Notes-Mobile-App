import '../../domain/entities/note.dart';

/// ============================================================================
/// File: note_model.dart
/// ============================================================================
///
/// Data model for Note.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Parses API responses.
/// - Serializes request/response objects.
/// - Maps between JSON and the domain [Note] entity.
///
/// This model extends the domain [Note] entity while adding JSON
/// serialization support.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// FastAPI JSON
///        ↓
///    NoteModel
///        ↓
///      Note
///
/// ============================================================================

final class NoteModel extends Note {
  const NoteModel({
    required super.id,
    required super.ownerId,
    required super.title,
    super.content,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Creates a model from JSON.
  factory NoteModel.fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.parse(json['created_at'] as String);

    return NoteModel(
      id: (json['id'] as num).toInt(),
      ownerId: (json['owner_id'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String?,
      createdAt: createdAt,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : createdAt,
    );
  }

  /// Creates a model from a domain entity.
  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      ownerId: note.ownerId,
      title: note.title,
      content: note.content,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
    );
  }

  /// Converts the model to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'owner_id': ownerId,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Converts the model to the domain entity.
  Note toEntity() {
    return Note(
      id: id,
      ownerId: ownerId,
      title: title,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Creates a copy with updated values.
  NoteModel copyWith({
    int? id,
    int? ownerId,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'NoteModel('
        'id: $id, '
        'ownerId: $ownerId, '
        'title: $title, '
        'content: $content, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt'
        ')';
  }
}
