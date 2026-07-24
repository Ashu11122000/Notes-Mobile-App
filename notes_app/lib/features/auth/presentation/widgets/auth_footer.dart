import 'package:flutter/material.dart';

/// A reusable footer for authentication screens.
///
/// Displays a supporting message followed by a clickable action.
///
/// This widget is shared between the Login and Register screens.
///
/// Example:
/// ```dart
/// AuthFooter(
///   questionText: "Don't have an account?",
///   actionText: 'Sign Up',
///   onPressed: () {},
/// )
/// ```
class AuthFooter extends StatelessWidget {
  /// Creates an authentication footer.
  const AuthFooter({
    super.key,
    required this.questionText,
    required this.actionText,
    required this.onPressed,
  });

  /// Supporting text displayed before the action.
  final String questionText;

  /// Clickable action text.
  final String actionText;

  /// Called when the action is tapped.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        children: [
          Text(questionText, style: textTheme.bodyMedium),
          TextButton(onPressed: onPressed, child: Text(actionText)),
        ],
      ),
    );
  }
}
