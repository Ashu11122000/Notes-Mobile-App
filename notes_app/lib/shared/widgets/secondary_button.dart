import 'package:flutter/material.dart';

/// A reusable Material 3 secondary button.
///
/// This widget wraps Flutter's [OutlinedButton] and provides a consistent
/// secondary action button throughout the application.
///
/// Example:
/// ```dart
/// SecondaryButton(
///   text: 'Create Account',
///   onPressed: _register,
/// )
/// ```
class SecondaryButton extends StatelessWidget {
  /// Creates a secondary button.
  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
  });

  /// Button label.
  final String text;

  /// Callback invoked when the button is pressed.
  final VoidCallback? onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// Whether to show a loading indicator.
  final bool isLoading;

  /// Whether the button should expand to fill the available width.
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    Widget button = OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      child: _ButtonContent(text: text, icon: icon, isLoading: isLoading),
    );

    if (isExpanded) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}

/// Internal button content.
///
/// Displays either:
/// - Loading indicator
/// - Icon + text
/// - Text only
class _ButtonContent extends StatelessWidget {
  /// Creates button content.
  const _ButtonContent({
    required this.text,
    required this.icon,
    required this.isLoading,
  });

  /// Button label.
  final String text;

  /// Optional leading icon.
  final IconData? icon;

  /// Whether to show a loading indicator.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon), const SizedBox(width: 8), Text(text)],
      );
    }

    return Text(text);
  }
}
