// ignore_for_file: file_names

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/controllers/chatAvailability_controller.dart';
import 'package:astrologer_app/widgets/app_bar_widget.dart';
import 'package:astrologer_app/widgets/common_textfield_widget.dart';
import 'package:astrologer_app/widgets/primary_text_widget.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

// ignore: must_be_immutable
class ChatAvailabilityScreen extends StatelessWidget {
  ChatAvailabilityScreen({super.key});

  ChatAvailabilityController chatAvailabilityController = Get.find<ChatAvailabilityController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(height: 80, backgroundColor: COLORS().primaryColor, title: const Text("Chat Availability").translate()),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: GetBuilder<ChatAvailabilityController>(builder: (chatAvaialble) {
            return Column(children: [
              ListTile(
                enabled: true,
                tileColor: Colors.white,
                title: Center(
                  child: Text(
                    "Change your availability for chat",
                    style: Theme.of(context).primaryTextTheme.headline3,
                  ).translate(),
                ),
              ),
              Row(
                children: [
                  Radio(
                    value: 1,
                    groupValue: chatAvailabilityController.chatType,
                    activeColor: COLORS().primaryColor,
                    onChanged: (val) {
                      chatAvailabilityController.setChatAvailability(val, "Online");
                      chatAvailabilityController.showAvailableTime = true;
                      chatAvailabilityController.update();
                    },
                  ),
                  Text(
                    'Online',
                    style: Theme.of(context).primaryTextTheme.subtitle1,
                  ).translate()
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: 2,
                    groupValue: chatAvailabilityController.chatType,
                    activeColor: COLORS().primaryColor,
                    onChanged: (val) {
                      chatAvailabilityController.setChatAvailability(val, "Offline");
                      chatAvailabilityController.showAvailableTime = true;
                      chatAvailabilityController.update();
                    },
                  ),
                  Text(
                    'Offline',
                    style: Theme.of(context).primaryTextTheme.subtitle1,
                  ).translate()
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: 3,
                    groupValue: chatAvailabilityController.chatType,
                    activeColor: COLORS().primaryColor,
                    onChanged: (val) {
                      chatAvailabilityController.setChatAvailability(val, "Wait Time");
                      chatAvailabilityController.showAvailableTime = false;
                      chatAvailabilityController.update();
                    },
                  ),
                  Text(
                    'Wait Time',
                    style: Theme.of(context).primaryTextTheme.subtitle1,
                  ).translate()
                ],
              ),
              chatAvailabilityController.showAvailableTime == true
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: PrimaryTextWidget(text: "Choose time for available"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0, left: 10),
                          child: const Text(
                            "Once wait time is over status will become Online",
                            style: TextStyle(fontSize: 09, color: Colors.grey),
                          ).translate(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: CommonTextFieldWidget(
                            onTap: () {
                              chatAvailabilityController.selectWaitTime(context);
                            },
                            hintText: "Choose Time",
                            textEditingController: chatAvailabilityController.waitTime,
                            readOnly: true,
                            keyboardType: TextInputType.none,
                          ),
                        ),
                      ],
                    ),
            ]);
          }),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: COLORS().primaryColor,
            borderRadius: BorderRadius.circular(5),
          ),
          height: 45,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          width: MediaQuery.of(context).size.width,
          child: TextButton(
            onPressed: () async {
              global.user.chatStatus = chatAvailabilityController.chatStatusName;
              global.user.dateTime = chatAvailabilityController.waitTime.text;

              global.showOnlyLoaderDialog();
              await chatAvailabilityController.statusChatChange(astroId: global.user.id!, chatStatus: chatAvailabilityController.chatStatusName, chatTime: chatAvailabilityController.waitTime.text);
              global.hideLoader();
              chatAvailabilityController.showAvailableTime = true;
              chatAvailabilityController.update();
              Get.back();
            },
            child: const Text(
              "Submit",
              style: TextStyle(color: Colors.black),
            ).translate(),
          ),
        ),
      ),
    );
  }
}
