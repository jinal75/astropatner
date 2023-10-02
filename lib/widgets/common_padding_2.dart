//flutter
import 'package:flutter/material.dart';

class CommonPadding2 extends StatelessWidget {
  final double? left;
  final double? right;
  final double? top;
  final Widget? child;
  const CommonPadding2({Key? key, this.left, this.right, this.top, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: child,
    );
  }
}
