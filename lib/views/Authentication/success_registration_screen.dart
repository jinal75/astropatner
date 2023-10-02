import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/constants/imageConst.dart';
import 'package:astrologer_app/constants/messageConst.dart';
import 'package:astrologer_app/controllers/Authentication/login_controller.dart';
import 'package:astrologer_app/views/Authentication/login_screen.dart';
import 'package:astrologer_app/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class SuccessRegistrationScreen extends StatelessWidget {
  const SuccessRegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(
          height: 80,
          appbarPadding: 0,
          backgroundColor: COLORS().primaryColor,
          leading: IconButton(
            onPressed: () {
              Get.delete<LoginController>();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(IMAGECONST.thankYouImage),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 15, right: 15),
              child: Center(
                child: Text(
                  "Thanks for submitting your detail with AstroGuru Partner,your token number is 101010 Our team shall reach out to you for interview within 4 weeks if profile get shortlisted, For more information, drop an email at astroguru@gmail.com",
                  style: Theme.of(context).primaryTextTheme.subtitle1,
                ).translate(),
              ),
            )
          ],
        ),
        bottomNavigationBar: Container(
          height: 45,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: COLORS().primaryColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextButton(
            onPressed: () {
              Get.delete<LoginController>();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
            },
            child: const Text(
              MessageConstants.LOGIN,
              style: TextStyle(color: Colors.black),
            ).translate(),
          ),
        ),
      ),
    );
  }
}
