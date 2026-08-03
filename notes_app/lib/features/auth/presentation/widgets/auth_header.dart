import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_logo.dart';

/// ============================================================================
/// File: auth_header.dart
/// ============================================================================
///
/// Authentication Header
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays the application logo.
/// • Displays the authentication screen title.
/// • Displays a supporting subtitle.
/// • Provides a reusable header for authentication screens.
///
/// Used By
/// ----------------------------------------------------------------------------
/// • Login Screen
/// • Register Screen
/// • Forgot Password Screen (future)
///
/// Performance
/// ----------------------------------------------------------------------------
/// • Stateless widget
/// • const-friendly
/// • Small widget tree
/// • Material 3 compliant
/// • Accessible
/// • Optimized for low-memory devices
/// ============================================================================

final class AuthHeader extends StatelessWidget {
  /// Creates an authentication header.
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.logoSize = 88,
    this.padding = _defaultPadding,
    this.alignment = CrossAxisAlignment.center,
  });

  static const EdgeInsets _defaultPadding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 32,
  );

  static const SizedBox _logoSpacing = SizedBox(height: 24);
  static const SizedBox _textSpacing = SizedBox(height: 8);

  /// Primary heading.
  final String title;

  /// Supporting description.
  final String subtitle;

  /// Logo size.
  final double logoSize;

  /// Outer padding.
  final EdgeInsetsGeometry padding;

  /// Horizontal alignment.
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Semantics(
      container: true,
      header: true,
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: alignment,
          children: <Widget>[
            AppLogo(size: logoSize, showTitle: false),

            _logoSpacing,

            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            _textSpacing,

            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
