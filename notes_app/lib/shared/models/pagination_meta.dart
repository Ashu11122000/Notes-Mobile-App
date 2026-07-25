import 'package:flutter/foundation.dart';

/// ============================================================================
/// File: pagination_meta.dart
/// ============================================================================
///
/// Generic pagination metadata.
///
/// Represents metadata returned by paginated API endpoints.
///
/// This model is feature-independent and can be reused across
/// Notes, Tasks, Users, Analytics, or any future module.
///
/// Example JSON:
///
/// {
///   "page": 1,
///   "size": 10,
///   "total": 125,
///   "pages": 13
/// }
///
/// ============================================================================

@immutable
class PaginationMeta {
  const PaginationMeta({
    required this.page,
    required this.size,
    required this.total,
    required this.pages,
  });

  /// Current page number (1-based).
  final int page;

  /// Number of items requested per page.
  final int size;

  /// Total number of records available.
  final int total;

  /// Total number of pages.
  final int pages;

  /// Creates a [PaginationMeta] from JSON.
  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      page: (json['page'] as num?)?.toInt() ?? 1,
      size: (json['size'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
      pages: (json['pages'] as num?)?.toInt() ?? 0,
    );
  }

  /// Converts this object into JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'page': page,
      'size': size,
      'total': total,
      'pages': pages,
    };
  }

  /// Returns a copy with updated values.
  PaginationMeta copyWith({int? page, int? size, int? total, int? pages}) {
    return PaginationMeta(
      page: page ?? this.page,
      size: size ?? this.size,
      total: total ?? this.total,
      pages: pages ?? this.pages,
    );
  }

  /// Whether another page exists.
  bool get hasNextPage => page < pages;

  /// Whether a previous page exists.
  bool get hasPreviousPage => page > 1;

  /// True if this is the first page.
  bool get isFirstPage => page == 1;

  /// True if this is the last page.
  bool get isLastPage => page >= pages;

  /// Number of records on previous pages.
  int get skippedItems => (page - 1) * size;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PaginationMeta &&
            runtimeType == other.runtimeType &&
            page == other.page &&
            size == other.size &&
            total == other.total &&
            pages == other.pages;
  }

  @override
  int get hashCode => Object.hash(page, size, total, pages);

  @override
  String toString() {
    return 'PaginationMeta('
        'page: $page, '
        'size: $size, '
        'total: $total, '
        'pages: $pages'
        ')';
  }
}
