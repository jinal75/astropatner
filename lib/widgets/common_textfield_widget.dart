// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:astrologer_app/utils/global.dart' as global;

class CommonTextFieldWidget extends StatelessWidget {
  const CommonTextFieldWidget({
    Key? key,
    this.hintText,
    this.textEditingController,
    this.onEditingComplete,
    this.obscureText,
    this.readOnly,
    this.suffixIcon,
    this.onTap,
    this.keyboardType,
    this.focusNode,
    this.onFieldSubmitted,
    this.maxLines,
    this.enabledBorder,
    this.prefix,
    this.onChanged,
    this.textCapitalization,
    this.formatter,
    this.maxLength,
    this.counterText,
    this.contentPadding,
  }) : super(key: key);

  final String? hintText;
  final TextEditingController? textEditingController;
  final Function()? onEditingComplete;
  final bool? obscureText;
  final bool? readOnly;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;
  final int? maxLines;
  final int? maxLength;
  final dynamic counterText;
  final InputBorder? enabledBorder;
  final Widget? prefix;
  final void Function(String)? onChanged;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? formatter;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: global.translatedText(hintText ?? ""),
        builder: (context, snapshot) {
          return TextFormField(
            controller: textEditingController,
            onEditingComplete: onEditingComplete,
            focusNode: focusNode,
            maxLength: maxLength,
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            maxLines: maxLines,
            onFieldSubmitted: onFieldSubmitted,
            obscureText: obscureText ?? false,
            readOnly: readOnly ?? false,
            onTap: onTap,
            cursorColor: const Color(0xFF757575),
            style: const TextStyle(fontSize: 16, color: Colors.black),
            keyboardType: keyboardType ?? TextInputType.text,
            inputFormatters: formatter,
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding: contentPadding,
              counterText: counterText,
              enabledBorder: enabledBorder,
              hintText: snapshot.data ?? hintText,
              prefixIcon: prefix,
              suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(
                    suffixIcon,
                    size: 25,
                    color: Theme.of(context).primaryColor,
                  )),
            ),
          );
        });
  }
}
