// ignore_for_file: file_names, avoid_print

import 'dart:io';

import 'package:astrologer_app/constants/imageConst.dart';
import 'package:astrologer_app/controllers/dailyHoroscopeController.dart';
import 'package:astrologer_app/controllers/splashController.dart';
import 'package:astrologer_app/views/HomeScreen/FloatingButton/DailyHoroscope/dailyHoroScopeDetailScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';

import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../widgets/time_wise_horoscope_widget.dart';

// ignore: must_be_immutable
class DailyHoroscopeScreen extends StatelessWidget {
  DailyHoroscopeScreen({Key? key}) : super(key: key);
  final DailyHoroscopeController controller = Get.find<DailyHoroscopeController>();
  SplashController splashController = Get.find<SplashController>();
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Get.theme.primaryColor,
            title: Text(
              'Daily Horoscope',
              style: Get.theme.primaryTextTheme.headline6!.copyWith(fontSize: 18, fontWeight: FontWeight.normal),
            ).translate(),
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                color: Get.theme.iconTheme.color,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  global.createAndShareLinkForDailyHorscope(screenshotController);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Image.asset(
                            IMAGECONST.whatsapp,
                            height: 20,
                            width: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('Share', style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)).translate(),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ]),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GetBuilder<DailyHoroscopeController>(builder: (dailyHoroscopeController) {
            return dailyHoroscopeController.dailyList == null
                ? const SizedBox()
                : Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                    (global.hororscopeSignList.isNotEmpty)
                        ? SizedBox(
                            height: 100,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: global.hororscopeSignList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            global.showOnlyLoaderDialog();
                                            await dailyHoroscopeController.selectZodic(index);
                                            await dailyHoroscopeController.getHoroscopeList(horoscopeId: dailyHoroscopeController.signId);
                                            global.hideLoader();
                                            dailyHoroscopeController.update();
                                          },
                                          child: Container(
                                            width: global.hororscopeSignList[index].isSelected ? 68.0 : 54.0,
                                            height: global.hororscopeSignList[index].isSelected ? 68.0 : 54.0,
                                            padding: const EdgeInsets.all(0),
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: const BorderRadius.all(Radius.circular(7)),
                                              border: Border.all(
                                                color: Colors.transparent,
                                                width: 1.0,
                                              ),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: '${global.imgBaseurl}${global.hororscopeSignList[index].image}',
                                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) => const Icon(Icons.no_accounts, size: 20),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          global.hororscopeSignList[index].name,
                                          textAlign: TextAlign.center,
                                          style: Get.textTheme.subtitle1!.copyWith(fontSize: 10),
                                        ).translate()
                                      ],
                                    ),
                                  );
                                }),
                          )
                        : const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  dailyHoroscopeController.updateDaily(1);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: dailyHoroscopeController.day == 1 ? const Color.fromARGB(255, 247, 243, 214) : Colors.transparent,
                                    border: Border.all(color: dailyHoroscopeController.day == 1 ? Get.theme.primaryColor : Colors.grey),
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                                  ),
                                  child: Text(
                                    'Yesterday',
                                    textAlign: TextAlign.center,
                                    style: Get.textTheme.subtitle1!.copyWith(fontSize: 12),
                                  ).translate(),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  dailyHoroscopeController.updateDaily(2);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: dailyHoroscopeController.day == 2 ? const Color.fromARGB(255, 247, 243, 214) : Colors.transparent,
                                    border: Border.all(color: dailyHoroscopeController.day == 2 ? Get.theme.primaryColor : Colors.grey),
                                  ),
                                  child: Text('Today', textAlign: TextAlign.center, style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)).translate(),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  dailyHoroscopeController.updateDaily(3);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: dailyHoroscopeController.day == 3 ? const Color.fromARGB(255, 247, 243, 214) : Colors.transparent,
                                    border: Border.all(color: dailyHoroscopeController.day == 3 ? Get.theme.primaryColor : Colors.grey),
                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                                  ),
                                  child: Text(
                                    'Tomorrow',
                                    textAlign: TextAlign.center,
                                    style: Get.textTheme.subtitle1!.copyWith(fontSize: 12),
                                  ).translate(),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Screenshot(
                      controller: screenshotController,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (dailyHoroscopeController.dailyList != null)
                                ? DailyHoroscopeContainer(
                                    date: dailyHoroscopeController.day == 2
                                        ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics!.isNotEmpty
                                            ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].horoscopeDate != null
                                                ? DateFormat('dd-MM-yyyy').format(dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].horoscopeDate!)
                                                : DateFormat('dd-MM-yyyy').format(DateTime.now())
                                            : DateFormat('dd-MM-yyyy').format(DateTime.now())
                                        : dailyHoroscopeController.day == 1
                                            ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics!.isNotEmpty
                                                ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics![0].horoscopeDate != null
                                                    ? DateFormat('dd-MM-yyyy').format(dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics![0].horoscopeDate!)
                                                    : DateFormat('dd-MM-yyyy').format(DateTime.now().subtract(const Duration(days: 1)))
                                                : DateFormat('dd-MM-yyyy').format(DateTime.now().subtract(const Duration(days: 1)))
                                            : dailyHoroscopeController.day == 3
                                                ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics!.isNotEmpty
                                                    ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics![0].horoscopeDate != null
                                                        ? DateFormat('dd-MM-yyyy').format(dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics![0].horoscopeDate!)
                                                        : DateFormat('dd-MM-yyyy').format(DateTime.now().add(const Duration(days: 1)))
                                                    : DateFormat('dd-MM-yyyy').format(DateTime.now().add(const Duration(days: 1)))
                                                : "",
                                    luckyNumber: dailyHoroscopeController.day == 2
                                        ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics!.isNotEmpty
                                            ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].luckyNumber ?? ""
                                            : ""
                                        : dailyHoroscopeController.day == 1
                                            ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics!.isNotEmpty
                                                ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics![0].luckyNumber ?? ""
                                                : ""
                                            : dailyHoroscopeController.day == 3
                                                ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics!.isNotEmpty
                                                    ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics![0].luckyNumber ?? ""
                                                    : ""
                                                : "",
                                    luckyTime: dailyHoroscopeController.day == 2
                                        ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics!.isNotEmpty
                                            ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].luckyTime ?? ""
                                            : ""
                                        : dailyHoroscopeController.day == 1
                                            ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics!.isNotEmpty
                                                ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics![0].luckyTime ?? ""
                                                : ""
                                            : dailyHoroscopeController.day == 3
                                                ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics!.isNotEmpty
                                                    ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics![0].luckyTime ?? ""
                                                    : ""
                                                : "",
                                    moodOfDay: dailyHoroscopeController.day == 2
                                        ? dailyHoroscopeController.dailyList != null
                                            ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics!.isNotEmpty
                                                ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].moodday ?? ""
                                                : ""
                                            : dailyHoroscopeController.day == 1
                                                ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics!.isNotEmpty
                                                    ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics![0].moodday ?? ""
                                                    : ""
                                                : dailyHoroscopeController.day == 3
                                                    ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics!.isNotEmpty
                                                        ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics![0].moodday ?? ""
                                                        : ""
                                                    : ""
                                        : dailyHoroscopeController.day == 1
                                            ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics!.isNotEmpty
                                                ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics![0].moodday ?? ""
                                                : ""
                                            : dailyHoroscopeController.day == 3
                                                ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics!.isNotEmpty
                                                    ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics![0].moodday ?? ""
                                                    : ""
                                                : "",
                                    colorCode: dailyHoroscopeController.day == 2
                                        ? dailyHoroscopeController.dailyList != null
                                            ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics!.isNotEmpty
                                                ? (dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].luckyColor != null && dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].luckyColor != "")
                                                    ? dailyHoroscopeController.dailyList!.todayHoroscopeStatics![0].luckyColor!.split("#")[1]
                                                    : ""
                                                : ""
                                            : null
                                        : dailyHoroscopeController.day == 1
                                            ? dailyHoroscopeController.dailyList != null
                                                ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics!.isNotEmpty
                                                    ? (dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics![0].luckyColor != null && dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics![0].luckyColor != "")
                                                        ? dailyHoroscopeController.dailyList!.yeasterdayHoroscopeStatics![0].luckyColor!.split("#")[1]
                                                        : ""
                                                    : ""
                                                : null
                                            : dailyHoroscopeController.day == 3
                                                ? dailyHoroscopeController.dailyList != null
                                                    ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics!.isNotEmpty
                                                        ? (dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics![0].luckyColor != null && dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics![0].luckyColor != "")
                                                            ? dailyHoroscopeController.dailyList!.tomorrowHoroscopeStatics![0].luckyColor!.split("#")[1]
                                                            : ""
                                                        : ""
                                                    : null
                                                : null,
                                  )
                                : const SizedBox(),
                            dailyHoroscopeController.day == 1
                                ? dailyHoroscopeController.dailyList!.yeasterDayHoroscope!.isNotEmpty
                                    ? Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          dailyHoroscopeController.dailyList!.yeasterDayHoroscope!.isNotEmpty
                                              ? Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text('Daily Horoscope', style: Get.textTheme.subtitle1).translate(),
                                                )
                                              : const SizedBox(),
                                          ListView.builder(
                                              itemCount: dailyHoroscopeController.dailyList!.yeasterDayHoroscope!.length,
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding: const EdgeInsets.all(8),
                                                    margin: const EdgeInsets.only(bottom: 10),
                                                    decoration: BoxDecoration(
                                                      color: dailyHoroscopeController.containerColor[index],
                                                      border: Border.all(color: dailyHoroscopeController.borderColor[index]),
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                    dailyHoroscopeController.dailyList!.yeasterDayHoroscope![index].category == "Career"
                                                                        ? '💼 '
                                                                        : dailyHoroscopeController.dailyList!.yeasterDayHoroscope![index].category == "Love"
                                                                            ? "❤️ "
                                                                            : dailyHoroscopeController.dailyList!.yeasterDayHoroscope![index].category == "Money"
                                                                                ? "💵 "
                                                                                : dailyHoroscopeController.dailyList!.yeasterDayHoroscope![index].category == "Health"
                                                                                    ? "🩺 "
                                                                                    : "✈️ ",
                                                                    style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w400)),
                                                                Text('${dailyHoroscopeController.dailyList!.yeasterDayHoroscope![index].category}', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w400)).translate(),
                                                              ],
                                                            ),
                                                            Text('${dailyHoroscopeController.dailyList!.yeasterDayHoroscope![index].percent}%'),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        FutureBuilder(
                                                          future: global.showHtml(
                                                            html: dailyHoroscopeController.dailyList!.yeasterDayHoroscope![index].description ?? '',
                                                            style: {
                                                              "html": Style(color: Colors.grey),
                                                            },
                                                          ),
                                                          builder: (context, snapshot) {
                                                            return snapshot.data ?? const SizedBox();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ],
                                      )
                                    : dailyHoroscopeController.day == 2
                                        ? dailyHoroscopeController.dailyList!.todayHoroscope!.isNotEmpty
                                            ? ListView.builder(
                                                itemCount: dailyHoroscopeController.dailyList!.todayHoroscope!.length,
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      width: double.infinity,
                                                      padding: const EdgeInsets.all(8),
                                                      margin: const EdgeInsets.only(bottom: 10),
                                                      decoration: BoxDecoration(
                                                        color: dailyHoroscopeController.containerColor[index],
                                                        border: Border.all(color: dailyHoroscopeController.borderColor[index]),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text('${dailyHoroscopeController.dailyList!.todayHoroscope![index].category}', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w400)).translate(),
                                                              Text('${dailyHoroscopeController.dailyList!.todayHoroscope![index].percent}%'),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          FutureBuilder(
                                                            future: global.showHtml(
                                                              html: dailyHoroscopeController.dailyList!.todayHoroscope![index].description ?? '',
                                                              style: {
                                                                "html": Style(color: Colors.grey),
                                                              },
                                                            ),
                                                            builder: (context, snapshot) {
                                                              return snapshot.data ?? const SizedBox();
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                })
                                            : dailyHoroscopeController.day == 3
                                                ? dailyHoroscopeController.dailyList!.tomorrowHoroscope!.isNotEmpty
                                                    ? ListView.builder(
                                                        itemCount: dailyHoroscopeController.dailyList!.tomorrowHoroscope!.length,
                                                        shrinkWrap: true,
                                                        physics: const NeverScrollableScrollPhysics(),
                                                        itemBuilder: (context, index) {
                                                          return Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Container(
                                                              width: double.infinity,
                                                              padding: const EdgeInsets.all(8),
                                                              margin: const EdgeInsets.only(bottom: 10),
                                                              decoration: BoxDecoration(
                                                                color: dailyHoroscopeController.containerColor[index],
                                                                border: Border.all(color: dailyHoroscopeController.borderColor[index]),
                                                                borderRadius: BorderRadius.circular(10),
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text('${dailyHoroscopeController.dailyList!.tomorrowHoroscope![index].category}', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w400)).translate(),
                                                                      Text('${dailyHoroscopeController.dailyList!.tomorrowHoroscope![index].percent}%'),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text('${dailyHoroscopeController.dailyList!.tomorrowHoroscope![index].description}', style: Get.textTheme.subtitle1!.copyWith(color: Colors.grey, fontSize: 14)).translate()
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        })
                                                    : const SizedBox()
                                                : const SizedBox()
                                        : const SizedBox()
                                : dailyHoroscopeController.day == 2
                                    ? dailyHoroscopeController.dailyList!.todayHoroscope!.isNotEmpty
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              dailyHoroscopeController.dailyList!.todayHoroscope!.isNotEmpty
                                                  ? Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text('Daily Horoscope', style: Get.textTheme.subtitle1).translate(),
                                                    )
                                                  : const SizedBox(),
                                              ListView.builder(
                                                  itemCount: dailyHoroscopeController.dailyList!.todayHoroscope!.length,
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, index) {
                                                    return Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        padding: const EdgeInsets.all(8),
                                                        margin: const EdgeInsets.only(bottom: 10),
                                                        decoration: BoxDecoration(
                                                          color: dailyHoroscopeController.containerColor[index],
                                                          border: Border.all(color: dailyHoroscopeController.borderColor[index]),
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                        dailyHoroscopeController.dailyList!.todayHoroscope![index].category == "Career"
                                                                            ? '💼 '
                                                                            : dailyHoroscopeController.dailyList!.todayHoroscope![index].category == "Love"
                                                                                ? "❤️ "
                                                                                : dailyHoroscopeController.dailyList!.todayHoroscope![index].category == "Money"
                                                                                    ? "💵 "
                                                                                    : dailyHoroscopeController.dailyList!.todayHoroscope![index].category == "Health"
                                                                                        ? "🩺 "
                                                                                        : "✈️ ",
                                                                        style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w400)),
                                                                    Text('${dailyHoroscopeController.dailyList!.todayHoroscope![index].category}', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w400)).translate(),
                                                                  ],
                                                                ),
                                                                Text('${dailyHoroscopeController.dailyList!.todayHoroscope![index].percent}%'),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            FutureBuilder(
                                                              future: global.showHtml(
                                                                html: dailyHoroscopeController.dailyList!.todayHoroscope![index].description ?? '',
                                                                style: {
                                                                  "html": Style(color: Colors.grey),
                                                                },
                                                              ),
                                                              builder: (context, snapshot) {
                                                                return snapshot.data ?? const SizedBox();
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ],
                                          )
                                        : const SizedBox()
                                    : dailyHoroscopeController.day == 3
                                        ? dailyHoroscopeController.dailyList!.tomorrowHoroscope!.isNotEmpty
                                            ? Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  dailyHoroscopeController.dailyList!.tomorrowHoroscope!.isNotEmpty
                                                      ? Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Text('Daily Horoscope', style: Get.textTheme.subtitle1).translate(),
                                                        )
                                                      : const SizedBox(),
                                                  ListView.builder(
                                                      itemCount: dailyHoroscopeController.dailyList!.tomorrowHoroscope!.length,
                                                      shrinkWrap: true,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      itemBuilder: (context, index) {
                                                        return Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Container(
                                                            width: double.infinity,
                                                            padding: const EdgeInsets.all(8),
                                                            margin: const EdgeInsets.only(bottom: 10),
                                                            decoration: BoxDecoration(
                                                              color: dailyHoroscopeController.containerColor[index],
                                                              border: Border.all(color: dailyHoroscopeController.borderColor[index]),
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                            dailyHoroscopeController.dailyList!.tomorrowHoroscope![index].category == "Career"
                                                                                ? '💼 '
                                                                                : dailyHoroscopeController.dailyList!.tomorrowHoroscope![index].category == "Love"
                                                                                    ? "❤️ "
                                                                                    : dailyHoroscopeController.dailyList!.tomorrowHoroscope![index].category == "Money"
                                                                                        ? "💵 "
                                                                                        : dailyHoroscopeController.dailyList!.tomorrowHoroscope![index].category == "Health"
                                                                                            ? "🩺 "
                                                                                            : "✈️ ",
                                                                            style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w400)),
                                                                        Text('${dailyHoroscopeController.dailyList!.tomorrowHoroscope![index].category}', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w400)).translate(),
                                                                      ],
                                                                    ),
                                                                    Text('${dailyHoroscopeController.dailyList!.tomorrowHoroscope![index].percent}%'),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                FutureBuilder(
                                                                  future: global.showHtml(
                                                                    html: '${dailyHoroscopeController.dailyList!.tomorrowHoroscope![index].description}',
                                                                    style: {
                                                                      "html": Style(color: Colors.grey),
                                                                    },
                                                                  ),
                                                                  builder: (context, snapshot) {
                                                                    return snapshot.data ?? const SizedBox();
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                ],
                                              )
                                            : const SizedBox()
                                        : const SizedBox()
                          ],
                        ),
                      ),
                    ),
                    dailyHoroscopeController.dailyList!.tomorrowInsight!.isNotEmpty || dailyHoroscopeController.dailyList!.todayInsight!.isNotEmpty || dailyHoroscopeController.dailyList!.yeasterdayInsight!.isNotEmpty ? Text('Daily Horosope Insights', style: Get.textTheme.subtitle1).translate() : const SizedBox(),
                    dailyHoroscopeController.day == 1
                        ? dailyHoroscopeController.dailyList!.yeasterdayInsight!.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: dailyHoroscopeController.dailyList!.yeasterdayInsight!.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          dailyHoroscopeController.dailyList!.yeasterdayInsight![index].coverImage != ""
                                              ? Container(
                                                  height: 150,
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.all(8),
                                                  child: Image.network(
                                                    // ignore: prefer_const_constructors, prefer_if_null_operators
                                                    '${global.imgBaseurl}${dailyHoroscopeController.dailyList!.yeasterdayInsight![index].coverImage != null ? dailyHoroscopeController.dailyList!.yeasterdayInsight![index].coverImage : SizedBox()}',
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : const SizedBox(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: RotatedBox(
                                              quarterTurns: 45,
                                              child: ClipPath(
                                                clipper: MultiplePointsClipper(Sides.bottom, heightOfPoint: 10, numberOfPoints: 1),
                                                child: Container(
                                                  width: 20,
                                                  height: 135,
                                                  decoration: BoxDecoration(
                                                      color: Get.theme.primaryColor,
                                                      borderRadius: const BorderRadius.only(
                                                        bottomRight: Radius.circular(10),
                                                      )),
                                                  alignment: Alignment.topCenter,
                                                  padding: const EdgeInsets.only(top: 5),
                                                  child: RotatedBox(
                                                    quarterTurns: -45,
                                                    child: Text(
                                                      '${dailyHoroscopeController.dailyList!.yeasterdayInsight![index].name}',
                                                      textAlign: TextAlign.center,
                                                      style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                        fontSize: 10,
                                                      ),
                                                    ).translate(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "\"${dailyHoroscopeController.dailyList!.yeasterdayInsight![index].title} \"",
                                            style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                                          ).translate(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          FutureBuilder(
                                            future: global.showHtml(
                                              html: dailyHoroscopeController.dailyList!.yeasterdayInsight![index].description ?? '',
                                            ),
                                            builder: (context, snapshot) {
                                              return snapshot.data ?? const SizedBox();
                                            },
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              String link = dailyHoroscopeController.dailyList!.yeasterdayInsight![index].link.toString();
                                              print(link);
                                              if (link == "") {
                                              } else {
                                                if (await canLaunchUrl(Uri.parse(link))) {
                                                  await launchUrl(Uri.parse(link));
                                                }
                                              }
                                            },
                                            style: ButtonStyle(
                                              padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                                              backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                            child: Text('Watch ${dailyHoroscopeController.dailyList!.yeasterdayInsight![index].title}', style: Get.textTheme.subtitle1!.copyWith(fontSize: 12, fontWeight: FontWeight.w500)).translate(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                            : dailyHoroscopeController.day == 2
                                // ignore: unnecessary_null_comparison
                                ? dailyHoroscopeController.dailyList!.todayHoroscope![1] != null
                                    ? Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 150,
                                                width: double.infinity,
                                                padding: const EdgeInsets.all(8),
                                                child: Image.network(
                                                  '${global.imgBaseurl}${dailyHoroscopeController.dailyList!.todayInsight![1].coverImage}',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Align(
                                                alignment: Alignment.bottomRight,
                                                child: RotatedBox(
                                                  quarterTurns: 45,
                                                  child: ClipPath(
                                                    clipper: MultiplePointsClipper(Sides.bottom, heightOfPoint: 10, numberOfPoints: 1),
                                                    child: Container(
                                                      width: 20,
                                                      height: 135,
                                                      decoration: BoxDecoration(
                                                          color: Get.theme.primaryColor,
                                                          borderRadius: const BorderRadius.only(
                                                            bottomRight: Radius.circular(10),
                                                          )),
                                                      alignment: Alignment.topCenter,
                                                      padding: const EdgeInsets.only(top: 5),
                                                      child: RotatedBox(
                                                        quarterTurns: -45,
                                                        child: Text(
                                                          'Movie of the Day',
                                                          textAlign: TextAlign.center,
                                                          style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                            fontSize: 10,
                                                          ),
                                                        ).translate(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "\"${dailyHoroscopeController.dailyList!.todayInsight![1].title} \"",
                                                style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                                              ).translate(),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              FutureBuilder(
                                                future: global.showHtml(
                                                  html: dailyHoroscopeController.dailyList!.todayInsight![1].description ?? '',
                                                  style: {
                                                    "html": Style(color: Colors.grey),
                                                  },
                                                ),
                                                builder: (context, snapshot) {
                                                  return snapshot.data ?? const SizedBox();
                                                },
                                              ),
                                              TextButton(
                                                onPressed: () {},
                                                style: ButtonStyle(
                                                  padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                                                  backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                                  shape: MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                  ),
                                                ),
                                                child: Text('Watch Movie', style: Get.textTheme.subtitle1!.copyWith(fontSize: 12, fontWeight: FontWeight.w500)).translate(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : dailyHoroscopeController.day == 1
                                        // ignore: unnecessary_null_comparison
                                        ? dailyHoroscopeController.dailyList!.tomorrowHoroscope![2] != null
                                            ? Card(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        height: 150,
                                                        width: double.infinity,
                                                        padding: const EdgeInsets.all(8),
                                                        child: Image.network(
                                                          '${global.imgBaseurl}${dailyHoroscopeController.dailyList!.tomorrowInsight![2].coverImage}',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Align(
                                                        alignment: Alignment.bottomRight,
                                                        child: RotatedBox(
                                                          quarterTurns: 45,
                                                          child: ClipPath(
                                                            clipper: MultiplePointsClipper(Sides.bottom, heightOfPoint: 10, numberOfPoints: 1),
                                                            child: Container(
                                                              width: 20,
                                                              height: 135,
                                                              decoration: BoxDecoration(
                                                                  color: Get.theme.primaryColor,
                                                                  borderRadius: const BorderRadius.only(
                                                                    bottomRight: Radius.circular(10),
                                                                  )),
                                                              alignment: Alignment.topCenter,
                                                              padding: const EdgeInsets.only(top: 5),
                                                              child: RotatedBox(
                                                                quarterTurns: -45,
                                                                child: Text(
                                                                  'Movie of the Day',
                                                                  textAlign: TextAlign.center,
                                                                  style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                                    fontSize: 10,
                                                                  ),
                                                                ).translate(),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        "\"${dailyHoroscopeController.dailyList!.tomorrowInsight![2].title} \"",
                                                        style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                                                      ).translate(),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        '${dailyHoroscopeController.dailyList!.tomorrowInsight![2].description}',
                                                        style: Get.theme.primaryTextTheme.bodySmall!.copyWith(fontSize: 13, color: Colors.grey),
                                                      ).translate(),
                                                      TextButton(
                                                        onPressed: () {},
                                                        style: ButtonStyle(
                                                          padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                                                          backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                                          shape: MaterialStateProperty.all(
                                                            RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                          ),
                                                        ),
                                                        child: Text('Watch Movie', style: Get.textTheme.subtitle1!.copyWith(fontSize: 12, fontWeight: FontWeight.w500)).translate(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : const SizedBox()
                                        : const SizedBox()
                                : const SizedBox()
                        : dailyHoroscopeController.day == 2
                            // ignore: unnecessary_null_comparison
                            ? dailyHoroscopeController.dailyList!.todayInsight!.isNotEmpty
                                ? ListView.builder(
                                    itemCount: dailyHoroscopeController.dailyList!.todayInsight!.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 150,
                                                width: double.infinity,
                                                padding: const EdgeInsets.all(8),
                                                child: Image.network(
                                                  '${global.imgBaseurl}${dailyHoroscopeController.dailyList!.todayInsight![index].coverImage}',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Align(
                                                alignment: Alignment.bottomRight,
                                                child: RotatedBox(
                                                  quarterTurns: 45,
                                                  child: ClipPath(
                                                    clipper: MultiplePointsClipper(Sides.bottom, heightOfPoint: 10, numberOfPoints: 1),
                                                    child: Container(
                                                      width: 20,
                                                      height: 135,
                                                      decoration: BoxDecoration(
                                                          color: Get.theme.primaryColor,
                                                          borderRadius: const BorderRadius.only(
                                                            bottomRight: Radius.circular(10),
                                                          )),
                                                      alignment: Alignment.topCenter,
                                                      padding: const EdgeInsets.only(top: 5),
                                                      child: RotatedBox(
                                                        quarterTurns: -45,
                                                        child: Text(
                                                          '${dailyHoroscopeController.dailyList!.todayInsight![index].name}',
                                                          textAlign: TextAlign.center,
                                                          style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                            fontSize: 10,
                                                          ),
                                                        ).translate(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "\"${dailyHoroscopeController.dailyList!.todayInsight![index].title} \"",
                                                style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                                              ).translate(),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              FutureBuilder(
                                                future: global.showHtml(
                                                  html: '${dailyHoroscopeController.dailyList!.todayInsight![index].description}',
                                                ),
                                                builder: (context, snapshot) {
                                                  return snapshot.data ?? const SizedBox();
                                                },
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  String link = dailyHoroscopeController.dailyList!.todayInsight![index].link.toString();
                                                  print(link);
                                                  if (link == "") {
                                                  } else {
                                                    if (await canLaunchUrl(Uri.parse(link))) {
                                                      await launchUrl(Uri.parse(link));
                                                    }
                                                  }
                                                },
                                                style: ButtonStyle(
                                                  padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                                                  backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                                  shape: MaterialStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                  ),
                                                ),
                                                child: Text('Watch ${dailyHoroscopeController.dailyList!.todayInsight![index].title}', style: Get.textTheme.subtitle1!.copyWith(fontSize: 12, fontWeight: FontWeight.w500)).translate(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                : const SizedBox()
                            : dailyHoroscopeController.day == 3
                                // ignore: unnecessary_null_comparison
                                ? dailyHoroscopeController.dailyList!.tomorrowInsight!.isNotEmpty
                                    ? ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: dailyHoroscopeController.dailyList!.tomorrowInsight!.length,
                                        itemBuilder: (context, index) {
                                          return Card(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 150,
                                                    width: double.infinity,
                                                    padding: const EdgeInsets.all(8),
                                                    child: Image.network(
                                                      '${global.imgBaseurl}${dailyHoroscopeController.dailyList!.tomorrowInsight![index].coverImage}',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Align(
                                                    alignment: Alignment.bottomRight,
                                                    child: RotatedBox(
                                                      quarterTurns: 45,
                                                      child: ClipPath(
                                                        clipper: MultiplePointsClipper(Sides.bottom, heightOfPoint: 10, numberOfPoints: 1),
                                                        child: Container(
                                                          width: 20,
                                                          height: 135,
                                                          decoration: BoxDecoration(
                                                              color: Get.theme.primaryColor,
                                                              borderRadius: const BorderRadius.only(
                                                                bottomRight: Radius.circular(10),
                                                              )),
                                                          alignment: Alignment.topCenter,
                                                          padding: const EdgeInsets.only(top: 5),
                                                          child: RotatedBox(
                                                            quarterTurns: -45,
                                                            child: Text(
                                                              '${dailyHoroscopeController.dailyList!.tomorrowInsight![index].name}',
                                                              textAlign: TextAlign.center,
                                                              style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                                fontSize: 10,
                                                              ),
                                                            ).translate(),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "\"${dailyHoroscopeController.dailyList!.tomorrowInsight![index].title} \"",
                                                    style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
                                                  ).translate(),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  FutureBuilder(
                                                    future: global.showHtml(
                                                      html: dailyHoroscopeController.dailyList!.tomorrowInsight![index].description ?? '',
                                                    ),
                                                    builder: (context, snapshot) {
                                                      return snapshot.data ?? const SizedBox();
                                                    },
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      String link = dailyHoroscopeController.dailyList!.tomorrowInsight![index].link.toString();
                                                      print(link);
                                                      if (link == "") {
                                                      } else {
                                                        if (await canLaunchUrl(Uri.parse(link))) {
                                                          await launchUrl(Uri.parse(link));
                                                        }
                                                      }
                                                    },
                                                    style: ButtonStyle(
                                                      padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                                                      backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
                                                      shape: MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Watch ${dailyHoroscopeController.dailyList!.tomorrowInsight![index].title}',
                                                      style: Get.textTheme.subtitle1!.copyWith(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ).translate(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        })
                                    : const SizedBox()
                                : const SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              dailyHoroscopeController.updateTimely(month: false, week: true, year: false);
                            },
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                              decoration: BoxDecoration(
                                color: dailyHoroscopeController.isWeek ? const Color.fromARGB(255, 247, 243, 214) : Colors.transparent,
                                border: Border.all(color: dailyHoroscopeController.isWeek ? Get.theme.primaryColor : Colors.grey),
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                              ),
                              child: Text('''Weekly \n Horoscope''', textAlign: TextAlign.center, style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)).translate(),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              dailyHoroscopeController.updateTimely(month: true, week: false, year: false);
                            },
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                              decoration: BoxDecoration(
                                color: dailyHoroscopeController.isMonth ? const Color.fromARGB(255, 247, 243, 214) : Colors.transparent,
                                border: Border.all(color: dailyHoroscopeController.isMonth ? Get.theme.primaryColor : Colors.grey),
                              ),
                              child: Text(
                                '''Monthly \n Horoscope''',
                                textAlign: TextAlign.center,
                                style: Get.textTheme.subtitle1!.copyWith(fontSize: 12),
                              ).translate(),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              dailyHoroscopeController.updateTimely(month: false, week: false, year: true);
                            },
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                              decoration: BoxDecoration(
                                color: dailyHoroscopeController.isYear ? const Color.fromARGB(255, 247, 243, 214) : Colors.transparent,
                                border: Border.all(color: dailyHoroscopeController.isYear ? Get.theme.primaryColor : Colors.grey),
                                borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                              ),
                              child: Text(
                                '''Yearly \n Horoscope''',
                                textAlign: TextAlign.center,
                                style: Get.textTheme.subtitle1!.copyWith(fontSize: 12),
                              ).translate(),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Get.theme.primaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: dailyHoroscopeController.isWeek
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      'Weekly Horoscope',
                                      style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ).translate(),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Expanded(
                                        child: Divider(
                                          color: Colors.black,
                                          height: 10,
                                          indent: 200,
                                          endIndent: 10,
                                        ),
                                      ),
                                      Text(DateFormat('dd MMM yyyy').format(DateTime.now()), style: Get.textTheme.subtitle1!.copyWith(fontSize: 13, color: Colors.grey)),
                                      const Expanded(
                                        child: Divider(
                                          color: Colors.black,
                                          height: 10,
                                          indent: 200,
                                          endIndent: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: dailyHoroscopeController.dailyList!.weeklyHoroScope!.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${dailyHoroscopeController.dailyList!.weeklyHoroScope![index].title}',
                                              style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),
                                            ).translate(),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            FutureBuilder(
                                              future: global.showHtml(
                                                html: dailyHoroscopeController.dailyList!.weeklyHoroScope![index].description ?? '',
                                                style: {
                                                  "html": Style(color: Colors.grey),
                                                },
                                              ),
                                              builder: (context, snapshot) {
                                                return snapshot.data ?? const SizedBox();
                                              },
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        );
                                      })
                                ],
                              ),
                            )
                          : dailyHoroscopeController.isMonth
                              ? dailyHoroscopeController.dailyList == null
                                  ? const SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Monthly Horoscope',
                                            style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
                                          ).translate(),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Expanded(
                                                child: Divider(
                                                  color: Colors.black,
                                                  height: 10,
                                                  indent: 200,
                                                  endIndent: 10,
                                                ),
                                              ),
                                              Text(DateFormat('MMMM yyy').format(DateTime.now()), style: Get.textTheme.subtitle1!.copyWith(fontSize: 13, color: Colors.grey)),
                                              const Expanded(
                                                child: Divider(
                                                  color: Colors.black,
                                                  height: 10,
                                                  indent: 200,
                                                  endIndent: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: dailyHoroscopeController.dailyList!.monthlyHoroScope!.length,
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      dailyHoroscopeController.dailyList!.monthlyHoroScope![index].title!,
                                                      style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),
                                                    ).translate(),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    FutureBuilder(
                                                      future: global.showHtml(
                                                        html: dailyHoroscopeController.dailyList!.monthlyHoroScope![index].description ?? '',
                                                      ),
                                                      builder: (context, snapshot) {
                                                        return snapshot.data ?? const SizedBox();
                                                      },
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                );
                                              })
                                        ],
                                      ),
                                    )
                              : dailyHoroscopeController.isYear
                                  ? dailyHoroscopeController.dailyList != null
                                      ? TimeWiseHoroscopeWidget(
                                          dailyHoroscopeModel: dailyHoroscopeController.dailyList!,
                                        )
                                      : const SizedBox()
                                  : const SizedBox(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 60,
                    )
                  ]);
          }),
        )));
  }
}
