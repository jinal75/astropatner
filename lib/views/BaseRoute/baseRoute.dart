// ignore_for_file: prefer_const_constructors_in_immutables, file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class BaseRoute extends StatelessWidget {
  final dynamic a;
  final dynamic o;
  final String? r;

  // ignore: use_key_in_widget_constructors
  BaseRoute({this.a, this.o, this.r});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }

  Future addAnalytics() async {
    a.setCurrentScreen(screenName: r);
  }

  Future exitAppDialog() async {
    Get.dialog(AlertDialog(
      title: const Text(
        'Exit',
      ).translate(),
      content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return const Text('Are you sure you want to exit App?');
      }),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Cancel',
            style: Get.theme.primaryTextTheme.overline,
          ).translate(),
          onPressed: () {
            Get.back();
          },
        ),
        TextButton(
          child: Text(
            'Exit',
            style: Get.theme.primaryTextTheme.overline,
          ).translate(),
          onPressed: () async {
            exit(0);
            // Get.back();
          },
        ),
      ],
    ));
  }
}
