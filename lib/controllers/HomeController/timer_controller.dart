import 'dart:async';

import 'package:get/get.dart';

class TimerController extends GetxController {
  Timer? timer;
  Timer? secTimer;
  int min = 0;
  int sec = 0;
  String minText = "00";
  String secText = "00";
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 300;
  bool isStartTimer = false;

  @override
  void onInit() async {
    _init();
    super.onInit();
  }

  _init() async {
    startTimer();
  }

  startTimer() {
    timer = Timer.periodic(const Duration(minutes: 1), (Timer timer) async {
      //leave();
    });
    secTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      if (sec < 60) {
        sec += 1;
        if (sec < 10) {
          secText = '0$sec';
        } else {
          secText = '$sec';
        }
        update();
      } else {
        sec = 0;
        update();
      }
      if (sec == 60) {
        if (min <= 4) {
          min += 1;
          if (min < 10) {
            minText = '0$min';
          } else {
            minText = '$min';
          }
          update();
        } else {
          min = 0;
          sec = 0;
          minText = "";
          secText = "";
          update();
          timer.cancel();
          secTimer!.cancel();
          //Get.back();
        }
      }
    });

    update();
  }
}
