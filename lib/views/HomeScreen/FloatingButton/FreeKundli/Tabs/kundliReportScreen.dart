// ignore_for_file: file_names

import 'package:astrologer_app/views/HomeScreen/FloatingButton/FreeKundli/Tabs/reportTabs/doshaReport.dart';
import 'package:astrologer_app/views/HomeScreen/FloatingButton/FreeKundli/Tabs/reportTabs/generalReportScreen.dart';
import 'package:astrologer_app/views/HomeScreen/FloatingButton/FreeKundli/Tabs/reportTabs/remediesKundli.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class KundliReportScreen extends StatelessWidget {
  const KundliReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(indicatorColor: Get.theme.primaryColor, tabs: [
            Container(height: 35, alignment: Alignment.center, child: const Text('General', style: TextStyle(fontSize: 13)).translate()),
            Container(height: 35, alignment: Alignment.center, child: const Text('Remedies', style: TextStyle(fontSize: 13)).translate()),
            Container(height: 35, alignment: Alignment.center, child: const Text('Dosha', style: TextStyle(fontSize: 13)).translate()),
          ]),
          SizedBox(
            height: Get.height - 180,
            child: TabBarView(
              children: [GeneralReport(), RemediesKundli(), DoshaReport()],
            ),
          )
        ],
      ),
    );
  }
}
