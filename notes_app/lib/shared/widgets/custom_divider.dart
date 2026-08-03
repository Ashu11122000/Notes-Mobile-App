import 'package:flutter/material.dart';

/// ============================================================================
/// File: custom_divider.dart
/// ============================================================================
///
/// Enterprise Material 3 divider.
///
/// A lightweight reusable divider that standardizes separators throughout
/// the application while respecting the active [DividerTheme].
///
/// Most visual customization should be handled globally through the app theme
/// to maintain a consistent design system.
///
/// Typical usage:
///
/// - Settings sections
/// - Lists
/// - Dialogs
/// - Bottom sheets
/// - Profile screens
/// - Forms
@immutable
final class CustomDivider extends StatelessWidget {
  /// Creates a reusable Material 3 divider.
  const CustomDivider({
    super.key,
    this.height = 24,
    this.thickness,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
  });

  /// Total vertical space occupied by the divider.
  final double height;

  /// Divider thickness.
  ///
  /// Uses [DividerTheme] when omitted.
  final double? thickness;

  /// Empty space before the divider starts.
  final double indent;

  /// Empty space after the divider ends.
  final double endIndent;

  /// Optional custom color.
  ///
  /// Prefer configuring [DividerTheme] globally.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return const _DividerContent();
  }
}

@immutable
final class _DividerContent extends StatelessWidget {
  const _DividerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(child: Divider());
  }
}
