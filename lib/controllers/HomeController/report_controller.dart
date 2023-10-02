// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

import 'package:astrologer_app/models/report_model.dart';
import 'package:astrologer_app/services/apiHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;

class ReportController extends GetxController {
  String screen = 'report_controller.dart';
  APIHelper apiHelper = APIHelper();
  List<ReportModel> reportList = [];

  ReportModel reportModel = ReportModel();
  String? reportFile;

  ScrollController scrollController = ScrollController();
  int fetchRecord = 20;
  int startIndex = 0;
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isMoreDataAvailable = false;

  @override
  // ignore: unnecessary_overrides
  void onInit() async {
    super.onInit();
  }

//Report list
  Future getReportList(bool isLazyLoading) async {
    try {
      startIndex = 0;
      if (reportList.isNotEmpty) {
        startIndex = reportList.length;
      }
      if (!isLazyLoading) {
        isDataLoaded = false;
      }
      await global.checkBody().then(
        (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            int id = global.user.id ?? 0;
            await apiHelper.getReportRequest(id, startIndex, fetchRecord).then(
              (result) {
                global.hideLoader();
                if (result.status == "200") {
                  reportList.addAll(result.recordList);
                  print('report list length ${reportList.length} ');
                  if (result.recordList.length == 0) {
                    isMoreDataAvailable = false;
                    isAllDataLoaded = true;
                  }
                  update();
                } else {
                  global.showToast(message: "No report list is here");
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - getReportList():-' + e.toString());
    }
  }
}
