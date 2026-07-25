import 'package:flutter/material.dart';

/// ============================================================================
/// File: pagination_loader.dart
/// ============================================================================
///
/// Pagination Loader
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Displays a loading indicator while additional data is being loaded.
/// - Used for infinite scrolling and pagination.
/// - Contains no business logic.
/// - Reusable across all paginated screens.
///
/// ============================================================================
class PaginationLoader extends StatelessWidget {
  const PaginationLoader({
    super.key,
    this.message = 'Loading more...',
    this.padding = const EdgeInsets.symmetric(vertical: 24),
  });

  /// Loading message.
  final String message;

  /// Outer padding.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: padding,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
