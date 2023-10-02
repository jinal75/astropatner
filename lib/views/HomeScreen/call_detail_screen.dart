// ignore_for_file: avoid_print, must_be_immutable

import 'dart:io';

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/controllers/HomeController/call_detail_controller.dart';
import 'package:astrologer_app/models/History/call_history_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';
import 'package:astrologer_app/utils/global.dart' as global;

import '../../models/chat_message_model.dart';

class CallDetailScreen extends StatelessWidget {
  CallHistoryModel? callHistorydata;
  CallDetailScreen({Key? key, this.callHistorydata}) : super(key: key);
  final CallDetailController callDetailController = Get.put(CallDetailController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        await callDetailController.disposeAudioPlayer();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: COLORS().greyBackgroundColor,
          appBar: AppBar(
            backgroundColor: COLORS().primaryColor,
            title: Text(
              callHistorydata!.name != null && callHistorydata!.name!.isNotEmpty ? '${callHistorydata!.name} detail\'s' : "User detail's",
            ).translate(),
            leading: IconButton(
              icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
              onPressed: () async {
                print('back press');
                await callDetailController.disposeAudioPlayer();
                Get.back();
              },
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Client Profile
              SizedBox(
                height: 150,
                width: width,
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Client Profile:",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                        ).translate(),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Text(
                                "Name : ",
                                style: Theme.of(context).primaryTextTheme.subtitle1,
                              ).translate(),
                              Text(
                                callHistorydata!.name != null && callHistorydata!.name!.isNotEmpty ? '${callHistorydata!.name}' : "User",
                                style: Get.theme.primaryTextTheme.headline3,
                              ).translate(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Text(
                                "Mobile Number : ",
                                style: Theme.of(context).primaryTextTheme.subtitle1,
                              ).translate(),
                              Text(
                                '${callHistorydata!.contactNo}',
                                style: Get.theme.primaryTextTheme.headline3,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Text(
                                "Call status : ",
                                style: Theme.of(context).primaryTextTheme.subtitle1,
                              ).translate(),
                              Text(
                                '${callHistorydata!.callStatus}',
                                style: Get.theme.primaryTextTheme.headline3,
                              ).translate(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //Appointment Schedule
              SizedBox(
                height: 210,
                width: width,
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Appointment Schedule:",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                        ).translate(),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Text(
                                "Expert Name : ",
                                style: Theme.of(context).primaryTextTheme.subtitle1,
                              ).translate(),
                              Text(
                                '${callHistorydata!.astrologerName}',
                                style: Get.theme.primaryTextTheme.headline3,
                              ).translate(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Text(
                                "Time : ",
                                style: Theme.of(context).primaryTextTheme.subtitle1,
                              ).translate(),
                              Text(
                                DateFormat('dd MMM yyyy , hh:mm a').format(DateTime.parse(callHistorydata!.createdAt!.toString())),
                                style: Get.theme.primaryTextTheme.headline3,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Text(
                                "Duration : ",
                                style: Theme.of(context).primaryTextTheme.subtitle1,
                              ).translate(),
                              Text(
                                callHistorydata!.totalMin != null && callHistorydata!.totalMin!.isNotEmpty ? '${callHistorydata!.totalMin} min' : "0 min",
                                style: Get.theme.primaryTextTheme.headline3,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Text(
                                "Price : ",
                                style: Theme.of(context).primaryTextTheme.subtitle1,
                              ).translate(),
                              Text(
                                '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ${callHistorydata!.charge}',
                                style: Get.theme.primaryTextTheme.headline3,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Text(
                                "Deduction : ",
                                style: Theme.of(context).primaryTextTheme.subtitle1,
                              ).translate(),
                              Text(
                                '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ${callHistorydata!.deduction}',
                                style: Get.theme.primaryTextTheme.headline3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              callHistorydata!.chatId != ""
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
                      child: const Text(
                        'Live Client Chat History',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                      ).translate(),
                    )
                  : const SizedBox(),
              //Recording Audio
              callHistorydata!.chatId != ""
                  ? Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 10,
                        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: callDetailController.getChatMessages(callHistorydata!.chatId ?? "", global.currentUserId),
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
                                      padding: const EdgeInsets.all(0),
                                      itemCount: messageList.length,
                                      //shrinkWrap: true,
                                      reverse: true,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Get.theme.primaryColor,
                                                borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(12),
                                                  topRight: Radius.circular(10),
                                                  bottomLeft: Radius.circular(12),
                                                  bottomRight: Radius.circular(0),
                                                ),
                                              ),
                                              width: 140,
                                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    messageList[index].message!,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                    textAlign: TextAlign.end,
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
                    )
                  : GetBuilder<CallDetailController>(builder: (callDetailController) {
                      return SizedBox(
                        height: 100,
                        width: width,
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    print("Play Audio");
                                    if (callDetailController.isPlay) {
                                      await callDetailController.audioPlayer.pause();
                                      await callDetailController.audioPlayer2.pause();
                                    } else {
                                      print('startPlay');
                                      print('siddd ${callHistorydata!.sId}');
                                      if (callHistorydata!.sId != "") {
                                        await callDetailController.audioPlayer.play(UrlSource("https://storage.googleapis.com/astroguru_bucket/${callHistorydata!.sId}_${callHistorydata!.channelName}.m3u8"));
                                      }
                                      if (callHistorydata!.sId1 != "") {
                                        await callDetailController.audioPlayer2.play(UrlSource("https://storage.googleapis.com/astroguru_bucket/${callHistorydata!.sId1}_${callHistorydata!.channelName}.m3u8"));
                                      }
                                    }
                                    callDetailController.isPlay = !callDetailController.isPlay;
                                    callDetailController.update();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    minimumSize: const Size(50, 50),
                                    padding: const EdgeInsets.only(left: 4),
                                    foregroundColor: COLORS().blackColor,
                                  ),
                                  child: Icon(
                                    callDetailController.isPlay ? Icons.pause : Icons.play_arrow,
                                    size: 20,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GetBuilder<CallDetailController>(
                                      builder: (c) {
                                        return Slider(
                                          value: callDetailController.position.inSeconds.toDouble(),
                                          max: callDetailController.duration.inSeconds.toDouble(),
                                          min: 0,
                                          onChanged: (_) {},
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      width: Get.width - 180,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            Duration(seconds: callDetailController.position.inSeconds.toInt(), minutes: callDetailController.position.inMinutes.toInt(), hours: callDetailController.position.inHours.toInt()).toString().split(".")[0],
                                            style: const TextStyle(fontSize: 10),
                                          ),
                                          Text(
                                            Duration(seconds: callDetailController.duration.inSeconds.toInt(), minutes: callDetailController.duration.inMinutes.toInt(), hours: callDetailController.duration.inHours.toInt()).toString().split(".")[0],
                                            style: const TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    })
            ],
          ),
        ),
      ),
    );
  }
}
