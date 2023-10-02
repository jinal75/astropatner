import 'dart:io';

import 'package:astrologer_app/controllers/AssistantController/astrologer_assistant_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';

import '../../../models/chat_message_model.dart';

class ChatWithAstrologerAssistantScreen extends StatelessWidget {
  final int flagId;
  final String customerName;
  final String fireBasechatId;
  final int customerId;
  ChatWithAstrologerAssistantScreen({
    super.key,
    required this.flagId,
    required this.customerName,
    required this.fireBasechatId,
    required this.customerId,
  });
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: GestureDetector(
              onTap: () async {},
              child: Text(
                customerName,
                style: Get.theme.primaryTextTheme.headline6!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ).translate(),
            ),
            leading: IconButton(
              onPressed: () async {
                Get.back();
              },
              icon: Icon(
                Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                color: Get.theme.iconTheme.color,
              ),
            ),
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
                GetBuilder<AstrologerAssistantChatController>(builder: (astrologerAssistantChatController) {
                  return Column(
                    children: [
                      Expanded(
                        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: astrologerAssistantChatController.getChatMessages(fireBasechatId, global.currentUserId),
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
                                  // ignore: avoid_print
                                  print(messageList.length);
                                  return ListView.builder(
                                      padding: const EdgeInsets.only(bottom: 50),
                                      itemCount: messageList.length,
                                      shrinkWrap: true,
                                      reverse: true,
                                      itemBuilder: (context, index) {
                                        ChatMessageModel message = messageList[index];
                                        astrologerAssistantChatController.isMe = message.userId1 == '${global.currentUserId}';
                                        return Row(
                                          mainAxisAlignment: astrologerAssistantChatController.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: astrologerAssistantChatController.isMe ? Colors.grey[300] : Get.theme.primaryColor,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: const Radius.circular(12),
                                                  topRight: const Radius.circular(12),
                                                  bottomLeft: astrologerAssistantChatController.isMe ? const Radius.circular(0) : const Radius.circular(12),
                                                  bottomRight: astrologerAssistantChatController.isMe ? const Radius.circular(0) : const Radius.circular(12),
                                                ),
                                              ),
                                              width: 140,
                                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                              child: Column(
                                                crossAxisAlignment: astrologerAssistantChatController.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    messageList[index].message!,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                    textAlign: astrologerAssistantChatController.isMe ? TextAlign.end : TextAlign.start,
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(8),
                    child: GetBuilder<AstrologerAssistantChatController>(builder: (astrologerAssistantChatController) {
                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              ),
                              height: 50,
                              child: TextField(
                                controller: messageController,
                                onChanged: (value) {},
                                cursorColor: Colors.black,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                    borderSide: BorderSide(color: Get.theme.primaryColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                    borderSide: BorderSide(color: Get.theme.primaryColor),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Material(
                              elevation: 3,
                              color: Colors.transparent,
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
                                    color: Get.theme.primaryColor,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    if (messageController.text != "") {
                                      astrologerAssistantChatController.sendMessage(messageController.text, fireBasechatId, customerId);
                                      messageController.clear();
                                    }
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
