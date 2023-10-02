// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'dart:async';
import 'package:astrologer_app/controllers/Authentication/login_controller.dart';
import 'package:astrologer_app/controllers/Authentication/signup_controller.dart';
import 'package:astrologer_app/services/apiHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginOtpController extends GetxController {
  SignupController signupController = Get.find<SignupController>();
  LoginController loginController = Get.find<LoginController>();
  String screen = 'login_otp_controller.dart';
  double second = 0;
  var maxSecond;
  Timer? time;
  Timer? time2;
  String countryCode = "+91";
  final TextEditingController cMobileNumber = TextEditingController();
  String smsCode = '';
  APIHelper apiHelper = APIHelper();

  timer() {
    maxSecond = 60;
    time = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (maxSecond > 0) {
        maxSecond--;
        update();
      } else {
        time!.cancel();
        update();
      }
    });
  }

  updateCountryCode(value) {
    countryCode = value.toString();
    update();
  }

//check otp
  void checkOtp(String mobile, String verificationId, String smsCode) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    var credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    await auth.signInWithCredential(credential).then((result) async {
      print('Success');
      await loginController.loginAstrologer(mobile);
    }).catchError((e) {
      print('Fail');
      print(e);
    }).onError((error, stackTrace) {});
  }
}
