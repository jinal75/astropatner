// ignore_for_file: avoid_print, file_names

import 'dart:convert';

import 'package:astrologer_app/services/apiHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;

class CallAvailabilityController extends GetxController {
  int? callType = 1;
  bool showAvailableTime = true;
  APIHelper apiHelper = APIHelper();
  TimeOfDay? timeOfDay2;
  final waitTime = TextEditingController();
  String? callStatusName = "Online";
  TimeOfDay selectedWaitTime = TimeOfDay.now();

  final cWaitTimeTime = TextEditingController();

  void setCallAvailability(int? index, String? name) {
    callType = index;
    callStatusName = name;
    update();
  }

  selectWaitTime(BuildContext context) async {
    try {
      final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: selectedWaitTime,
        initialEntryMode: TimePickerEntryMode.dial,
      );
      if (timeOfDay != null && timeOfDay != selectedWaitTime) {
        selectedWaitTime = timeOfDay;
        timeOfDay2 = timeOfDay;
        // ignore: use_build_context_synchronously
        waitTime.text = timeOfDay.format(context);
      }
      update();
    } catch (e) {
      print('Exception  - $screen - selectStartTime():$e');
    }
  }

  statusCallChange({int? astroId, String? callStatus, String? callTime}) async {
    try {
      DateTime? date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
      if (callStatus == "Wait Time") {
        date = date.add(Duration(
          minutes: timeOfDay2!.minute,
          hours: timeOfDay2!.hour,
        ));
      }
      await global.checkBody().then(
        (result) async {
          if (result) {
            await apiHelper.addCallWaitList(astrologerId: astroId, status: callStatus, callDateTime: date).then(
              (result) async {
                if (result.status == "200") {
                  global.user.callStatus = callStatus;
                  global.user.callWaitTime = date;
                  await global.sp!.setString('currentUser', json.encode(global.user.toJson()));
                  global.showToast(message: "Call availability add successfully");
                  update();
                } else {
                  global.showToast(message: "Not available call status");
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - statusCallChange(): $e');
    }
  }

  @override
  // ignore: unnecessary_overrides
  void onInit() {
    super.onInit();
  }
}
