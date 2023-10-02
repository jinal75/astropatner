// ignore_for_file: must_be_immutable, avoid_print

import 'dart:convert';

import 'package:astrologer_app/controllers/Authentication/signup_controller.dart';
import 'package:astrologer_app/controllers/HomeController/call_controller.dart';
import 'package:astrologer_app/controllers/HomeController/chat_controller.dart';
import 'package:astrologer_app/controllers/HomeController/home_controller.dart';
import 'package:astrologer_app/controllers/HomeController/live_astrologer_controller.dart';
import 'package:astrologer_app/controllers/HomeController/report_controller.dart';
import 'package:astrologer_app/controllers/HomeController/timer_controller.dart';
import 'package:astrologer_app/controllers/HomeController/wallet_controller.dart';
import 'package:astrologer_app/controllers/splashController.dart';
import 'package:astrologer_app/firebase_options.dart';
import 'package:astrologer_app/theme/nativeTheme.dart';
import 'package:astrologer_app/theme/themeService.dart';
import 'package:astrologer_app/utils/binding/networkBinding.dart';
import 'package:astrologer_app/views/HomeScreen/Drawer/Wallet/Wallet_screen.dart';
import 'package:astrologer_app/views/HomeScreen/home_screen.dart';
import 'package:astrologer_app/views/splash/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_translator/google_translator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astrologer_app/utils/global.dart' as global;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print(settings);

  runApp(MyApp());
}

FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  LiveAstrologerController liveAstrologerController = Get.put(LiveAstrologerController());
  CallController callController = Get.put(CallController());
  ChatController chatController = Get.put(ChatController());
  ReportController reportController = Get.put(ReportController());
  WalletController walletController = Get.put(WalletController());
  print('_firebaseMessagingBackgroundHandler called..');
  global.sp = await SharedPreferences.getInstance();
  if (global.sp!.getString("currentUser") != null) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    if (message.notification!.title == "For Live Streaming Chat") {
      print('_firebaseMessagingBackgroundHandler For Live Streaming Chat');
      Future.delayed(const Duration(milliseconds: 500)).then((value) async {
        await _localNotifications.cancelAll();
      });
      String sessionType = message.data["sessionType"];
      if (sessionType == "start") {
        String? liveChatUserName2 = message.data['liveChatSUserName'];
        if (liveChatUserName2 != null) {
          liveAstrologerController.liveChatUserName = liveChatUserName2;
          liveAstrologerController.update();
        }
        String chatId = message.data["chatId"];
        liveAstrologerController.isUserJoinAsChat = true;
        liveAstrologerController.update();
        liveAstrologerController.chatId = chatId;
        int waitListId = int.parse(message.data["waitListId"].toString());
        String time = liveAstrologerController.waitList.where((element) => element.id == waitListId).first.time;
        liveAstrologerController.endTime = DateTime.now().millisecondsSinceEpoch + 1000 * int.parse(time.toString());
        liveAstrologerController.update();
      } else {
        if (liveAstrologerController.isOpenPersonalChatDialog) {
          Get.back(); //if chat dialog opended
          liveAstrologerController.isOpenPersonalChatDialog = false;
        }
        liveAstrologerController.isUserJoinAsChat = false;
        liveAstrologerController.chatId = null;
        liveAstrologerController.update();
      }
    } else if (message.notification!.title == "For timer and session start for live") {
      Future.delayed(const Duration(milliseconds: 500)).then((value) async {
        await _localNotifications.cancelAll();
      });
      int waitListId = int.parse(message.data["waitListId"].toString());
      liveAstrologerController.joinedUserName = message.data["name"] ?? "User";
      liveAstrologerController.joinedUserProfile = message.data["profile"] ?? "";
      String time = liveAstrologerController.waitList.where((element) => element.id == waitListId).first.time;
      liveAstrologerController.endTime = DateTime.now().millisecondsSinceEpoch + 1000 * int.parse(time.toString());
      liveAstrologerController.update();
    } else if (message.notification!.title == "Start simple chat timer") {
      Future.delayed(const Duration(milliseconds: 500)).then((value) async {
        await _localNotifications.cancelAll();
      });
      TimerController timerController = Get.put(TimerController());
      timerController.isStartTimer = true;
      timerController.endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 300;
      timerController.update();
    } else if (message.notification!.title == "End chat from customer") {
      Future.delayed(const Duration(milliseconds: 500)).then((value) async {
        await _localNotifications.cancelAll();
      });

      //if astrologer in chat screen then customer end chat at that time astrologer automatically back from chat screen
      if (chatController.isInChatScreen) {
        chatController.isInChatScreen = false;
        chatController.update();
        Get.back();
      }
    } else if (message.notification!.title == "Reject call request from astrologer") {
      Future.delayed(const Duration(milliseconds: 500)).then((value) async {
        await _localNotifications.cancelAll();
      });

      //if astrologer in call screen then customer end call at that time astrologer automatically leave the call
      print('user Rejected call request:-');
      callController.isRejectCall = true;
      callController.update();
    } else {
      try {
        if (message.data.isNotEmpty) {
          var messageData = json.decode((message.data['body']));

          print('body $messageData');
          if (messageData['notificationType'] != null) {
            if (messageData['notificationType'] == 7) {
              // get wallet api call
              await walletController.getAmountList();
            } else if (messageData['notificationType'] == 8) {
              chatController.chatList.clear();
              chatController.update();
              await chatController.getChatList(false);
            } else if (messageData['notificationType'] == 2) {
              await callController.getCallList(false);
            } else if (messageData['notificationType'] == 9) {
              reportController.reportList.clear();
              reportController.update();
              await reportController.getReportList(false);
            } else if (messageData['notificationType'] == 12 || messageData['notificationType'] == 11 || messageData['notificationType'] == 10) {
              liveAstrologerController.isUserJoinWaitList = true;
              liveAstrologerController.update();
            }
          }
        }
      } catch (e) {
        print("Exception in _firebaseMessagingBackgroundHandler else $e");
      }
    }
  } else {
    Future.delayed(const Duration(milliseconds: 500)).then((value) async {
      await _localNotifications.cancelAll();
    });
  }
}

