// ignore_for_file: file_names

import 'package:astrologer_app/controllers/free_kundli_controller.dart';
import 'package:astrologer_app/widgets/FreeKundliWidget/container_list_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

// ignore: must_be_immutable
class KalsarpaDosha extends StatelessWidget {
  KalsarpaDosha({Key? key}) : super(key: key);
  KundliController kundliController = Get.find<KundliController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          height: 10,
        ),
        Text('Kalsarpa Analysis', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold)).translate(),
        const SizedBox(
          height: 10,
        ),
        ContainerListTileWidget(
          title: 'Kalsarpa',
          subTitle: 'Kundli is free from kalsharrpa dosha',
          doshText: kundliController.isKalsarpa! ? 'Yes' : 'No',
          color: kundliController.isKalsarpa! ? Colors.red : Colors.green,
        ),
      ]),
    );
  }
}
