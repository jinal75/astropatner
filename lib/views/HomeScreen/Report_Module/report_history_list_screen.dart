// ignore_for_file: must_be_immutable

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/controllers/Authentication/signup_controller.dart';
import 'package:astrologer_app/views/HomeScreen/Report_Module/report_history_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';
import 'package:astrologer_app/utils/global.dart' as global;

class ReportHistoryListScreen extends StatelessWidget {
  ReportHistoryListScreen({Key? key}) : super(key: key);
  SignupController signupController = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double width = MediaQuery.of(context).size.width;
    return GetBuilder<SignupController>(
      builder: (controller) {
        return signupController.astrologerList.isEmpty
            ? SizedBox(
                child: Center(
                  child: const Text('Please Wait!!!!').translate(),
                ),
              )
            : signupController.astrologerList[0].reportHistory!.isEmpty
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
                      Center(child: const Text('No report history is here').translate()),
                    ],
                  )
                : GetBuilder<SignupController>(
                    builder: (signupController) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          signupController.astrologerList.clear();
                          await signupController.astrologerProfileById(false);
                          signupController.update();
                        },
                        child: ListView.builder(
                          itemCount: signupController.astrologerList[0].reportHistory!.length,
                          controller: signupController.reportHistoryScrollController,
                          physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => ReportHistoryDetailScreen(
                                      reportHistoryData: signupController.astrologerList[0].reportHistory![index],
                                    ));
                              },
                              child: Column(
                                children: [
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              ClipRRect(
                                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                child: signupController.astrologerList[0].reportHistory![index].reportImage == ""
                                                    ? Image.asset(
                                                        "assets/images/2022Image.jpg",
                                                        height: 180,
                                                        width: Get.width,
                                                        fit: BoxFit.fill,
                                                      )
                                                    : CachedNetworkImage(
                                                        imageUrl: '${global.imgBaseurl}${signupController.astrologerList[0].reportHistory![index].reportImage}',
                                                        imageBuilder: (context, imageProvider) => Container(
                                                          height: 180,
                                                          width: Get.width,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            image: DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: imageProvider,
                                                            ),
                                                          ),
                                                        ),
                                                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                        errorWidget: (context, url, error) => Image.asset(
                                                          "assets/images/2022Image.jpg",
                                                          height: 180,
                                                          width: Get.width,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                              ),
                                              Positioned(
                                                bottom: 8,
                                                left: 8,
                                                child: Text(
                                                  signupController.astrologerList[0].reportHistory![index].reportType.toString(),
                                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                                ).translate(),
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 90,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    color: COLORS().primaryColor,
                                                    borderRadius: BorderRadius.circular(5),
                                                    image: signupController.astrologerList[0].reportHistory![index].profile == "" || signupController.astrologerList[0].reportHistory![index].profile == null
                                                        ? const DecorationImage(
                                                            scale: 8,
                                                            image: AssetImage(
                                                              "assets/images/no_customer_image.png",
                                                            ),
                                                          )
                                                        : DecorationImage(
                                                            image: NetworkImage(
                                                              '${global.imgBaseurl}${signupController.astrologerList[0].reportHistory![index].profile}',
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                                Expanded(
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
                                                                signupController.astrologerList[0].reportHistory![index].firstName!,
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
                                                                  DateFormat('dd-MM-yyyy').format(DateTime.parse(signupController.astrologerList[0].reportHistory![index].birthDate.toString())),
                                                                  style: Get.theme.primaryTextTheme.subtitle2,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        signupController.astrologerList[0].reportHistory![index].birthTime != null
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
                                                                        signupController.astrologerList[0].reportHistory![index].birthTime!,
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
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  signupController.isMoreDataAvailable == true && !signupController.isAllDataLoaded && signupController.astrologerList[0].reportHistory!.length - 1 == index ? const CircularProgressIndicator() : const SizedBox(),
                                  index == signupController.astrologerList[0].reportHistory!.length - 1
                                      ? const SizedBox(
                                          height: 20,
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
      },
    );
  }
}
