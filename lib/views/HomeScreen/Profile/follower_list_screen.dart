// ignore_for_file: must_be_immutable

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/controllers/following_controller.dart';
import 'package:astrologer_app/models/following_model.dart';
import 'package:astrologer_app/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

class FollowerListScreen extends StatelessWidget {
  FollowingModel? following;
  FollowerListScreen({Key? key, this.following}) : super(key: key);
  FollowingController followingController = Get.find<FollowingController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(height: 80, backgroundColor: COLORS().primaryColor, title: const Text("Followers").translate()),
        body: GetBuilder<FollowingController>(
          builder: (followingController) {
            return followingController.followerList.isEmpty
                ? Center(
                    child: const Text("You don't have followers yet!").translate(),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        followingController.followerList.clear();
                        await followingController.followingList(false);
                      },
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: followingController.followerList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                leading: followingController.followerList[index].profile != null && followingController.followerList[index].profile != ""
                                    ? Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          color: COLORS().primaryColor,
                                          image: DecorationImage(
                                            scale: 8,
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              "${global.imgBaseurl}${followingController.followerList[index].profile}",
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          color: COLORS().primaryColor,
                                          image: const DecorationImage(
                                            scale: 8,
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              "assets/images/no_customer_image.png",
                                            ),
                                          ),
                                        ),
                                      ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      followingController.followerList[index].name != null || followingController.followerList[index].name != "" ? followingController.followerList[index].name! : 'following 1',
                                      style: Theme.of(context).primaryTextTheme.headline2,
                                    ).translate(),
                                    followingController.followerList[index].email != null && followingController.followerList[index].email!.isNotEmpty
                                        ? Row(
                                            children: [
                                              Text(
                                                "Email: ",
                                                style: Theme.of(context).primaryTextTheme.subtitle1,
                                              ).translate(),
                                              Text(
                                                followingController.followerList[index].email != null ? followingController.followerList[index].email! : 'abc@gmail.com',
                                                style: Theme.of(context).primaryTextTheme.subtitle1,
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
                                    Row(
                                      children: [
                                        Text(
                                          "Mobile No: ",
                                          style: Theme.of(context).primaryTextTheme.subtitle1,
                                        ).translate(),
                                        Text(
                                          followingController.followerList[index].contactNo != null ? followingController.followerList[index].contactNo! : '',
                                          style: Theme.of(context).primaryTextTheme.subtitle1,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              followingController.isMoreDataAvailable == true && !followingController.isAllDataLoaded && followingController.followerList.length - 1 == index ? const CircularProgressIndicator() : const SizedBox(),
                              index == followingController.followerList.length - 1
                                  ? const SizedBox(
                                      height: 50,
                                    )
                                  : const SizedBox()
                            ],
                          );
                        },
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
