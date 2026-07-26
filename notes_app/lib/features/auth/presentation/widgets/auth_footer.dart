import 'package:flutter/material.dart';

/// ============================================================================
/// File: auth_footer.dart
/// ============================================================================
///
/// A reusable footer for authentication screens.
///
/// Displays supporting text followed by a clickable action.
///
/// Shared between:
/// • Login Screen
/// • Register Screen
/// • Forgot Password Screen (future)
///
/// Lightweight, reusable, Material 3 compliant and accessible.
/// ============================================================================

class AuthFooter extends StatelessWidget {
  /// Creates an authentication footer.
  const AuthFooter({
    super.key,
    required this.questionText,
    required this.actionText,
    required this.onPressed,
    this.alignment = WrapAlignment.center,
  });

  static const EdgeInsets _padding = EdgeInsets.symmetric(vertical: 24);

  /// Supporting text displayed before the action.
  final String questionText;

  /// Clickable action text.
  final String actionText;

  /// Callback when the action is pressed.
  final VoidCallback onPressed;

  /// Horizontal alignment of the footer.
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Semantics(
      container: true,
      child: Padding(
        padding: _padding,
        child: Wrap(
          alignment: alignment,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 4,
          children: <Widget>[
            Text(questionText, style: textTheme.bodyMedium),
            TextButton(onPressed: onPressed, child: Text(actionText)),
          ],
        ),
      ),
    );
  }
}
