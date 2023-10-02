// ignore_for_file: must_be_immutable
import 'dart:developer';

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/controllers/Authentication/signup_controller.dart';
import 'package:astrologer_app/widgets/app_bar_widget.dart';
import 'package:astrologer_app/widgets/common_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

class CustomeReviewScreen extends StatelessWidget {
  CustomeReviewScreen({Key? key}) : super(key: key);
  SignupController signupController = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(
          height: 80,
          title: const Text("Customer Review").translate(),
          backgroundColor: COLORS().primaryColor,
        ),
        body: GetBuilder<SignupController>(
          builder: (signupController) {
            return signupController.astrologerList.isEmpty
                ? SizedBox(
                    child: Center(
                      child: const Text('Please Wait!!!!').translate(),
                    ),
                  )
                : signupController.astrologerList[0].review!.isEmpty || signupController.astrologerList[0].review == []
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
                          Center(
                            child: const Text("You don't have any review yet!").translate(),
                          ),
                        ],
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          signupController.astrologerList.clear();
                          await signupController.astrologerProfileById(false);
                          signupController.update();
                        },
                        child: ListView.builder(
                          itemCount: signupController.astrologerList[0].review!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            signupController.astrologerList[0].review![index].profile != null
                                                ? Container(
                                                    height: Get.height * 0.08,
                                                    width: Get.width * 0.17,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius: BorderRadius.circular(7),
                                                      image: DecorationImage(
                                                        image: NetworkImage("${global.imgBaseurl}${signupController.astrologerList[0].review![index].profile!}"),
                                                        fit: BoxFit.cover,
                                                      ),
                                                      border: Border.all(
                                                        color: Colors.black,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  )
                                                : CircleAvatar(
                                                    backgroundColor: COLORS().primaryColor,
                                                    radius: 30,
                                                    backgroundImage: const AssetImage(
                                                      "assets/images/no_customer_image.png",
                                                    ),
                                                  ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8.0),
                                              child: Text(
                                                signupController.astrologerList[0].review![index].name!.isNotEmpty ? signupController.astrologerList[0].review![index].name! : "User ${index + 1}",
                                                style: Get.theme.primaryTextTheme.headline3,
                                              ).translate(),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: RatingBar.builder(
                                            initialRating: signupController.astrologerList[0].review![index].rating ?? 0,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemSize: 25,
                                            itemCount: 5,
                                            ignoreGestures: true,
                                            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: COLORS().primaryColor,
                                            ),
                                            onRatingUpdate: (rating) {},
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 8, bottom: 8),
                                          padding: const EdgeInsets.all(10),
                                          color: COLORS().greyBackgroundColor,
                                          child: Text(
                                            signupController.astrologerList[0].review![index].review != null || signupController.astrologerList[0].review![index].review!.isNotEmpty ? signupController.astrologerList[0].review![index].review! : "",
                                            style: Get.theme.primaryTextTheme.subtitle1,
                                          ).translate(),
                                        ),
                                        signupController.astrologerList[0].review![index].reply!.isNotEmpty
                                            ? Align(
                                                alignment: Alignment.centerRight,
                                                child: Container(
                                                  margin: const EdgeInsets.only(top: 8, bottom: 8),
                                                  padding: const EdgeInsets.all(10),
                                                  color: COLORS().greyBackgroundColor,
                                                  child: Text(
                                                    signupController.astrologerList[0].review![index].reply!.isNotEmpty || signupController.astrologerList[0].review![index].reply != null ? signupController.astrologerList[0].review![index].reply! : "",
                                                    style: Get.theme.primaryTextTheme.subtitle1,
                                                  ).translate(),
                                                ),
                                              )
                                            : const SizedBox(),
                                        signupController.astrologerList[0].review![index].reply!.isNotEmpty
                                            ? const SizedBox()
                                            : Padding(
                                                padding: const EdgeInsets.only(top: 5, bottom: 5),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 4,
                                                      child: CommonTextFieldWidget(
                                                        hintText: "Reply.....",
                                                        keyboardType: TextInputType.text,
                                                        textCapitalization: TextCapitalization.words,
                                                        formatter: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
                                                        textEditingController: signupController.astrologerList[0].review![index].reviewReply,
                                                        onChanged: (p0) {
                                                          log(signupController.astrologerList[0].review![index].reviewReply!.text);
                                                        },
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: IconButton(
                                                        onPressed: () {
                                                          if (signupController.astrologerList[0].review![index].reviewReply != null) {
                                                            signupController.sendReply(
                                                              signupController.astrologerList[0].review![index].id!,
                                                              signupController.astrologerList[0].review![index].reviewReply!.text,
                                                            );
                                                            signupController.update();
                                                          } else {
                                                            global.showToast(message: 'Please enter message');
                                                          }
                                                        },
                                                        icon: Icon(
                                                          Icons.send,
                                                          size: 30,
                                                          color: COLORS().primaryColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
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
