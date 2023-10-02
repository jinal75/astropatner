import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class ContainerListTileWidget extends StatelessWidget {
  final Color? color;
  final String? doshText;
  final String? title;
  final String? subTitle;
  const ContainerListTileWidget({Key? key, this.title, this.subTitle, this.doshText, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: color!),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        leading: CircleAvatar(
          radius: 40,
          backgroundColor: color,
          child: Text(
            doshText!,
            style: const TextStyle(color: Colors.white),
          ).translate(),
        ),
        title: Text(
          title!,
          style: title == '' ? const TextStyle(fontSize: 0) : Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500, color: Colors.black),
        ).translate(),
        subtitle: Text(subTitle!, style: Theme.of(context).primaryTextTheme.subtitle2).translate(),
      ),
    );
  }
}
