import 'package:flutter/material.dart';

import 'app_bar_title.dart';

/// A reusable Material 3 app bar used throughout the application.
///
/// This widget provides a consistent app bar implementation while allowing
/// screens to customize common properties such as the title, leading widget,
/// actions, and bottom widget.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a reusable application app bar.
  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.bottom,
    this.centerTitle = false,
    this.automaticallyImplyLeading = true,
    this.elevation = 0,
  });

  /// Title displayed in the app bar.
  final String title;

  /// Optional leading widget.
  final Widget? leading;

  /// Optional action widgets.
  final List<Widget>? actions;

  /// Optional bottom widget.
  final PreferredSizeWidget? bottom;

  /// Whether the title should be centered.
  final bool centerTitle;

  /// Whether to automatically infer the leading widget.
  final bool automaticallyImplyLeading;

  /// Elevation of the app bar.
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: AppBarTitle(title),
      leading: leading,
      actions: actions,
      bottom: bottom,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      elevation: elevation,
      scrolledUnderElevation: elevation,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
