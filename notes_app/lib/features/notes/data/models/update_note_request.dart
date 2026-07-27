import 'package:flutter/foundation.dart';

/// ============================================================================
/// File: update_note_request.dart
/// ============================================================================
///
/// Request model for updating an existing note.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Represents the request body for PUT and PATCH operations.
/// • Serializes data for the FastAPI backend.
/// • Omits null values to support partial updates.
/// • Provides lightweight validation helpers.
/// • Remains immutable and strongly typed.
///
/// Notes
/// ----------------------------------------------------------------------------
/// PUT
/// Supply every field required by the backend.
///
/// PATCH
/// Supply only the fields that should be modified.
///
/// ============================================================================

@immutable
final class UpdateNoteRequest {
  const UpdateNoteRequest({this.title, this.content});

  /// Updated note title.
  final String? title;

  /// Updated note content.
  final String? content;

  // ===========================================================================
  // Computed Properties
  // ===========================================================================

  /// Normalized title.
  ///
  /// Returns null when the value is null or empty after trimming.
  String? get normalizedTitle {
    final String? value = title?.trim();

    if (value == null || value.isEmpty) {
      return null;
    }

    return value;
  }

  /// Normalized content.
  ///
  /// Returns null when the value is null or empty after trimming.
  String? get normalizedContent {
    final String? value = content?.trim();

    if (value == null || value.isEmpty) {
      return null;
    }

    return value;
  }

  /// Returns true when the title will be updated.
  bool get hasTitleUpdate => normalizedTitle != null;

  /// Returns true when the content will be updated.
  bool get hasContentUpdate => normalizedContent != null;

  /// Returns true when at least one field will be updated.
  bool get hasUpdates => hasTitleUpdate || hasContentUpdate;

  // ===========================================================================
  // Serialization
  // ===========================================================================

  /// Converts this request into the JSON format expected by FastAPI.
  ///
  /// Null values are intentionally omitted to support PATCH requests.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    if (normalizedTitle != null) {
      json['title'] = normalizedTitle;
    }

    if (normalizedContent != null) {
      json['content'] = normalizedContent;
    }

    return json;
  }

  // ===========================================================================
  // Copy
  // ===========================================================================

  UpdateNoteRequest copyWith({String? title, String? content}) {
    return UpdateNoteRequest(
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  // ===========================================================================
  // Equality
  // ===========================================================================

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UpdateNoteRequest &&
            title == other.title &&
            content == other.content;
  }

  @override
  int get hashCode => Object.hash(title, content);

  // ===========================================================================
  // Debugging
  // ===========================================================================

  @override
  String toString() {
    return 'UpdateNoteRequest('
        'title: $title, '
        'content: $content'
        ')';
  }
}
