//flutter
// ignore_for_file: file_names

import 'package:astrologer_app/constants/imageConst.dart';
import 'package:flutter/material.dart';
//controllers
import 'package:astrologer_app/controllers/splashController.dart';
//models
//packages
import 'package:get/get.dart';

import 'package:astrologer_app/utils/global.dart' as global;
import '../BaseRoute/baseRoute.dart';

class SplashScreen extends BaseRoute {
  //a - analytics
  //o - observer
  SplashScreen({a, o}) : super();

  final SplashController customerController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage("assets/images/splash_background.jpg"),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(IMAGECONST.splashImage),
              ),
              const SizedBox(
                height: 15,
              ),
              global.appName != ""
                  ? Text(
                      global.appName,
                      style: Get.textTheme.headline5,
                    )
                  : const CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}
