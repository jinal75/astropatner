//flutter
import 'package:flutter/material.dart';

class MyCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double? height;
  final double? elevation;
  final double? appbarPadding;
  final Widget? title;
  final bool? centerTitle;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;

  const MyCustomAppBar({
    Key? key,
    this.leading,
    this.elevation,
    this.title,
    this.centerTitle,
    this.actions,
    this.backgroundColor,
    @required this.height,
    this.appbarPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(top: appbarPadding ?? 0, bottom: appbarPadding ?? 0),
          child: AppBar(
            elevation: elevation ?? 0,
            title: title,
            centerTitle: centerTitle,
            leading: leading,
            actions: actions,
            backgroundColor: backgroundColor ?? Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 80);
}
