//flutter
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_translator/google_translator.dart';

class CommonDropDown extends StatelessWidget {
  final Widget? hint;
  final VoidCallback? voidCallback;
  final void Function()? onTap;
  final List<dynamic>? list;
  final void Function(dynamic)? onChanged;
  final dynamic type;
  final dynamic val;
  final double? height;
  final double? width;
  const CommonDropDown({
    Key? key,
    this.voidCallback,
    this.type,
    this.onChanged,
    this.hint,
    this.onTap,
    this.val,
    this.list,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      icon: Icon(
        Icons.arrow_drop_down,
        color: Theme.of(context).primaryColor,
      ),
      style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2.5, color: Colors.black, overflow: TextOverflow.visible),
      items: list!.map<DropdownMenuItem>((dynamic value) {
        return DropdownMenuItem<dynamic>(
          value: value,
          child: Text(
            value.toString(),
            style: TextStyle(fontSize: 14, letterSpacing: 2.5, fontWeight: FontWeight.bold, overflow: TextOverflow.visible),
          ).translate(),
        );
      }).toList(),
      value: val,
      hint: hint,
      onTap: onTap,
      onChanged: onChanged,
      isExpanded: true,
    );
  }
}
