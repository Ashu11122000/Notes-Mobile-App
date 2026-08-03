import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_bar_title.dart';

/// ============================================================================
/// File: custom_app_bar.dart
/// ============================================================================
///
/// Enterprise Material 3 application app bar.
///
/// Provides a centralized, reusable implementation of the application's
/// top app bar while remaining lightweight, accessible, and highly
/// customizable.
///
/// Features:
///
/// - Material 3 compliant
/// - Theme-aware
/// - Lightweight
/// - Accessible
/// - PreferredSizeWidget compatible
/// - Hero-safe
/// - Future-proof
///
/// Example:
///
/// ```dart
/// Scaffold(
///   appBar: const CustomAppBar(
///     title: 'Notes',
///   ),
/// )
/// ```
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
    this.shadowColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.systemOverlayStyle,
    this.leadingWidth,
    this.toolbarHeight = kToolbarHeight,
    this.titleSpacing,
    this.shape,
    this.clipBehavior = Clip.none,
    this.notificationPredicate = defaultScrollNotificationPredicate,
  });

  /// Title displayed by the default [AppBarTitle].
  ///
  /// Ignored when [titleWidget] is supplied.
  final String title;

  /// Optional custom title widget.
  final Widget? titleWidget;

  /// Optional leading widget.
  final Widget? leading;

  /// Optional action widgets.
  final List<Widget>? actions;

  /// Optional bottom widget.
  final PreferredSizeWidget? bottom;

  /// Whether the title should be centered.
  final bool centerTitle;

  /// Whether Flutter should automatically infer a leading widget.
  final bool automaticallyImplyLeading;

  /// App bar elevation.
  final double elevation;

  /// Elevation when content scrolls underneath.
  ///
  /// Defaults to [elevation].
  final double? scrolledUnderElevation;

  /// Background color.
  final Color? backgroundColor;

  /// Foreground color.
  final Color? foregroundColor;

  /// Material 3 surface tint.
  final Color? surfaceTintColor;

  /// Shadow color.
  final Color? shadowColor;

  /// Icon theme.
  final IconThemeData? iconTheme;

  /// Action icon theme.
  final IconThemeData? actionsIconTheme;

  /// Status bar appearance.
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Width of the leading widget.
  final double? leadingWidth;

  /// Toolbar height.
  final double toolbarHeight;

  /// Horizontal spacing around the title.
  final double? titleSpacing;

  /// Optional app bar shape.
  final ShapeBorder? shape;

  /// Clip behavior.
  final Clip clipBehavior;

  /// Predicate used to determine whether a scroll notification
  /// should trigger the scrolled-under effect.
  final ScrollNotificationPredicate notificationPredicate;

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
      shadowColor: shadowColor,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      systemOverlayStyle: systemOverlayStyle,
      leadingWidth: leadingWidth,
      toolbarHeight: toolbarHeight,
      titleSpacing: titleSpacing,
      shape: shape,
      clipBehavior: clipBehavior,
      notificationPredicate: notificationPredicate,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0));
}
