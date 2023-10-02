// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:astrologer_app/services/apiHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/live_users_model.dart';
import '../../models/user_model.dart';
import '../../models/wait_list_model.dart';

class LiveAstrologerController extends GetxController {
  APIHelper apiHelper = APIHelper();
  bool isUserJoinAsChat = false;
  List<WaitList> waitList = [];
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 180;
  String? liveChatUserName;
  bool isOpenPersonalChatDialog = false;
  String? chatId;
  bool isChatDetailLoaded = false;
  bool isImInLive = false;
  String joinedUserProfile = "";
  String joinedUserName = "User";
  bool isUserJoinWaitList = false;
  Stream<QuerySnapshot<Map<String, dynamic>>>? getChatMessages(String idUser, int globalId) {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> data = FirebaseFirestore.instance.collection('chats2/$idUser/userschat').doc(globalId.toString()).collection('messages').orderBy("updatedAt", descending: true).snapshots();
      return data;
    } catch (err) {
      print("Exception - apiHelper.dart - getChatMessages()$err");
      return null;
    }
  }

  sendLiveToken(
    int id,
    String channelName,
    String token,
    String chatToken,
  ) async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            await apiHelper.sendLiveAstrologerToken(id, channelName, token, chatToken).then(
              (result) {
                if (result.status == "200") {
                  print('live token sent :- $token');
                } else {
                  global.showToast(message: "accept Request ");
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - sendCallToken(): $e');
    }
  }

  Future<dynamic> getWaitList(String channel) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.showOnlyLoaderDialog();
          await apiHelper.getWaitList(channel).then((result) {
            global.hideLoader();
            if (result.status == "200") {
              waitList = result.recordList;
              update();
            } else {
              global.showToast(message: "${result.message}");
            }
            for (var i = 0; i < waitList.length; i++) {
              if (waitList[i].time != "") {
                waitList[i].endTime = DateTime.now().millisecondsSinceEpoch + 1000 * int.parse(waitList[i].time);
              }
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getAstrologerList :-$e");
    }
  }

  sendLiveChatToken(int id, String channelName, String token) async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            await apiHelper.sendLiveAstrologerChatToken(id, channelName, token).then(
              (result) {
                if (result.status == "200") {
                  print('live token sent :- $token');
                } else {
                  global.showToast(message: "accept Request ");
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - sendCallToken(): $e');
    }
  }

  endLiveSession(bool isFromdispose) async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            global.sp = await SharedPreferences.getInstance();
            CurrentUser userData = CurrentUser.fromJson(json.decode(global.sp!.getString("currentUser") ?? ""));
            int id = userData.id ?? 0;
            await apiHelper.endLiveSession(id).then(
              (result) {
                if (result.status == "200") {
                  if (!isFromdispose) {
                    global.showToast(message: 'Live session end!');
                  }
                } else {
                  global.showToast(message: "There are some problem to fetching data on server!");
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - sendCallToken(): $e');
    }
  }

  //live users

  var liveUsers = <LiveUserModel>[];
  Future<dynamic> getLiveuserData(String channel) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getLiveUsers(channel).then((result) {
            if (result.status == "200") {
              liveUsers = result.recordList;
              update();
              print('Live user length ${liveUsers.length}');
            } else {
              global.showToast(message: '${result.status} failed to get live users');
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getLiveuserData :-$e");
    }
  }

  Future<void> onlineOfflineUser() async {
    for (int i = 0; i < waitList.length; i++) {
      for (int j = 0; j < liveUsers.length; j++) {
        if (waitList[i].userId == liveUsers[j].userId) {
          waitList[i].isOnline = true;
          update();
        }
      }
    }
  }

  Future<dynamic> getRtmToken(String appId, String appCertificate, String chatId, String channelName) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.generateRtmToken(appId, appCertificate, chatId, channelName).then((result) {
            if (result.status == "200") {
              global.agoraChatToken = result.recordList['rtmToken'];
            } else {
              global.showToast(message: '${result.status} failed to get live RTM Token');
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getRtmToken :-$e");
    }
  }

  Future<dynamic> getRtcToken(String appId, String appCertificate, String chatId, String channelName) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.generateRtcToken(appId, appCertificate, chatId, channelName).then((result) {
            if (result.status == "200") {
              global.agoraLiveToken = result.recordList['rtcToken'];
            } else {
              global.showToast(message: '${result.status} failed to get live RTC Token');
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getRtcToken :-$e");
    }
  }
}