class MyApp extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'Atroguru local notifications',
    'High Importance Notifications for Atroguru',
    importance: Importance.defaultImportance,
  );
  //HomeController homeController = Get.put(HomeController());
  Future<void> onSelectNotification(String payload) async {
    Map<dynamic, dynamic> messageData;
    try {
      messageData = json.decode(payload);
      // ignore: unused_local_variable
      Map<dynamic, dynamic> body;
      body = jsonDecode(messageData['body']);
      if (body["notificationType"] == 7) {
        await walletController.getAmountList();
        Get.to(() => WalletScreen());
      } else if (body["notificationType"] == 8) {
        Get.find<HomeController>().homeCurrentIndex = 0;
        Get.find<HomeController>().update();
        Get.to(() => HomeScreen());
      } else if (body["notificationType"] == 2) {
        callController.callList.clear();
        await callController.getCallList(false);
        Get.find<HomeController>().homeCurrentIndex = 1;
        Get.find<HomeController>().update();
        Get.to(() => HomeScreen());
      } else if (body["notificationType"] == 9) {
        reportController.reportList.clear();
        reportController.update();
        await reportController.getReportList(false);
        Get.find<HomeController>().homeCurrentIndex = 2;
        Get.find<HomeController>().update();
        Get.to(() => HomeScreen());
      } else if (body["notificationType"] == 13) {
        await walletController.getAmountList();
        Get.find<SignupController>().astrologerList = [];
        Get.find<SignupController>().update();
        await Get.find<SignupController>().astrologerProfileById(false);
        Get.find<HomeController>().homeCurrentIndex2 = 0;
        Get.find<HomeController>().isSelectedBottomIcon = 3;
        Get.find<HomeController>().historyTabController!.animateTo(0);
        Get.find<HomeController>().update();
        Get.to(() => HomeScreen());
      }
    } catch (e) {
      print(
        'Exception in onSelectNotification main.dart:- ${e.toString()}',
      );
    }
  }

  dynamic analytics;

  dynamic observer;
  LiveAstrologerController liveAstrologerController = Get.put(LiveAstrologerController());
  WalletController walletController = Get.put(WalletController());
  ChatController chatController = Get.put(ChatController());
  CallController callController = Get.put(CallController());
  TimerController timerController = Get.put(TimerController());
  ReportController reportController = Get.put(ReportController());
  Future<void> foregroundNotification(RemoteMessage payload) async {
    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      defaultPresentBadge: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
      defaultPresentSound: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        print("object notification call");
        return;
      },
    );
    AndroidInitializationSettings android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initialSetting = InitializationSettings(android: android, iOS: initializationSettingsDarwin);
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initialSetting, onDidReceiveNotificationResponse: (_) {
      onSelectNotification(json.encode(payload.data));
    });

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      importance: Importance.max,
      priority: Priority.high,
      icon: "@mipmap/ic_launcher",
      playSound: true,
    );
    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidDetails, iOS: iOSDetails);
    global.sp = await SharedPreferences.getInstance();
    if (global.sp!.getString("currentUser") != null) {
      await flutterLocalNotificationsPlugin.show(
        0,
        payload.notification!.title,
        payload.notification!.body,
        platformChannelSpecifics,
        payload: json.encode(payload.data.toString()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    //Sent Notification When App is Running || Background Message is Automatically Sent by Firebase
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification!.title == "For Live Streaming Chat") {
        String sessionType = message.data["sessionType"];
        if (sessionType == "start") {
          String? liveChatUserName2 = message.data['liveChatSUserName'];
          if (liveChatUserName2 != null) {
            liveAstrologerController.liveChatUserName = liveChatUserName2;
            liveAstrologerController.update();
          }
          String chatId = message.data["chatId"];
          liveAstrologerController.isUserJoinAsChat = true;
          liveAstrologerController.update();
          liveAstrologerController.chatId = chatId;
          int waitListId = int.parse(message.data["waitListId"].toString());
          String time = liveAstrologerController.waitList.where((element) => element.id == waitListId).first.time;
          liveAstrologerController.endTime = DateTime.now().millisecondsSinceEpoch + 1000 * int.parse(time.toString());
          liveAstrologerController.update();
        } else {
          if (liveAstrologerController.isOpenPersonalChatDialog) {
            Get.back(); //if chat dialog opended
            liveAstrologerController.isOpenPersonalChatDialog = false;
          }
          liveAstrologerController.isUserJoinAsChat = false;
          liveAstrologerController.chatId = null;
          liveAstrologerController.update();
        }
      } else if (message.notification!.title == "For timer and session start for live") {
        int waitListId = int.parse(message.data["waitListId"].toString());
        liveAstrologerController.joinedUserName = message.data["name"] ?? "User";
        liveAstrologerController.joinedUserProfile = message.data["profile"] ?? "";
        String time = liveAstrologerController.waitList.where((element) => element.id == waitListId).first.time;
        liveAstrologerController.endTime = DateTime.now().millisecondsSinceEpoch + 1000 * int.parse(time.toString());
        liveAstrologerController.update();
      } else if (message.notification!.title == "Start simple chat timer") {
        timerController.isStartTimer = true;
        timerController.endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 300;
        timerController.update();
      } else if (message.notification!.title == "End chat from customer") {
        //if astrologer in chat screen then customer end chat at that time astrologer automatically back from chat screen
        if (chatController.isInChatScreen) {
          chatController.isInChatScreen = false;
          chatController.update();
          Get.back();
        }
      } else if (message.notification!.title == "Reject call request from astrologer") {
        //if astrologer in call screen then customer end call at that time astrologer automatically leave the call
        print('user Rejected call request:-');
        callController.isRejectCall = true;
        callController.update();
        callController.rejectDialog();
      } else {
        try {
          if (message.data.isNotEmpty) {
            var messageData = json.decode((message.data['body']));

            print('body $messageData');
            if (messageData['notificationType'] != null) {
              if (messageData['notificationType'] == 7) {
                // get wallet api call
                await walletController.getAmountList();
                foregroundNotification(message);
                await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
              } else if (messageData['notificationType'] == 8) {
                chatController.chatList.clear();
                chatController.update();
                await chatController.getChatList(false);
                foregroundNotification(message);
                await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
              } else if (messageData['notificationType'] == 2) {
                await callController.getCallList(false);
                foregroundNotification(message);
                await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
              } else if (messageData['notificationType'] == 9) {
                reportController.reportList.clear();
                reportController.update();
                await reportController.getReportList(false);
                foregroundNotification(message);
                await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
              } else if (messageData['notificationType'] == 12 || messageData['notificationType'] == 11 || messageData['notificationType'] == 10) {
                liveAstrologerController.isUserJoinWaitList = true;
                liveAstrologerController.update();
                foregroundNotification(message);
                await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
              } else {
                foregroundNotification(message);
                await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
              }

              foregroundNotification(message);
              await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
            } else {
              foregroundNotification(message);
              await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
            }
          } else {
            foregroundNotification(message);
            await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
          }
        } catch (e) {
          foregroundNotification(message);
          await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
        }
      }
    });
    //Perform On Tap Operation On Notification Click when app is in backgroud Or in Kill Mode
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onSelectNotification(json.encode(message.data));
    });
  }

  final String apiKey = "AIzaSyDwps2hHZbsri0yg4NPUYdQoj5BOsZmWK0";
  SplashController splashController = Get.put(SplashController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (s) {
      return GoogleTranslatorInit(apiKey, translateFrom: Locale(splashController.currentLanguageCode == 'en' ? 'hi' : 'en'), translateTo: Locale(splashController.currentLanguageCode), automaticDetection: true, builder: () {
        return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: Get.key,
            enableLog: true,
            theme: Themes.light,
            darkTheme: Themes.dark,
            themeMode: ThemeService().theme,
            locale: Get.deviceLocale,
            initialBinding: NetworkBinding(),
            title: 'astromtpatner',
            initialRoute: "SplashScreen",
            home: SplashScreen(
              a: analytics,
              o: observer,
            ));
      });
    });
  }
}
