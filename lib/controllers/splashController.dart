// ignore_for_file: file_names, avoid_print

import 'dart:convert';

import 'package:astrologer_app/controllers/HomeController/call_controller.dart';
import 'package:astrologer_app/controllers/HomeController/chat_controller.dart';
import 'package:astrologer_app/controllers/HomeController/report_controller.dart';
import 'package:astrologer_app/controllers/following_controller.dart';
import 'package:astrologer_app/controllers/networkController.dart';
import 'package:astrologer_app/models/systemFlagModel.dart';
import 'package:astrologer_app/models/user_model.dart';
import 'package:astrologer_app/services/apiHelper.dart';
import 'package:astrologer_app/views/Authentication/login_screen.dart';
import 'package:astrologer_app/views/HomeScreen/home_screen.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeController/live_astrologer_controller.dart';

class SplashController extends GetxController {
  // getxcontroller instance
  NetworkController networkController = Get.put(NetworkController());
  ChatController chatController = Get.put(ChatController());
  CallController callController = Get.put(CallController());
  ReportController reportController = Get.put(ReportController());
  FollowingController followingController = Get.put(FollowingController());
  LiveAstrologerController liveAstrologerController = Get.put(LiveAstrologerController());
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  String? appShareLinkForLiveSreaming;

  //Class
  APIHelper apiHelper = APIHelper();
  CurrentUser? currentUser;
  //Variables
  var systemFlag = <SystemFlag>[];
  RxBool isDataLoaded = false.obs;
  String? version;
  String currentLanguageCode = 'en';

  @override
  void onInit() async {
    _init();
    super.onInit();
  }

  _init() async {
    try {
      await global.checkBody().then(
        (networkResult) async {
          if (networkResult) {
            await apiHelper.getMasterTableData().then(
              (apiResult) async {
                if (apiResult.status == "200") {
                  await global.getDeviceData();
                  await getSystemList();
                  global.appName = global.getSystemFlagValue(global.systemFlagNameList.appName);
                  global.spLanguage = await SharedPreferences.getInstance();
                  currentLanguageCode = global.spLanguage!.getString('currentLanguage') ?? 'en';
                  update();
                  global.getMasterTableDataModelList = apiResult.recordList;
                  global.astrologerCategoryModelList = global.getMasterTableDataModelList.astrologerCategory;
                  global.skillModelList = global.getMasterTableDataModelList.skill;
                  global.allSkillModelList = global.getMasterTableDataModelList.allskill;
                  global.languageModelList = global.getMasterTableDataModelList.language;
                  global.assistantPrimarySkillModelList = global.getMasterTableDataModelList.assistantPrimarySkill;
                  global.assistantAllSkillModelList = global.getMasterTableDataModelList.assistantAllSkill;
                  global.assistantLanguageModelList = global.getMasterTableDataModelList.assistantLanguage;
                  global.mainSourceBusinessModelList = global.getMasterTableDataModelList.mainSourceBusiness;
                  global.highestQualificationModelList = global.getMasterTableDataModelList.highestQualification;
                  global.degreeDiplomaList = global.getMasterTableDataModelList.qualifications;
                  global.jobWorkingList = global.getMasterTableDataModelList.jobs;
                }
              },
            );
            global.sp = await SharedPreferences.getInstance();
            if (global.sp!.getString("currentUser") != null) {
              await apiHelper.validateSession().then((result) async {
                if (result.status == "200") {
                  global.user = result.recordList;
                  global.user.token = global.user.sessionToken!.split(" ")[1];
                  await global.sp!.setString('currentUser', json.encode(global.user.toJson()));
                  if (global.user.id != null) {
                    await global.getCurrentUserId();

                    //Lazy loading
                    chatController.chatList.clear();
                    callController.callList.clear();
                    reportController.reportList.clear();
                    followingController.followerList.clear();

                    await chatController.getChatList(false);
                    await callController.getCallList(false);
                    await reportController.getReportList(false);
                    await followingController.followingList(false);

                    await liveAstrologerController.endLiveSession(true);
                    Get.off(() => HomeScreen(), routeName: "HomeScreen");
                  } else {
                    Get.off(() => LoginScreen(), routeName: "LoginScreen");
                  }
                } else {
                  Get.off(() => LoginScreen(), routeName: "LoginScreen");
                }
              });
            } else {
              Get.off(() => LoginScreen(), routeName: "LoginScreen");
            }
          } else {
            global.showToast(message: "No Network Available");
          }
        },
      );
    } catch (err) {
      global.printException("SplashController", "_init", err);
    }

    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print('FCM TOKEN $fcmToken');
  }

  getSystemList() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getSystemFlag().then((result) {
            if (result.status == "200") {
              systemFlag = result.recordList;
              update();
            } else {
              if (global.currentUserId != null) {
                global.showToast(message: "System flag not found");
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getKundliList():$e');
    }
  }

  Future<void> createAstrologerShareLink() async {
    try {
      global.showOnlyLoaderDialog();
      String appShareLink;
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://astroguruupdated.page.link',
        link: Uri.parse("https://astroguruupdated.page.link/userProfile?screen=astrologerShare"),
        // ignore: prefer_const_constructors
        androidParameters: AndroidParameters(
          packageName: 'com.example.astrologer_app',
          minimumVersion: 1,
        ),
      );
      Uri url;
      final ShortDynamicLink shortLink = await dynamicLinks.buildShortLink(parameters, shortLinkType: ShortDynamicLinkType.short);
      url = shortLink.shortUrl;
      appShareLink = url.toString();
      appShareLinkForLiveSreaming = appShareLink;
      update();
      global.hideLoader();
      await FlutterShare.share(
        title: 'Hey! I am using ${global.getSystemFlagValue(global.systemFlagNameList.appName)} to get predictions related to marriage/career. I would recommend you to connect with ${global.getSystemFlagValue(global.systemFlagNameList.appName)}.',
        text: 'Hey! I am using ${global.getSystemFlagValue(global.systemFlagNameList.appName)} to get predictions related to marriage/career. I would recommend you to connect with ${global.getSystemFlagValue(global.systemFlagNameList.appName)}.',
        linkUrl: '$appShareLinkForLiveSreaming',
      );
    } catch (e) {
      print("Exception - global.dart - referAndEarn():$e");
    }
  }
}
