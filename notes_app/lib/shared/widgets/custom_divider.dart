import 'package:flutter/material.dart';

/// ============================================================================
/// File: custom_divider.dart
/// ============================================================================
///
/// Enterprise Material 3 divider.
///
/// A lightweight, reusable divider that standardizes separators throughout
/// the application while respecting the active [DividerTheme].
///
/// This widget intentionally remains minimal. Most visual customization should
/// be performed globally through the application's theme, ensuring a
/// consistent design language.
///
/// Typical use cases:
///
/// - Settings sections
/// - Lists
/// - Dialogs
/// - Bottom sheets
/// - Profile screens
/// - Forms
///
/// Example:
///
/// ```dart
/// const CustomDivider();
/// ```
///
/// ```dart
/// const CustomDivider(
///   indent: 16,
///   endIndent: 16,
/// );
/// ```
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
    this.radius,
  });

  /// Total height occupied by the divider.
  final double height;

  /// Thickness of the divider.
  ///
  /// When omitted, the value from the active [DividerTheme] is used.
  final double? thickness;

  /// Empty space before the divider begins.
  final double indent;

  /// Empty space after the divider ends.
  final double endIndent;

  /// Optional divider color.
  ///
  /// Prefer configuring the application's [DividerTheme] instead of setting
  /// this property unless a specific screen requires a custom appearance.
  final Color? color;

  /// Optional border radius.
  ///
  /// Useful when creating premium section separators that integrate with
  /// rounded surfaces.
  final BorderRadiusGeometry? radius;

  @override
  Widget build(BuildContext context) {
    Widget divider = Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color,
    );

    if (radius != null) {
      divider = ClipRRect(borderRadius: radius!, child: divider);
    }

    return ExcludeSemantics(child: divider);
  }
}
