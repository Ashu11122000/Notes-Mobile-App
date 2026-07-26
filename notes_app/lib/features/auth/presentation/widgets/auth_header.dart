import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_logo.dart';

/// ============================================================================
/// File: auth_header.dart
/// ============================================================================
///
/// A reusable header for authentication screens.
///
/// Displays:
/// • Application logo
/// • Screen title
/// • Supporting subtitle
///
/// Shared between:
/// • Login Screen
/// • Register Screen
/// • Forgot Password Screen (future)
///
/// Lightweight, reusable, accessible and Material 3 compliant.
/// ============================================================================

class AuthHeader extends StatelessWidget {
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

  static const SizedBox _largeSpacing = SizedBox(height: 24);
  static const SizedBox _smallSpacing = SizedBox(height: 8);

  /// Primary heading.
  final String title;

  /// Supporting description.
  final String subtitle;

  /// Logo size.
  final double logoSize;

  /// Outer padding.
  final EdgeInsetsGeometry padding;

  /// Horizontal alignment of the content.
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      container: true,
      header: true,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: alignment,
          children: <Widget>[
            AppLogo(size: logoSize, showTitle: false),

            _largeSpacing,

            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            _smallSpacing,

            Text(
              subtitle,
              textAlign: TextAlign.center,
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
