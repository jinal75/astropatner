// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, unused_local_variable, prefer_typing_uninitialized_variables, unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:astrologer_app/controllers/networkController.dart';
import 'package:astrologer_app/controllers/splashController.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/all_skill_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/assistant/assistant_all_skill_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/assistant/assistant_language_list_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/assistant/assistant_primary_skill_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/astrologer_category_list_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/get_master_table_list_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/highest_qualification_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/language_list_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/main_source_business_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/primary_skill_model.dart';
import 'package:astrologer_app/models/hororScopeSignModel.dart';
import 'package:astrologer_app/models/systemFlagNameList.dart';
import 'package:astrologer_app/models/user_model.dart';
import 'package:astrologer_app/services/apiHelper.dart';
import 'package:astrologer_app/views/Authentication/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_translator/google_translator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

//----------------------------------------------Variable--------------------------------------

//Getx Controller
NetworkController networkController = Get.put(NetworkController());

//Shared PReffrence
SharedPreferences? sp;
SharedPreferences? spLanguage;

//Model
CurrentUser user = CurrentUser();
GetMasterTableDataModel getMasterTableDataModelList = GetMasterTableDataModel();
SplashController splashController = Get.find<SplashController>();

//Model List
final List<String> genderList = <String>["Male", "Female", "Other"];
List<AstrolgoerCategoryModel>? astrologerCategoryModelList = [];
List<PrimarySkillModel>? skillModelList = [];
List<AllSkillModel>? allSkillModelList = [];
// List<SystemFlag>? systemFlagList;

List<LanguageModel>? languageModelList = [];
List<AssistantPrimarySkillModel>? assistantPrimarySkillModelList = [];
List<AssistantAllSkillModel>? assistantAllSkillModelList = [];
List<AssistantLanguageModel>? assistantLanguageModelList = [];
List<MainSourceBusinessModel>? mainSourceBusinessModelList = [];
bool isUserJoinAsChatInLive = false;
List<HighestQualificationModel>? highestQualificationModelList = [];
List<CountryTravel>? degreeDiplomaList = [];
List<CountryTravel>? jobWorkingList = [];
FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
APIHelper apiHelper = APIHelper();
List<HororscopeSignModel> hororscopeSignList = [];
final List foreignCountryCountList = <String>["0", "1-2", "3-5", "6+"];
final translator = GoogleTranslator();

abstract class DateFormatter {
  static String? formatDate(DateTime timestamp) {
    if (timestamp == null) {
      return null;
    }
    String date = "${timestamp.day} ${DateFormat('MMMM').format(timestamp)} ${timestamp.year}";
    return date;
  }

  static dynamic fromDateTimeToJson(DateTime date) {
    if (date == null) return null;

    return date.toUtc();
  }

  static DateTime? toDateTime(Timestamp value) {
    if (value == null) return null;

    return value.toDate();
  }
}

//Other Variable
Map<int, Color> color = {
  50: const Color.fromRGBO(240, 223, 32, .1),
  100: const Color.fromRGBO(240, 223, 32, .2),
  200: const Color.fromRGBO(240, 223, 32, .3),
  300: const Color.fromRGBO(240, 223, 32, .4),
  400: const Color.fromRGBO(240, 223, 32, .5),
  500: const Color.fromRGBO(240, 223, 32, .6),
  600: const Color.fromRGBO(240, 223, 32, .7),
  700: const Color.fromRGBO(240, 223, 32, .8),
  800: const Color.fromRGBO(240, 223, 32, .9),
  900: const Color.fromRGBO(240, 223, 32, 1),
};

String getSystemFlagValue(String flag) {
  return splashController.systemFlag.firstWhere((e) => e.name == flag).value;
}

Future<void> share() async {
  await FlutterShare.share(
    title: '1 item',
    text: '1 item',
    chooserTitle: '1 item',
  );
}

