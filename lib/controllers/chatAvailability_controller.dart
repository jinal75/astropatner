// ignore_for_file: avoid_print, file_names

import 'dart:convert';

import 'package:astrologer_app/services/apiHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;

class ChatAvailabilityController extends GetxController {
  int? chatType = 1;

  APIHelper apiHelper = APIHelper();
  bool showAvailableTime = true;
  final waitTime = TextEditingController();
  TimeOfDay? timeOfDay2;
  TimeOfDay selectedWaitTime = TimeOfDay.now();
  // final cWaitTimeTime = TextEditingController();
  String? chatStatusName;

  void setChatAvailability(int? index, String? name) {
    chatType = index;
    chatStatusName = name;
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
        update();
        // ignore: use_build_context_synchronously
        waitTime.text = timeOfDay.format(context);
      }
      update();
    } catch (e) {
      print('Exception  - $screen - selectWaitTime():$e');
    }
  }

  statusChatChange({int? astroId, String? chatStatus, String? chatTime}) async {
    try {
      DateTime? date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
      if (chatStatus == "Wait Time") {
        date = date.add(Duration(
          minutes: timeOfDay2!.minute,
          hours: timeOfDay2!.hour,
        ));
      }
      await global.checkBody().then(
        (result) async {
          if (result) {
            await apiHelper.addChatWaitList(astrologerId: astroId, status: chatStatus, datetime: date).then(
              (result) async {
                if (result.status == "200") {
                  global.user.chatStatus = chatStatus;
                  global.user.chatWaitTime = date;
                  await global.sp!.setString('currentUser', json.encode(global.user.toJson()));
                  global.showToast(message: "Chat availability add successfully");
                  update();
                } else {
                  global.showToast(message: "Not available chat status");
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - statusChatChange(): $e');
    }
  }
}
