import 'package:flutter/material.dart';

/// =============================================================================
/// File: app_logo.dart
/// =============================================================================
///
/// A reusable, theme-aware application logo.
///
/// The logo is intentionally built using Material 3 widgets instead of image
/// assets, making it lightweight, resolution-independent, and easy to brand.
///
/// Designed for:
/// - Splash Screen
/// - Login Screen
/// - Register Screen
/// - Empty States
/// - About Screen
/// - Maintenance Screens
///
/// Features:
/// - Material 3 styling
/// - Theme-aware
/// - Lightweight rendering
/// - Accessibility support
/// - Optional Hero animation
/// - Responsive sizing
/// - Highly reusable
@immutable
final class AppLogo extends StatelessWidget {
  /// Creates an application logo.
  const AppLogo({
    super.key,
    this.size = 96,
    this.showTitle = true,
    this.title = 'Notes App',
    this.subtitle,
    this.icon = Icons.sticky_note_2_rounded,
    this.heroTag,
  });

  /// Size of the logo.
  final double size;

  /// Whether to display the application title.
  final bool showTitle;

  /// Application title.
  final String title;

  /// Optional subtitle.
  final String? subtitle;

  /// Icon displayed inside the logo.
  final IconData icon;

  /// Optional Hero tag.
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final double titleSpacing = (size * 0.16).clamp(12.0, 24.0);
    final double subtitleSpacing = (size * 0.04).clamp(4.0, 8.0);

    final Widget logo = Material(
      color: colorScheme.primaryContainer,
      elevation: 1,
      borderRadius: BorderRadius.circular(size * 0.28),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * 0.28),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.40),
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            size: size * 0.50,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );

    final Widget logoWidget = heroTag == null
        ? logo
        : Hero(
            tag: heroTag!,
            child: logo,
          );

    return Semantics(
      container: true,
      image: true,
      label: title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          logoWidget,

          if (showTitle) ...[
            SizedBox(height: titleSpacing),

            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.headlineSmall,
            ),

            if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
              SizedBox(height: subtitleSpacing),

              Text(
                subtitle!,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}