//Base url for api
String imgBaseurl = "https://astromt.lttrbxtech.com/";
String pdfBaseurl = "https://astromt.lttrbxtech.com/";
String appMode = "LIVE";
String webBaseUrl = "https://astromt.lttrbxtech.com/";

Map<String, dynamic> appParameters = {
  "LIVE": {
    "apiUrl": "https://astromt.lttrbxtech.com/api/",
  },
  "DEV": {
    "apiUrl": "https://astromt.lttrbxtech.com/api/",
  }
};

//Application Id
String appId = Platform.isAndroid ? "AstroGuruAndroid" : "AstroGuruIos";
AndroidDeviceInfo? androidInfo;
IosDeviceInfo? iosInfo;
DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
String? deviceId;
String? fcmToken;
String? deviceLocation;
String? deviceManufacturer;
String? deviceModel;
var appVersion;
int? currentUserId;

String agoraAppId = "832f8b58443247a2b8b74677198bbc82";
String agoraAppCertificate = "36a8fdae33b447e8a928e108a7f36bd9";
String agoraChannelName = "";
String agoraToken = "";
String agoraLiveToken = "";
String channelName = "astroGuruCall";
String agoraLiveChannelName = "";
String liveChannelName = "astroGuruLive";
String agoraChatToken = "";
String agoraChatUserId = "chatAstrologer";
String chatChannelName = "astroGuruChat";
String encodedString = "&&";
String appName = "";
var nativeAndroidPlatform = const MethodChannel('nativeAndroid');
SystemFlagNameList systemFlagNameList = SystemFlagNameList();

//Get app version
String getAppVersion() {
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    appVersion = packageInfo.version;
  });
  return appVersion;
}

//Get device info
getDeviceData() async {
  await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    appVersion = packageInfo.version;
  });
  if (Platform.isAndroid) {
    androidInfo ??= await deviceInfo.androidInfo;
    deviceModel = androidInfo!.model;
    deviceManufacturer = androidInfo!.manufacturer;
    deviceId = androidInfo!.id;
    fcmToken = await FirebaseMessaging.instance.getToken();
  } else if (Platform.isIOS) {
    iosInfo ??= await deviceInfo.iosInfo;
    deviceModel = iosInfo!.model;
    deviceManufacturer = "Apple";
    deviceId = iosInfo!.identifierForVendor;
    fcmToken = await FirebaseMessaging.instance.getToken();
  }
}

Future<bool> callOnFcmApiSendPushNotifications({List<String?>? fcmTokem, String? title, String? subTitle, sendData}) async {
  try {
    String postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "registration_ids": fcmTokem,
      "notification": {
        "title": title,
        "body": subTitle,
        "sound": "default",
        "color": "#ff3296fa",
        "vibrate": "300",
        "priority": 'high',
      },
      "android": {
        "priority": 'high',
        "notification": {
          " sound": 'default',
          "color": '#ff3296fa',
          "clickAction": 'FLUTTER_NOTIFICATION_CLICK',
          "notificationType": '52',
        },
      },
      "data": sendData
    };
    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=AAAAmwRvEy0:APA91bE_lDUJ8Llz9Y9QsWxp2pITgnjwNOeZ84U-GeWrCu99xT_SCXinqrCWMObYQiaMBMwtu9bMHdZhyD1G0g2HKgl_KEJqQpPzdcyfudZD-QERgFWaVDAMj3THPn1EOrMy2mDIXBTU' // 'key=YOUR_SERVER_KEY'
    };
    final response = await http.post(Uri.parse(postUrl), body: json.encode(data), encoding: Encoding.getByName('utf-8'), headers: headers);
    if (response.statusCode == 200) {
      // on success do sth
      print('Send');
      return true;
    } else {
      print('Error');
      // on failure do sth
      return false;
    }
  } catch (e) {
    print("Exception -  global.dart - callOnFcmApiSendPushNotifications(): ${e.toString()}");
    return false;
  }
}

