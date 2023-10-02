// ignore_for_file: must_be_immutable, prefer_const_constructors, avoid_print

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/constants/imageConst.dart';
import 'package:astrologer_app/controllers/Authentication/login_controller.dart';
import 'package:astrologer_app/controllers/Authentication/login_otp_controller.dart';
import 'package:astrologer_app/controllers/Authentication/signup_controller.dart';
import 'package:astrologer_app/models/time_availability_model.dart';
import 'package:astrologer_app/models/week_model.dart';
import 'package:astrologer_app/views/Authentication/signup_screen.dart';
import 'package:astrologer_app/views/HomeScreen/Drawer/Setting/privacy_policy_screen.dart';
import 'package:astrologer_app/views/HomeScreen/Drawer/Setting/term_and_condition_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  SignupController signupController = Get.find<SignupController>();
  LoginController loginController = Get.find<LoginController>();
  LoginOtpController loginOtpController = Get.put(LoginOtpController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: Get.width,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(IMAGECONST.splashImage),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      global.appName,
                      style: Get.textTheme.headline5,
                    ).translate(),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                color: COLORS().primaryColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 70, left: 18, right: 18),
                        child: SizedBox(
                            child: FutureBuilder(
                                future: global.translatedText("Phone Number"),
                                builder: (context, snapshot) {
                                  return IntlPhoneField(
                                    autovalidateMode: null,
                                    showDropdownIcon: false,
                                    flagsButtonPadding: const EdgeInsets.all(6),
                                    onCountryChanged: (value) {},
                                    controller: loginOtpController.cMobileNumber,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                        hintText: snapshot.data ?? 'Phone Number',
                                        errorText: null,
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontFamily: "verdana_regular",
                                          fontWeight: FontWeight.w400,
                                        ),
                                        counterText: ''),
                                    initialCountryCode: 'IN',
                                    onChanged: (phone) {
                                      print('length ${phone.number.length}');
                                    },
                                  );
                                })),
                      ),
                      GestureDetector(
                        onTap: () {
                          String phoneNumber = loginOtpController.cMobileNumber.text;
                          phoneNumber.isNotEmpty ? loginController.sendLoginOTP(phoneNumber) : global.showToast(message: 'Please enter mobile number');
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
                          child: Container(
                            height: 48,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const SizedBox(
                                  width: 40,
                                ),
                                const Text(
                                  'SEND OTP',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ).translate(),
                                Image.asset(
                                  IMAGECONST.arrowLeft,
                                  color: Colors.white,
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GetBuilder<LoginController>(builder: (logninController) {
                        return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: '${loginController.signupText} ',
                                style: Theme.of(context).primaryTextTheme.subtitle1,
                                children: [
                                  TextSpan(
                                    text: loginController.termsConditionText,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 11,
                                      color: Colors.blue,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.to(() => TermAndConditionScreen());
                                        print("Terms and condition");
                                      },
                                  ),
                                  TextSpan(
                                    text: ' ${loginController.andText} ',
                                    style: TextStyle(color: Colors.black, fontSize: 11),
                                  ),
                                  TextSpan(
                                    text: loginController.privacyPolicyText,
                                    style: TextStyle(decoration: TextDecoration.underline, fontSize: 11, color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.to(() => PrivacyPolicyScreen());
                                        print("Privacy policy");
                                      },
                                  ),
                                ],
                              ),
                            ));
                      }),
                    ]),
                    InkWell(
                      onTap: () {
                        signupController.week = [];
                        signupController.week!.add(Week(day: "Sunday", timeAvailabilityList: [TimeAvailabilityModel(fromTime: "", toTime: "")]));
                        signupController.week!.add(Week(day: "Monday", timeAvailabilityList: [TimeAvailabilityModel(fromTime: "", toTime: "")]));
                        signupController.week!.add(Week(day: "Tuesday", timeAvailabilityList: [TimeAvailabilityModel(fromTime: "", toTime: "")]));
                        signupController.week!.add(Week(day: "Wednesday", timeAvailabilityList: [TimeAvailabilityModel(fromTime: "", toTime: "")]));
                        signupController.week!.add(Week(day: "Thursday", timeAvailabilityList: [TimeAvailabilityModel(fromTime: "", toTime: "")]));
                        signupController.week!.add(Week(day: "Friday", timeAvailabilityList: [TimeAvailabilityModel(fromTime: "", toTime: "")]));
                        signupController.week!.add(Week(day: "Saturday", timeAvailabilityList: [TimeAvailabilityModel(fromTime: "", toTime: "")]));
                        signupController.clearAstrologer();
                        Get.to(() => SignupScreen(), routeName: "Signup Screen");
                      },
                      child: GetBuilder<LoginController>(builder: (loginController) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Center(
                              child: RichText(
                            text: TextSpan(
                              text: '${loginController.notaAccountText} ',
                              style: Theme.of(context).primaryTextTheme.subtitle1,
                              children: <TextSpan>[
                                TextSpan(
                                  text: loginController.signUp,
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                              ],
                            ),
                          )),
                        );
                      }),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
