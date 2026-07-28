import 'package:flutter/material.dart';

/// ============================================================================
/// File: pagination_loader.dart
/// ============================================================================
///
/// Pagination Loader.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays a loading indicator during pagination.
/// • Used by infinite scrolling lists and grids.
/// • Contains no business logic.
/// • Reusable across all paginated features.
///
/// Architecture
/// ----------------------------------------------------------------------------
/// List/Grid
///     ↓
/// PaginationLoader
///     ↓
/// Loading UI
///
/// ============================================================================

final class PaginationLoader extends StatelessWidget {
  const PaginationLoader({
    super.key,
    this.message = 'Loading more...',
    this.padding = const EdgeInsets.symmetric(vertical: 24.0),
    this.indicatorSize = 28.0,
    this.strokeWidth = 2.5,
    this.showMessage = true,
  });

  /// Loading text.
  final String message;

  /// Outer spacing.
  final EdgeInsetsGeometry padding;

  /// Circular indicator size.
  final double indicatorSize;

  /// Circular indicator thickness.
  final double strokeWidth;

  /// Whether to show the loading message.
  final bool showMessage;

  // ===========================================================================
  // Constants
  // ===========================================================================

  static const double _messageSpacing = 12.0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    final bool displayMessage = showMessage && message.trim().isNotEmpty;

    return Semantics(
      container: true,
      liveRegion: true,
      readOnly: true,
      label: displayMessage ? message : 'Loading',
      child: Padding(
        padding: padding,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: indicatorSize,
                height: indicatorSize,
                child: CircularProgressIndicator(
                  strokeWidth: strokeWidth,
                  color: colorScheme.primary,
                ),
              ),

              if (displayMessage) ...<Widget>[
                const SizedBox(height: _messageSpacing),

                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