//Shared prefrences
//save current user
CurrentUser? astroUser;
saveCurrentUser(CurrentUser user) async {
  try {
    sp = await SharedPreferences.getInstance();
    await sp!.setString('currentUser', json.encode(user.toJson()));
    print("sucess");
  } catch (e) {
    print("Exception - gloabl.dart - saveCurrentUser():" + e.toString());
  }
}

//logout
logoutUser() async {
  sp = await SharedPreferences.getInstance();
  sp!.remove("currentUser");
  log("current user logout:- ${sp!.getString('currentUserId')}");
  currentUserId = null;
  splashController.currentUser = null;
  user = CurrentUser();
  Get.off(() => LoginScreen());
}

//get current user
Future<int> getCurrentUser() async {
  sp = await SharedPreferences.getInstance();
  CurrentUser userData = CurrentUser.fromJson(json.decode(sp!.getString("currentUser") ?? ""));
  int id = userData.id ?? 0;
  return id;
}

//Get data of current user id
getCurrentUserId() async {
  sp = await SharedPreferences.getInstance();
  CurrentUser userData = CurrentUser.fromJson(json.decode(sp!.getString("currentUser") ?? ""));
  currentUserId = userData.id;
}

//check login
Future<bool> isLogin() async {
  sp = await SharedPreferences.getInstance();
  if (sp!.getString("token") == null && sp!.getInt("currentUserId") == null) {
    Get.to(() => LoginScreen());
    return false;
  } else {
    return true;
  }
}

//Device Details
String appId2 = Platform.isAndroid ? "2" : "2";
String reviewAppId = "2";
//-------------------------------------------Functions--------------------------------------

//Api Header
Future<Map<String, String>> getApiHeaders(bool authorizationRequired) async {
  try {
    // ignore: prefer_collection_literals
    Map<String, String> apiHeader = Map<String, String>();
    Map<String, dynamic> deviceData = {};

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceData = {
        "deviceModel": androidInfo.model,
        "deviceManufacturer": androidInfo.manufacturer,
        "deviceId": androidInfo.id,
        "fcmToken": await FirebaseMessaging.instance.getToken(),
        "deviceLocation": null,
      };
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceData = {
        "deviceModel": iosInfo.model,
        "deviceManufacturer": "Apple",
        "deviceId": iosInfo.identifierForVendor,
        "fcmToken": await FirebaseMessaging.instance.getToken(),
        "deviceLocation": null,
      };
    }

    if (authorizationRequired) {
      sp = await SharedPreferences.getInstance();
      if (sp!.getString("currentUser") != null) {
        String? tokenType;
        String? token;
        if (sp!.getString('currentUser') != null) {
          CurrentUser userData = CurrentUser.fromJson(json.decode(sp!.getString("currentUser") ?? ""));
          tokenType = userData.tokenType;
          token = userData.token;
        }
        apiHeader.addAll({"Authorization": " $tokenType $token"});
      } else {
        apiHeader.addAll({"Authorization": appId});
      }
    } else {
      apiHeader.addAll({"Authorization": appId});
    }

    apiHeader.addAll({"Content-Type": "application/json"});
    apiHeader.addAll({"Accept": "application/json"});
    apiHeader.addAll({"DeviceInfo": json.encode(deviceData)});
    log('$apiHeader');
    return apiHeader;
  } catch (err) {
    print("Exception: global.dart : getApiHeaders" + err.toString());
    return {};
  }
}

