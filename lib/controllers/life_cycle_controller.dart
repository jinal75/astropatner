// ignore_for_file: avoid_print

import 'package:astrologer_app/controllers/HomeController/call_controller.dart';
import 'package:astrologer_app/controllers/HomeController/chat_controller.dart';
import 'package:astrologer_app/controllers/HomeController/report_controller.dart';
import 'package:get/get.dart';

class HomeCheckController extends FullLifeCycleController with FullLifeCycleMixin {
  // Mandatory
  ChatController chatController = Get.find<ChatController>();
  CallController callController = Get.find<CallController>();
  ReportController reportController = Get.find<ReportController>();
  @override
  void onDetached() {
    print('HomeController - onDetached called');
  }

  // Mandatory
  @override
  void onInactive() async {
    print('Hello');
    print('HomeController - onInative called');
  }

  // Mandatory
  @override
  void onPaused() {
    print('HomeController - onPaused called');
  }

  // Mandatory
  @override
  void onResumed() async {
    chatController.chatList = [];
    callController.callList = [];
    reportController.reportList = [];
    await chatController.getChatList(false);
    await callController.getCallList(false);
    await reportController.getReportList(false);
    print("App Is Release");
  }

  @override
  Future<bool> didPushRoute(String route) {
    print('HomeController - the route $route will be open');
    return super.didPushRoute(route);
  }

  // Optional
  @override
  Future<bool> didPopRoute() {
    print('HomeController - the current route will be closed');
    return super.didPopRoute();
  }

  // Optional
  @override
  void didChangeMetrics() {
    print('HomeController - the window size did change');
    super.didChangeMetrics();
  }

  // Optional
  @override
  void didChangePlatformBrightness() {
    print('HomeController - platform change ThemeMode');
    super.didChangePlatformBrightness();
  }
}
