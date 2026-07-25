import 'package:flutter/foundation.dart';

/// ============================================================================
/// File: update_note_request.dart
/// ============================================================================
///
/// Request model used for updating an existing note.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Represents the request body for both PUT and PATCH operations.
/// - Immutable and strongly typed.
/// - Matches the FastAPI `NoteUpdate` schema.
///
/// Notes
/// ----------------------------------------------------------------------------
/// PUT:
/// Provide all fields.
///
/// PATCH:
/// Provide only the fields that should be updated.
///
/// ============================================================================

@immutable
class UpdateNoteRequest {
  const UpdateNoteRequest({this.title, this.content});

  /// Updated note title.
  final String? title;

  /// Updated note content.
  final String? content;

  /// Returns true if at least one field will be updated.
  bool get hasUpdates => title != null || content != null;

  /// Converts this request to JSON.
  ///
  /// Null values are omitted to support PATCH requests.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (title != null) {
      json['title'] = title!.trim();
    }

    if (content != null) {
      json['content'] = content?.trim();
    }

    return json;
  }

  /// Creates a copy with updated values.
  UpdateNoteRequest copyWith({String? title, String? content}) {
    return UpdateNoteRequest(
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UpdateNoteRequest &&
            runtimeType == other.runtimeType &&
            title == other.title &&
            content == other.content;
  }

  @override
  int get hashCode => Object.hash(title, content);

  @override
  String toString() {
    return 'UpdateNoteRequest('
        'title: $title, '
        'content: $content'
        ')';
  }
}
