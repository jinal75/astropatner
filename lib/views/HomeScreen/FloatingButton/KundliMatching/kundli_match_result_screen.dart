// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:astrologer_app/controllers/kundli_matchig_controller.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:astrologer_app/utils/global.dart' as global;

class KundliMatchingResultScreen extends StatelessWidget {
  KundliMatchingResultScreen({Key? key}) : super(key: key);

  KundliMatchingController kundliMatchingController = Get.find<KundliMatchingController>();
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: GetBuilder<KundliMatchingController>(builder: (c) {
            return kundliMatchingController.kundliMatchDetailList == null
                ? SizedBox(
                    height: Get.height * 0.9,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 2.8,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage("assets/images/night_star.jpg"),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: const Text(
                                    "Compatibility Score",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ).translate(),
                                ),
                                kundliMatchingController.kundliMatchDetailList == null
                                    ? const SizedBox()
                                    : SizedBox(
                                        height: 180,
                                        width: 230,
                                        child: SfRadialGauge(
                                          axes: <RadialAxis>[
                                            RadialAxis(
                                              showLabels: false,
                                              showAxisLine: false,
                                              showTicks: false,
                                              minimum: 0,
                                              maximum: 36,
                                              ranges: <GaugeRange>[
                                                GaugeRange(
                                                  startValue: 0,
                                                  endValue: 12,
                                                  color: const Color(0xFFFE2A25),
                                                  label: '',
                                                  sizeUnit: GaugeSizeUnit.factor,
                                                  labelStyle: const GaugeTextStyle(fontFamily: 'Times', fontSize: 20),
                                                  startWidth: 0.50,
                                                  endWidth: 0.50,
                                                ),
                                                GaugeRange(
                                                  startValue: 12,
                                                  endValue: 24,
                                                  color: const Color(0xFFFFBA00),
                                                  label: '',
                                                  startWidth: 0.50,
                                                  endWidth: 0.50,
                                                  sizeUnit: GaugeSizeUnit.factor,
                                                ),
                                                GaugeRange(
                                                  startValue: 24,
                                                  endValue: 36,
                                                  color: const Color(0xFF00AB47),
                                                  label: '',
                                                  sizeUnit: GaugeSizeUnit.factor,
                                                  startWidth: 0.50,
                                                  endWidth: 0.50,
                                                ),
                                              ],
                                              pointers: <GaugePointer>[
                                                NeedlePointer(
                                                  value: kundliMatchingController.kundliMatchDetailList!.totalList!.receivedPoints != null ? double.parse(kundliMatchingController.kundliMatchDetailList!.totalList!.receivedPoints.toString()) : 0.0,
                                                  needleStartWidth: 0,
                                                  needleEndWidth: 5,
                                                  needleColor: const Color(0xFFDADADA),
                                                  enableAnimation: true,
                                                ),
                                              ],
                                            )
                                          ],
                                        )),
                              ],
                            ),
                          ),
                          ListTile(
                            leading: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(
                                Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                            title: const Text(
                              "Kundli Matching",
                              style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
                            ).translate(),
                            trailing: GestureDetector(
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      insetPadding: EdgeInsets.zero,
                                      child: Screenshot(
                                        controller: screenshotController,
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: AssetImage("assets/images/night_star.jpg"),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      "assets/images/splash.png",
                                                      height: 30,
                                                      width: 30,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      global.appName,
                                                      style: const TextStyle(color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                                kundliMatchingController.isFemaleManglik == null
                                                    ? const SizedBox()
                                                    : Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Container(
                                                                  height: 70,
                                                                  width: 100,
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    border: Border.all(
                                                                      color: Colors.green,
                                                                      width: 3, /*strokeAlign: StrokeAlign.outside*/
                                                                    ),
                                                                    color: Get.theme.primaryColor,
                                                                    image: const DecorationImage(
                                                                      image: AssetImage(
                                                                        "assets/images/no_customer_image.png",
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(top: 8.0),
                                                                  child: Text(
                                                                    kundliMatchingController.cBoysName.text,
                                                                    style: Theme.of(context).primaryTextTheme.subtitle1!.copyWith(color: Colors.white),
                                                                  ),
                                                                ),
                                                                kundliMatchingController.isFemaleManglik == null
                                                                    ? const SizedBox()
                                                                    : Padding(
                                                                        padding: const EdgeInsets.only(top: 6.0),
                                                                        child: Text(
                                                                          kundliMatchingController.isFemaleManglik! ? 'Non Manglik' : 'Manglik',
                                                                          style: TextStyle(
                                                                            color: kundliMatchingController.isFemaleManglik! ? Colors.green : Colors.red,
                                                                          ),
                                                                        ),
                                                                      ),
                                                              ],
                                                            ),
                                                            Image.asset(
                                                              "assets/images/couple_ring_image.png",
                                                              scale: 8,
                                                            ),
                                                            Column(
                                                              children: [
                                                                Container(
                                                                  height: 60,
                                                                  width: 110,
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    border: Border.all(
                                                                      color: Colors.green,
                                                                      width: 3, /* strokeAlign: StrokeAlign.outside*/
                                                                    ),
                                                                    color: Get.theme.primaryColor,
                                                                    image: const DecorationImage(
                                                                      image: AssetImage(
                                                                        "assets/images/no_customer_image.png",
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(top: 8.0),
                                                                  child: Text(
                                                                    kundliMatchingController.cGirlName.text,
                                                                    style: Theme.of(context).primaryTextTheme.subtitle1!.copyWith(color: Colors.white),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(top: 9.0),
                                                                  child: Text(
                                                                    kundliMatchingController.isFemaleManglik! ? 'Non Manglik' : 'Manglik',
                                                                    style: TextStyle(
                                                                      color: kundliMatchingController.isFemaleManglik! ? Colors.green : Colors.red,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 10),
                                                  child: Text(
                                                    "Compatibility Score",
                                                    style: TextStyle(
                                                      color: Get.theme.primaryColor,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                                kundliMatchingController.kundliMatchDetailList!.totalList!.receivedPoints == null
                                                    ? const SizedBox()
                                                    : SizedBox(
                                                        height: 180,
                                                        width: 230,
                                                        child: SfRadialGauge(
                                                          axes: <RadialAxis>[
                                                            RadialAxis(
                                                              showLabels: false,
                                                              showAxisLine: false,
                                                              showTicks: false,
                                                              minimum: 0,
                                                              maximum: 36,
                                                              ranges: <GaugeRange>[
                                                                GaugeRange(
                                                                  startValue: 0,
                                                                  endValue: 12,
                                                                  color: const Color(0xFFFE2A25),
                                                                  label: '',
                                                                  sizeUnit: GaugeSizeUnit.factor,
                                                                  labelStyle: const GaugeTextStyle(fontFamily: 'Times', fontSize: 20),
                                                                  startWidth: 0.50,
                                                                  endWidth: 0.50,
                                                                ),
                                                                GaugeRange(
                                                                  startValue: 12,
                                                                  endValue: 24,
                                                                  color: const Color(0xFFFFBA00),
                                                                  label: '',
                                                                  startWidth: 0.50,
                                                                  endWidth: 0.50,
                                                                  sizeUnit: GaugeSizeUnit.factor,
                                                                ),
                                                                GaugeRange(
                                                                  startValue: 24,
                                                                  endValue: 36,
                                                                  color: const Color(0xFF00AB47),
                                                                  label: '',
                                                                  sizeUnit: GaugeSizeUnit.factor,
                                                                  startWidth: 0.50,
                                                                  endWidth: 0.50,
                                                                ),
                                                              ],
                                                              pointers: <GaugePointer>[
                                                                NeedlePointer(
                                                                  value: kundliMatchingController.kundliMatchDetailList!.totalList!.receivedPoints != null ? double.parse(kundliMatchingController.kundliMatchDetailList!.totalList!.receivedPoints.toString()) : 0.0,
                                                                  needleStartWidth: 0,
                                                                  needleEndWidth: 5,
                                                                  needleColor: const Color(0xFFDADADA),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        )),
                                                kundliMatchingController.kundliMatchDetailList!.totalList!.receivedPoints == null
                                                    ? const SizedBox()
                                                    : Container(
                                                        height: 50,
                                                        width: 100,
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(color: Colors.greenAccent),
                                                          borderRadius: BorderRadius.circular(15),
                                                        ),
                                                        child: Center(
                                                            child: RichText(
                                                          text: TextSpan(
                                                            text: '${kundliMatchingController.kundliMatchDetailList!.totalList!.receivedPoints!}/',
                                                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 24),
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                text: '${kundliMatchingController.kundliMatchDetailList!.totalList!.totalPoints!}',
                                                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 22),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                      ),
                                                kundliMatchingController.kundliMatchDetailList!.conclusionList!.report == null
                                                    ? const SizedBox()
                                                    : Container(
                                                        padding: const EdgeInsets.only(top: 8, left: 8.0, right: 8.0),
                                                        margin: const EdgeInsets.symmetric(vertical: 20),
                                                        width: MediaQuery.of(context).size.width,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(15),
                                                          border: Border.all(color: Get.theme.primaryColor),
                                                          gradient: LinearGradient(
                                                            begin: Alignment.topCenter,
                                                            end: Alignment.bottomCenter,
                                                            colors: [
                                                              Get.theme.primaryColor,
                                                              Colors.white,
                                                            ],
                                                          ),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              "${global.appName} Conclusion",
                                                              style: Theme.of(context).primaryTextTheme.subtitle1,
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                                                              child: Text(
                                                                'The overall points of this couple ${kundliMatchingController.kundliMatchDetailList!.conclusionList!.report!}',
                                                                style: const TextStyle(fontSize: 12, color: Colors.black),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                                String appShareLink;
                                FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
                                // ignore: unused_local_variable
                                String applink;
                                final DynamicLinkParameters parameters = DynamicLinkParameters(
                                  uriPrefix: 'https://astroguruupdated.page.link',
                                  link: Uri.parse("https://astroguruupdated.page.link/userProfile?screen=dailyHorscope"),
                                  androidParameters: const AndroidParameters(
                                    packageName: 'com.example.astrologer_app',
                                    minimumVersion: 1,
                                  ),
                                );
                                Uri url;
                                final ShortDynamicLink shortLink = await dynamicLinks.buildShortLink(parameters, shortLinkType: ShortDynamicLinkType.short);
                                url = shortLink.shortUrl;
                                appShareLink = url.toString();
                                applink = appShareLink;
                                Get.back(); //back from dialog
                                final temp1 = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
                                screenshotController.capture().then((image) async {
                                  if (image != null) {
                                    try {
                                      String fileName = DateTime.now().microsecondsSinceEpoch.toString();
                                      final imagePath = await File('${temp1!.path}/$fileName.png').create();
                                      // ignore: unnecessary_null_comparison
                                      if (imagePath != null) {
                                        // ignore: prefer_typing_uninitialized_variables
                                        final temp;
                                        if (Platform.isIOS) {
                                          temp = await getApplicationDocumentsDirectory();
                                        } else {
                                          temp = await getExternalStorageDirectory();
                                        }
                                        final path = '${temp!.path}/$fileName.jpg';
                                        File(path).writeAsBytesSync(image);

                                        await FlutterShare.shareFile(filePath: path, title: global.appName, text: "Check out the ${global.getSystemFlagValue(global.systemFlagNameList.appName)} marriage compatibility report for ${kundliMatchingController.cBoysName.text} and ${kundliMatchingController.cGirlName.text}. Get your free Matchnaking report here: $appShareLink").then((value) {}).catchError((e) {
                                          // ignore: avoid_print
                                          print(e);
                                        });
                                      }
                                    } catch (e) {
                                      // ignore: avoid_print
                                      print('Exception in match sharing $e');
                                    }
                                  }
                                }).catchError((onError) {
                                  // ignore: avoid_print
                                  print('Error --->> $onError');
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                width: 90,
                                decoration: BoxDecoration(
                                  color: Get.theme.primaryColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: FittedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Share",
                                        style: Theme.of(context).primaryTextTheme.subtitle1,
                                      ).translate(),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Icon(
                                          Icons.share,
                                          color: Colors.green,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          kundliMatchingController.kundliMatchDetailList!.totalList!.receivedPoints != null
                              ? Positioned(
                                  bottom: -25,
                                  left: MediaQuery.of(context).size.width / 2.8,
                                  child: Container(
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.greenAccent),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                          child: RichText(
                                        text: TextSpan(
                                          text: '${kundliMatchingController.kundliMatchDetailList?.totalList!.receivedPoints!}/',
                                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 24),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: '${kundliMatchingController.kundliMatchDetailList!.totalList!.totalPoints!}',
                                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 22),
                                            ),
                                          ],
                                        ),
                                      ))),
                                )
                              : const SizedBox()
                        ],
                      ),
//----------------------Details-----------------------

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 40.0, bottom: 20),
                              child: Center(
                                child: Text(
                                  "Details",
                                  style: Theme.of(context).primaryTextTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500, fontSize: 18),
                                ).translate(),
                              ),
                            ),
//------------------Card-------------------------------

                            kundliMatchingController.kundliMatchDetailList!.varnaList!.received_points == null
                                ? const SizedBox()
                                : Container(
                                    width: Get.width,
                                    decoration: BoxDecoration(color: const Color(0xfffff6f1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey, width: 1)),
                                    child: kundliMatchingController.kundliMatchDetailList == null
                                        ? const SizedBox()
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Compatibility (Varna)",
                                                        style: Theme.of(context).primaryTextTheme.subtitle1,
                                                      ).translate(),
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 8.0, right: 5),
                                                        child: const Text(
                                                          "Varna refers to the mental compatility of the two persons involed. it holds nominal effect in the matters of marriage",
                                                          style: TextStyle(fontSize: 12, color: Colors.black),
                                                          textAlign: TextAlign.justify,
                                                        ).translate(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                CircularPercentIndicator(
                                                  radius: 35.0,
                                                  lineWidth: 5.0,
                                                  percent: kundliMatchingController.kundliMatchDetailList!.varnaList!.received_points! / 1,
                                                  center: Text(
                                                    "${kundliMatchingController.kundliMatchDetailList!.varnaList!.received_points!.toStringAsFixed(0)}/${kundliMatchingController.kundliMatchDetailList!.varnaList!.total_points!.toStringAsFixed(0)}",
                                                    style: const TextStyle(color: Color(0xfffca47c), fontWeight: FontWeight.bold, fontSize: 16),
                                                  ),
                                                  progressColor: const Color(0xfffca47c),
                                                )
                                              ],
                                            ),
                                          )),
                            kundliMatchingController.kundliMatchDetailList!.bhakutList!.received_points == null
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Container(
                                        width: Get.width,
                                        decoration: BoxDecoration(color: const Color(0xffeffaf4), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey, width: 1)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Love (Bhakut)",
                                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                                    ).translate(),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0, right: 5),
                                                      child: const Text(
                                                        "Bhaukt is related to the couple's joys and sorrows together and assesses the wealth and health after their wedding.",
                                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                                        textAlign: TextAlign.justify,
                                                      ).translate(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              CircularPercentIndicator(
                                                radius: 35.0,
                                                lineWidth: 5.0,
                                                percent: kundliMatchingController.kundliMatchDetailList!.bhakutList!.received_points! / 7,
                                                center: Text(
                                                  "${kundliMatchingController.kundliMatchDetailList!.bhakutList!.received_points!.toStringAsFixed(0)}/${kundliMatchingController.kundliMatchDetailList!.bhakutList!.total_points!.toStringAsFixed(0)}",
                                                  style: const TextStyle(color: Color(0xff70ce99), fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                                progressColor: const Color(0xff70ce99),
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                            kundliMatchingController.kundliMatchDetailList!.maitriList!.received_points == null
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Container(
                                        width: Get.width,
                                        decoration: BoxDecoration(color: const Color(0xfffcf2fd), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey, width: 1)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Mental Compatibility (Maitri)",
                                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                                    ).translate(),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0, right: 5),
                                                      child: const Text(
                                                        "Maitri assesses the mental compatibility and mutual love between the partners to be married.",
                                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                                        textAlign: TextAlign.justify,
                                                      ).translate(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              CircularPercentIndicator(
                                                radius: 35.0,
                                                lineWidth: 5.0,
                                                percent: kundliMatchingController.kundliMatchDetailList!.maitriList!.received_points! / 5,
                                                center: Text(
                                                  "${kundliMatchingController.kundliMatchDetailList!.maitriList!.received_points!.toStringAsFixed(0)}/5",
                                                  style: const TextStyle(color: Color(0xffba6ad9), fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                                progressColor: const Color(0xffba6ad9),
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                            kundliMatchingController.kundliMatchDetailList!.nadiList!.received_points == null
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Container(
                                        width: Get.width,
                                        decoration: BoxDecoration(color: const Color(0xffeef7fe), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey, width: 1)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Health (Nadi)",
                                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                                    ).translate(),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0, right: 5),
                                                      child: const Text(
                                                        "Nadi is related to the health compatibility of the couple. Matters of childbirth and progeny are also determinded with this Guna.",
                                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                                        textAlign: TextAlign.justify,
                                                      ).translate(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              CircularPercentIndicator(
                                                radius: 35.0,
                                                lineWidth: 5.0,
                                                percent: kundliMatchingController.kundliMatchDetailList!.nadiList!.received_points! / 8,
                                                center: Text(
                                                  "${kundliMatchingController.kundliMatchDetailList!.nadiList!.received_points!.toStringAsFixed(0)}/8",
                                                  style: const TextStyle(color: Color(0xff58a4f2), fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                                progressColor: const Color(0xff58a4f2),
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                            kundliMatchingController.kundliMatchDetailList!.vashyaList!.received_points == null
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Container(
                                        width: Get.width,
                                        decoration: BoxDecoration(color: const Color(0xfffff2f9), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey, width: 1)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Dominance (Vashya)",
                                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                                    ).translate(),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0, right: 5),
                                                      child: const Text(
                                                        "Vashya indicates the bride and the groom's tendency to dominate or infulence each other in marriage.",
                                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                                        textAlign: TextAlign.justify,
                                                      ).translate(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              CircularPercentIndicator(
                                                radius: 35.0,
                                                lineWidth: 5.0,
                                                percent: kundliMatchingController.kundliMatchDetailList!.vashyaList!.received_points! / 2,
                                                center: Text(
                                                  "${kundliMatchingController.kundliMatchDetailList!.vashyaList!.received_points!.toStringAsFixed(0)}/2",
                                                  style: const TextStyle(color: Color(0xffff84bb), fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                                progressColor: const Color(0xffff84bb),
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                            kundliMatchingController.kundliMatchDetailList!.ganList!.received_points == null
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Container(
                                        width: Get.width,
                                        decoration: BoxDecoration(color: const Color(0xfffff6f1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey, width: 1)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Temperament (Gana)",
                                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                                    ).translate(),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0, right: 5),
                                                      child: const Text(
                                                        "Gana is the indicator of the behaviour, character and temperament of the potential bride and groom towards each other.",
                                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                                        textAlign: TextAlign.justify,
                                                      ).translate(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              CircularPercentIndicator(
                                                radius: 35.0,
                                                lineWidth: 5.0,
                                                percent: kundliMatchingController.kundliMatchDetailList!.ganList!.received_points! / 6,
                                                center: Text(
                                                  "${kundliMatchingController.kundliMatchDetailList!.ganList!.received_points!.toStringAsFixed(0)}/6",
                                                  style: const TextStyle(color: Color(0xffffa37a), fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                                progressColor: const Color(0xffffa37a),
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                            kundliMatchingController.kundliMatchDetailList!.taraList!.received_points == null
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Container(
                                        width: Get.width,
                                        decoration: BoxDecoration(color: const Color(0xffeffaf4), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey, width: 1)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Destiny (Tara)",
                                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                                    ).translate(),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0, right: 5),
                                                      child: const Text(
                                                        "Tara is the indicator of the birth star compatibility of the bride and the groom. It also indicates the fortune of the couple.",
                                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                                        textAlign: TextAlign.justify,
                                                      ).translate(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              CircularPercentIndicator(
                                                radius: 35.0,
                                                lineWidth: 5.0,
                                                percent: kundliMatchingController.kundliMatchDetailList!.taraList!.received_points! / 3,
                                                center: Text(
                                                  "${kundliMatchingController.kundliMatchDetailList!.taraList!.received_points!.toStringAsFixed(0)}/3",
                                                  style: const TextStyle(color: Color(0xff70ce99), fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                                progressColor: const Color(0xff70ce99),
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                            kundliMatchingController.kundliMatchDetailList!.yoniList!.received_points == null
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Container(
                                        width: Get.width,
                                        decoration: BoxDecoration(color: const Color(0xfffcf2fd), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey, width: 1)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Physical compatibility (Yoni)",
                                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                                    ).translate(),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0, right: 5),
                                                      child: const Text(
                                                        "Yoni is the indicator of the sexual or physical compatibility between the bride and the groom in question.",
                                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                                        textAlign: TextAlign.justify,
                                                      ).translate(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              CircularPercentIndicator(
                                                radius: 35.0,
                                                lineWidth: 5.0,
                                                percent: kundliMatchingController.kundliMatchDetailList!.yoniList!.received_points! / 4,
                                                center: Text(
                                                  "${kundliMatchingController.kundliMatchDetailList!.yoniList!.received_points!.toStringAsFixed(0)}/4",
                                                  style: const TextStyle(color: Color(0xffbb6bda), fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                                progressColor: const Color(0xffbb6bda),
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
//----------------------------------Manglik Report-------------------------------------
                            kundliMatchingController.isFemaleManglik == null
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                                    child: Text(
                                      "Manglik Report",
                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                    ).translate(),
                                  ),
                            kundliMatchingController.isFemaleManglik == null
                                ? const SizedBox()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            height: 70,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.green,
                                                width: 3, /*strokeAlign: StrokeAlign.outside*/
                                              ),
                                              color: Get.theme.primaryColor,
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                  "assets/images/no_customer_image.png",
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              kundliMatchingController.cBoysName.text,
                                              style: Theme.of(context).primaryTextTheme.subtitle1,
                                            ).translate(),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 9.0),
                                            child: Text(
                                              kundliMatchingController.isFemaleManglik! ? 'Non Manglik' : 'Manglik',
                                              style: TextStyle(
                                                color: kundliMatchingController.isFemaleManglik! ? Colors.green : Colors.red,
                                              ),
                                            ).translate(),
                                          ),
                                        ],
                                      ),
                                      Image.asset(
                                        "assets/images/couple_ring_image.png",
                                        scale: 8,
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            height: 70,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.green,
                                                width: 3, /* strokeAlign: StrokeAlign.outside*/
                                              ),
                                              color: Get.theme.primaryColor,
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                  "assets/images/no_customer_image.png",
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              kundliMatchingController.cGirlName.text,
                                              style: Theme.of(context).primaryTextTheme.subtitle1,
                                            ).translate(),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 9.0),
                                            child: Text(
                                              kundliMatchingController.isFemaleManglik! ? 'Non Manglik' : 'Manglik',
                                              style: TextStyle(
                                                color: kundliMatchingController.isFemaleManglik! ? Colors.green : Colors.red,
                                              ),
                                            ).translate(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
//--------------------------Conclusion-------------------------------------
                            kundliMatchingController.kundliMatchDetailList!.conclusionList!.report == null
                                ? const SizedBox()
                                : Container(
                                    padding: const EdgeInsets.only(top: 8, left: 8.0, right: 8.0),
                                    margin: const EdgeInsets.symmetric(vertical: 20),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Get.theme.primaryColor),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Get.theme.primaryColor,
                                          Colors.white,
                                        ],
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Astrotalk Conclusion",
                                          style: Theme.of(context).primaryTextTheme.subtitle1,
                                        ).translate(),
                                        kundliMatchingController.kundliMatchDetailList == null
                                            ? const SizedBox()
                                            : Padding(
                                                padding: const EdgeInsets.only(top: 10.0),
                                                child: Text(
                                                  'The overall points of this couple ${kundliMatchingController.kundliMatchDetailList!.conclusionList!.report!}',
                                                  style: const TextStyle(fontSize: 12, color: Colors.black),
                                                ).translate(),
                                              ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                                          child: Image.asset(
                                            "assets/images/couple_image.png",
                                            scale: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ],
                  );
          }),
        ),
      ),
    );
  }
}
