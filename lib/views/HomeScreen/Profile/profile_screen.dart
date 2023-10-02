// ignore_for_file: unused_local_variable, must_be_immutable

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/controllers/Authentication/signup_controller.dart';
import 'package:astrologer_app/controllers/callAvailability_controller.dart';
import 'package:astrologer_app/controllers/chatAvailability_controller.dart';
import 'package:astrologer_app/controllers/following_controller.dart';
import 'package:astrologer_app/views/HomeScreen/FloatingButton/FreeKundli/Tabs/reportTabs/chatAvailabilityScreen.dart';
import 'package:astrologer_app/views/HomeScreen/Profile/ProfileDetailScreen/assignment_detail_screen.dart';
import 'package:astrologer_app/views/HomeScreen/Profile/ProfileDetailScreen/availabity_Detail_scree.dart';
import 'package:astrologer_app/views/HomeScreen/Profile/ProfileDetailScreen/other_detail_screen.dart';
import 'package:astrologer_app/views/HomeScreen/Profile/ProfileDetailScreen/personal_detail_screen.dart';
import 'package:astrologer_app/views/HomeScreen/Profile/ProfileDetailScreen/skill_detail_screen.dart';
import 'package:astrologer_app/views/HomeScreen/Profile/follower_list_screen.dart';
import 'package:astrologer_app/views/HomeScreen/call/callAvailabilityScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  SignupController signupController = Get.find<SignupController>();
  FollowingController followingController = Get.find<FollowingController>();
  ChatAvailabilityController chatAvailabilityController = Get.find<ChatAvailabilityController>();
  CallAvailabilityController callAvailabilityController = Get.find<CallAvailabilityController>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GetBuilder<SignupController>(
        builder: (controller) {
          return ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 170,
                    width: width,
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  global.user.imagePath != null && global.user.imagePath!.isNotEmpty
                                      ? signupController.astrologerList[0].imagePath!.isNotEmpty
                                          ? Container(
                                              height: Get.height * 0.1,
                                              width: Get.width * 0.2,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(7),
                                                image: DecorationImage(
                                                  image: NetworkImage("${global.imgBaseurl}${signupController.astrologerList[0].imagePath}"),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          : Container(
                                              height: Get.height * 0.1,
                                              width: Get.width * 0.2,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(7),
                                                image: DecorationImage(
                                                  image: NetworkImage("${global.imgBaseurl}${global.user.imagePath}"),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                      : Container(
                                          height: 75,
                                          width: 75,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: COLORS().primaryColor),
                                          child: CircleAvatar(
                                            backgroundColor: COLORS().primaryColor,
                                            radius: 45,
                                            backgroundImage: const AssetImage(
                                              "assets/images/no_customer_image.png",
                                            ),
                                          ),
                                        ),
                                  GetBuilder<FollowingController>(
                                    builder: (followingController) {
                                      return TextButton(
                                        onPressed: () {
                                          followingController.followerList.clear();
                                          followingController.followingList(false);
                                          Get.to(() => FollowerListScreen());
                                        },
                                        child: Text(
                                          '${followingController.followerList.length} followers',
                                          style: Theme.of(context).primaryTextTheme.headline2,
                                        ).translate(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    global.user.name != null && global.user.name != '' ? '${global.user.name}' : "Astrologer Name",
                                    style: Theme.of(context).primaryTextTheme.headline2,
                                  ).translate(),
                                  Row(
                                    children: [
                                      Text(
                                        "Email: ",
                                        style: Theme.of(context).primaryTextTheme.subtitle1,
                                      ).translate(),
                                      Text(
                                        global.user.email != null && global.user.email != '' ? '${global.user.email}' : "",
                                        style: Theme.of(context).primaryTextTheme.subtitle1,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Mobile Number: ",
                                        style: Theme.of(context).primaryTextTheme.subtitle1,
                                      ).translate(),
                                      Text(
                                        global.user.contactNo != null && global.user.contactNo != '' ? '${global.user.contactNo}' : "",
                                        style: Theme.of(context).primaryTextTheme.subtitle1,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        ListTile(
                          enabled: true,
                          tileColor: Colors.white,
                          leading: const Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          title: Text(
                            "Personal Detail",
                            style: Theme.of(context).primaryTextTheme.subtitle1,
                          ).translate(),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Get.to(() => const PersonalDetailScreen());
                          },
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        ListTile(
                          enabled: true,
                          tileColor: Colors.white,
                          leading: const Icon(
                            Icons.work,
                            color: Colors.black,
                          ),
                          title: Text(
                            "Skill Details",
                            style: Theme.of(context).primaryTextTheme.subtitle1,
                          ).translate(),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Get.to(() => SkillDetailScreen());
                          },
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        ListTile(
                          enabled: true,
                          tileColor: Colors.white,
                          leading: const Icon(
                            Icons.school,
                            color: Colors.black,
                          ),
                          title: Text(
                            "Other Details",
                            style: Theme.of(context).primaryTextTheme.subtitle1,
                          ).translate(),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Get.to(() => const OtherDetailScreen());
                          },
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        ListTile(
                          enabled: true,
                          tileColor: Colors.white,
                          leading: const Icon(
                            Icons.emoji_events,
                            color: Colors.black,
                          ),
                          title: Text(
                            "Assignment",
                            style: Theme.of(context).primaryTextTheme.subtitle1,
                          ).translate(),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Get.to(() => const AssignmentDetailScreen());
                          },
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        ListTile(
                          enabled: true,
                          tileColor: Colors.white,
                          leading: const Icon(
                            Icons.event_available,
                            color: Colors.black,
                          ),
                          title: Text(
                            "Availability",
                            style: Theme.of(context).primaryTextTheme.subtitle1,
                          ).translate(),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                            await signupController.astrologerProfileById(false);
                            signupController.update();
                            Get.to(() => AvailabiltyScreen());
                          },
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        ListTile(
                          enabled: true,
                          tileColor: Colors.white,
                          leading: const Icon(
                            Icons.chat,
                            color: Colors.black,
                          ),
                          title: Text(
                            "Chat Availability",
                            style: Theme.of(context).primaryTextTheme.subtitle1,
                          ).translate(),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            chatAvailabilityController.chatStatusName = global.user.chatStatus;
                            global.user;
                            if (global.user.chatWaitTime != null) {
                              String formattedTime = DateFormat('HH:mm').format(global.user.chatWaitTime!);
                              chatAvailabilityController.waitTime.text = formattedTime;
                              chatAvailabilityController.timeOfDay2 = TimeOfDay(hour: global.user.chatWaitTime!.hour, minute: global.user.chatWaitTime!.minute);
                            }
                            if (global.user.chatStatus == "Online") {
                              chatAvailabilityController.chatType = 1;
                              chatAvailabilityController.showAvailableTime = true;
                            } else if (global.user.chatStatus == "Offline") {
                              chatAvailabilityController.chatType = 2;
                              chatAvailabilityController.showAvailableTime = true;
                            } else {
                              chatAvailabilityController.chatType = 3;
                              chatAvailabilityController.showAvailableTime = false;
                            }
                            chatAvailabilityController.update();
                            Get.to(() => ChatAvailabilityScreen());
                          },
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        ListTile(
                          enabled: true,
                          tileColor: Colors.white,
                          leading: const Icon(
                            Icons.phone,
                            color: Colors.black,
                          ),
                          title: Text(
                            "Call Availability",
                            style: Theme.of(context).primaryTextTheme.subtitle1,
                          ).translate(),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            callAvailabilityController.callStatusName = global.user.callStatus;
                            if (global.user.callWaitTime != null) {
                              String formattedTime = DateFormat('HH:mm').format(global.user.callWaitTime!);
                              callAvailabilityController.waitTime.text = formattedTime;
                              callAvailabilityController.timeOfDay2 = TimeOfDay(hour: global.user.callWaitTime!.hour, minute: global.user.callWaitTime!.minute);
                            }
                            if (global.user.callStatus == "Online") {
                              callAvailabilityController.callType = 1;
                              callAvailabilityController.showAvailableTime = true;
                            } else if (global.user.callStatus == "Offline") {
                              callAvailabilityController.callType = 2;
                              callAvailabilityController.showAvailableTime = true;
                            } else {
                              callAvailabilityController.callType = 3;
                              callAvailabilityController.showAvailableTime = false;
                            }
                            callAvailabilityController.update();
                            Get.to(() => CallAvailabilityScreen());
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
