import 'package:flutter/foundation.dart';

import '../../../../shared/models/pagination_meta.dart';
import '../../../../shared/models/pagination_response.dart';
import 'note_model.dart';

/// ============================================================================
/// File: paginated_notes_response.dart
/// ============================================================================
///
/// Strongly typed paginated response for Notes.
///
/// Uses composition because [PaginationResponse] is a final class.
///
/// Expected JSON
/// ----------------------------------------------------------------------------
/// {
///   "items": [
///     {
///       "id": 1,
///       "title": "...",
///       "content": "...",
///       "created_at": "...",
///       "updated_at": "..."
///     }
///   ],
///   "meta": {
///     "page": 1,
///     "size": 10,
///     "total": 25,
///     "pages": 3
///   }
/// }
///
/// ============================================================================

@immutable
final class PaginatedNotesResponse {
  const PaginatedNotesResponse({required this.response});

  /// Wrapped generic pagination response.
  final PaginationResponse<NoteModel> response;

  // ===========================================================================
  // Convenience Getters
  // ===========================================================================

  List<NoteModel> get items => response.items;

  PaginationMeta get meta => response.meta;

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  // ===========================================================================
  // Factories
  // ===========================================================================

  factory PaginatedNotesResponse.empty() {
    return PaginatedNotesResponse(
      response: PaginationResponse<NoteModel>(
        items: const <NoteModel>[],
        meta: const PaginationMeta(page: 1, size: 0, total: 0, pages: 0),
      ),
    );
  }

  factory PaginatedNotesResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawItems =
        json['items'] as List<dynamic>? ?? const <dynamic>[];

    return PaginatedNotesResponse(
      response: PaginationResponse<NoteModel>(
        items: List<NoteModel>.unmodifiable(
          rawItems.map((dynamic item) => NoteModel.fromJson(_asJsonMap(item))),
        ),
        meta: PaginationMeta.fromJson(_asJsonMap(json['meta'])),
      ),
    );
  }

  // ===========================================================================
  // JSON Helpers
  // ===========================================================================

  static Map<String, dynamic> _asJsonMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return const <String, dynamic>{};
  }

  // ===========================================================================
  // Serialization
  // ===========================================================================

  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> serializedItems = items
        .map((NoteModel note) => note.toJson())
        .toList(growable: false);

    return <String, dynamic>{'items': serializedItems, 'meta': meta.toJson()};
  }

  // ===========================================================================
  // Copy
  // ===========================================================================

  PaginatedNotesResponse copyWith({PaginationResponse<NoteModel>? response}) {
    return PaginatedNotesResponse(response: response ?? this.response);
  }

  // ===========================================================================
  // Equality
  // ===========================================================================

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PaginatedNotesResponse && other.response == response);
  }

  @override
  int get hashCode => response.hashCode;

  // ===========================================================================
  // Debug
  // ===========================================================================

  @override
  String toString() {
    return 'PaginatedNotesResponse('
        'itemCount: ${items.length}, '
        'meta: $meta'
        ')';
  }
}
