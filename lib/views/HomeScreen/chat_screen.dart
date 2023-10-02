// ignore_for_file: must_be_immutable, avoid_print

import 'dart:io';

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/controllers/HomeController/chat_controller.dart';
import 'package:astrologer_app/controllers/HomeController/timer_controller.dart';
import 'package:astrologer_app/models/History/chat_history_model.dart';
import 'package:astrologer_app/widgets/app_bar_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';

import '../../models/chat_message_model.dart';

class ChatScreen extends StatelessWidget {
  int flagId;
  final String customerName;
  final int customerId;
  final String? fireBasechatId;
  final String? chatId;
  final int? astrologerId;
  final String? astrologerName;
  final String customerProfile;
  final String? fcmToken;
  ChatHistoryModel? chatHistoryData;
  ChatScreen({
    Key? key,
    required this.flagId,
    required this.customerName,
    required this.customerProfile,
    required this.customerId,
    this.fireBasechatId,
    this.chatId,
    this.astrologerId,
    this.astrologerName,
    this.chatHistoryData,
    this.fcmToken,
  }) : super(key: key);
  final ChatController chatController = Get.put(ChatController());
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (flagId == 1) {
          chatController.sendMessage('${global.user.name} -> ended chat', customerId, true);
          global.callOnFcmApiSendPushNotifications(fcmTokem: [fcmToken], title: 'End chat from astrologer');
          TimerController timerController = Get.find<TimerController>();
          timerController.min = 0;
          timerController.minText = "";
          timerController.sec = 0;
          timerController.secText = "";
          timerController.timer!.cancel();
          timerController.secTimer!.cancel();
          timerController.update();
        }
        chatController.isInChatScreen = false;
        chatController.update();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: MyCustomAppBar(
            height: 80,
            backgroundColor: COLORS().primaryColor,
            leading: InkWell(
              onTap: () {
                if (flagId == 1) {
                  chatController.sendMessage('${global.user.name} -> ended chat', customerId, true);
                  global.callOnFcmApiSendPushNotifications(fcmTokem: [fcmToken], title: 'End chat from astrologer');
                  TimerController timerController = Get.find<TimerController>();
                  timerController.min = 0;
                  timerController.minText = "";
                  timerController.sec = 0;
                  timerController.secText = "";
                  timerController.timer!.cancel();
                  timerController.secTimer!.cancel();
                  timerController.update();
                }
                chatController.isInChatScreen = false;
                chatController.update();
                Get.back();
              },
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
              ),
            ),
            title: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: CachedNetworkImage(
                    imageUrl: '${global.imgBaseurl}$customerProfile',
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 48,
                      backgroundImage: imageProvider,
                    ),
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/images/no_customer_image.png",
                      fit: BoxFit.fill,
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    customerName.isNotEmpty ? customerName : "User",
                  ).translate(),
                ),
              ],
            ),
            actions: [
              flagId == 2
                  ? const SizedBox()
                  : GetBuilder<TimerController>(builder: (timerController) {
                      return timerController.isStartTimer
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: const Text("Duration").translate(),
                                ),
                                CountdownTimer(
                                  endTime: timerController.endTime,
                                  widgetBuilder: (_, CurrentRemainingTime? time) {
                                    if (time == null) {
                                      return const Text('00:00', style: TextStyle(fontSize: 10, color: Colors.red));
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: time.min != null ? Text('${time.min}:${time.sec}', style: const TextStyle(fontSize: 10, color: Colors.red)) : Text('${time.sec}', style: const TextStyle(fontSize: 10, color: Colors.red)),
                                    );
                                  },
                                  onEnd: () {
                                    //call the disconnect method from requested customer
                                  },
                                )
                              ],
                            )
                          : const SizedBox();
                    })
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/chat_background.jpg"),
              ),
            ),
            child: Stack(
              children: [
                GetBuilder<ChatController>(builder: (chatController) {
                  return Column(
                    children: [
                      flagId == 2
                          ? const SizedBox()
                          : FutureBuilder(
                              future: global.translatedText("Warning - Don't close the app without leaving running session."),
                              builder: (context, snapshot) {
                                return Container(
                                    margin: const EdgeInsets.only(bottom: 5, left: 5),
                                    padding: const EdgeInsets.only(top: 3, left: 3, right: 3),
                                    height: 20,
                                    // width: Get.width,
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
                      Expanded(
                        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: chatController.getChatMessages(fireBasechatId == null ? chatController.firebaseChatId : fireBasechatId!, global.currentUserId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState.name == "waiting") {
                                return const Center(child: CircularProgressIndicator());
                              } else {
                                if (snapshot.hasError) {
                                  return Text('snapShotError :- ${snapshot.error}');
                                } else {
                                  List<ChatMessageModel> messageList = [];
                                  for (var res in snapshot.data!.docs) {
                                    messageList.add(ChatMessageModel.fromJson(res.data()));
                                  }
                                  print(messageList.length);
                                  return ListView.builder(
                                      padding: const EdgeInsets.only(bottom: 50),
                                      itemCount: messageList.length,
                                      shrinkWrap: true,
                                      reverse: true,
                                      itemBuilder: (context, index) {
                                        ChatMessageModel message = messageList[index];
                                        chatController.isMe = message.userId1 == '${global.currentUserId}';
                                        return messageList[index].isEndMessage == true
                                            ? Container(
                                                color: const Color.fromARGB(255, 247, 244, 211),
                                                margin: const EdgeInsets.only(bottom: 10),
                                                padding: const EdgeInsets.all(8),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  messageList[index].message!,
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            : Row(
                                                mainAxisAlignment: chatController.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: chatController.isMe ? Colors.grey[300] : COLORS().primaryColor,
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: const Radius.circular(12),
                                                        topRight: const Radius.circular(12),
                                                        bottomLeft: chatController.isMe ? const Radius.circular(0) : const Radius.circular(12),
                                                        bottomRight: chatController.isMe ? const Radius.circular(0) : const Radius.circular(12),
                                                      ),
                                                    ),
                                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                                    margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                                    child: Column(
                                                      crossAxisAlignment: chatController.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          constraints: BoxConstraints(maxWidth: Get.width - 100),
                                                          child: Text(
                                                            messageList[index].message!,
                                                            style: const TextStyle(
                                                              color: Colors.black,
                                                            ),
                                                            textAlign: chatController.isMe ? TextAlign.end : TextAlign.start,
                                                          ),
                                                        ),
                                                        messageList[index].createdAt != null
                                                            ? Padding(
                                                                padding: const EdgeInsets.only(top: 8.0),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    Text(DateFormat().add_jm().format(messageList[index].createdAt!),
                                                                        style: const TextStyle(
                                                                          color: Colors.grey,
                                                                          fontSize: 9.5,
                                                                        )),
                                                                  ],
                                                                ),
                                                              )
                                                            : const SizedBox()
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                      });
                                }
                              }
                            }),
                      ),
                    ],
                  );
                }),
                flagId == 2
                    ? const SizedBox()
                    : Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.all(8),
                          child: GetBuilder<ChatController>(builder: (chatController) {
                            return Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: messageController,
                                    onChanged: (value) {},
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: COLORS().blackColor),
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                        borderSide: BorderSide(color: COLORS().primaryColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                        borderSide: BorderSide(color: COLORS().primaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Material(
                                    elevation: 3,
                                    color: Colors.transparent,
                                    shadowColor: COLORS().greyBackgroundColor,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                    child: Container(
                                      height: 49,
                                      width: 49,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: COLORS().primaryColor,
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          chatController.sendMessage(messageController.text, customerId, false);
                                          messageController.clear();
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(left: 5.0),
                                          child: Icon(
                                            Icons.send,
                                            size: 25,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
