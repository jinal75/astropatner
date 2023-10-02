//ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, prefer_typing_uninitialized_variables

import 'dart:async';
import 'package:astrologer_app/controllers/Authentication/signup_controller.dart';
import 'package:astrologer_app/services/apiHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;

class SignupOtpController extends GetxController {
  String screen = 'signup_otp_controller.dart';
  final SignupController signupController = Get.find<SignupController>();
  double second = 0;
  var maxSecond = 60;
  Timer? time;
  APIHelper apiHelper = APIHelper();
  RxBool isLoading = false.obs;
  String countryCode = "+91";

  timer() {
    maxSecond = 60;
    time = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (maxSecond > 0) {
        maxSecond--;
        update();
      } else {
        time!.cancel();
      }
    });
  }

  updateCountryCode(value) {
    countryCode = value.toString();
    update();
  }

  Future<void> verifyOTP() async {
    print(signupController.cMobileNumber.text);
    Get.snackbar('OTP Sent', 'Wait a moment OTP is sent on your number', snackPosition: SnackPosition.BOTTOM);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: countryCode + signupController.cMobileNumber.text,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        verificationId = verificationId;
        update();
        global.hideLoader();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
