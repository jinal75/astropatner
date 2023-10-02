// ignore_for_file: file_names, prefer_interpolation_to_compose_strings, avoid_print

import 'package:astrologer_app/models/dailyHoroscopeModel.dart';
import 'package:astrologer_app/services/apiHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;

class DailyHoroscopeController extends GetxController {
  APIHelper apiHelper = APIHelper();
  List zodiac = ['Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo', 'Libra', 'Scorpio', 'Sagittarius', 'Capricornus', 'Aquarius', 'Pisces'];

  List dailyHoroscopeCate = ['Love', 'Career', 'Money', 'Health', 'Travel'];
  List borderColor = [Colors.red, Colors.orange, Colors.green, Colors.blue, Colors.purple];
  List containerColor = const [Color.fromARGB(255, 241, 223, 220), Color.fromARGB(255, 248, 233, 211), Color.fromARGB(255, 226, 248, 227), Color.fromARGB(255, 218, 234, 247), Color.fromARGB(255, 242, 227, 245)];
  bool isToday = true;
  bool isYesterday = false;
  bool isTomorrow = false;
  bool isMonth = true;
  bool isWeek = false;
  bool isYear = false;
  int? signId;
  int day = 2;
  DailyscopeModel? dailyList;
  int zodiacindex = 0;
  Map<String, dynamic> dailyHororscopeData = {};

  updateDaily(int flag) {
    day = flag;
    update();
  }

  @override
  Future onInit() async {
    super.onInit();
    await getHororScopeSignData();
    await getDefaultDailyHororscope();
    if (global.hororscopeSignList.isNotEmpty) {
      await getHoroscopeList(horoscopeId: global.hororscopeSignList[0].id);
    }
  }

  updateTimely({bool? month, bool? year, bool? week}) {
    isMonth = month!;
    isWeek = week!;
    isYear = year!;
    update();
  }

  Future getDefaultDailyHororscope() async {
    try {
      if (global.hororscopeSignList.isNotEmpty) {
        global.hororscopeSignList[0].isSelected = true;
      }
    } catch (e) {
      print('Exception in getDefaultDailyHororscope():' + e.toString());
    }
  }

  selectZodic(int index) async {
    await getHororScopeSignData();
    global.hororscopeSignList.map((e) => e.isSelected = false).toList();
    global.hororscopeSignList[index].isSelected = true;
    zodiacindex = index;
    signId = global.hororscopeSignList[index].id;
    update();
  }

  Future getHororScopeSignData() async {
    try {
      if (global.hororscopeSignList.isEmpty) {
        await global.checkBody().then((result) async {
          if (result) {
            await apiHelper.getHororscopeSign().then((result) {
              if (result.status == "200") {
                global.hororscopeSignList = result.recordList;
                update();
              } else {
                global.showToast(message: "No daily hororScope");
              }
            });
          }
        });
      }
    } catch (e) {
      print('Exception in getHororScopeSignData():' + e.toString());
    }
  }

  getHoroscopeList({int? horoscopeId}) async {
    try {
      dailyList = null;

      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getHoroscope(horoscopeSignId: horoscopeId).then((result) {
            if (result != null) {
              Map<String, dynamic> map = result;
              dailyList = DailyscopeModel.fromJson(map);
              update();
            } else {
              if (global.currentUserId != null) {
                global.showToast(message: 'Not show daily horoscope');
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getHoroscopeList():' + e.toString());
    }
  }
}
