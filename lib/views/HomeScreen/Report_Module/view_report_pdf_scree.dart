import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/controllers/Authentication/signup_controller.dart';
import 'package:astrologer_app/models/History/report_history_model.dart';
import 'package:astrologer_app/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:astrologer_app/utils/global.dart' as global;

class ViewReportPdfScreen extends StatelessWidget {
  final ReportHistoryModel? reportHistoryData;
  ViewReportPdfScreen({Key? key, this.reportHistoryData}) : super(key: key);
  final SignupController signupController = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(
          height: 80,
          backgroundColor: COLORS().primaryColor,
          title: const Text("PDF"),
        ),
        body: SfPdfViewer.network(
          '${global.pdfBaseurl}${reportHistoryData!.reportFile}',
          enableDocumentLinkAnnotation: false,
        ),
      ),
    );
  }
}
