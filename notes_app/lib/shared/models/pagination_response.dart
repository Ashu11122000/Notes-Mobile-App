import 'package:flutter/foundation.dart';

import 'pagination_meta.dart';

/// ============================================================================
/// File: pagination_response.dart
/// ============================================================================
///
/// Generic pagination response.
///
/// This model represents a paginated API response and is intended to be reused
/// across multiple features (Notes, Tasks, Users, etc.).
///
/// Example JSON:
///
/// {
///   "items": [
///     {
///       ...
///     }
///   ],
///   "meta": {
///     "page": 1,
///     "size": 10,
///     "total": 42,
///     "pages": 5
///   }
/// }
///
/// This model is currently **not used** by the Notes API because the backend
/// returns a simple `List<NoteResponse>`. It is kept as a reusable shared model
/// for future APIs that expose pagination metadata.
///
/// ============================================================================

@immutable
class PaginationResponse<T> {
  const PaginationResponse({required this.items, required this.meta});

  /// Items returned for the current page.
  final List<T> items;

  /// Pagination metadata.
  final PaginationMeta meta;

  /// Creates a [PaginationResponse] from JSON.
  factory PaginationResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final List<dynamic> itemsJson =
        (json['items'] as List<dynamic>?) ?? const [];

    return PaginationResponse<T>(
      items: List<T>.unmodifiable(
        itemsJson.map(
          (dynamic item) => fromJsonT(Map<String, dynamic>.from(item as Map)),
        ),
      ),
      meta: PaginationMeta.fromJson(
        Map<String, dynamic>.from((json['meta'] as Map?) ?? const {}),
      ),
    );
  }

  /// Converts this object to JSON.
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T item) toJsonT) {
    return <String, dynamic>{
      'items': items.map<Map<String, dynamic>>(toJsonT).toList(growable: false),
      'meta': meta.toJson(),
    };
  }

  /// Creates a copy with updated values.
  PaginationResponse<T> copyWith({List<T>? items, PaginationMeta? meta}) {
    return PaginationResponse<T>(
      items: items ?? this.items,
      meta: meta ?? this.meta,
    );
  }

  /// Returns true if another page is available.
  bool get hasNextPage => meta.hasNextPage;

  /// Returns true if a previous page exists.
  bool get hasPreviousPage => meta.hasPreviousPage;

  /// Returns true if no items were returned.
  bool get isEmpty => items.isEmpty;

  /// Returns true if at least one item exists.
  bool get isNotEmpty => items.isNotEmpty;

  /// Number of items in the current page.
  int get itemCount => items.length;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PaginationResponse<T> &&
            runtimeType == other.runtimeType &&
            listEquals(items, other.items) &&
            meta == other.meta;
  }

  @override
  int get hashCode => Object.hash(Object.hashAll(items), meta);

  @override
  String toString() {
    return 'PaginationResponse('
        'itemCount: $itemCount, '
        'meta: $meta'
        ')';
  }
}
