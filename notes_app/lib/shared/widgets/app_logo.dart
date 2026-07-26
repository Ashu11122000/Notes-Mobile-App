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
/// This widget is designed to be reused across:
///
/// - Splash Screen
/// - Login Screen
/// - Register Screen
/// - Empty States
/// - About Screen
/// - Maintenance Screens
///
/// Features:
/// - Material 3 styling
/// - Responsive sizing
/// - Theme awareness
/// - Accessibility support
/// - Optional Hero animation
/// - Highly customizable
@immutable
final class AppLogo extends StatelessWidget {
  /// Creates an application logo.
  const AppLogo({
    super.key,
    this.size = 96,
    this.showTitle = true,
    this.title = 'Notes App',
    this.subtitle = 'Capture your ideas, anytime.',
    this.icon = Icons.sticky_note_2_rounded,
    this.heroTag,
  });

  /// Size of the logo container.
  final double size;

  /// Whether to display the application title.
  final bool showTitle;

  /// Application title displayed below the logo.
  final String title;

  /// Optional subtitle displayed below the title.
  final String subtitle;

  /// Icon displayed inside the logo.
  final IconData icon;

  /// Optional Hero tag.
  ///
  /// When supplied, the logo participates in Hero transitions.
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final logo = DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(size * .28),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: size * .10,
            offset: Offset(0, size * .04),
          ),
        ],
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Icon(
            icon,
            size: size * .50,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );

    return Semantics(
      container: true,
      label: title,
      image: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          heroTag != null
              ? Hero(
                  tag: heroTag!,
                  child: Material(color: Colors.transparent, child: logo),
                )
              : logo,
          if (showTitle) ...[
            SizedBox(height: size * .16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -.25,
              ),
            ),
            SizedBox(height: size * .04),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
