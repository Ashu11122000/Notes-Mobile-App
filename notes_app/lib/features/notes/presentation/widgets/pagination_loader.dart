import 'package:flutter/material.dart';

/// ============================================================================
/// File: pagination_loader.dart
/// ============================================================================
///
/// Pagination Loader.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays loading indicator during pagination.
/// • Used by infinite scrolling lists/grids.
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
    this.padding = const EdgeInsets.symmetric(vertical: 24),
    this.indicatorSize = 28,
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

  /// Whether to show message.
  final bool showMessage;

  // ===========================================================================
  // Constants
  // ===========================================================================

  static const double _messageSpacing = 12;

  // ===========================================================================
  // Build
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Semantics(
      liveRegion: true,

      label: message,

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

                  color: theme.colorScheme.primary,
                ),
              ),

              if (showMessage) ...<Widget>[
                const SizedBox(height: _messageSpacing),

                Text(
                  message,

                  textAlign: TextAlign.center,

                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
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
