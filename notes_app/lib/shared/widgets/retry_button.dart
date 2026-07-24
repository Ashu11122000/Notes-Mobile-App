import 'package:flutter/material.dart';

import 'primary_button.dart';

/// A reusable retry button.
///
/// This widget is a convenience wrapper around [PrimaryButton] for retry
/// actions shown in error and offline states.
///
/// Example:
/// ```dart
/// RetryButton(
///   onPressed: _loadNotes,
/// )
/// ```
class RetryButton extends StatelessWidget {
  /// Creates a retry button.
  const RetryButton({
    super.key,
    required this.onPressed,
    this.text = 'Retry',
    this.isLoading = false,
    this.isExpanded = false,
    this.icon = Icons.refresh_rounded,
  });

  /// Callback invoked when the button is pressed.
  final VoidCallback? onPressed;

  /// Button label.
  final String text;

  /// Whether to show a loading indicator.
  final bool isLoading;

  /// Whether the button should expand to fill the available width.
  final bool isExpanded;

  /// Leading icon.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: text,
      icon: icon,
      onPressed: onPressed,
      isLoading: isLoading,
      isExpanded: isExpanded,
    );
  }
}
