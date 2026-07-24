import 'package:flutter/material.dart';

/// A reusable Material 3 divider.
///
/// This widget provides a consistent divider throughout the application
/// while allowing optional customization of spacing and indentation.
///
/// The visual appearance is inherited from the application's
/// [DividerTheme].
///
/// Example:
/// ```dart
/// const CustomDivider()
/// ```
///
/// ```dart
/// const CustomDivider(
///   indent: 16,
///   endIndent: 16,
/// )
/// ```
class CustomDivider extends StatelessWidget {
  /// Creates a reusable divider.
  const CustomDivider({
    super.key,
    this.height = 24,
    this.thickness,
    this.indent = 0,
    this.endIndent = 0,
  });

  /// Total height occupied by the divider.
  final double height;

  /// Divider thickness.
  ///
  /// If null, the application's [DividerTheme] is used.
  final double? thickness;

  /// Empty space before the divider begins.
  final double indent;

  /// Empty space after the divider ends.
  final double endIndent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
