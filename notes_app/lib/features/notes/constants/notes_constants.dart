// ============================================================================
// File: notes_constants.dart
// ============================================================================
//
// Notes feature constants.
//
// Responsibilities
// ----------------------------------------------------------------------------
// - Centralize Notes-specific configuration.
// - Eliminate magic numbers and hardcoded strings.
// - Provide reusable values across the Notes feature.
//
// Notes
// ----------------------------------------------------------------------------
// - API endpoints belong in ApiConstants.
// - This file contains only Notes feature constants.
//
// ============================================================================

/// Centralized constants used throughout the Notes feature.
///
/// Keeping all feature-specific configuration in one location improves
/// maintainability, consistency, and discoverability.
final class NotesConstants {
  const NotesConstants._();

  // ===========================================================================
  // Pagination
  // ===========================================================================

  /// Default number of notes requested per page.
  ///
  /// Must remain synchronized with the backend default if pagination
  /// behavior depends on a shared page size.
  static const int defaultPageSize = 10;

  /// First page index used by the backend.
  static const int initialPage = 1;

  // ===========================================================================
  // Validation
  // ===========================================================================

  /// Minimum allowed title length.
  static const int minTitleLength = 1;

  /// Maximum allowed title length.
  static const int maxTitleLength = 255;

  /// Maximum allowed note content length.
  ///
  /// Matches the current FastAPI backend implementation.
  /// Update only if the backend validation changes.
  static const int maxContentLength = 5000;

  // ===========================================================================
  // UI
  // ===========================================================================

  /// Distance from the bottom of a scrollable list before requesting
  /// the next page of notes.
  static const double paginationThreshold = 200.0;

  /// Default animation duration used throughout the Notes feature.
  static const Duration animationDuration = Duration(milliseconds: 300);

  // ===========================================================================
  // Search
  // ===========================================================================

  /// Delay before executing a search after user input.
  static const Duration searchDebounce = Duration(milliseconds: 400);

  // ===========================================================================
  // Hero Tags
  // ===========================================================================

  /// Hero tag for the Notes FloatingActionButton.
  static const String notesFabHeroTag = 'notes_fab';

  // ===========================================================================
  // Route Arguments
  // ===========================================================================

  /// Route argument key for passing a note identifier.
  static const String noteIdArgument = 'noteId';
}
