// ignore_for_file: file_names

import 'package:astrologer_app/controllers/free_kundli_controller.dart';
import 'package:astrologer_app/models/kundliModel.dart';
import 'package:astrologer_app/views/HomeScreen/FloatingButton/FreeKundli/Tabs/DashaTabs/vismshattariDasha.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class KundliDashaScreen extends StatelessWidget {
  final KundliModel? userModel;
  const KundliDashaScreen({Key? key, this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KundliController>(builder: (kundliController) {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: kundliController.dashaTab.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        kundliController.selectDashaTab(index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: kundliController.dashaTab[index].isSelected ? const Color.fromARGB(255, 247, 243, 213) : Colors.transparent,
                              border: Border.all(color: kundliController.dashaTab[index].isSelected ? Get.theme.primaryColor : Colors.black),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(kundliController.dashaTab[index].title, style: const TextStyle(fontSize: 13)).translate()),
                      ),
                    );
                  }),
            ),
            const VismshattariDasha()
          ],
        ),
      );
    });
  }
}
