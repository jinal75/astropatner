// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'package:astrologer_app/models/following_model.dart';
import 'package:astrologer_app/services/apiHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;

class FollowingController extends GetxController {
  String screen = 'following_controller.dart';
  APIHelper apiHelper = APIHelper();
  List<FollowingModel> followerList = [];

  ScrollController scrollController = ScrollController();
  int fetchRecord = 20;
  int startIndex = 0;
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isMoreDataAvailable = false;

  //get following list
  Future followingList(bool isLazyLoading) async {
    try {
      startIndex = 0;
      if (followerList.isNotEmpty) {
        startIndex = followerList.length;
      }
      if (!isLazyLoading) {
        isDataLoaded = false;
      }
      await global.checkBody().then(
        (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            int id = global.user.id ?? 0;
            await apiHelper.getFollowersList(id, startIndex, fetchRecord).then(
              (result) {
                global.hideLoader();
                if (result.status == "200") {
                  followerList.addAll(result.recordList);
                  print('following list length ${followerList.length} ');
                  if (result.recordList.length == 0) {
                    isMoreDataAvailable = false;
                    isAllDataLoaded = true;
                  }
                  update();
                } else {
                  global.showToast(message: "No following list is here");
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - followingList():-' + e.toString());
    }
  }
}
