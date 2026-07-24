import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_logo.dart';

/// A reusable header for authentication screens.
///
/// Displays the application logo, a title, and a subtitle.
///
/// This widget is shared between the Login and Register screens.
///
/// Example:
/// ```dart
/// const AuthHeader(
///   title: 'Welcome Back',
///   subtitle: 'Sign in to continue.',
/// )
/// ```
class AuthHeader extends StatelessWidget {
  /// Creates an authentication header.
  const AuthHeader({super.key, required this.title, required this.subtitle});

  /// Primary heading.
  final String title;

  /// Supporting description.
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const AppLogo(size: 88, showTitle: false),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
