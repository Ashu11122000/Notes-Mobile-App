import 'package:flutter/foundation.dart';

/// ============================================================================
/// File: pagination_meta.dart
/// ============================================================================
///
/// Represents metadata returned by paginated API endpoints.
///
/// This model is intentionally generic and reusable across any feature that
/// supports pagination, including:
///
/// - Notes
/// - Tasks
/// - Users
/// - Analytics
/// - Notifications
///
/// It contains only pagination metadata and is independent of any specific
/// API implementation.
///
/// Example JSON:
///
/// ```json
/// {
///   "page": 1,
///   "size": 10,
///   "total": 125,
///   "pages": 13
/// }
/// ```
@immutable
final class PaginationMeta {
  /// Creates immutable pagination metadata.
  const PaginationMeta({
    required this.page,
    required this.size,
    required this.total,
    required this.pages,
  });

  /// Creates pagination metadata from JSON.
  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      page: (json['page'] as num?)?.toInt() ?? 1,
      size: (json['size'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
      pages: (json['pages'] as num?)?.toInt() ?? 0,
    );
  }

  /// Current page (1-based).
  final int page;

  /// Number of items requested per page.
  final int size;

  /// Total number of records.
  final int total;

  /// Total number of available pages.
  final int pages;

  /// Converts this object into JSON.
  Map<String, dynamic> toJson() => {
    'page': page,
    'size': size,
    'total': total,
    'pages': pages,
  };

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

  /// Whether this is the first page.
  bool get isFirstPage => page == 1;

  /// Whether this is the last page.
  bool get isLastPage => page >= pages;

  /// Whether the paginated collection contains no records.
  bool get isEmpty => total == 0;

  /// Whether the paginated collection contains records.
  bool get isNotEmpty => !isEmpty;

  /// Number of items skipped before this page.
  int get skippedItems => (page - 1) * size;

  /// Next page number.
  ///
  /// Returns the current page if already at the last page.
  int get nextPage => hasNextPage ? page + 1 : page;

  /// Previous page number.
  ///
  /// Returns the current page if already at the first page.
  int get previousPage => hasPreviousPage ? page - 1 : page;

  /// Number of items that have been loaded up to the current page.
  ///
  /// The value never exceeds [total].
  int get loadedItems {
    final loaded = page * size;
    return loaded > total ? total : loaded;
  }

  /// Number of remaining items that have not yet been loaded.
  int get remainingItems => total - loadedItems;

  @override
  String toString() {
    return '$runtimeType('
        'page: $page, '
        'size: $size, '
        'total: $total, '
        'pages: $pages'
        ')';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PaginationMeta &&
            page == other.page &&
            size == other.size &&
            total == other.total &&
            pages == other.pages;
  }

  @override
  int get hashCode => Object.hash(page, size, total, pages);
}
