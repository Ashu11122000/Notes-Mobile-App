import 'package:flutter/material.dart';

/// A reusable application logo widget.
///
/// The logo is intentionally built using Material 3 widgets instead of an
/// image asset, making it lightweight, theme-aware, and easy to replace
/// with a branded logo in the future.
///
/// This widget can be reused on:
/// - Splash Screen
/// - Login Screen
/// - Register Screen
/// - Empty States
/// - About Screen
class AppLogo extends StatelessWidget {
  /// Creates an application logo.
  const AppLogo({super.key, this.size = 96, this.showTitle = true});

  /// Size of the logo container.
  final double size;

  /// Whether to display the application title below the logo.
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(size * 0.28),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.sticky_note_2_rounded,
            size: size * 0.5,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        if (showTitle) ...[
          const SizedBox(height: 16),
          Text(
            'Notes App',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Capture your ideas, anytime.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
