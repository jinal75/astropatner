// ignore_for_file: file_names

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/controllers/free_kundli_controller.dart';
import 'package:astrologer_app/widgets/FreeKundliWidget/create_kundli_title_widget.dart';
import 'package:astrologer_app/widgets/FreeKundliWidget/kundli_birth_time_widget.dart';
import 'package:astrologer_app/widgets/FreeKundliWidget/kundli_birthdate_widget.dart';
import 'package:astrologer_app/widgets/FreeKundliWidget/kundli_born_place_widget.dart';
import 'package:astrologer_app/widgets/FreeKundliWidget/kundli_gender_widget.dart';
import 'package:astrologer_app/widgets/FreeKundliWidget/kundli_name_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:astrologer_app/utils/global.dart' as global;

class CreateNewKundki extends StatelessWidget {
  CreateNewKundki({Key? key}) : super(key: key);
  final KundliController kundliController = Get.find<KundliController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        width: double.infinity,
        height: Get.height,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topLeft, colors: [Get.theme.primaryColor, Colors.white]),
        ),
        child: SingleChildScrollView(
          child: GetBuilder<KundliController>(builder: (c) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.arrow_back_ios,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('Kundli', style: Theme.of(context).primaryTextTheme.headline4).translate()
                  ],
                ),
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 5,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: kundliController.listIcon[index].isSelected!
                            ? CircleAvatar(
                                radius: 13,
                                backgroundColor: COLORS().primaryColor,
                                child: Icon(
                                  kundliController.listIcon[kundliController.initialIndex].icon,
                                  size: 15,
                                  color: Colors.black,
                                ),
                              )
                            : kundliController.initialIndex >= index
                                ? GestureDetector(
                                    onTap: () {
                                      kundliController.backStepForCreateKundli(index);
                                      kundliController.updateIcon(kundliController.initialIndex);
                                    },
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: COLORS().primaryColor,
                                    ),
                                  )
                                : const CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.grey,
                                  ),
                      );
                    },
                  ),
                ),
                CreateKundliTitleWidget(
                  title: kundliController.initialIndex == 0
                      ? kundliController.kundliTitle[0]
                      : kundliController.initialIndex == 1
                          ? kundliController.kundliTitle[1]
                          : kundliController.initialIndex == 2
                              ? kundliController.kundliTitle[2]
                              : kundliController.initialIndex == 3
                                  ? kundliController.kundliTitle[3]
                                  : kundliController.kundliTitle[4],
                ),
                const SizedBox(
                  height: 10,
                ),
                if (kundliController.initialIndex == 0)
                  KundliNameWidget(
                    kundliController: kundliController,
                    onPressed: () {
                      if (!kundliController.isDisable) {
                        kundliController.updateInitialIndex();
                        kundliController.updateIcon(kundliController.initialIndex);
                      }
                    },
                  ),
                if (kundliController.initialIndex == 1)
                  KundliGenderWidget(
                    kundliController: kundliController,
                  ),
                if (kundliController.initialIndex == 2)
                  KundliBrithDateWidget(
                    kundliController: kundliController,
                    onPressed: () {
                      kundliController.updateInitialIndex();
                      kundliController.updateIcon(kundliController.initialIndex);
                    },
                  ),
                if (kundliController.initialIndex == 3)
                  KundliBirthTimeWidget(
                    kundliController: kundliController,
                    onPressed: () {
                      kundliController.updateInitialIndex();
                      kundliController.updateIcon(kundliController.initialIndex);
                    },
                  ),
                if (kundliController.initialIndex == 4)
                  KundliBornPlaceWidget(
                    kundliController: kundliController,
                    onPressed: () async {
                      if (kundliController.birthKundliPlaceController.text == "") {
                        global.showToast(message: 'Please select birth place');
                      } else {
                        kundliController.updateIcon(kundliController.initialIndex);
                        await kundliController.addKundliData();
                        await kundliController.getKundliList();
                        kundliController.initialIndex = 0;
                        Get.back();
                      }
                    },
                  )
              ],
            );
          }),
        ),
      ),
    ));
  }
}
