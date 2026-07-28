import 'package:flutter/material.dart';

/// ============================================================================
/// File: auth_footer.dart
/// ============================================================================
///
/// Authentication Footer
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Displays supporting text with a secondary authentication action.
/// • Reused across authentication-related screens.
/// • Lightweight, accessible and Material 3 compliant.
///
/// Used By
/// ----------------------------------------------------------------------------
/// • Login Screen
/// • Register Screen
/// • Forgot Password Screen (future)
///
/// Performance
/// ----------------------------------------------------------------------------
/// • Stateless
/// • const-friendly
/// • Small widget tree
/// • No animations
/// • No unnecessary rebuilds
/// • Optimized for low-memory devices
/// ============================================================================

final class AuthFooter extends StatelessWidget {
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

  /// Action button label.
  final String actionText;

  /// Callback invoked when the action button is pressed.
  final VoidCallback onPressed;

  /// Horizontal alignment of the footer.
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      container: true,
      child: Padding(
        padding: _padding,
        child: Wrap(
          alignment: alignment,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 4,
          runSpacing: 4,
          children: <Widget>[
            Text(
              questionText,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            Semantics(
              button: true,
              label: actionText,
              child: TextButton(
                onPressed: onPressed,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(actionText, textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
