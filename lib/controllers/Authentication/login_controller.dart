// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:developer';
import 'package:astrologer_app/controllers/Authentication/login_otp_controller.dart';
import 'package:astrologer_app/models/device_detail_model.dart';
import 'package:astrologer_app/services/apiHelper.dart';
import 'package:astrologer_app/views/Authentication/OtpScreens/login_otp_screen.dart';
import 'package:astrologer_app/views/HomeScreen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;

import '../HomeController/call_controller.dart';
import '../HomeController/chat_controller.dart';
import '../HomeController/live_astrologer_controller.dart';
import '../HomeController/report_controller.dart';
import '../following_controller.dart';

class LoginController extends GetxController {
  String screen = 'login_controller.dart';
  APIHelper apiHelper = APIHelper();

  // //Controller
  // final TextEditingController cMobileNumber = TextEditingController();

  //Login
  ChatController chatController = Get.find<ChatController>();
  CallController callController = Get.find<CallController>();
  ReportController reportController = Get.find<ReportController>();
  FollowingController followingController = Get.find<FollowingController>();
  LiveAstrologerController liveAstrologerController = Get.find<LiveAstrologerController>();
  String signupText = "By signin up you agree to our";
  String termsConditionText = "Terms of Services";
  String andText = "and";
  String privacyPolicyText = "Privacy Policy";
  String notaAccountText = "Don't have an account?";
  String signUp = "Signup";

  @override
  void onInit() async {
    await init();
    super.onInit();
  }

  init() async {
    signupText = await global.translatedText('By signin up you agree to our');
    termsConditionText = await global.translatedText('Terms of Services');
    andText = await global.translatedText('and');
    privacyPolicyText = await global.translatedText('Privacy Policy');
    notaAccountText = await global.translatedText("Don't have an account?");
    signUp = await global.translatedText('Signup');
    update();
  }

  Future loginAstrologer(phoneNumber) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.showOnlyLoaderDialog();
          global.getDeviceData();
          DeviceInfoLoginModel deviceInfoLoginModel = DeviceInfoLoginModel(
            appId: "2",
            appVersion: global.appVersion,
            deviceId: global.deviceId,
            deviceManufacturer: global.deviceManufacturer,
            deviceModel: global.deviceModel,
            fcmToken: global.fcmToken,
            deviceLocation: "",
          );

          await apiHelper.login(phoneNumber, deviceInfoLoginModel).then((result) async {
            if (result.status == "200") {
              global.user = result.recordList;
              await global.sp!.setString('currentUser', json.encode(global.user.toJson()));
              log('currentuser ${global.user}');
              print('success');
              await global.getCurrentUserId();
              await chatController.getChatList(false);
              await callController.getCallList(false);
              await reportController.getReportList(false);
              await followingController.followingList(false);
              await liveAstrologerController.endLiveSession(true);
              global.hideLoader();
              Get.to(() => HomeScreen());
            } else if (result.status == "400") {
              global.showToast(message: result.message.toString());
            } else {
              global.showToast(message: result.message.toString());
            }
          });
        } else {
          global.showToast(message: 'No network connection!');
        }
      });
      update();
    } catch (e) {
      print('Exception - $screen - loginAstrologer(): ' + e.toString());
    }
  }

//send otp to login
  Future<void> sendLoginOTP(String phoneNumber) async {
    try {
      await global.checkBody().then((result) {
        if (result) {
          global.showOnlyLoaderDialog();
          FirebaseAuth _auth = FirebaseAuth.instance;
          _auth.verifyPhoneNumber(
            phoneNumber: '+91$phoneNumber',
            //timeout: const Duration(seconds: 60),
            verificationCompleted: (PhoneAuthCredential credential) {
              //lobal.hideLoader();
              log("Select $credential");
            },
            verificationFailed: (FirebaseAuthException e) {
              global.hideLoader();
              //global.showToast(message: e.toString());
              Get.snackbar('Warning', e.toString());
              //Please try agains some time
              log('Login Screen - > ${e.message.toString()}');
            },
            codeSent: (String verificationId, int? resendToken) async {
              global.hideLoader();
              LoginOtpController loginOtpController = Get.put(LoginOtpController());
              loginOtpController.timer();
              Get.to(() => LoginOtpScreen(
                    mobileNumber: phoneNumber,
                    verificationId: verificationId,
                  ));
              log('Login Screen -> code sent');
            },
            codeAutoRetrievalTimeout: (String verificationId) {},
          );
        }
      });
    } catch (e) {
      print("Exception - $screen - sendLoginOTP():" + e.toString());
    }
  }
}
