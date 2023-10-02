// ignore_for_file: avoid_print

import 'package:astrologer_app/services/apiHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;

import '../models/app_review_model.dart';

class AppReviewController extends GetxController {
  final TextEditingController feedbackController = TextEditingController();
  APIHelper apiHelper = APIHelper();
  var clientReviews = <AppReviewModel>[];

  getAppReview() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAppReview().then((result) {
            if (result.status == "200") {
              clientReviews = result.recordList;
              update();
            } else {
              global.showToast(message: 'Failed to get client testimonals');
            }
          });
        }
      });
    } catch (e) {
      print("Exception in  getAppReview:-$e");
    }
  }

  addFeedback(String review) async {
    var appReviewModel = {
      "appId": global.reviewAppId,
      "review": review,
    };
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.addAppFeedback(appReviewModel).then((result) async {
            if (result.status == "200") {
              feedbackController.text = '';
              global.showToast(message: 'Thank you!');
              await getAppReview();
            } else {
              global.showToast(message: 'Failed to add feedback');
            }
          });
        }
      });
    } catch (e) {
      print("Exception in addFeedback():- $e");
    }
  }
}
