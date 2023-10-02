// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'package:astrologer_app/models/call_model.dart';
import 'package:astrologer_app/services/apiHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import '../../models/intake_model.dart';
import '../../views/HomeScreen/call/accept_call_screen.dart';

class CallController extends GetxController {
  String screen = 'call_controller.dart';
  APIHelper apiHelper = APIHelper();
  List<CallModel> callList = [];
  var intakeData = <IntakeModel>[];

  ScrollController scrollController = ScrollController();
  int fetchRecord = 5;
  int startIndex = 0;
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isMoreDataAvailable = false;
  bool isRejectCall = false;

  @override
  // ignore: unnecessary_overrides
  void onInit() async {
    super.onInit();
  }

//Get a call list
  Future getCallList(bool isLazyLoading) async {
    try {
      startIndex = 0;
      if (callList.isNotEmpty) {
        startIndex = callList.length;
      }
      if (!isLazyLoading) {
        isDataLoaded = false;
      }
      await global.checkBody().then(
        (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            int id = global.user.id ?? 0;
            await apiHelper.getCallRequest(id, startIndex, fetchRecord).then(
              (result) {
                global.hideLoader();
                if (result.status == "200") {
                  callList.addAll(result.recordList);
                  print('call list length ${callList.length} ');
                  if (result.recordList.length == 0) {
                    isMoreDataAvailable = false;
                    isAllDataLoaded = true;
                  }
                  update();
                } else {
                  global.showToast(message: "No call list is here");
                }
                update();
              },
            );
          }
        },
      );
    } catch (e) {
      print('Exception: $screen - getCallList(): ' + e.toString());
    }
  }

  acceptCallRequest(int callId, String profile, String name, int id, String fcmToken) async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            await apiHelper.acceptCallRequest(callId).then(
              (result) async {
                if (result.status == "200") {
                  global.hideLoader();
                  isRejectCall = false;
                  update();
                  Get.to(() => AcceptCallScreen(
                        name: name,
                        profile: profile,
                        id: id,
                        callId: callId,
                        fcmToken: fcmToken,
                      ));
                  callList.clear();
                  isAllDataLoaded = false;
                  update();
                  await getCallList(false);
                } else {
                  global.showToast(message: "accept request${result.status}");
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - acceptCallRequest(): ' + e.toString());
    }
  }

  sendCallToken(String token, String channelName, int callId) async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            await apiHelper.addCallToken(token, channelName, callId).then(
              (result) {
                if (result.status == "200") {
                  //callList = result.recordList;
                  print('call token sent :- $token');
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
      print('Exception: $screen - sendCallToken(): ' + e.toString());
    }
  }

  rejectCallRequest(int callId) async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            await apiHelper.rejectCallRequest(callId).then(
              (result) async {
                if (result.status == "200") {
                  global.showToast(message: "Reject call request Successfully");
                  callList.clear();
                  isAllDataLoaded = false;
                  update();
                  await getCallList(false);
                  Get.back();
                } else {
                  global.showToast(message: "Reject Request failed please try again later!");
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - rejectCallRequest(): ' + e.toString());
    }
  }

  Future<dynamic> getRtcToken(String appId, String appCertificate, String chatId, String channelName) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.generateRtcToken(appId, appCertificate, chatId, channelName).then((result) {
            if (result.status == "200") {
              global.agoraToken = result.recordList['rtcToken'];
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

  getFormIntakeData(int userId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getIntakedata(userId).then((result) {
            if (result.status == "200") {
              intakeData = result.recordList;
              if (intakeData.isNotEmpty) {}
              update();
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: 'Fail to get get Intake data',
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getFormIntakeData():' + e.toString());
    }
  }

  rejectDialog() {
    showDialog(
        context: Get.context!,
        // barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            content: SizedBox(
              height: 150,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: const Text(
                      "Call Rejected!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ).translate(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: const Text(
                      "The call was declined/cancelled by the user. Please decline the call.",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                      textAlign: TextAlign.center,
                    ).translate(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: const Text(
                            "Ok",
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ).translate(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actionsPadding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
          );
        });
  }
}
