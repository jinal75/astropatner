// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:astrologer_app/controllers/HomeController/live_astrologer_controller.dart';
import 'package:astrologer_app/models/message_model_live.dart';
import 'package:astrologer_app/services/apiHelper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/messageConst.dart';
import '../../../controllers/HomeController/home_controller.dart';
import '../../../models/message_model.dart';
import '../../../models/user_model.dart';
import '../../../utils/global.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  int uid = 0; // current user id
  int? remoteUid;
  late RtcEngine agoraEngine; // Agora engine instance
  bool isJoined = false;
  HomeController homeController = Get.find<HomeController>();
  APIHelper apiHelper = APIHelper();
  LiveAstrologerController liveAstrologerController = Get.find<LiveAstrologerController>();
  String chatuid = "";
  String channelId = "";
  String peerUserId = "";
  bool isSetConn = false;
  late AgoraRtmClient client;
  bool isImHost = false;
  late AgoraRtmChannel channel;
  int? conneId;
  String userName = "";
  final TextEditingController messageController = TextEditingController();
  String currenUserName = "";
  String currentUserProfile = "";

  int? currentUserId;
  int viewer = 1;
  final List<MessageModel> messageList = [];
  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 15, color: Colors.black),
        ).translate(),
      );
  List<MessageModel> reverseMessage = [];
  _buildMessage(MessageModelLive message, bool isMe) {
    return isMe
        ? Padding(
            padding: const EdgeInsets.only(right: 10, top: 7, bottom: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                    child: (message.message != "")
                        ? Container(
                            width: MediaQuery.of(context).size.width * .6,
                            margin: const EdgeInsets.only(right: 0, left: 20, bottom: 3),
                            child: Stack(
                              alignment: Alignment.topRight,
                              clipBehavior: Clip.antiAlias,
                              children: [
                                Card(
                                  color: Colors.white,
                                  margin: EdgeInsets.zero,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(right: 0, bottom: 05),
                                            // constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .6),
                                            width: MediaQuery.of(context).size.width * .6,
                                            padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10, right: 10),
                                            decoration: const BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                              '${message.message}',
                                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox()),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(right: 10, top: 7, bottom: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                    child: (message.message != "")
                        ? SizedBox(
                            child: Card(
                              color: Get.theme.primaryColor,
                              margin: EdgeInsets.zero,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    10,
                                  ),
                                ),
                              ),
                              child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.end, children: [
                                Container(
                                    margin: const EdgeInsets.only(
                                      right: 0,
                                      bottom: 05,
                                    ),
                                    // constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .6),
                                    // width: MediaQuery.of(context).size.width * .6,
                                    padding: const EdgeInsets.only(
                                      left: 15,
                                      top: 10,
                                      bottom: 10,
                                      right: 10,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Container(
                                      constraints: BoxConstraints(maxWidth: Get.width - 250),
                                      child: Text(
                                        '${message.message}',
                                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
                                      ),
                                    )),
                                message.createdAt != null
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 25, right: 07, bottom: 5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(DateFormat().add_jm().format(message.createdAt!),
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 9.5,
                                                )),
                                          ],
                                        ),
                                      )
                                    : const SizedBox()
                              ]),
                            ),
                          )
                        : const SizedBox()),
              ],
            ),
          );
  }

  personalChatDialog({String? userName}) {
    BuildContext context = Get.context!;
    showDialog(
        context: context,
        // barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            content: Stack(clipBehavior: Clip.none, children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                height: 300,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        userName != null ? "Live chat with $userName" : "Live chat with User",
                        style: const TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ).translate(),
                    ),
                    liveAstrologerController.chatId == null
                        ? const SizedBox()
                        : SizedBox(
                            height: 250,
                            width: Get.width,
                            child: Scrollbar(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  GetBuilder<LiveAstrologerController>(
                                    builder: (c) {
                                      return liveAstrologerController.chatId == null
                                          ? const SizedBox()
                                          : Expanded(
                                              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                                  stream: liveAstrologerController.getChatMessages(liveAstrologerController.chatId!, global.user.id!),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.connectionState.name == "waiting") {
                                                      return const Center(child: CircularProgressIndicator());
                                                    } else {
                                                      if (snapshot.hasError) {
                                                        print(snapshot.error);
                                                        return buildText(
                                                          "Something went wrong try again",
                                                        );
                                                      } else {
                                                        List<MessageModelLive> messageList = [];
                                                        snapshot.data!.docs;
                                                        for (var res in snapshot.data!.docs) {
                                                          // ignore: unnecessary_cast
                                                          messageList.add(MessageModelLive.fromJson(res.data() as Map<String, dynamic>));
                                                        }
                                                        print(messageList.length);
                                                        return messageList.isEmpty
                                                            ? buildText(
                                                                'No message available',
                                                              )
                                                            : Padding(
                                                                padding: const EdgeInsets.only(bottom: 10),
                                                                child: ListView.builder(
                                                                  reverse: true,
                                                                  physics: const BouncingScrollPhysics(),
                                                                  itemCount: messageList.length,
                                                                  itemBuilder: (context, index) {
                                                                    MessageModelLive message = messageList[index];
                                                                    return _buildMessage(
                                                                      message,
                                                                      message.userId1 == global.user.id,
                                                                    );
                                                                  },
                                                                ),
                                                              );
                                                      }
                                                    }
                                                  })
                                              // : Center(
                                              //     child: CircularProgressIndicator(),
                                              //   ),
                                              );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              Positioned(
                  top: -5,
                  right: -5,
                  child: GestureDetector(
                      onTap: () {
                        if (liveAstrologerController.isOpenPersonalChatDialog) {
                          liveAstrologerController.isOpenPersonalChatDialog = false;
                        }
                        Get.back();
                      },
                      child: const Icon(Icons.close)))
            ]),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actionsPadding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
          );
        });
  }

  @override
  void initState() {
    super.initState();

    setupVideoSDKEngine();
    createClient();
    getWaitList();
  }

  Future<void> getWaitList() async {
    // ignore: unnecessary_null_comparison
    if (global.agoraLiveChannelName != "" && global.agoraLiveChannelName != null) {
      await liveAstrologerController.getWaitList(global.agoraLiveChannelName);
    }
  }

  Future<void> wailtListDialog() {
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        backgroundColor: Colors.white,
        builder: (context) {
          return Container(
              height: 250,
              margin: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: Get.width,
                    child: Stack(children: [
                      Center(
                        child: const Text(
                          "Waitlist",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                        ).translate(),
                      ),
                      Positioned(
                          right: 10,
                          child: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(Icons.close)))
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: const Text(
                      "Customers who missed the call & were marked offline will get priority as per the list, if they come online.",
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                      textAlign: TextAlign.center,
                    ).translate(),
                  ),
                  SizedBox(
                    height: 150,
                    // ignore: prefer_is_empty
                    child: liveAstrologerController.waitList.length != 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: liveAstrologerController.waitList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: const EdgeInsets.all(10),
                                width: Get.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        liveAstrologerController.waitList[index].userProfile != ""
                                            ? CircleAvatar(
                                                radius: 15,
                                                backgroundColor: Get.theme.primaryColor,
                                                child: Image.network(
                                                  "${global.imgBaseurl}${liveAstrologerController.waitList[index].userProfile}",
                                                  height: 18,
                                                ),
                                              )
                                            : CircleAvatar(
                                                radius: 15,
                                                backgroundColor: Get.theme.primaryColor,
                                                child: Image.asset(
                                                  "assets/images/no_customer_image.png",
                                                  height: 18,
                                                ),
                                              ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Column(
                                            children: [
                                              Text(
                                                liveAstrologerController.waitList[index].userName,
                                                style: const TextStyle(fontWeight: FontWeight.w500),
                                              ).translate(),
                                              Text(
                                                liveAstrologerController.waitList[index].isOnline ? 'Online' : 'Offline',
                                                style: const TextStyle(fontWeight: FontWeight.w500),
                                              ).translate(),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Get.theme.primaryColor,
                                          child: Icon(
                                            liveAstrologerController.waitList[index].requestType == "Video"
                                                ? Icons.video_call
                                                : liveAstrologerController.waitList[index].requestType == "Audio"
                                                    ? Icons.call
                                                    : Icons.chat,
                                            color: Colors.black,
                                            size: 13,
                                          ),
                                        ),
                                        liveAstrologerController.waitList[index].status == "Pending"
                                            ? Padding(
                                                padding: const EdgeInsets.only(left: 10),
                                                child: Text(
                                                  "${liveAstrologerController.waitList[index].time} sec",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              )
                                            : CountdownTimer(
                                                endTime: liveAstrologerController.endTime,
                                                widgetBuilder: (_, CurrentRemainingTime? time) {
                                                  if (time == null) {
                                                    return const Text('00 min 00 sec');
                                                  }
                                                  return Padding(
                                                    padding: const EdgeInsets.only(left: 10),
                                                    child: time.min != null ? Text('${time.min} min ${time.sec} sec', style: const TextStyle(fontWeight: FontWeight.w500)) : Text('${time.sec} sec', style: const TextStyle(fontWeight: FontWeight.w500)),
                                                  );
                                                },
                                                onEnd: () {
                                                  //call the disconnect method from requested customer
                                                },
                                              ),
                                        liveAstrologerController.waitList[index].isOnline
                                            ? Container(
                                                margin: const EdgeInsets.only(left: 10),
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: liveAstrologerController.waitList[index].isOnline ? Get.theme.primaryColor : Colors.grey,
                                                ),
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    Get.back();
                                                    List<String> list = [];
                                                    for (var i = 0; i < liveAstrologerController.waitList.length; i++) {
                                                      if (liveAstrologerController.waitList[i].status == "Running") {
                                                        list.add("value");
                                                      }
                                                    }
                                                    if (list.isEmpty) {
                                                      CurrentUser userData = CurrentUser.fromJson(json.decode(global.sp!.getString("currentUser") ?? ""));
                                                      int id = userData.id ?? 0;
                                                      String? fcmToken = await FirebaseMessaging.instance.getToken();
                                                      global.callOnFcmApiSendPushNotifications(
                                                          fcmTokem: [liveAstrologerController.waitList[index].userFcmToken],
                                                          title: "For Live accept/reject",
                                                          subTitle: "For Live accept/reject",
                                                          sendData: {
                                                            "astroName": (global.user.name != null && global.user.name != "") ? global.user.name : "Astrologer",
                                                            "channel": global.agoraLiveChannelName,
                                                            "token": global.agoraLiveToken,
                                                            "astroId": id,
                                                            "requestType": liveAstrologerController.waitList[index].requestType,
                                                            "id": liveAstrologerController.waitList[index].id,
                                                            "charge": global.user.charges,
                                                            "fcmToken": fcmToken,
                                                            "astroProfile": global.user.imagePath ?? "",
                                                            "videoCallCharge": global.user.videoCallRate ?? 0,
                                                          });
                                                      liveAstrologerController.endTime = DateTime.now().millisecondsSinceEpoch + 1000 * int.parse(liveAstrologerController.waitList[index].time);
                                                    } else {
                                                      global.showToast(message: "Once running session complete, you will be able to start new session");
                                                    }
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor: liveAstrologerController.waitList[index].isOnline ? MaterialStateProperty.all(Get.theme.primaryColor) : MaterialStateProperty.all(Colors.grey),
                                                  ),
                                                  child: Center(
                                                    child: const Text(
                                                      "Start",
                                                      style: TextStyle(color: Colors.black),
                                                    ).translate(),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            })
                        : Center(
                            child: const Text(
                              "No members available",
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
                            ).translate(),
                          ),
                  ),
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () async {
        print('personal deialog ${liveAstrologerController.isOpenPersonalChatDialog}');
        if (liveAstrologerController.isOpenPersonalChatDialog) {
          liveAstrologerController.isOpenPersonalChatDialog = false;
          liveAstrologerController.update();
        }
        return true;
      },
      child: Scaffold(
          body: ListView(
        children: [
          Stack(children: [
            SizedBox(
                height: Get.height * 0.9,
                child: Stack(
                  children: [
                    SizedBox(
                      height: isImHost ? Get.height * 0.5 : Get.height * 0.9,
                      width: Get.width,
                      child: isJoined
                          ? videoPanel()
                          : Center(
                              child: const Text('joining..').translate(),
                            ),
                    ),
                    isImHost
                        ? Container(
                            margin: EdgeInsets.only(
                              top: Get.height * 0.46,
                            ),
                            height: Get.height * 0.5,
                            width: Get.width,
                            child: _videoPanelForCoHost(),
                          )
                        : const SizedBox(),
                  ],
                )),
            Positioned(
              bottom: 10,
              right: 8,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await liveAstrologerController.getWaitList(global.agoraLiveChannelName);
                      await liveAstrologerController.getLiveuserData(global.agoraLiveChannelName);
                      await liveAstrologerController.onlineOfflineUser();
                      liveAstrologerController.isUserJoinWaitList = false;
                      liveAstrologerController.update();
                      wailtListDialog();
                    },
                    child: GetBuilder<LiveAstrologerController>(builder: (liveController) {
                      return Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            margin: const EdgeInsets.only(right: 20, bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.35),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Icon(
                              FontAwesomeIcons.hourglassEnd,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          liveController.isUserJoinWaitList
                              ? const Positioned(
                                  right: 20,
                                  top: 0,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 6,
                                  ))
                              : const SizedBox(),
                        ],
                      );
                    }),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text("Are you sure you want Leave live stream?").translate(),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text(MessageConstants.No).translate(),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  onPressed: () {
                                    leave();
                                    Get.back(); //close dialog
                                  },
                                  child: const Text(MessageConstants.YES).translate(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              left: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        reverseMessage.isEmpty
                            ? const SizedBox()
                            : SizedBox(
                                height: Get.height * 0.4,
                                width: Get.width * 0.74,
                                child: ListView.builder(
                                    itemCount: reverseMessage.length,
                                    reverse: true,
                                    padding: const EdgeInsets.only(bottom: 10),
                                    itemBuilder: (context, index) {
                                      print('revrese profile ${reverseMessage[index].profile}');
                                      return Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: CircleAvatar(
                                              backgroundColor: Get.theme.primaryColor,
                                              child: reverseMessage[index].profile == ""
                                                  ? Image.asset(
                                                      'assets/images/no_customer_image.png',
                                                      height: 40,
                                                      width: 30,
                                                    )
                                                  : CachedNetworkImage(
                                                      imageUrl: '${reverseMessage[index].profile}',
                                                      imageBuilder: (context, imageProvider) => CircleAvatar(
                                                        backgroundImage: NetworkImage('${reverseMessage[index].profile}'),
                                                      ),
                                                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                      errorWidget: (context, url, error) => Image.asset(
                                                        'assets/images/no_customer_image.png',
                                                        height: 40,
                                                        width: 30,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: Get.width * 0.55,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  reverseMessage[index].userName ?? "User",
                                                  style: Get.textTheme.bodyMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                                ).translate(),
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      reverseMessage.isNotEmpty ? reverseMessage[index].message! : '',
                                                      style: Get.textTheme.bodySmall!.copyWith(color: Colors.white),
                                                    ),
                                                    reverseMessage[index].gift != null && reverseMessage[index].gift != 'null'
                                                        ? CachedNetworkImage(
                                                            height: 30,
                                                            width: 30,
                                                            imageUrl: '${global.imgBaseurl}${reverseMessage[index].gift}',
                                                          )
                                                        : const SizedBox()
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    }),
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            FutureBuilder(
                                future: global.translatedText('Say hi..'),
                                builder: (context, snapshot) {
                                  return SizedBox(
                                    height: 40,
                                    width: Get.width * 0.4,
                                    child: TextFormField(
                                      style: const TextStyle(fontSize: 12, color: Colors.white),
                                      controller: messageController,
                                      keyboardType: TextInputType.text,
                                      cursorColor: Colors.white,
                                      decoration: InputDecoration(
                                          fillColor: Colors.black38,
                                          filled: true,
                                          hintStyle: const TextStyle(fontSize: 14, color: Colors.white),
                                          helperStyle: TextStyle(color: Get.theme.primaryColor),
                                          contentPadding: const EdgeInsets.all(10.0),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.transparent),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.transparent),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.transparent),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.transparent),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          hintText: snapshot.data ?? "Say hi..",
                                          prefixIcon: const Icon(
                                            Icons.chat,
                                            color: Colors.white,
                                            size: 15,
                                          )),
                                    ),
                                  );
                                }),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                if (messageController.text != "") {
                                  sendMessage(messageController.text);
                                  messageController.clear();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.only(top: 8),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  FutureBuilder(
                      future: global.translatedText("Warning - Don't close the app without leaving running session."),
                      builder: (context, snapshot) {
                        return Container(
                            margin: const EdgeInsets.only(bottom: 5, left: 5),
                            padding: const EdgeInsets.only(top: 3, left: 3, right: 3),
                            height: 20,
                            color: Colors.black.withOpacity(0.9),
                            child: Marquee(
                              text: snapshot.data ?? "Warning - Don't close the app without leaving running session.",
                              style: const TextStyle(color: Colors.red, fontSize: 10),
                              scrollAxis: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              blankSpace: 20.0,
                              velocity: 80.0,
                              pauseAfterRound: const Duration(milliseconds: 500),
                              startPadding: 10.0,
                              accelerationDuration: const Duration(milliseconds: 500),
                              accelerationCurve: Curves.linear,
                              decelerationDuration: const Duration(milliseconds: 500),
                              decelerationCurve: Curves.easeOut,
                            ));
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: remoteUid != null ? 10 : 4),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            remoteUid != null
                                ? Stack(clipBehavior: Clip.none, children: [
                                    CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 13.0,
                                        child: currentUserProfile == ""
                                            ? CircleAvatar(
                                                backgroundColor: Get.theme.primaryColor,
                                                backgroundImage: const AssetImage("assets/images/no_customer_image.png"),
                                                radius: 10.0,
                                              )
                                            : CircleAvatar(
                                                backgroundImage: NetworkImage(currentUserProfile),
                                                radius: 10.0,
                                              )),
                                    Positioned(
                                      top: 10,
                                      left: 10,
                                      child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 13.0,
                                          child: liveAstrologerController.joinedUserProfile == ""
                                              ? CircleAvatar(
                                                  backgroundColor: Get.theme.primaryColor,
                                                  backgroundImage: const AssetImage("assets/images/no_customer_image.png"),
                                                  radius: 10.0,
                                                )
                                              : CircleAvatar(
                                                  backgroundImage: NetworkImage("${global.imgBaseurl}${liveAstrologerController.joinedUserProfile}"),
                                                  radius: 10.0,
                                                )),
                                    ),
                                  ])
                                : CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 18.0,
                                    // ignore: unnecessary_null_comparison
                                    child: (currentUserProfile != "" && currentUserProfile != null)
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(currentUserProfile),
                                            radius: 15.0,
                                          )
                                        : CircleAvatar(
                                            backgroundColor: Get.theme.primaryColor,
                                            backgroundImage: const AssetImage("assets/images/no_customer_image.png"),
                                            radius: 15.0,
                                          ),
                                  ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  currenUserName,
                                  style: Get.textTheme.bodySmall!.copyWith(color: Colors.white),
                                ).translate(),
                                remoteUid != null
                                    ? liveAstrologerController.joinedUserName != ""
                                        ? Text(
                                            "&${liveAstrologerController.joinedUserName.toString()}",
                                            style: Get.textTheme.bodySmall!.copyWith(color: Colors.white),
                                          ).translate()
                                        : const SizedBox()
                                    : const SizedBox(),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            remoteUid != null
                                ? Image.asset(
                                    'assets/images/voice.gif',
                                    height: 30,
                                    width: 30,
                                  )
                                : const SizedBox(),
                            liveAstrologerController.isUserJoinAsChat
                                ? Image.asset(
                                    'assets/images/voice.gif',
                                    height: 30,
                                    width: 30,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          remoteUid != null
                              ? Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  margin: const EdgeInsets.only(right: 8),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                                  child: CountdownTimer(
                                    endTime: liveAstrologerController.endTime,
                                    widgetBuilder: (_, CurrentRemainingTime? time) {
                                      if (time == null) {
                                        return Text(
                                          '00 min 00 sec',
                                          style: Get.textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10),
                                        );
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: time.min != null ? Text('${time.min} min ${time.sec} sec', style: Get.textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10)) : Text('${time.sec} sec', style: Get.textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10)),
                                      );
                                    },
                                    onEnd: () {
                                      //call the disconnect method from requested customer
                                    },
                                  ),
                                )
                              : const SizedBox(),
                          GetBuilder<LiveAstrologerController>(builder: (c) {
                            return liveAstrologerController.isUserJoinAsChat
                                ? Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    margin: const EdgeInsets.only(right: 8),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                                    child: CountdownTimer(
                                      endTime: liveAstrologerController.endTime,
                                      widgetBuilder: (_, CurrentRemainingTime? time) {
                                        if (time == null) {
                                          return Text(
                                            '00 min 00 sec',
                                            style: Get.textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10),
                                          );
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: time.min != null ? Text('${time.min} min ${time.sec} sec', style: Get.textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10)) : Text('${time.sec} sec', style: Get.textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10)),
                                        );
                                      },
                                      onEnd: () {
                                        //call the disconnect method from requested customer
                                      },
                                    ),
                                  )
                                : const SizedBox();
                          }),
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                margin: const EdgeInsets.only(right: 8),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  viewer.toString(),
                                  style: Get.textTheme.bodySmall!.copyWith(color: Colors.white, fontSize: 10),
                                ),
                              ),
                              GetBuilder<LiveAstrologerController>(builder: (c) {
                                return liveAstrologerController.isUserJoinAsChat == true
                                    ? GestureDetector(
                                        onTap: () {
                                          liveAstrologerController.isOpenPersonalChatDialog = true;
                                          liveAstrologerController.update();
                                          personalChatDialog(userName: "${liveAstrologerController.liveChatUserName}");
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 5, right: 5),
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Colors.black.withOpacity(0.3),
                                            child: const Icon(
                                              Icons.message,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox();
                              })
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            )
          ]),
        ],
      )),
    ));
  }

  Future generateToken() async {
    try {
      global.sp = await SharedPreferences.getInstance();
      CurrentUser userData = CurrentUser.fromJson(json.decode(global.sp!.getString("currentUser") ?? ""));
      int id = userData.id ?? 0;
      global.agoraLiveChannelName = '${global.liveChannelName}_$id';
      await liveAstrologerController.getRtcToken(global.getSystemFlagValue(global.systemFlagNameList.agoraAppId), global.getSystemFlagValue(global.systemFlagNameList.agoraAppCertificate), "$uid", global.agoraLiveChannelName);
      log("live token:-${global.agoraLiveToken}");
      await liveAstrologerController.sendLiveToken(id, global.agoraLiveChannelName, global.agoraLiveToken, "");
      log("object");
    } catch (e) {
      print("Exception in getting token: ${e.toString()}");
    }
  }

  Future<void> setRemoteId2(int astroId, int rmeoteId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.setRemoteId(astroId, rmeoteId).then((result) {
            if (result.status == "200") {
            } else {}
          });
        }
      });
    } catch (e) {
      print("Exception in getFollowedAstrologerList :-" + e.toString());
    }
  }

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(RtcEngineContext(appId: global.getSystemFlagValue(global.systemFlagNameList.agoraAppId)));

    await agoraEngine.enableVideo();

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            isJoined = true;
            conneId = connection.localUid;
          });
          print("RemoteId5555:" + connection.localUid.toString());
          //api call
        },
        onUserJoined: (RtcConnection connection, int remoteUid2, int elapsed) {
          setState(() {
            remoteUid = remoteUid2;
            isImHost = true;
            print('isimHost in onUserJoined $isImHost');
          });
          log('customer jn:---- $isImHost');
          log('Connection local Id: ' + connection.localUid.toString());
          log('RemoteId from onUserJoinded' + remoteUid.toString());
        },
        onUserMuteVideo: (RtcConnection conn, int remoteId3, bool muted) {
          print("Muted remoteId:" + remoteId3.toString());
          print("muted or not" + muted.toString());
          if (remoteUid == remoteId3) {
            if (muted == true) {
              setState(() {
                isImHost = false;
                print('isimHost in onUserMuteVideo muted $isImHost');
              });
            } else {
              setState(() {
                isImHost = true;
                print('isimHost in onUserMuteVideo mutede else $isImHost');
              });
            }
          }
        },
        onUserOffline: (RtcConnection connection, int remoteUId, UserOfflineReasonType reason) {
          setState(() {
            remoteUid = null;
            isImHost = false;
            print('isimHost in onUserOffline  $isImHost');
          });
        },
        onLeaveChannel: (RtcConnection con, RtcStats sc) {
          print("onLeaveChannel called" + con.localUid.toString());
        },
      ),
    );
    sp = await SharedPreferences.getInstance();
    CurrentUser userData = CurrentUser.fromJson(json.decode(sp!.getString("currentUser") ?? ""));
    setState(() {
      currentUserId = userData.id ?? 0;
      currenUserName = userData.name ?? "User";
      currentUserProfile = userData.imagePath != "" ? "${global.imgBaseurl}${userData.imagePath}" : "";
    });
    await generateToken();
    join();
  }

  Widget _videoPanelForCoHost() {
    if (remoteUid != null) {
      print('remote id from _videoPanelForCoHost:- $remoteUid');
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: remoteUid),
          connection: RtcConnection(channelId: global.agoraLiveChannelName),
        ),
      );
    } else {
      return const Text(
        'Astrologer not  join..',
        textAlign: TextAlign.center,
      ).translate();
    }
  }

  Widget videoPanel() {
    // Local user joined as a host
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: agoraEngine,
        canvas: VideoCanvas(
          uid: uid,
        ),
      ),
    );
  }

  void join() async {
    // Set channel options
    ChannelMediaOptions options;
    // Set channel profile and client role
    options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    );
    await agoraEngine.startPreview();
    await agoraEngine.joinChannel(
      token: global.agoraLiveToken,
      channelId: global.agoraLiveChannelName,
      options: options,
      uid: 0,
    );
    setState(() {
      isJoined = true;
    });
    log('in join method');
  }

  void leave() async {
    if (mounted) {
      setState(() {
        isJoined = false;
        remoteUid = null;
        log('astrologer leave in method');
      });
    }
    homeController.isSelectedBottomIcon = 1;
    homeController.update();
    await agoraEngine.leaveChannel();
    await agoraEngine.release();
    await liveAstrologerController.endLiveSession(false);
    liveAstrologerController.isImInLive = false;
    liveAstrologerController.update();
  }

  Future generateChatToken() async {
    try {
      global.sp = await SharedPreferences.getInstance();
      CurrentUser userData = CurrentUser.fromJson(json.decode(global.sp!.getString("currentUser") ?? ""));
      int? id = userData.id;
      chatuid = "liveAstrologer_$id";
      channelId = "liveAstrologer_$id";
      await liveAstrologerController.getRtmToken(global.getSystemFlagValue(global.systemFlagNameList.agoraAppId), global.getSystemFlagValue(global.systemFlagNameList.agoraAppCertificate), chatuid, channelName);
      log("token chat genrated:-${global.agoraChatToken}");

      log("object");
    } catch (e) {
      print("Exception in gettting token: ${e.toString()}");
    }
  }

  void createClient() async {
    client = await AgoraRtmClient.createInstance(global.getSystemFlagValue(global.systemFlagNameList.agoraAppId));

    client.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      setState(() {
        messageList.add(MessageModel(
          message: message.text,
          userName: message.text,
          profile: currentUserProfile,
          isMe: true,
        ));
        reverseMessage = messageList.reversed.toList();
      });
    };

    await generateChatToken();
    login();
  }

  void login() async {
    if (chatuid.isEmpty) {
      log('Enter userId');
    }
    try {
      log('client $client');
      await generateChatToken();
      await client.login(global.agoraChatToken, chatuid);
      joinChannel();

      log("login success:");
    } catch (e) {
      log("Exception in login:- $e");
    }
  }

  void joinChannel() async {
    if (channelId.isEmpty) {
      log("Please input channel id to join.");
      return;
    }
    try {
      channel = await createChannel(channelId);
      await channel.join();
    } catch (e) {
      log("Exception in joinChannel:- $e");
    }
  }

  Future<AgoraRtmChannel> createChannel(String name) async {
    AgoraRtmChannel? channel = await client.createChannel(name);
    channel!.onMemberJoined = (member) {
      setState(() {
        messageList.add(MessageModel(
          message: 'joined',
          userName: member.userId.split(global.encodedString)[1],
          profile: currentUserProfile,
          isMe: true,
        ));
        reverseMessage = messageList.reversed.toList();
        channel.getMembers().then((value) {
          print("Members count: " + value.toString());
          viewer = value.length;
          setState(() {});
        });
      });
      log("member joined: ${member.userId},channel:${member.channelId}");
    };
    channel.onMemberLeft = (member) {
      log("member left: ${member.userId},channel:${member.channelId}");
      channel.getMembers().then((value) {
        print("Members count: " + value.toString());
        viewer = value.length;
        setState(() {});
      });
    };
    channel.onMessageReceived = (message, fromMember) {
      log("Public Message from  ${fromMember.userId} :  ${message.text}");
      setState(() {
        messageList.add(MessageModel(
          message: message.text.split("&&")[1],
          userName: message.text.split("&&")[0],
          profile: message.text.split("&&")[2],
          isMe: true,
          gift: message.text.split('&&')[3],
        ));
        reverseMessage = messageList.reversed.toList();
      });
    };
    return channel;
  }

  void sendMessage(String message) async {
    try {
      await channel.sendMessage(AgoraRtmMessage.fromText('$currenUserName&&$message&&$currentUserProfile&&null'));
      log('channelId -------->$channelId');
      setState(() {
        messageList.add(MessageModel(
          message: message,
          userName: currenUserName,
          profile: currentUserProfile,
          isMe: true,
          gift: 'null',
        ));
        reverseMessage = messageList.reversed.toList();
      });

      print('message sent to channel : - $message');
    } catch (e) {
      print("Exception in sendChannelMessage: -${e.toString()}");
    }
  }

  @override
  void dispose() async {
    await liveAstrologerController.endLiveSession(true);
    // ignore: unnecessary_null_comparison
    if (agoraEngine != null) {
      await agoraEngine.leaveChannel();
      await agoraEngine.release();
      log('astrologer left despose');
    }
    super.dispose();
  }
}
