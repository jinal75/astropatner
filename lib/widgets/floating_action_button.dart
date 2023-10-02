import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/controllers/dailyHoroscopeController.dart';
import 'package:astrologer_app/views/HomeScreen/FloatingButton/AstroBlog/astrology_blog_screen.dart';
import 'package:astrologer_app/views/HomeScreen/FloatingButton/DailyHoroscope/dailyHoroscopeScreen.dart';
import 'package:astrologer_app/views/HomeScreen/FloatingButton/FreeKundli/kundliScreen.dart';
import 'package:astrologer_app/views/HomeScreen/FloatingButton/KundliMatching/kundli_matching_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:astrologer_app/utils/global.dart' as global;

import '../controllers/HomeController/astrology_blog_controller.dart';
import '../controllers/splashController.dart';

class FloatingActionButtonWidget extends StatefulWidget {
  const FloatingActionButtonWidget({Key? key}) : super(key: key);

  @override
  State<FloatingActionButtonWidget> createState() => _FloatingActionButtonWidgetState();
}

class _FloatingActionButtonWidgetState extends State<FloatingActionButtonWidget> with SingleTickerProviderStateMixin {
  AnimationController? controller;
  String dailyHOroscopeText = "Daily Horoscope";
  String kundliText = "";
  String kundaliMatchingText = "";
  String blogText = "";
  SplashController splashController = Get.find<SplashController>();
  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      controller: controller,
      closedBackgroundColor: Colors.purple,
      closedForegroundColor: Colors.indigoAccent,
      openBackgroundColor: Colors.cyan,
      openForegroundColor: Colors.orange,
      labelsStyle: Theme.of(context).primaryTextTheme.subtitle1,
      labelsBackgroundColor: COLORS().primaryColor,
      speedDialChildren: <SpeedDialChild>[
        SpeedDialChild(
          child: CircleAvatar(
            radius: 20,
            backgroundColor: COLORS().primaryColor,
            child: CircleAvatar(
              radius: 19,
              backgroundColor: COLORS().primaryColor,
              child: Image.asset(
                'assets/images/daily_horoscope.png',
              ),
            ),
          ),
          label: dailyHOroscopeText,
          onPressed: () async {
            Get.find<DailyHoroscopeController>().selectZodic(0);
            await Get.find<DailyHoroscopeController>().getHoroscopeList(horoscopeId: Get.find<DailyHoroscopeController>().signId);
            Get.to(() => DailyHoroscopeScreen());
          },
          closeSpeedDialOnPressed: true,
        ),
        SpeedDialChild(
          child: CircleAvatar(
            radius: 20,
            backgroundColor: COLORS().primaryColor,
            child: CircleAvatar(
              radius: 19,
              backgroundColor: COLORS().primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset('assets/images/free_kundli.png'),
              ),
            ),
          ),
          label: kundliText,
          onPressed: () async {
            Get.to(() => const KundaliScreen());
          },
          closeSpeedDialOnPressed: true,
        ),
        SpeedDialChild(
          child: CircleAvatar(
            radius: 20,
            backgroundColor: COLORS().primaryColor,
            child: CircleAvatar(
              radius: 19,
              backgroundColor: COLORS().primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset('assets/images/kundli_matching.png'),
              ),
            ),
          ),
          label: kundaliMatchingText,
          onPressed: () async {
            Get.to(() => KundliMatchingScreen());
          },
          closeSpeedDialOnPressed: true,
        ),
        SpeedDialChild(
          child: CircleAvatar(
            radius: 20,
            backgroundColor: COLORS().primaryColor,
            child: CircleAvatar(
              backgroundColor: COLORS().primaryColor,
              radius: 19,
              child: Image.asset('assets/images/astrology_blog.png'),
            ),
          ),
          label: blogText,
          onPressed: () async {
            AstrologyBlogController blogController = Get.find<AstrologyBlogController>();
            global.showOnlyLoaderDialog();
            blogController.astrologyBlogs = [];
            blogController.astrologyBlogs.clear();
            blogController.isAllDataLoaded = false;
            blogController.update();
            await blogController.getAstrologyBlog("", false);
            global.hideLoader();
            Get.to(() => AstrologyBlogScreen());
          },
          closeSpeedDialOnPressed: true,
        ),
      ],
      child: GestureDetector(
        onTap: () async {
          if (controller!.isDismissed) {
            global.showOnlyLoaderDialog();
            dailyHOroscopeText = await global.translatedText('Daily Horoscope');
            if (splashController.currentLanguageCode == 'hi') {
              kundliText = await global.translatedText('मुफ्त कुंडली');
              kundaliMatchingText = await global.translatedText('कुंडली मिलान');
            } else {
              kundliText = await global.translatedText('Free kundli');
              kundaliMatchingText = await global.translatedText('Kundli Matching');
            }

            blogText = await global.translatedText('Astrology Blog');
            setState(() {});
            global.hideLoader();
            controller!.forward();
          } else {
            controller!.reverse();
          }
        },
        child: CircleAvatar(
          backgroundColor: COLORS().primaryColor,
          radius: 28,
          child: CircleAvatar(
            radius: 23,
            backgroundColor: COLORS().primaryColor,
            child: const Icon(
              FontAwesomeIcons.wandMagicSparkles,
              color: Colors.black,
              size: 25,
            ),
          ),
        ),
      ),
    );
  }
}
