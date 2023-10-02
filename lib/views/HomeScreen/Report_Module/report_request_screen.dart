// ignore_for_file: must_be_immutable

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/controllers/HomeController/report_controller.dart';
import 'package:astrologer_app/models/report_model.dart';
import 'package:astrologer_app/views/HomeScreen/Report_Module/report_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';
import 'package:astrologer_app/utils/global.dart' as global;

class ReportRequestScreen extends StatelessWidget {
  final ReportModel? report;
  ReportRequestScreen({Key? key, this.report}) : super(key: key);
  ReportController reportController = Get.find<ReportController>();

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double width = MediaQuery.of(context).size.width;
    return GetBuilder<ReportController>(
      builder: (reportController) {
        return reportController.reportList.isEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, right: 10, bottom: 200),
                    child: ElevatedButton(
                      onPressed: () async {
                        await reportController.getReportList(false);
                        reportController.update();
                      },
                      child: const Icon(
                        Icons.refresh_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Center(
                    child: const Text("You don't have report request yet!").translate(),
                  ),
                ],
              )
            : GetBuilder<ReportController>(
                builder: (reportController) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      reportController.reportList.clear();
                      await reportController.getReportList(false);
                      reportController.update();
                    },
                    child: ListView.builder(
                      itemCount: reportController.reportList.length,
                      controller: reportController.scrollController,
                      physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => ReportDetailScreen(
                                  flagId: 1,
                                  report: reportController.reportList[index],
                                ));
                          },
                          child: Card(
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
                                        child: reportController.reportList[index].reportImage == ""
                                            ? Image.asset(
                                                "assets/images/2022Image.jpg",
                                                height: 180,
                                                width: Get.width,
                                                fit: BoxFit.fill,
                                              )
                                            : CachedNetworkImage(
                                                imageUrl: '${global.imgBaseurl}${reportController.reportList[index].reportImage}',
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
                                          reportController.reportList[index].reportType ?? "",
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                        ).translate(),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                                    child: Row(
                                      children: [
                                        reportController.reportList[index].profile == "" || reportController.reportList[index].profile == null
                                            ? Container(
                                                height: 90,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                    color: COLORS().primaryColor,
                                                    borderRadius: BorderRadius.circular(7),
                                                    image: const DecorationImage(
                                                      scale: 8,
                                                      image: AssetImage(
                                                        "assets/images/no_customer_image.png",
                                                      ),
                                                    )),
                                              )
                                            : CachedNetworkImage(
                                                imageUrl: '${global.imgBaseurl}${reportController.reportList[index].profile}',
                                                imageBuilder: (context, imageProvider) => Container(
                                                      height: 90,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                        color: COLORS().primaryColor,
                                                        borderRadius: BorderRadius.circular(7),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                            '${global.imgBaseurl}${reportController.reportList[index].profile}',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                errorWidget: (context, url, error) => Container(
                                                      height: 90,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          color: COLORS().primaryColor,
                                                          borderRadius: BorderRadius.circular(7),
                                                          image: const DecorationImage(
                                                            scale: 8,
                                                            image: AssetImage(
                                                              "assets/images/no_customer_image.png",
                                                            ),
                                                          )),
                                                    )),
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
                                                        reportController.reportList[index].firstName ?? "Customer Name ${index + 1}",
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
                                                          DateFormat('dd-MM-yyyy').format(DateTime.parse(reportController.reportList[index].birthDate.toString())),
                                                          style: Get.theme.primaryTextTheme.subtitle2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                reportController.reportList[index].birthTime!.isNotEmpty
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
                                                                reportController.reportList[index].birthTime!,
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
