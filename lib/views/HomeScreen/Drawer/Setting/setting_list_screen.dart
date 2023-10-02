// ignore_for_file: must_be_immutable

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/constants/messageConst.dart';
import 'package:astrologer_app/controllers/Authentication/login_controller.dart';
import 'package:astrologer_app/controllers/Authentication/login_otp_controller.dart';
import 'package:astrologer_app/controllers/Authentication/signup_controller.dart';
import 'package:astrologer_app/views/Authentication/login_screen.dart';
import 'package:astrologer_app/views/HomeScreen/Drawer/Setting/privacy_policy_screen.dart';
import 'package:astrologer_app/views/HomeScreen/Drawer/Setting/term_and_condition_screen.dart';
import 'package:astrologer_app/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

class SettingListScreen extends StatelessWidget {
  SettingListScreen({Key? key}) : super(key: key);
  SignupController signupController = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(
          height: 80,
          backgroundColor: COLORS().primaryColor,
          title: const Text("Settings").translate(),
        ),
        body: Column(
          children: [
            GestureDetector(
              onTap: () {
                Get.to(() => const TermAndConditionScreen());
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: const Text(
                      "Terms and Condition",
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 16),
                    ).translate(),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => const PrivacyPolicyScreen());
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: const Text(
                      "Privacy Policy",
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 16),
                    ).translate(),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text("Are you sure you want to logout?").translate(),
                    content: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(MessageConstants.No).translate(),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 4,
                          child: ElevatedButton(
                            onPressed: () async {
                              final LoginController loginController = Get.find<LoginController>();
                              final LoginOtpController loginOtpController = Get.put(LoginOtpController());
                              global.showOnlyLoaderDialog();
                              loginOtpController.cMobileNumber.clear();
                              await loginController.init();
                              global.hideLoader();
                              await global.logoutUser();
                            },
                            child: const Text(MessageConstants.YES).translate(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.logout,
                          color: Colors.black,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: const Text(
                            "Logout my account",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                          ).translate(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text("Are you sure you want to delete this Account?").translate(),
                    content: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(MessageConstants.No).translate(),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 4,
                          child: ElevatedButton(
                            onPressed: () {
                              int id = global.user.id ?? 0;
                              signupController.deleteAstrologer(id);
                              Get.offUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
                            },
                            child: const Text(MessageConstants.YES).translate(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          color: COLORS().errorColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            "Delete my account",
                            style: TextStyle(color: COLORS().errorColor, fontWeight: FontWeight.w500, fontSize: 16),
                          ).translate(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
