// ignore_for_file: avoid_print

import 'package:astrologer_app/models/kundliMatchingDetailModel.dart';
import 'package:astrologer_app/models/kundliModel.dart';
import 'package:astrologer_app/services/apiHelper.dart';
import 'package:astrologer_app/views/HomeScreen/FloatingButton/KundliMatching/kundli_match_result_screen.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:intl/intl.dart';

class KundliMatchingController extends GetxController {
//Tab Manage
  final int currentIndex = 0;
  String? errorMessage;
  int? boykundliId;
  int? girlKundliId;
  int? minGirls;
  int? minBoy;
  int? hourGirl;
  double? lat;
  double? long;
  double? timeZone;
  int? hourBoy;
  bool? isFemaleManglik;
  bool? isMaleManglik;
  RxInt homeTabIndex = 0.obs;
  APIHelper apiHelper = APIHelper();
  KundliMatchingTitleModel? kundliMatchDetailList;
  TabController? kundliMatchingTabController;
  onHomeTabBarIndexChanged(value) {
    homeTabIndex.value = value;
    update();
  }

//Boys Name
  final TextEditingController cBoysName = TextEditingController();
//Boys Birth Date
  final TextEditingController cBoysBirthDate = TextEditingController();
  DateTime? boySelectedDate;
  onBoyDateSelected(DateTime? picked) {
    if (picked != null && picked != boySelectedDate) {
      boySelectedDate = picked;

      cBoysBirthDate.text = boySelectedDate.toString();
      cBoysBirthDate.text = formatDate(boySelectedDate!, [dd, '-', mm, '-', yyyy]);
    }
    update();
  }

  bool isValidData() {
    if (cBoysName.text == "") {
      errorMessage = "Please Input boy's detail";
      update();
      return false;
    } else if (cGirlName.text == "") {
      errorMessage = "Please Input Girl's detail";
      update();
      return false;
    } else {
      return true;
    }
  }

  openKundliData(var kundliList, int index) {
    if (kundliList[index].gender == "Male") {
      boykundliId = kundliList[index].id;
      cBoysName.text = kundliList[index].name;
      cBoysBirthDate.text = formatDate(kundliList[index].birthDate, [dd, '-', mm, '-', yyyy]);
      cBoysBirthTime.text = kundliList[index].birthTime.toString();
      cBoysBirthPlace.text = kundliList[index].birthPlace.toString();
      update();
    } else if (kundliList[index].gender == "Female") {
      girlKundliId = kundliList[index].id;
      cGirlName.text = kundliList[index].name;
      cGirlBirthDate.text = formatDate(kundliList[index].birthDate, [dd, '-', mm, '-', yyyy]);
      cGirlBirthTime.text = kundliList[index].birthTime.toString();
      cGirlBirthPlace.text = kundliList[index].birthPlace.toString();
      update();
    }
  }

  @override
  onInit() {
    _init();
    super.onInit();
  }

  _init() {
    onBoyDateSelected(DateTime.now());
    onGirlDateSelected(DateTime.now());
    cBoysBirthTime.text = DateFormat.jm().format(DateTime.now());
    cGirlBirthTime.text = DateFormat.jm().format(DateTime.now());
    cBoysBirthPlace.text = "New Delhi,Delhi,India";
    cGirlBirthPlace.text = "New Delhi,Delhi,India";
  }

