import 'package:flutter/foundation.dart';

/// ============================================================================
/// File: create_note_request.dart
/// ============================================================================
///
/// Request model used when creating a new note.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Serialize request body for the Create Note API.
/// - Immutable and strongly typed.
/// - Provide validation helpers.
/// - Match the FastAPI request schema.
///
/// Example JSON:
///
/// {
///   "title": "Shopping List",
///   "content": "Buy milk and eggs."
/// }
///
/// ============================================================================

@immutable
class CreateNoteRequest {
  const CreateNoteRequest({required this.title, this.content});

  /// Title of the note.
  final String title;

  /// Optional note content.
  final String? content;

  /// Returns true if the request contains a valid title.
  bool get isValid => title.trim().isNotEmpty;

  /// Converts this request into JSON.
  Map<String, dynamic> toJson() {
    return {'title': title.trim(), 'content': content?.trim()};
  }

  /// Creates a copy with updated values.
  CreateNoteRequest copyWith({String? title, String? content}) {
    return CreateNoteRequest(
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CreateNoteRequest &&
            runtimeType == other.runtimeType &&
            title == other.title &&
            content == other.content;
  }

  @override
  int get hashCode => Object.hash(title, content);

  @override
  String toString() {
    return 'CreateNoteRequest('
        'title: $title, '
        'content: $content'
        ')';
  }
}
