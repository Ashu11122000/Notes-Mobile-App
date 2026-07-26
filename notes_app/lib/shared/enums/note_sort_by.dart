/// =============================================================================
/// File: note_sort_by.dart
/// =============================================================================
///
/// Defines the supported sorting options for notes.
///
/// This enum belongs to the domain layer and intentionally remains independent
/// of Flutter widgets, repositories, networking, and persistence.
///
/// The repository or presentation layer is responsible for translating these
/// values into:
///
/// - API query parameters
/// - SQL ordering
/// - Client-side sorting algorithms
///
/// Centralizing sorting definitions provides:
///
/// - Strong typing
/// - Consistent UI behavior
/// - Safer persistence
/// - Easier serialization
/// - Better maintainability
///
/// Example:
///
/// ```dart
/// final sort = NoteSortBy.fromValue('newest');
///
/// switch (sort) {
///   case NoteSortBy.newest:
///     break;
///
///   case NoteSortBy.oldest:
///     break;
///
///   case NoteSortBy.titleAscending:
///     break;
///
///   case NoteSortBy.titleDescending:
///     break;
/// }
/// ```
enum NoteSortBy {
  /// Displays the most recently created or updated notes first.
  newest(value: 'newest', displayName: 'Newest First'),

  /// Displays the oldest notes first.
  oldest(value: 'oldest', displayName: 'Oldest First'),

  /// Sorts notes alphabetically from A to Z.
  titleAscending(value: 'title_asc', displayName: 'Title (A–Z)'),

  /// Sorts notes alphabetically from Z to A.
  titleDescending(value: 'title_desc', displayName: 'Title (Z–A)');

  /// Creates a note sorting option.
  const NoteSortBy({required this.value, required this.displayName});

  /// Persisted value used for serialization.
  ///
  /// Examples:
  /// - `newest`
  /// - `oldest`
  /// - `title_asc`
  /// - `title_desc`
  final String value;

  /// Human-readable label displayed in the user interface.
  final String displayName;

  /// Returns whether notes should be ordered from newest to oldest.
  bool get isNewest => this == NoteSortBy.newest;

  /// Returns whether notes should be ordered from oldest to newest.
  bool get isOldest => this == NoteSortBy.oldest;

  /// Returns whether notes should be sorted alphabetically (A → Z).
  bool get isTitleAscending => this == NoteSortBy.titleAscending;

  /// Returns whether notes should be sorted alphabetically (Z → A).
  bool get isTitleDescending => this == NoteSortBy.titleDescending;

  /// Converts a persisted value into a [NoteSortBy].
  ///
  /// If the supplied value is:
  ///
  /// - `null`
  /// - empty
  /// - unsupported
  ///
  /// the default value ([NoteSortBy.newest]) is returned.
  static NoteSortBy fromValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return NoteSortBy.newest;
    }

    final normalizedValue = value.trim().toLowerCase();

    return NoteSortBy.values.firstWhere(
      (sortBy) => sortBy.value == normalizedValue,
      orElse: () => NoteSortBy.newest,
    );
  }

  /// Returns whether the supplied value represents a supported sorting option.
  static bool isSupported(String? value) {
    if (value == null || value.trim().isEmpty) {
      return false;
    }

    final normalizedValue = value.trim().toLowerCase();

    return NoteSortBy.values.any((sortBy) => sortBy.value == normalizedValue);
  }

  /// List of all supported persisted sorting values.
  ///
  /// Useful for:
  /// - validation
  /// - serialization
  /// - analytics
  /// - Settings
  static const List<String> supportedValues = [
    'newest',
    'oldest',
    'title_asc',
    'title_desc',
  ];
}
