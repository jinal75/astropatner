// ignore_for_file: must_be_immutable

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/controllers/free_kundli_controller.dart';
import 'package:astrologer_app/controllers/kundli_matchig_controller.dart';
import 'package:astrologer_app/widgets/app_bar_widget.dart';
import 'package:astrologer_app/views/HomeScreen/FloatingButton/KundliMatching/Tabs/new_matching_screen.dart';
import 'package:astrologer_app/views/HomeScreen/FloatingButton/KundliMatching/Tabs/open_kundli_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

class KundliMatchingScreen extends StatelessWidget {
  KundliMatchingScreen({Key? key}) : super(key: key);
  final KundliMatchingController kundliMatchingController = Get.find<KundliMatchingController>();
  KundliController kundliController = Get.find<KundliController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<KundliMatchingController>(
          init: kundliMatchingController,
          builder: (controller) {
            return Scaffold(
              appBar: MyCustomAppBar(
                height: 80,
                backgroundColor: COLORS().primaryColor,
                title: const Text("Kundli Matching").translate(),
              ),
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/chat_background.jpg"),
                  ),
                ),
                child: DefaultTabController(
                    length: 2,
                    initialIndex: kundliMatchingController.currentIndex,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: TabBar(
                                unselectedLabelColor: Colors.black,
                                labelColor: Colors.black,
                                indicatorWeight: 0.1,
                                indicatorColor: Colors.blue,
                                labelPadding: EdgeInsets.zero,
                                tabs: [
                                  Obx(
                                    () => kundliMatchingController.homeTabIndex.value == 0
                                        ? Container(
                                            height: Get.height,
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                              color: COLORS().primaryColor,
                                              borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(8),
                                                topLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(12),
                                                topRight: Radius.circular(12),
                                              ),
                                              border: Border.all(color: Colors.grey),
                                            ),
                                            child: Center(child: const Text('Open Kundli').translate()),
                                          )
                                        : Center(
                                            child: const Text('Open Kundli').translate(),
                                          ),
                                  ),
                                  Obx(
                                    () => kundliMatchingController.homeTabIndex.value == 1
                                        ? Container(
                                            height: Get.height,
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                              color: COLORS().primaryColor,
                                              borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(12),
                                                topLeft: Radius.circular(12),
                                                bottomRight: Radius.circular(8),
                                                topRight: Radius.circular(8),
                                              ),
                                              border: Border.all(color: Colors.grey),
                                            ),
                                            child: Center(child: const Text('New Matching').translate()),
                                          )
                                        : Center(
                                            child: const Text('New Matching').translate(),
                                          ),
                                  ),
                                ],
                                onTap: (index) {
                                  global.showOnlyLoaderDialog();
                                  kundliMatchingController.onHomeTabBarIndexChanged(index);
                                  global.hideLoader();
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: kundliMatchingController.homeTabIndex.value == 1
                              ?
//First Tabbar
                              NewMatchingScreen()
                              :
//Second Tabbar
                              OpenKundliScreen(),
                        )
                      ],
                    )),
              ),
              bottomNavigationBar: kundliMatchingController.homeTabIndex.value == 1
                  ? Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/chat_background.jpg"),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: COLORS().primaryColor,
                            maximumSize: Size(MediaQuery.of(context).size.width, 100),
                            minimumSize: Size(MediaQuery.of(context).size.width, 48),
                          ),
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            bool isvalid = kundliMatchingController.isValidData();
                            if (!isvalid) {
                              global.showToast(message: kundliMatchingController.errorMessage!);
                            } else {
                              await kundliMatchingController.addKundliMatchData();
                            }
                          },
                          child: const Text(
                            "Match Horoscope",
                            style: TextStyle(color: Colors.black),
                          ).translate(),
                        ),
                      ),
                    )
                  : const SizedBox(),
            );
          }),
    );
  }
}