createAndShareLinkForDailyHorscope(ScreenshotController sc) async {
  showOnlyLoaderDialog();
  String appShareLink;
  String applink;
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://astroguruupdated.page.link',
    link: Uri.parse("https://astroguruupdated.page.link/userProfile?screen=dailyHorscope"),
    androidParameters: const AndroidParameters(
      packageName: 'com.example.astrologer_app',
      minimumVersion: 1,
    ),
  );
  Uri url;
  final ShortDynamicLink shortLink = await dynamicLinks.buildShortLink(parameters, shortLinkType: ShortDynamicLinkType.short);
  url = shortLink.shortUrl;
  appShareLink = url.toString();
  applink = appShareLink;
  hideLoader();
  final directory = (await getApplicationDocumentsDirectory()).path;
  sc.capture().then((Uint8List? image) async {
    if (image != null) {
      try {
        String fileName = DateTime.now().microsecondsSinceEpoch.toString();
        final imagePath = await File('$directory/$fileName.png').create();
        if (imagePath != null) {
          final temp = await getExternalStorageDirectory();
          final path = '${temp!.path}/$fileName.jpg';
          File(path).writeAsBytesSync(image);
          await FlutterShare.shareFile(filePath: path, title: getSystemFlagValue(systemFlagNameList.appName), text: "Check out your free daily horoscope on ${getSystemFlagValue(systemFlagNameList.appName)} & plan your day batter $appShareLink").then((value) {}).catchError((e) {
            print(e);
          });
        }
      } catch (error) {
        print('$error');
      }
    }
  }).catchError((onError) {
    print('Error --->> $onError');
  });
}

showToast({required String message}) async {
  var translation = await GoogleTranslator().translate(message, to: splashController.currentLanguageCode);
  return Fluttertoast.showToast(
    msg: translation.text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black.withOpacity(0.8),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

Future<Widget> showHtml({required String html, Map<String, Style>? style}) async {
  try {
    var translation = await translator.translate(html, to: splashController.currentLanguageCode);
    return Html(
      data: translation.text,
      style: style ?? {},
    );
  } catch (e) {
    return Html(
      data: html,
      style: style ?? {},
    );
  }
}

Future<String> translatedText(String text) async {
  var textTranslation = await translator.translate(text, to: splashController.currentLanguageCode);
  return textTranslation.text;
}

showOnlyLoaderDialog() {
  return showDialog(
    context: Get.context!,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Center(child: CircularProgressIndicator()),
      );
    },
  );
}

void hideLoader() {
  Get.back();
}

//For Network controller
Future<bool> checkBody() async {
  bool result;
  try {
    await networkController.initConnectivity();
    if (networkController.connectionStatus.value != 0) {
      result = true;
    } else {
      Get.snackbar(
        "Warning",
        "No Internet Connection",
        snackPosition: SnackPosition.BOTTOM,
        messageText: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.signal_wifi_off,
              color: Colors.white,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                ),
                child: const Text(
                  "No Internet Available",
                  textAlign: TextAlign.start,
                ).translate(),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (networkController.connectionStatus.value != 0) {
                  Get.back();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(color: Colors.white),
                height: 30,
                width: 55,
                child: Center(
                  child: Text(
                    "Retry",
                    style: TextStyle(color: Theme.of(Get.context!).primaryColor),
                  ).translate(),
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(days: 1),
        backgroundColor: Theme.of(Get.context!).primaryColor,
        colorText: Colors.white,
      );
      result = false;
    }

    return result;
  } catch (e) {
    print("Exception - checkBodyController - checkBody():" + e.toString());
    return false;
  }
}

printException(String className, String functionName, dynamic err) {
  print("Exception: $className: - $functionName(): $err");
}

Future exitAppDialog() async {
  try {
    showCupertinoDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return Theme(
            data: ThemeData(dialogBackgroundColor: Colors.white),
            child: CupertinoAlertDialog(
              title: const Text(
                'Exit App',
              ).translate(),
              content: const Text(
                'Are you sure you want to exit app?',
              ).translate(),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ).translate(),
                  onPressed: () {
                    // Dismiss the dialog but don't
                    // dismiss the swiped item
                    return Navigator.of(context).pop(false);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text(
                    'Exit',
                  ).translate(),
                  onPressed: () async {
                    exit(0);
                  },
                ),
              ],
            ),
          );
        });
  } catch (e) {
    print('Exception - gloabl.dart - exitAppDialog(): ${e.toString()}');
  }
}