  addKundliMatchData() async {
    global.showOnlyLoaderDialog();
    // ignore: unused_local_variable
    KundliModel sendKundli;
    List<KundliModel> kundliModel = [
      KundliModel(
        id: boykundliId,
        name: cBoysName.text,
        gender: 'Male',
        birthDate: boySelectedDate!,
        birthTime: cBoysBirthTime.text,
        birthPlace: cBoysBirthPlace.text,
      ),
      KundliModel(
        id: girlKundliId,
        name: cGirlName.text,
        gender: 'Female',
        birthDate: girlSelectedDate!,
        birthTime: cGirlBirthTime.text,
        birthPlace: cGirlBirthPlace.text,
      )
    ];
    int ind = cBoysBirthTime.text.indexOf(":");
    int ind2 = cGirlBirthTime.text.indexOf(":");
    hourBoy = int.parse(cBoysBirthTime.text.substring(0, ind));
    hourGirl = int.parse(cGirlBirthTime.text.substring(0, ind2));
    //print('done ' + cBoysBirthTime.text.substring(ind + 1, ind + 3));
    minBoy = int.parse(cBoysBirthTime.text.substring(ind + 1, ind + 3));
    minGirls = int.parse(cGirlBirthTime.text.substring(ind + 1, ind + 3));
    update();
    await global.checkBody().then((result) async {
      if (result) {
        await apiHelper.addKundli(kundliModel).then((result) async {
          if (result.status == "200") {
            print('success');
            getKundlMatchingiList(boySelectedDate!, girlSelectedDate!);
            getKundlMagllicList(boySelectedDate!, girlSelectedDate!);
            global.hideLoader();
            Get.to(() => KundliMatchingResultScreen());
          } else {
            global.hideLoader();
            global.showToast(message: "Failed to add kundli please try again later!");
          }
        });
      }
    });
  }

  getKundlMatchingiList(DateTime kundliBoys, DateTime kundliGirls) async {
    try {
      kundliMatchDetailList = null;
      DateTime datePanchang = kundliBoys;
      int formattedYear = int.parse(DateFormat('yyyy').format(datePanchang));
      int formattedDay = int.parse(DateFormat('dd').format(datePanchang));
      int formattedMonth = int.parse(DateFormat('MM').format(datePanchang));
      DateTime dateForGirl = kundliGirls;
      int yearGirl = int.parse(DateFormat('yyyy').format(dateForGirl));
      int dayGirl = int.parse(DateFormat('dd').format(dateForGirl));
      int monthGirl = int.parse(DateFormat('MM').format(dateForGirl));
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getMatching(formattedDay, formattedMonth, formattedYear, hourBoy, minBoy, dayGirl, monthGirl, yearGirl, hourGirl, minGirls).then((result) {
            if (result != null) {
              Map<String, dynamic> map = result;
              kundliMatchDetailList = KundliMatchingTitleModel.fromJson(map);
              print(kundliMatchDetailList);
              update();
            } else {}
          });
        }
      });
    } catch (e) {
      print('Exception in getKundliList():$e');
    }
  }

  getKundlMagllicList(DateTime kundliBoys, DateTime kundliGirls) async {
    try {
      kundliMatchDetailList = null;
      DateTime datePanchang = kundliBoys;
      int formattedYear = int.parse(DateFormat('yyyy').format(datePanchang));
      int formattedDay = int.parse(DateFormat('dd').format(datePanchang));
      int formattedMonth = int.parse(DateFormat('MM').format(datePanchang));
      DateTime dateForGirl = kundliGirls;
      int yearGirl = int.parse(DateFormat('yyyy').format(dateForGirl));
      int dayGirl = int.parse(DateFormat('dd').format(dateForGirl));
      int monthGirl = int.parse(DateFormat('MM').format(dateForGirl));
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getManglic(formattedDay, formattedMonth, formattedYear, hourBoy, minBoy, dayGirl, monthGirl, yearGirl, hourGirl, minGirls).then((result) {
            if (result != null) {
              isFemaleManglik = result['female']['is_present'];
              isMaleManglik = result['male']['is_present'];
              update();
            } else {}
          });
        }
      });
    } catch (e) {
      print('Exception in getKundliList():$e');
    }
  }

//Boys Birthdate Time
  final TextEditingController cBoysBirthTime = TextEditingController();
//Boys Birth Place
  final TextEditingController cBoysBirthPlace = TextEditingController();

//Girls Name
  final TextEditingController cGirlName = TextEditingController();
//Girls Birth Date
  final TextEditingController cGirlBirthDate = TextEditingController();
  DateTime? girlSelectedDate;
  onGirlDateSelected(DateTime? picked) {
    if (picked != null && picked != girlSelectedDate) {
      girlSelectedDate = picked;

      cGirlBirthDate.text = girlSelectedDate.toString();
      cGirlBirthDate.text = formatDate(girlSelectedDate!, [dd, '-', mm, '-', yyyy]);
    }
    update();
  }

//Girls Birthdate Time
  final TextEditingController cGirlBirthTime = TextEditingController();
//Girls Birth Place
  final TextEditingController cGirlBirthPlace = TextEditingController();
}
