// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:io';
import 'package:astrologer_app/controllers/HomeController/report_controller.dart';
import 'package:astrologer_app/models/report_model.dart';
import 'package:astrologer_app/report/open_file.dart';
import 'package:astrologer_app/services/apiHelper.dart';
import 'package:get/get.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:astrologer_app/utils/global.dart' as global;

class ReportDetailController extends GetxController {
  ReportController reportController = Get.find<ReportController>();
  String screen = 'report_detail_controller.dart';
  String? path;

  int? reoprtId;

  APIHelper apiHelper = APIHelper();

  ReportModel report = ReportModel();
  String? reportFile;

//Select pdf from storage file
  Future selectPDF() async {
    try {
      FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedFileExtensions: ['pdf', 'doc', 'docx'],
        invalidFileNameSymbols: ['/'],
      );

      path = await FlutterDocumentPicker.openDocument(params: params);

      update();
      print("---->>>> $path");
      return File(path!);
    } catch (e) {
      print('Exception - $screen - selectPDF():' + e.toString());
    }
  }

//View file
  void viewFile(File file) {
    OpenFile.open(file.path);
  }

  //Send report
  Future reportSent(int id) async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            report.id = id;
            report.reportFile = path;
            final bytes = File(path!).readAsBytesSync();
            String file64 = base64Encode(bytes);
            await apiHelper.sendReport(id, file64).then(
              (result) async {
                global.hideLoader();
                if (result.status == "200") {
                  report = result.recordList;
                  global.showToast(message: 'Report uploaded successfully');
                  reportController.reportList.clear();
                  reportController.isAllDataLoaded = false;
                  update();
                  await reportController.getReportList(false);
                  Get.back();
                } else {
                  global.showToast(message: result.message.toString());
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - reportSent():-' + e.toString());
    }
  }
}
