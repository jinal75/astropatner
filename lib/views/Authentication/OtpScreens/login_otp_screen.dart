// ignore_for_file: must_be_immutable, avoid_print

import 'package:astrologer_app/constants/messageConst.dart';
import 'package:astrologer_app/controllers/Authentication/login_controller.dart';
import 'package:astrologer_app/controllers/Authentication/login_otp_controller.dart';
import 'package:astrologer_app/controllers/Authentication/signup_controller.dart';
import 'package:astrologer_app/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class LoginOtpScreen extends StatelessWidget {
  String? mobileNumber;
  String? verificationId;

  LoginOtpScreen({Key? key, this.mobileNumber, this.verificationId}) : super(key: key);

  final LoginOtpController loginOtpController = Get.put(LoginOtpController());
  LoginController loginController = Get.find<LoginController>();
  SignupController signupController = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: MyCustomAppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
          height: 80,
          elevation: 0.5,
          appbarPadding: 0,
          title: const Text(
            MessageConstants.VERIFY_PHONE,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 19),
          ).translate(),
          backgroundColor: Colors.grey[100],
        ),
        body: Center(
          child: SizedBox(
            width: Get.width - Get.width * 0.1,
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                children: [
                  Text(
                    'OTP Send to ${loginOtpController.countryCode}-$mobileNumber',
                    style: const TextStyle(color: Colors.green),
                  ).translate(),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 50,
                    child: OtpTextField(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      numberOfFields: 6,
                      showFieldAsBox: true,
                      textStyle: const TextStyle(color: Colors.black),
                      onCodeChanged: (value) {},
                      onSubmit: (value) {
                        loginOtpController.smsCode = value;
                        loginOtpController.update();
                        print('smscode from : ${loginOtpController.smsCode}');
                      },
                      filled: true,
                      fillColor: Colors.white,
                      fieldWidth: 48,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                      borderColor: Colors.transparent,
                      enabledBorderColor: Colors.transparent,
                      focusedBorderColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      margin: const EdgeInsets.only(right: 4),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        loginOtpController.checkOtp(
                          mobileNumber!,
                          verificationId!,
                          loginOtpController.smsCode,
                        );
                        loginOtpController.update();
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 0.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(12),
                        backgroundColor: Get.theme.primaryColor,
                        textStyle: const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      child: const Text(
                        MessageConstants.SUBMIT_CAPITAL,
                        style: TextStyle(color: Colors.black),
                      ).translate(),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GetBuilder<LoginOtpController>(builder: (c) {
                    return SizedBox(
                        child: loginOtpController.maxSecond != 0
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Resend OTP Available in ${loginOtpController.maxSecond} s',
                                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                                  ).translate()
                                ],
                              )
                            : Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                const Text(
                                  'Resend OTP Available',
                                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                                ).translate(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        String phoneNumber = loginOtpController.cMobileNumber.text;
                                        loginController.sendLoginOTP(phoneNumber);
                                      },
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        padding: MaterialStateProperty.all(const EdgeInsets.only(left: 25, right: 25)),
                                        backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                        textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 12, color: Colors.black)),
                                      ),
                                      child: const Text(
                                        'Resend OTP on SMS',
                                        style: TextStyle(color: Colors.black),
                                      ).translate(),
                                    ),
                                  ],
                                )
                              ]));
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
