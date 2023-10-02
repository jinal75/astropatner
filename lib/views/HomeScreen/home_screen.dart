// ignore_for_file: must_be_immutable, unnecessary_null_comparison, avoid_print

import 'dart:io';

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/constants/messageConst.dart';
import 'package:astrologer_app/controllers/Authentication/signup_controller.dart';
import 'package:astrologer_app/controllers/HistoryController/call_history_controller.dart';
import 'package:astrologer_app/controllers/HomeController/call_controller.dart';
import 'package:astrologer_app/controllers/HomeController/chat_controller.dart';
import 'package:astrologer_app/controllers/HomeController/edit_profile_controller.dart';
import 'package:astrologer_app/controllers/HomeController/home_controller.dart';
import 'package:astrologer_app/controllers/HomeController/live_astrologer_controller.dart';
import 'package:astrologer_app/controllers/HomeController/report_controller.dart';
import 'package:astrologer_app/controllers/HomeController/wallet_controller.dart';
import 'package:astrologer_app/controllers/following_controller.dart';
import 'package:astrologer_app/controllers/notification_controller.dart';
import 'package:astrologer_app/views/HomeScreen/Drawer/Wallet/Wallet_screen.dart';
import 'package:astrologer_app/views/HomeScreen/Drawer/drawer_screen.dart';
import 'package:astrologer_app/views/HomeScreen/Profile/edit_profile_screen.dart';
import 'package:astrologer_app/views/HomeScreen/Profile/profile_screen.dart';
import 'package:astrologer_app/views/HomeScreen/Report_Module/report_history_list_screen.dart';
import 'package:astrologer_app/views/HomeScreen/call_detail_screen.dart';
import 'package:astrologer_app/views/HomeScreen/chat_screen.dart';
import 'package:astrologer_app/views/HomeScreen/live/live_screen.dart';
import 'package:astrologer_app/views/HomeScreen/notification_screen.dart';
import 'package:astrologer_app/views/HomeScreen/Report_Module/report_request_screen.dart';
import 'package:astrologer_app/widgets/app_bar_widget.dart';
import 'package:astrologer_app/widgets/floating_action_button.dart';
import 'package:astrologer_app/widgets/wallet_history_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/splashController.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  HomeController homeController = Get.find<HomeController>();
  ChatController chatController = Get.find<ChatController>();
  CallController callController = Get.find<CallController>();
  CallHistoryController callHistoryController = Get.find<CallHistoryController>();
  ReportController reportController = Get.find<ReportController>();
  SignupController signupController = Get.find<SignupController>();
  WalletController walletController = Get.find<WalletController>();
  FollowingController followingController = Get.find<FollowingController>();
  EditProfileController editProfileController = Get.put(EditProfileController());
  LiveAstrologerController liveAstrologerController = Get.find<LiveAstrologerController>();
  NotificationController notificationController = Get.find<NotificationController>();
  SplashController splashController = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: GetBuilder<HomeController>(
          init: homeController,
          builder: (homeController) {
            return WillPopScope(
              onWillPop: () async {
                bool isExit = false;
                if (homeController.isSelectedBottomIcon == 1) {
                  isExit = await homeController.onBackPressed();
                  if (isExit) {
                    exit(0);
                  }
                } else if (homeController.isSelectedBottomIcon == 2) {
                  global.showToast(message: 'You must end the call to exit the live streaming session.');
                } else {
                  homeController.isSelectedBottomIcon = 1;
                  homeController.update();
                }
                return isExit;
              },
              child: Scaffold(
                appBar: homeController.isSelectedBottomIcon == 2
                    ? null
                    : MyCustomAppBar(
                        height: 80,
                        title: Text(global.getSystemFlagValue(global.systemFlagNameList.appName)).translate(),
                        actions: [
                          homeController.isSelectedBottomIcon == 1
                              ? Row(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        homeController.lan = [];
                                        await homeController.getLanguages();
                                        await homeController.updateLanIndex();
                                        print(homeController.lan);
                                        global.checkBody().then((result) {
                                          if (result) {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return GetBuilder<HomeController>(builder: (h) {
                                                    return AlertDialog(
                                                      contentPadding: EdgeInsets.zero,
                                                      content: GetBuilder<HomeController>(builder: (h) {
                                                        return Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            InkWell(
                                                                onTap: () => Get.back(),
                                                                child: const Align(
                                                                  alignment: Alignment.topRight,
                                                                  child: Icon(Icons.close),
                                                                )),
                                                            Container(
                                                                padding: const EdgeInsets.all(0),
                                                                child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                                                  Text('Choose your app language', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold)).translate(),
                                                                  GetBuilder<HomeController>(builder: (home) {
                                                                    return Wrap(
                                                                        children: List.generate(homeController.lan.length, (index) {
                                                                      return InkWell(
                                                                        onTap: () {
                                                                          homeController.updateLan(index);
                                                                        },
                                                                        child: GetBuilder<HomeController>(builder: (h) {
                                                                          return Container(
                                                                            height: 80,
                                                                            alignment: Alignment.center,
                                                                            margin: const EdgeInsets.only(left: 7, right: 7, top: 10),
                                                                            width: 75,
                                                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                            decoration: BoxDecoration(
                                                                              color: homeController.lan[index].isSelected ? const Color.fromARGB(255, 228, 217, 185) : Colors.transparent,
                                                                              border: Border.all(color: homeController.lan[index].isSelected ? Get.theme.primaryColor : Colors.black),
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child: Column(mainAxisSize: MainAxisSize.min, children: [
                                                                              Text(
                                                                                homeController.lan[index].title,
                                                                                style: Get.textTheme.bodyText2,
                                                                              ),
                                                                              Text(
                                                                                homeController.lan[index].subTitle,
                                                                                style: Get.textTheme.bodyText2!.copyWith(fontSize: 12),
                                                                              )
                                                                            ]),
                                                                          );
                                                                        }),
                                                                      );
                                                                    }));
                                                                  }),
                                                                  Container(
                                                                    width: double.infinity,
                                                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                    child: ElevatedButton(
                                                                      onPressed: () async {
                                                                        splashController.currentLanguageCode = homeController.lan[homeController.selectedIndex].lanCode;
                                                                        splashController.update();
                                                                        global.spLanguage = await SharedPreferences.getInstance();
                                                                        global.spLanguage!.setString('currentLanguage', splashController.currentLanguageCode);
                                                                        // ignore: invalid_use_of_protected_member
                                                                        homeController.refresh();

                                                                        Get.back();
                                                                      },
                                                                      style: ButtonStyle(
                                                                        backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                                                      ),
                                                                      child: Text('APPLY', style: Get.textTheme.bodyText1).translate(),
                                                                    ),
                                                                  )
                                                                ]))
                                                          ],
                                                        );
                                                      }),
                                                    );
                                                  });
                                                });
                                          }
                                        });
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 0),
                                        child: ImageIcon(
                                          AssetImage(
                                            'assets/images/translation.png',
                                          ),
                                          color: Colors.black,
                                          size: 25,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: IconButton(
                                        onPressed: () {
                                          notificationController.notificationList.clear();
                                          notificationController.getNotificationList(false);
                                          Get.to(() => NotificationScreen());
                                        },
                                        icon: const Icon(Icons.notifications_outlined),
                                      ),
                                    ),
                                    GetBuilder<WalletController>(
                                      builder: (walletController) {
                                        return GestureDetector(
                                          onTap: () {
                                            walletController.getAmountList();
                                            Get.to(() => WalletScreen());
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.black),
                                            ),
                                            margin: const EdgeInsets.symmetric(horizontal: 4),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ',
                                                    style: Get.theme.primaryTextTheme.headline3,
                                                  ),
                                                  Text(
                                                    walletController.withdraw.walletAmount != null ? walletController.withdraw.walletAmount!.toStringAsFixed(0) : " 0",
                                                    style: Get.theme.primaryTextTheme.headline3,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                )
                              : GetBuilder<EditProfileController>(
                                  builder: (editProfileController) {
                                    return homeController.isSelectedBottomIcon == 4
                                        ? IconButton(
                                            onPressed: () {
                                              editProfileController.fillAstrologer(global.user);
                                              editProfileController.updateId = global.user.id;
                                              Get.to(() => EditProfileScreen());
                                              editProfileController.index = 0;
                                            },
                                            icon: const Icon(Icons.edit_outlined),
                                          )
                                        : const SizedBox();
                                  },
                                ),
                        ],
                      ),
                body: Container(
                  height: height,
                  color: COLORS().greyBackgroundColor,
                  child: homeController.isSelectedBottomIcon == 1
                      ?
                      //---------------------------Home-------------------------------------
                      DefaultTabController(
                          length: 3,
                          initialIndex: homeController.homeCurrentIndex,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 40,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.transparent,
                                        spreadRadius: 0.2,
                                        blurRadius: 0.2,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: TabBar(
                                    controller: homeController.homeTabController,
                                    onTap: (index) async {
                                      homeController.onHomeTabBarIndexChanged(index);
                                    },
                                    indicatorColor: COLORS().primaryColor,
                                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                                    unselectedLabelColor: COLORS().bodyTextColor,
                                    labelColor: Colors.black,
                                    tabs: [
                                      const Text('Chat').translate(),
                                      const Text('Calls').translate(),
                                      const Text('Report').translate(),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  controller: homeController.homeTabController,
                                  children: [
                                    //First TabBar  --chat--
                                    GetBuilder<ChatController>(
                                      builder: (chatController) {
                                        return chatController.chatList.isEmpty
                                            ? Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 10, right: 10, bottom: 200),
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        await chatController.getChatList(false);
                                                        chatController.update();
                                                      },
                                                      child: const Icon(
                                                        Icons.refresh_outlined,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: const Text('You don\'t have chat request yet!').translate(),
                                                  ),
                                                ],
                                              )
                                            : RefreshIndicator(
                                                onRefresh: () async {
                                                  chatController.chatList.clear();
                                                  await chatController.getChatList(false);
                                                  chatController.update();
                                                },
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: chatController.chatList.length,
                                                  physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                                  controller: chatController.scrollController,
                                                  itemBuilder: (context, index) {
                                                    return Card(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 2,
                                                              child: CachedNetworkImage(
                                                                imageUrl: '${global.imgBaseurl}${chatController.chatList[index].profile}',
                                                                imageBuilder: (context, imageProvider) => Container(
                                                                  height: 75,
                                                                  width: 75,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(7),
                                                                    color: Get.theme.primaryColor,
                                                                    image: DecorationImage(
                                                                      image: NetworkImage("${global.imgBaseurl}${chatController.chatList[index].profile}"),
                                                                    ),
                                                                  ),
                                                                ),
                                                                errorWidget: (context, url, error) => Container(
                                                                  height: 75,
                                                                  width: 75,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(7),
                                                                    color: Get.theme.primaryColor,
                                                                    image: const DecorationImage(
                                                                      image: AssetImage("assets/images/no_customer_image.png"),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 4,
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 8.0),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons.person,
                                                                          color: COLORS().primaryColor,
                                                                          size: 20,
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(left: 5),
                                                                          child: Text(
                                                                            chatController.chatList[index].name == "" || chatController.chatList[index].name == null ? "User" : chatController.chatList[index].name!,
                                                                            style: Get.theme.primaryTextTheme.headline3,
                                                                          ).translate(),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(top: 5),
                                                                      child: Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.calendar_month_outlined,
                                                                            color: COLORS().primaryColor,
                                                                            size: 20,
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(left: 5),
                                                                            child: Text(
                                                                              DateFormat('dd-MM-yyyy').format(DateTime.parse(chatController.chatList[index].birthDate.toString())),
                                                                              style: Get.theme.primaryTextTheme.subtitle2,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    chatController.chatList[index].birthTime!.isNotEmpty
                                                                        ? Padding(
                                                                            padding: const EdgeInsets.only(top: 5),
                                                                            child: Row(
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.schedule_outlined,
                                                                                  color: COLORS().primaryColor,
                                                                                  size: 20,
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 5),
                                                                                  child: Text(
                                                                                    chatController.chatList[index].birthTime!,
                                                                                    style: Get.theme.primaryTextTheme.subtitle2,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        : const SizedBox(),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 90,
                                                                    child: OutlinedButton(
                                                                      style: OutlinedButton.styleFrom(
                                                                        foregroundColor: Colors.green,
                                                                        side: const BorderSide(color: Colors.green),
                                                                      ),
                                                                      onPressed: () async {
                                                                        global.showOnlyLoaderDialog();
                                                                        await chatController.storeChatId(
                                                                          chatController.chatList[index].id!,
                                                                          chatController.chatList[index].chatId!,
                                                                        );
                                                                        global.hideLoader();
                                                                        await chatController.acceptChatRequest(
                                                                          chatController.chatList[index].chatId!,
                                                                          chatController.chatList[index].name ?? 'user',
                                                                          chatController.chatList[index].profile ?? "",
                                                                          chatController.chatList[index].id!,
                                                                          chatController.chatList[index].fcmToken!,
                                                                        );
                                                                      },
                                                                      child: splashController.currentLanguageCode == 'en'
                                                                          ? const Text(
                                                                              "Accept",
                                                                              textAlign: TextAlign.center,
                                                                            )
                                                                          : const Text(
                                                                              "Accept",
                                                                              textAlign: TextAlign.center,
                                                                            ).translate(),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 90,
                                                                    child: OutlinedButton(
                                                                      style: OutlinedButton.styleFrom(
                                                                        foregroundColor: COLORS().errorColor,
                                                                        side: BorderSide(color: COLORS().errorColor),
                                                                      ),
                                                                      onPressed: () {
                                                                        Get.dialog(
                                                                          AlertDialog(
                                                                            title: const Text("Are you sure you want remove customer?").translate(),
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
                                                                                  onPressed: () {
                                                                                    chatController.rejectChatRequest(chatController.chatList[index].chatId!);
                                                                                  },
                                                                                  child: const Text(MessageConstants.YES).translate(),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                      child: splashController.currentLanguageCode == 'en'
                                                                          ? const Text(
                                                                              "Reject",
                                                                              textAlign: TextAlign.center,
                                                                            )
                                                                          : const Text(
                                                                              "Reject",
                                                                              textAlign: TextAlign.center,
                                                                            ).translate(),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
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
                                    //Second TabBar  --calls--
                                    GetBuilder<CallController>(
                                      builder: (callController) {
                                        return callController.callList.isEmpty
                                            ? Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 10, right: 10, bottom: 200),
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        await callController.getCallList(false);
                                                        callController.update();
                                                      },
                                                      child: const Icon(
                                                        Icons.refresh_outlined,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: const Text("You don't have call request yet!").translate(),
                                                  ),
                                                ],
                                              )
                                            : RefreshIndicator(
                                                onRefresh: () async {
                                                  await callController.getCallList(false);
                                                  callController.update();
                                                },
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: callController.callList.length,
                                                  controller: callController.scrollController,
                                                  physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                                  itemBuilder: (context, index) {
                                                    return Card(
                                                      color: Colors.white,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 2,
                                                              child: CachedNetworkImage(
                                                                imageUrl: '${global.imgBaseurl}${callController.callList[index].profile}',
                                                                imageBuilder: (context, imageProvider) => Container(
                                                                  height: 75,
                                                                  width: 75,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(7),
                                                                    color: Colors.black,
                                                                    image: DecorationImage(
                                                                      image: NetworkImage("${global.imgBaseurl}${callController.callList[index].profile}"),
                                                                    ),
                                                                  ),
                                                                ),
                                                                errorWidget: (context, url, error) => Container(
                                                                  height: 75,
                                                                  width: 75,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(7),
                                                                    color: Get.theme.primaryColor,
                                                                    image: const DecorationImage(
                                                                      image: AssetImage("assets/images/no_customer_image.png"),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 4,
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 8.0),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons.person,
                                                                          color: COLORS().primaryColor,
                                                                          size: 20,
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(left: 5),
                                                                          child: Text(
                                                                            callController.callList[index].name == "" ? "User" : callController.callList[index].name,
                                                                            style: Get.theme.primaryTextTheme.headline3,
                                                                          ).translate(),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(top: 5),
                                                                      child: Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.calendar_month_outlined,
                                                                            color: COLORS().primaryColor,
                                                                            size: 20,
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(left: 5),
                                                                            child: Text(
                                                                              DateFormat('dd-MM-yyyy').format(DateTime.parse(callController.callList[index].birthDate.toString())),
                                                                              style: Get.theme.primaryTextTheme.subtitle2,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    callController.callList[index].birthTime!.isNotEmpty
                                                                        ? Padding(
                                                                            padding: const EdgeInsets.only(top: 5),
                                                                            child: Row(
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.schedule_outlined,
                                                                                  color: COLORS().primaryColor,
                                                                                  size: 20,
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 5),
                                                                                  child: Text(
                                                                                    callController.callList[index].birthTime!,
                                                                                    style: Get.theme.primaryTextTheme.subtitle2,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        : const SizedBox(),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 80,
                                                                    child: OutlinedButton(
                                                                      style: OutlinedButton.styleFrom(
                                                                        foregroundColor: Colors.green,
                                                                        side: const BorderSide(color: Colors.green),
                                                                      ),
                                                                      onPressed: () async {
                                                                        global.showOnlyLoaderDialog();
                                                                        await callController.acceptCallRequest(
                                                                          callController.callList[index].callId,
                                                                          callController.callList[index].profile == "" ? "assets/images/no_customer_image.png" : callController.callList[index].profile,
                                                                          callController.callList[index].name,
                                                                          callController.callList[index].id,
                                                                          callController.callList[index].fcmToken ?? '',
                                                                        );
                                                                      },
                                                                      child: splashController.currentLanguageCode == 'en'
                                                                          ? const Text(
                                                                              "Accept",
                                                                              textAlign: TextAlign.center,
                                                                            )
                                                                          : const Text(
                                                                              "Accept",
                                                                              textAlign: TextAlign.center,
                                                                            ).translate(),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 80,
                                                                    child: OutlinedButton(
                                                                      style: OutlinedButton.styleFrom(
                                                                        foregroundColor: COLORS().errorColor,
                                                                        side: BorderSide(color: COLORS().errorColor),
                                                                      ),
                                                                      onPressed: () {
                                                                        Get.dialog(
                                                                          AlertDialog(
                                                                            title: const Text("Are you sure you want remove customer?").translate(),
                                                                            content: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                ElevatedButton(
                                                                                  onPressed: () {
                                                                                    Get.back();
                                                                                  },
                                                                                  child: const Text("No").translate(),
                                                                                ),
                                                                                ElevatedButton(
                                                                                  onPressed: () {
                                                                                    callController.rejectCallRequest(callController.callList[index].callId);
                                                                                    callController.update();
                                                                                  },
                                                                                  child: const Text("Yes").translate(),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                      child: splashController.currentLanguageCode == 'en'
                                                                          ? const Text(
                                                                              "Reject",
                                                                              textAlign: TextAlign.center,
                                                                            )
                                                                          : const Text(
                                                                              "Reject",
                                                                              textAlign: TextAlign.center,
                                                                            ).translate(),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
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
                                    //third TabBar --report--
                                    ReportRequestScreen(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      : homeController.isSelectedBottomIcon == 2
                          ?
                          //---------------------------Record Live session-------------------------------------
                          const LiveScreen()
                          : homeController.isSelectedBottomIcon == 3
                              ?
                              //---------------------------History-------------------------------------
                              DefaultTabController(
                                  length: 4,
                                  initialIndex: homeController.homeCurrentIndex2,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 40,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.transparent,
                                                spreadRadius: 0.2,
                                                blurRadius: 0.2,
                                                offset: Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: TabBar(
                                            controller: homeController.historyTabController,
                                            onTap: (index) {
                                              homeController.onHistoryTabBarIndexChanged(index);
                                            },
                                            indicatorColor: COLORS().primaryColor,
                                            overlayColor: MaterialStateProperty.all(Colors.transparent),
                                            unselectedLabelColor: COLORS().bodyTextColor,
                                            labelColor: Colors.black,
                                            tabs: [
                                              const Text('Wallet').translate(),
                                              const Text('Call').translate(),
                                              const Text('Chat').translate(),
                                              const Text('Report').translate(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: TabBarView(
                                          controller: homeController.historyTabController,
                                          children: [
                                            //First Tabbar
                                            GetBuilder<SignupController>(builder: (c) {
                                              return WalletHistoryScreen();
                                            }),
                                            //Second Tabbar history of call
                                            GetBuilder<SignupController>(
                                              builder: (signupController) {
                                                return signupController.astrologerList.isEmpty
                                                    ? SizedBox(
                                                        child: Center(
                                                          child: const Text('Please Wait!!!!').translate(),
                                                        ),
                                                      )
                                                    : signupController.astrologerList[0].callHistory!.isEmpty
                                                        ? Column(
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 10, right: 10, bottom: 200),
                                                                child: ElevatedButton(
                                                                  onPressed: () async {
                                                                    signupController.astrologerList.clear();
                                                                    await signupController.astrologerProfileById(false);
                                                                    signupController.update();
                                                                  },
                                                                  child: const Icon(
                                                                    Icons.refresh_outlined,
                                                                    color: Colors.black,
                                                                  ),
                                                                ),
                                                              ),
                                                              Center(child: const Text('No call history is here').translate()),
                                                            ],
                                                          )
                                                        : RefreshIndicator(
                                                            onRefresh: () async {
                                                              await signupController.astrologerProfileById(false);
                                                              signupController.update();
                                                            },
                                                            child: ListView.builder(
                                                              itemCount: signupController.astrologerList[0].callHistory?.length,
                                                              controller: signupController.callHistoryScrollController,
                                                              physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                                              shrinkWrap: true,
                                                              itemBuilder: (context, index) {
                                                                return Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: GestureDetector(
                                                                    onTap: () {
                                                                      print('if live chat then chatId - ${signupController.astrologerList[0].callHistory![index].chatId}');
                                                                      Get.to(() => CallDetailScreen(
                                                                            callHistorydata: signupController.astrologerList[0].callHistory![index],
                                                                          ));
                                                                    },
                                                                    child: Column(
                                                                      children: [
                                                                        Container(
                                                                          width: width,
                                                                          padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 10),
                                                                          decoration: const BoxDecoration(
                                                                            color: Colors.white,
                                                                            borderRadius: BorderRadius.all(
                                                                              Radius.circular(5),
                                                                            ),
                                                                          ),
                                                                          child: Row(
                                                                            children: [
                                                                              Expanded(
                                                                                flex: 6,
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    Row(
                                                                                      children: [
                                                                                        Text(
                                                                                          '#00${signupController.astrologerList[0].callHistory![index].id.toString()}',
                                                                                          style: Get.theme.primaryTextTheme.subtitle2,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(top: 8.0),
                                                                                      child: Text(
                                                                                        signupController.astrologerList[0].callHistory![index].name != null || signupController.astrologerList[0].callHistory![index].name.toString().isNotEmpty ? signupController.astrologerList[0].callHistory![index].name.toString() : "User",
                                                                                        style: Get.theme.primaryTextTheme.headline3,
                                                                                      ).translate(),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(top: 8.0),
                                                                                      child: Text(
                                                                                        DateFormat('dd MMM yyyy , hh:mm a').format(DateTime.parse(signupController.astrologerList[0].callHistory![index].createdAt.toString())),
                                                                                        style: Get.theme.primaryTextTheme.subtitle1,
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(top: 8.0),
                                                                                      child: Text(
                                                                                        signupController.astrologerList[0].callHistory![index].callStatus!,
                                                                                        style: const TextStyle(color: Colors.green),
                                                                                      ).translate(),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(top: 8.0),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Text(
                                                                                            "Rate : ",
                                                                                            style: Get.theme.primaryTextTheme.subtitle2,
                                                                                          ).translate(),
                                                                                          Text(
                                                                                            '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ${signupController.astrologerList[0].callHistory![index].callRate} /min',
                                                                                            style: Get.theme.primaryTextTheme.subtitle2,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(top: 8.0),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Text(
                                                                                            "Duration : ",
                                                                                            style: Get.theme.primaryTextTheme.subtitle2,
                                                                                          ).translate(),
                                                                                          Text(
                                                                                            signupController.astrologerList[0].callHistory![index].totalMin != null && signupController.astrologerList[0].callHistory![index].totalMin!.isNotEmpty ? "${signupController.astrologerList[0].callHistory![index].totalMin} min" : "0 min",
                                                                                            style: Get.theme.primaryTextTheme.subtitle2,
                                                                                          ).translate(),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(top: 8.0),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Text(
                                                                                            "Deduction : ",
                                                                                            style: Get.theme.primaryTextTheme.subtitle2,
                                                                                          ).translate(),
                                                                                          Text(
                                                                                            "${global.getSystemFlagValue(global.systemFlagNameList.currency)} ${signupController.astrologerList[0].callHistory![index].deduction}",
                                                                                            style: Get.theme.primaryTextTheme.subtitle2,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                  flex: 4,
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Container(
                                                                                        height: 75,
                                                                                        width: 75,
                                                                                        margin: const EdgeInsets.only(top: 50),
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(7),
                                                                                          color: COLORS().primaryColor,
                                                                                          image: signupController.astrologerList[0].callHistory![index].profile != null && signupController.astrologerList[0].callHistory![index].profile!.isNotEmpty
                                                                                              ? DecorationImage(
                                                                                                  scale: 8,
                                                                                                  image: NetworkImage(
                                                                                                    "${global.imgBaseurl}${signupController.astrologerList[0].callHistory![index].profile}",
                                                                                                  ))
                                                                                              : const DecorationImage(
                                                                                                  scale: 8,
                                                                                                  image: AssetImage(
                                                                                                    "assets/images/no_customer_image.png",
                                                                                                  ),
                                                                                                ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ))
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        signupController.isMoreDataAvailable == true && !signupController.isAllDataLoaded && signupController.astrologerList[0].callHistory!.length - 1 == index ? const CircularProgressIndicator() : const SizedBox(),
                                                                        index == signupController.astrologerList[0].callHistory!.length - 1
                                                                            ? const SizedBox(
                                                                                height: 20,
                                                                              )
                                                                            : const SizedBox()
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          );
                                              },
                                            ),
                                            //Third tabbar history if chat
                                            GetBuilder<SignupController>(
                                              builder: (signupController) {
                                                return signupController.astrologerList.isEmpty
                                                    ? SizedBox(
                                                        child: Center(
                                                          child: const Text('Please Wait!!!!').translate(),
                                                        ),
                                                      )
                                                    : signupController.astrologerList[0].chatHistory!.isEmpty
                                                        ? Column(
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 10, right: 10, bottom: 200),
                                                                child: ElevatedButton(
                                                                  onPressed: () async {
                                                                    signupController.astrologerList.clear();
                                                                    await signupController.astrologerProfileById(false);
                                                                    signupController.update();
                                                                  },
                                                                  child: const Icon(
                                                                    Icons.refresh_outlined,
                                                                    color: Colors.black,
                                                                  ),
                                                                ),
                                                              ),
                                                              Center(child: const Text('No chat history is here').translate()),
                                                            ],
                                                          )
                                                        : RefreshIndicator(
                                                            onRefresh: () async {
                                                              // signupController.astrologerList.clear();
                                                              await signupController.astrologerProfileById(false);
                                                              signupController.update();
                                                            },
                                                            child: ListView.builder(
                                                              itemCount: signupController.astrologerList[0].chatHistory?.length,
                                                              controller: signupController.chatHistoryScrollController,
                                                              physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                                              shrinkWrap: true,
                                                              itemBuilder: (context, index) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    print('firebase history chat id:- ${signupController.astrologerList[0].chatHistory![index].chatId!}');
                                                                    Get.to(
                                                                      () => ChatScreen(
                                                                        chatHistoryData: signupController.astrologerList[0].chatHistory![index],
                                                                        flagId: 2,
                                                                        customerName: signupController.astrologerList[0].chatHistory![index].name!,
                                                                        customerProfile: signupController.astrologerList[0].chatHistory![index].profile!,
                                                                        customerId: signupController.astrologerList[0].chatHistory![index].id!, //cutomer id here
                                                                        fireBasechatId: signupController.astrologerList[0].chatHistory![index].chatId!, //firebase chat id
                                                                        chatId: signupController.astrologerList[0].chatHistory![index].chatId!, //chat id
                                                                        astrologerId: signupController.astrologerList[0].chatHistory![index].astrologerId!,
                                                                        astrologerName: signupController.astrologerList[0].chatHistory![index].astrologerName!,
                                                                      ),
                                                                    );
                                                                  },
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Column(
                                                                      children: [
                                                                        Container(
                                                                          width: width,
                                                                          padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 10),
                                                                          decoration: const BoxDecoration(
                                                                            color: Colors.white,
                                                                            borderRadius: BorderRadius.all(
                                                                              Radius.circular(5),
                                                                            ),
                                                                          ),
                                                                          child: Row(
                                                                            children: [
                                                                              Expanded(
                                                                                flex: 6,
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(5),
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          Text(
                                                                                            '#00${signupController.astrologerList[0].chatHistory![index].id.toString()}',
                                                                                            style: Get.theme.primaryTextTheme.subtitle2,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(top: 8.0),
                                                                                        child: Text(
                                                                                          signupController.astrologerList[0].chatHistory![index].name != null && signupController.astrologerList[0].chatHistory![index].name!.isNotEmpty ? signupController.astrologerList[0].chatHistory![index].name! : "User",
                                                                                          style: Get.theme.primaryTextTheme.headline3,
                                                                                        ).translate(),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(top: 8.0),
                                                                                        child: Text(
                                                                                          DateFormat('dd MMM yyyy , hh:mm a').format(DateTime.parse(signupController.astrologerList[0].chatHistory![index].createdAt.toString())),
                                                                                          style: Get.theme.primaryTextTheme.subtitle1,
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(top: 8.0),
                                                                                        child: Text(
                                                                                          signupController.astrologerList[0].chatHistory![index].chatStatus!,
                                                                                          style: const TextStyle(color: Colors.green),
                                                                                        ).translate(),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(top: 8.0),
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              "Rate : ",
                                                                                              style: Get.theme.primaryTextTheme.subtitle2,
                                                                                            ).translate(),
                                                                                            Text(
                                                                                              signupController.astrologerList[0].chatHistory![index].chatRate != null && signupController.astrologerList[0].chatHistory![index].chatRate!.isNotEmpty ? '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ${signupController.astrologerList[0].chatHistory![index].chatRate} /min' : "${global.getSystemFlagValue(global.systemFlagNameList.currency)} 0/min",
                                                                                              style: Get.theme.primaryTextTheme.subtitle2,
                                                                                            ).translate(),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(top: 8.0),
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              "Duration : ",
                                                                                              style: Get.theme.primaryTextTheme.subtitle2,
                                                                                            ).translate(),
                                                                                            Text(
                                                                                              signupController.astrologerList[0].chatHistory![index].totalMin != null && signupController.astrologerList[0].chatHistory![index].totalMin!.isNotEmpty ? "${signupController.astrologerList[0].chatHistory![index].totalMin} min" : "0 min",
                                                                                              style: Get.theme.primaryTextTheme.subtitle2,
                                                                                            ).translate(),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(top: 8.0),
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              "Deduction : ",
                                                                                              style: Get.theme.primaryTextTheme.subtitle2,
                                                                                            ).translate(),
                                                                                            Text(
                                                                                              "${global.getSystemFlagValue(global.systemFlagNameList.currency)} ${signupController.astrologerList[0].chatHistory![index].deduction}",
                                                                                              style: Get.theme.primaryTextTheme.subtitle2,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                  flex: 4,
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Container(
                                                                                        height: 75,
                                                                                        width: 75,
                                                                                        margin: const EdgeInsets.only(top: 50),
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(7),
                                                                                          color: COLORS().primaryColor,
                                                                                          image: signupController.astrologerList[0].chatHistory![index].profile != null && signupController.astrologerList[0].chatHistory![index].profile!.isNotEmpty
                                                                                              ? DecorationImage(
                                                                                                  scale: 8,
                                                                                                  image: NetworkImage(
                                                                                                    "${global.imgBaseurl}${signupController.astrologerList[0].chatHistory![index].profile}",
                                                                                                  ))
                                                                                              : const DecorationImage(
                                                                                                  scale: 8,
                                                                                                  image: AssetImage(
                                                                                                    "assets/images/no_customer_image.png",
                                                                                                  ),
                                                                                                ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ))
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        signupController.isMoreDataAvailable == true && !signupController.isAllDataLoaded && signupController.astrologerList[0].chatHistory!.length - 1 == index ? const CircularProgressIndicator() : const SizedBox(),
                                                                        index == signupController.astrologerList[0].chatHistory!.length - 1
                                                                            ? const SizedBox(
                                                                                height: 20,
                                                                              )
                                                                            : const SizedBox()
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          );
                                              },
                                            ),
                                            //Fifth Tabbar
                                            ReportHistoryListScreen(),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : homeController.isSelectedBottomIcon == 4
                                  ?
                                  //--------------------------Profile------------------------------------

                                  ProfileScreen()
                                  : null,
                ),
                floatingActionButton: homeController.isSelectedBottomIcon != 1 ? const SizedBox() : const FloatingActionButtonWidget(),
                drawer: DrawerScreen(),
                bottomNavigationBar: Container(
                  color: Colors.white,
                  height: 50,
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          homeController.isSelectedBottomIcon = 1;
                          homeController.update();
                        },
                        child: Column(
                          children: [
                            Icon(
                              homeController.isSelectedBottomIcon != 1 ? Icons.house_outlined : Icons.house,
                              size: 30,
                              color: homeController.isSelectedBottomIcon != 1 ? Colors.grey : Colors.black,
                            ),
                            Text("Home", style: Get.theme.primaryTextTheme.caption).translate(),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          liveAstrologerController.isImInLive = true;
                          liveAstrologerController.update();
                          homeController.isSelectedBottomIcon = 2;
                          homeController.update();
                        },
                        child: Column(
                          children: [
                            Icon(
                              homeController.isSelectedBottomIcon != 2 ? Icons.album_outlined : Icons.album,
                              size: 30,
                              color: homeController.isSelectedBottomIcon != 2 ? Colors.grey : Colors.black,
                            ),
                            Text("Live", style: Get.theme.primaryTextTheme.caption).translate(),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          signupController.astrologerList.clear();
                          await signupController.astrologerProfileById(false);
                          signupController.update();
                          homeController.isSelectedBottomIcon = 3;
                          homeController.update();
                        },
                        child: Column(
                          children: [
                            Icon(
                              homeController.isSelectedBottomIcon != 3 ? Icons.description_outlined : Icons.description,
                              size: 30,
                              color: homeController.isSelectedBottomIcon != 3 ? Colors.grey : Colors.black,
                            ),
                            Text("History", style: Get.theme.primaryTextTheme.caption).translate(),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          followingController.followerList.clear();
                          await followingController.followingList(false);
                          homeController.isSelectedBottomIcon = 4;
                          homeController.update();
                        },
                        child: Column(
                          children: [
                            Icon(
                              homeController.isSelectedBottomIcon != 4 ? Icons.person_outline : Icons.person,
                              size: 30,
                              color: homeController.isSelectedBottomIcon != 4 ? Colors.grey : Colors.black,
                            ),
                            Text("Profile", style: Get.theme.primaryTextTheme.caption).translate(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
