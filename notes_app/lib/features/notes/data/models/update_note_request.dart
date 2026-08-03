import 'package:flutter/foundation.dart';

/// ============================================================================
/// File: update_note_request.dart
/// ============================================================================
///
/// Immutable request model for updating an existing note.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Represents the request body for PUT and PATCH operations.
/// • Normalizes user input.
/// • Omits null or empty values from JSON.
/// • Provides lightweight validation helpers.
/// • Remains immutable and strongly typed.
///
/// Notes
/// ----------------------------------------------------------------------------
/// PUT
/// - Typically supplies all required fields expected by the backend.
///
/// PATCH
/// - Supplies only the fields that should be modified.
///
/// ============================================================================

@immutable
final class UpdateNoteRequest {
  const UpdateNoteRequest({this.title, this.content});

  // ===========================================================================
  // Fields
  // ===========================================================================

  /// Updated note title.
  final String? title;

  /// Updated note content.
  final String? content;

  // ===========================================================================
  // Helpers
  // ===========================================================================

  static String? _normalize(String? value) {
    final String? normalized = value?.trim();

    return (normalized == null || normalized.isEmpty) ? null : normalized;
  }

  // ===========================================================================
  // Computed Properties
  // ===========================================================================

  /// Normalized title.
  String? get normalizedTitle => _normalize(title);

  /// Normalized content.
  String? get normalizedContent => _normalize(content);

  /// Returns true when the title will be updated.
  bool get hasTitleUpdate => normalizedTitle != null;

  /// Returns true when the content will be updated.
  bool get hasContentUpdate => normalizedContent != null;

  /// Returns true when at least one field will be updated.
  bool get hasUpdates => hasTitleUpdate || hasContentUpdate;

  // ===========================================================================
  // Serialization
  // ===========================================================================

  /// Converts this request into the JSON payload expected by the FastAPI backend.
  ///
  /// Null or empty values are intentionally omitted to support PATCH requests.
  Map<String, dynamic> toJson() {
    final String? normalizedTitle = this.normalizedTitle;
    final String? normalizedContent = this.normalizedContent;

    return <String, dynamic>{
      if (normalizedTitle != null) 'title': normalizedTitle,
      if (normalizedContent != null) 'content': normalizedContent,
    };
  }

  // ===========================================================================
  // Copy
  // ===========================================================================

  /// Creates a modified copy of this request.
  ///
  /// Use [clearTitle] or [clearContent] to explicitly remove a field.
  UpdateNoteRequest copyWith({
    String? title,
    String? content,
    bool clearTitle = false,
    bool clearContent = false,
  }) {
    return UpdateNoteRequest(
      title: clearTitle ? null : (title ?? this.title),
      content: clearContent ? null : (content ?? this.content),
    );
  }

  // ===========================================================================
  // Equality
  // ===========================================================================

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateNoteRequest &&
            other.title == title &&
            other.content == content);
  }

  @override
  int get hashCode => Object.hash(title, content);

  // ===========================================================================
  // Debugging
  // ===========================================================================

  @override
  String toString() {
    return 'UpdateNoteRequest('
        'hasTitleUpdate: $hasTitleUpdate, '
        'hasContentUpdate: $hasContentUpdate'
        ')';
  }
}
