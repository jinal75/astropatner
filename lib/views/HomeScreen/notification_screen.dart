// ignore_for_file: must_be_immutable

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/controllers/notification_controller.dart';
import 'package:astrologer_app/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';

import '../../constants/messageConst.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);
  NotificationController notificationController = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    double height = Get.height;
    double width = Get.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: COLORS().greyBackgroundColor,
        appBar: MyCustomAppBar(
          height: 80,
          backgroundColor: COLORS().primaryColor,
          title: const Text("Notification").translate(),
          actions: [
            IconButton(
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    titleTextStyle: Get.textTheme.bodyText1,
                    title: const Text("Are you sure you want delete all notifications?").translate(),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(MessageConstants.No).translate(),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Get.back(); //back from dialog
                            await notificationController.deleteAllNotification();
                          },
                          child: const Text(MessageConstants.YES).translate(),
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
        body: GetBuilder<NotificationController>(
          builder: (notificationController) {
            return SizedBox(
              height: height,
              width: width,
              child: notificationController.notificationList.isEmpty
                  ? Center(child: const Text('No Notification is here').translate())
                  : ListView.builder(
                      itemCount: notificationController.notificationList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(10),
                          height: 70,
                          child: ListTile(
                            tileColor: Colors.white,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    notificationController.notificationList[index].title!,
                                    style: Get.theme.primaryTextTheme.headline3,
                                  ).translate(),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                notificationController.notificationList[index].description!,
                                style: Get.theme.primaryTextTheme.subtitle2,
                              ).translate(),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.dialog(
                                      AlertDialog(
                                        titleTextStyle: Get.textTheme.bodyText1,
                                        title: const Text("Are you sure you want delete notification?").translate(),
                                        content: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: const Text(MessageConstants.No).translate(),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                Get.back(); //back from dialog
                                                await notificationController.deleteNotification(notificationController.notificationList[index].id!);
                                              },
                                              child: const Text(MessageConstants.YES).translate(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  DateFormat('dd MMM yyyy').format(DateTime.parse(notificationController.notificationList[index].createdAt.toString())),
                                  style: Get.theme.primaryTextTheme.bodyText1,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            );
          },
        ),
      ),
    );
  }
}
