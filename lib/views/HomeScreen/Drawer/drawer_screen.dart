// ignore_for_file: must_be_immutable

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/controllers/AssistantController/add_assistant_controller.dart';
import 'package:astrologer_app/controllers/Authentication/signup_controller.dart';
import 'package:astrologer_app/controllers/HomeController/home_controller.dart';
import 'package:astrologer_app/controllers/HomeController/wallet_controller.dart';
import 'package:astrologer_app/controllers/app_review_controller.dart';
import 'package:astrologer_app/controllers/customerReview_controller.dart';

import 'package:astrologer_app/views/HomeScreen/Assistant/assistant_screen.dart';
import 'package:astrologer_app/views/HomeScreen/Drawer/AppReview/app_review_screen.dart';
import 'package:astrologer_app/views/HomeScreen/Drawer/Setting/setting_list_screen.dart';
import 'package:astrologer_app/views/HomeScreen/Drawer/Wallet/Wallet_screen.dart';
import 'package:astrologer_app/views/HomeScreen/Drawer/customer_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

import '../../../controllers/AssistantController/astrologer_assistant_chat_controller.dart';
import '../Assistant/assistant_chat_request_screen.dart';

class DrawerScreen extends StatelessWidget {
  DrawerScreen({Key? key}) : super(key: key);
  AddAssistantController assistantController = Get.find<AddAssistantController>();
  CustomerReviewController customerReviewController = Get.find<CustomerReviewController>();
  SignupController signupController = Get.find<SignupController>();
  HomeController homeController = Get.find<HomeController>();
  WalletController walletController = Get.find<WalletController>();
  AppReviewController appReviewController = Get.find<AppReviewController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    homeController.isSelectedBottomIcon = 4;
                    homeController.update();
                    Navigator.pop(context);
                  },
                  child: global.user.imagePath != null && global.user.imagePath!.isNotEmpty
                      ? signupController.astrologerList[0].imagePath!.isNotEmpty
                          ? Container(
                              height: Get.height * 0.1,
                              width: Get.width * 0.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                image: DecorationImage(
                                  image: NetworkImage("${global.imgBaseurl}${signupController.astrologerList[0].imagePath}"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: Get.height * 0.1,
                              width: Get.width * 0.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                image: DecorationImage(
                                  image: NetworkImage("${global.user.imagePath}"),
                                  fit: BoxFit.cover,
                                ),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                            )
                      : Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: COLORS().primaryColor),
                          child: CircleAvatar(
                            backgroundColor: COLORS().primaryColor,
                            radius: 45,
                            backgroundImage: const AssetImage(
                              "assets/images/no_customer_image.png",
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    children: [
                      Text(
                        global.user.name != null && global.user.name != '' ? '${global.user.name}' : "Astrologer",
                        style: Theme.of(context).primaryTextTheme.headline2,
                      ).translate(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                '+91-',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                            Text(
                              global.user.contactNo != null && global.user.contactNo != '' ? '${global.user.contactNo}' : "",
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.black,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "My Assistant",
                      style: Theme.of(context).textTheme.subtitle1,
                    ).translate(),
                  ),
                ],
              ),
              onTap: () async {
                await assistantController.getAstrologerAssistantList();
                Get.to(() => AssistantScreen());
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  const Icon(
                    Icons.chat,
                    color: Colors.grey,
                    size: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "Assistant Chat Request",
                      style: Theme.of(context).textTheme.subtitle1,
                    ).translate(),
                  ),
                ],
              ),
              onTap: () async {
                final AstrologerAssistantChatController astrologerAssistantChatController = Get.find<AstrologerAssistantChatController>();
                global.showOnlyLoaderDialog();
                await astrologerAssistantChatController.getAstrologerAssistantChatRequest();
                global.hideLoader();
                Get.to(() => AssistantChatRequestScreen());
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  const Icon(
                    Icons.wallet,
                    color: Colors.grey,
                    size: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "Wallet Transactions",
                      style: Theme.of(context).textTheme.subtitle1,
                    ).translate(),
                  ),
                ],
              ),
              onTap: () {
                walletController.getAmountList();
                Get.to(() => WalletScreen());
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  const Icon(
                    Icons.rate_review,
                    color: Colors.grey,
                    size: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "Customer Review",
                      style: Theme.of(context).textTheme.subtitle1,
                    ).translate(),
                  ),
                ],
              ),
              onTap: () async {
                signupController.astrologerList.clear();
                signupController.clearReply();
                await signupController.astrologerProfileById(false);
                signupController.update();
                Get.to(() => CustomeReviewScreen());
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  const Icon(
                    Icons.rate_review_outlined,
                    color: Colors.grey,
                    size: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "App Review",
                      style: Theme.of(context).textTheme.subtitle1,
                    ).translate(),
                  ),
                ],
              ),
              onTap: () async {
                global.showOnlyLoaderDialog();
                appReviewController.getAppReview();
                global.hideLoader();
                Get.to(() => AppReviewScreen());
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  const Icon(
                    Icons.settings,
                    color: Colors.grey,
                    size: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "Settings",
                      style: Theme.of(context).textTheme.subtitle1,
                    ).translate(),
                  ),
                ],
              ),
              onTap: () {
                Get.to(() => SettingListScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
