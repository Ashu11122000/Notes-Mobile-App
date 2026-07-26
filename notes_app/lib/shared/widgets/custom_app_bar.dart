import 'package:flutter/material.dart';

import 'app_bar_title.dart';

/// ============================================================================
/// File: custom_app_bar.dart
/// ============================================================================
///
/// Enterprise Material 3 application app bar.
///
/// This widget provides a centralized, reusable implementation of the
/// application's top app bar, ensuring a consistent appearance and behavior
/// across all screens.
///
/// Features:
///
/// - Material 3 compliant
/// - Theme-aware
/// - Lightweight
/// - Accessible
/// - Highly customizable
/// - PreferredSizeWidget compatible
///
/// Typical usage:
///
/// ```dart
/// return Scaffold(
///   appBar: const CustomAppBar(
///     title: 'My Notes',
///   ),
/// );
/// ```
///
/// If additional flexibility is required, a custom [titleWidget] may be
/// supplied instead of the default [AppBarTitle].
@immutable
final class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// Creates an enterprise application app bar.
  const CustomAppBar({
    super.key,
    required this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.bottom,
    this.centerTitle = false,
    this.automaticallyImplyLeading = true,
    this.elevation = 0,
    this.scrolledUnderElevation,
    this.backgroundColor,
    this.foregroundColor,
    this.surfaceTintColor,
    this.leadingWidth,
    this.toolbarHeight = kToolbarHeight,
  });

  /// Title displayed in the app bar.
  ///
  /// Ignored when [titleWidget] is supplied.
  final String title;

  /// Optional custom title widget.
  ///
  /// When provided, this widget replaces the default [AppBarTitle].
  final Widget? titleWidget;

  /// Optional leading widget.
  final Widget? leading;

  /// Optional action widgets.
  final List<Widget>? actions;

  /// Optional bottom widget.
  final PreferredSizeWidget? bottom;

  /// Whether the title should be centered.
  final bool centerTitle;

  /// Whether Flutter should automatically infer the leading widget.
  final bool automaticallyImplyLeading;

  /// Elevation of the app bar.
  final double elevation;

  /// Elevation applied after the content scrolls underneath.
  ///
  /// Defaults to [elevation] when omitted.
  final double? scrolledUnderElevation;

  /// Optional background color.
  final Color? backgroundColor;

  /// Optional foreground color.
  final Color? foregroundColor;

  /// Optional Material 3 surface tint color.
  final Color? surfaceTintColor;

  /// Optional width of the leading widget.
  final double? leadingWidth;

  /// Height of the toolbar.
  final double toolbarHeight;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleWidget ?? AppBarTitle(title),
      leading: leading,
      actions: actions,
      bottom: bottom,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation ?? elevation,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      surfaceTintColor: surfaceTintColor,
      leadingWidth: leadingWidth,
      toolbarHeight: toolbarHeight,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0));
}
