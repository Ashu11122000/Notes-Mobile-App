/// =============================================================================
/// File: note_filter.dart
/// =============================================================================
///
/// Defines the filtering options available for the Notes feature.
///
/// This enum belongs to the domain layer and intentionally remains independent
/// of Flutter widgets, networking, and persistence implementations.
///
/// The selected filter may be applied:
///
/// - Server-side through API query parameters.
/// - Client-side after fetching note data.
///
/// Centralizing filter definitions provides:
///
/// - Strong typing
/// - Safer persistence
/// - Easier serialization
/// - Consistent UI behavior
/// - Better maintainability
///
/// Example:
///
/// ```dart
/// switch (filter) {
///   case NoteFilter.all:
///     // Display every note.
///     break;
///
///   case NoteFilter.search:
///     // Display notes matching the current search query.
///     break;
/// }
/// ```
enum NoteFilter {
  /// Displays every available note.
  all(value: 'all', displayName: 'All'),

  /// Displays notes matching the current search query.
  ///
  /// The search implementation may be performed either locally or by
  /// the backend API.
  search(value: 'search', displayName: 'Search');

  /// Creates a note filter.
  const NoteFilter({required this.value, required this.displayName});

  /// Persisted value used for serialization.
  ///
  /// Examples:
  /// - `all`
  /// - `search`
  final String value;

  /// Human-readable label displayed in the UI.
  final String displayName;

  /// Returns whether this filter displays every note.
  bool get isAll => this == NoteFilter.all;

  /// Returns whether this filter represents a search operation.
  bool get isSearch => this == NoteFilter.search;

  /// Converts a persisted value into a [NoteFilter].
  ///
  /// If the supplied value is:
  ///
  /// - `null`
  /// - empty
  /// - unsupported
  ///
  /// the default filter ([NoteFilter.all]) is returned.
  static NoteFilter fromValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return NoteFilter.all;
    }

    final normalizedValue = value.trim().toLowerCase();

    return NoteFilter.values.firstWhere(
      (filter) => filter.value == normalizedValue,
      orElse: () => NoteFilter.all,
    );
  }

  /// Returns whether the supplied value represents a supported filter.
  static bool isSupported(String? value) {
    if (value == null || value.trim().isEmpty) {
      return false;
    }

    final normalizedValue = value.trim().toLowerCase();

    return NoteFilter.values.any((filter) => filter.value == normalizedValue);
  }

  /// List of all supported persisted values.
  ///
  /// Useful for:
  /// - validation
  /// - serialization
  /// - analytics
  /// - Settings
  static const List<String> supportedValues = ['all', 'search'];
}
