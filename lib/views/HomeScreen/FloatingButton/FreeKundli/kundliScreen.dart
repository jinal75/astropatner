// ignore_for_file: file_names

import 'dart:math';

import 'package:astrologer_app/controllers/free_kundli_controller.dart';
import 'package:astrologer_app/views/HomeScreen/FloatingButton/FreeKundli/createNewKundli.dart';
import 'package:astrologer_app/views/HomeScreen/FloatingButton/FreeKundli/editKundliScreen.dart';
import 'package:astrologer_app/views/HomeScreen/FloatingButton/FreeKundli/kundliDetailsScreen.dart';
import 'package:astrologer_app/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';
import 'package:astrologer_app/utils/global.dart' as global;

class KundaliScreen extends StatelessWidget {
  const KundaliScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: MyCustomAppBar(
        height: 80,
        title: const Text("Kundli").translate(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetBuilder<KundliController>(builder: (kundliController) {
                return FutureBuilder(
                    future: global.translatedText("Search kundli by name"),
                    builder: (context, snapshot) {
                      return SizedBox(
                        height: 38,
                        child: TextField(
                          onChanged: (value) {
                            kundliController.searchKundli(value);
                          },
                          cursorColor: const Color(0xFF757575),
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                          decoration: InputDecoration(
                              isDense: true,
                              prefixIcon: Icon(
                                Icons.search,
                                color: Get.theme.iconTheme.color,
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                              ),
                              hintText: snapshot.data ?? 'Search kundli by name',
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                        ),
                      );
                    });
              }),
              GetBuilder<KundliController>(builder: (kundliController) {
                return kundliController.searchKundliList.isEmpty
                    ? Column(
                        children: [
                          Container(
                              height: 500,
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              alignment: Alignment.center,
                              child: const Text(
                                'Result not found',
                                style: TextStyle(fontSize: 18),
                              ).translate()),
                        ],
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: kundliController.searchKundliList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              DateTime dateBasic = kundliController.searchKundliList[index].birthDate;
                              int formattedYear = int.parse(DateFormat('yyyy').format(dateBasic));
                              int formattedDay = int.parse(DateFormat('dd').format(dateBasic));
                              int formattedMonth = int.parse(DateFormat('MM').format(dateBasic));
                              int formattedHour = int.parse(DateFormat('HH').format(dateBasic));
                              int formattedMint = int.parse(DateFormat('mm').format(dateBasic));
                              await kundliController.getReportDescDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: kundliController.searchKundliList[index].latitude, lon: kundliController.searchKundliList[index].longitude, tzone: kundliController.searchKundliList[index].timezone);
                              await kundliController.getSadesatiDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: kundliController.searchKundliList[index].latitude, lon: kundliController.searchKundliList[index].longitude, tzone: kundliController.searchKundliList[index].timezone);
                              await kundliController.getKalsarpaDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: kundliController.searchKundliList[index].latitude, lon: kundliController.searchKundliList[index].longitude, tzone: kundliController.searchKundliList[index].timezone);
                              await kundliController.getGemstoneDetail(day: formattedDay, hour: formattedHour, min: formattedMint, month: formattedMonth, year: formattedYear, lat: kundliController.searchKundliList[index].latitude, lon: kundliController.searchKundliList[index].longitude, tzone: kundliController.searchKundliList[index].timezone);
                              await kundliController.getGeoCodingLatLong(latitude: kundliController.searchKundliList[index].latitude, longitude: kundliController.searchKundliList[index].longitude);
                              Get.to(() => KundliDetailsScreen(usreDetails: kundliController.searchKundliList[index]));
                            },
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(8),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                                  child: Text(
                                    kundliController.searchKundliList[index].name[0],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  kundliController.searchKundliList[index].name,
                                  style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500, color: Colors.black),
                                ).translate(),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${DateFormat("dd MMM yyyy").format(kundliController.searchKundliList[index].birthDate)},${kundliController.searchKundliList[index].birthTime}', style: Get.textTheme.subtitle1!.copyWith(fontSize: 12, color: Colors.grey)),
                                    Text(
                                      kundliController.searchKundliList[index].birthPlace,
                                      style: Get.textTheme.subtitle1!.copyWith(fontSize: 12, color: Colors.grey),
                                    ).translate(),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        global.showOnlyLoaderDialog();
                                        await kundliController.getKundliListById(index);
                                        global.hideLoader();
                                        Get.to(() => EditKundliScreen(id: kundliController.searchKundliList[index].id!));
                                      },
                                      child: const CircleAvatar(
                                        backgroundColor: Color.fromARGB(255, 235, 231, 231),
                                        radius: 12,
                                        child: Icon(Icons.edit, size: 14, color: Colors.black),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.dialog(
                                          AlertDialog(
                                            title: Text(
                                              "Are you sure you want to permanently delete this kundli?",
                                              style: Get.textTheme.bodyText2,
                                            ).translate(),
                                            content: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: Text(
                                                    'CANCEL',
                                                    style: TextStyle(color: Get.theme.primaryColor),
                                                  ).translate(),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    global.showOnlyLoaderDialog();
                                                    await kundliController.deleteKundli(kundliController.searchKundliList[index].id!);
                                                    await kundliController.getKundliList();
                                                    Get.back();
                                                    global.hideLoader();
                                                  },
                                                  child: Text('YES', style: TextStyle(color: Get.theme.primaryColor)).translate(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      child: const CircleAvatar(
                                        backgroundColor: Color.fromARGB(255, 235, 231, 231),
                                        radius: 12,
                                        child: Icon(Icons.delete, size: 14, color: Colors.red),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
              })
            ],
          ),
        ),
      ),
      bottomSheet: SizedBox(
        height: 60,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
              backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            onPressed: () {
              KundliController kundliController = Get.find<KundliController>();
              kundliController.userName = "";
              kundliController.userNameController.clear();
              kundliController.birthKundliPlaceController.clear();
              kundliController.selectedGender = null;
              kundliController.selectedDate = null;
              kundliController.selectedTime = null;
              kundliController.isDisable = true;
              kundliController.initialIndex = 0;
              kundliController.updateIcon(0);
              kundliController.update();
              Get.to(() => CreateNewKundki());
            },
            child: Text(
              'Create New Kundli',
              textAlign: TextAlign.center,
              style: Get.theme.primaryTextTheme.subtitle1!.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
            ).translate(),
          ),
        ),
      ),
    ));
  }
}
