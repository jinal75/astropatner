// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'package:astrologer_app/models/Notification/notification_model.dart';
import 'package:astrologer_app/services/apiHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;

class NotificationController extends GetxController {
  String screen = 'notification_controller.dart';
  APIHelper apiHelper = APIHelper();

  List<NotificationModel> notificationList = [];

  ScrollController scrollController = ScrollController();
  int fetchRecord = 20;
  int startIndex = 0;
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isMoreDataAvailable = false;

  @override
  onInit() {
    init();
    super.onInit();
  }

  init() async {
    paginateTask();
  }

  void paginateTask() {
    scrollController.addListener(() async {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isAllDataLoaded) {
        isMoreDataAvailable = true;
        print('scroll my following');
        update();
        await getNotificationList(true);
      }
    });
  }

//Get a notification
  Future getNotificationList(bool isLazyLoading) async {
    try {
      startIndex = 0;
      if (notificationList.isNotEmpty) {
        startIndex = notificationList.length;
      }
      if (!isLazyLoading) {
        isDataLoaded = false;
      }
      await global.checkBody().then(
        (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            await apiHelper.getNotification(startIndex, fetchRecord).then(
              (result) {
                global.hideLoader();
                if (result.status == "200") {
                  notificationList.addAll(result.recordList);
                  print('Notification list length ${notificationList.length} ');
                  if (result.recordList.length == 0) {
                    isMoreDataAvailable = false;
                    isAllDataLoaded = true;
                  }
                  update();
                } else {
                  global.showToast(message: result.message.toString());
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - getNotificationList():-' + e.toString());
    }
  }

  Future deleteNotification(int notificationId) async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            await apiHelper.deleteNotification(notificationId).then(
              (result) {
                global.hideLoader();
                if (result.status == "200") {
                  global.showToast(message: "Notification deleted successfully");
                  notificationList.clear();
                  getNotificationList(false);
                } else {
                  global.showToast(message: result.message.toString());
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - deleteNotification():-' + e.toString());
    }
  }

  Future deleteAllNotification() async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            await apiHelper.deleteAllNotification(global.user.userId!).then(
              (result) {
                global.hideLoader();
                if (result.status == "200") {
                  global.showToast(message: "Notifications deleted successfully");
                  notificationList.clear();
                  getNotificationList(false);
                } else {
                  global.showToast(message: result.message.toString());
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - deleteAllNotification():-' + e.toString());
    }
  }
}
