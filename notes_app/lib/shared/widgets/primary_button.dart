import 'package:flutter/material.dart';

/// A reusable Material 3 primary button.
///
/// This widget wraps Flutter's [FilledButton] and provides a consistent
/// primary action button throughout the application.
///
/// Example:
/// ```dart
/// PrimaryButton(
///   text: 'Sign In',
///   onPressed: _login,
/// )
/// ```
class PrimaryButton extends StatelessWidget {
  /// Creates a primary button.
  const PrimaryButton({
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
    Widget button = FilledButton(
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
  const _ButtonContent({
    required this.text,
    required this.icon,
    required this.isLoading,
  });

  final String text;
  final IconData? icon;
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
