/// Represents the available filters for the notes list.
///
/// This enum is shared across the application and is primarily used by the
/// Notes feature for filtering displayed notes.
///
/// The actual filtering implementation may be performed either:
/// - Server-side using API query parameters.
/// - Client-side after fetching notes.
///
/// This enum intentionally remains independent of any UI widgets.
enum NoteFilter {
  /// Show all notes.
  all(value: 'all', displayName: 'All'),

  /// Show only notes matching a search query.
  search(value: 'search', displayName: 'Search');

  /// Creates a note filter.
  const NoteFilter({required this.value, required this.displayName});

  /// Value used for persistence or serialization.
  final String value;

  /// Human-readable name displayed in the UI.
  final String displayName;

  /// Returns a [NoteFilter] from its stored value.
  ///
  /// Defaults to [NoteFilter.all] if the value is null or invalid.
  static NoteFilter fromValue(String? value) {
    return NoteFilter.values.firstWhere(
      (filter) => filter.value == value,
      orElse: () => NoteFilter.all,
    );
  }
}
