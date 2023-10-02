import 'dart:math';

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/constants/messageConst.dart';
import 'package:astrologer_app/controllers/free_kundli_controller.dart';
import 'package:astrologer_app/controllers/kundli_matchig_controller.dart';
import 'package:astrologer_app/widgets/common_padding_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';

class OpenKundliScreen extends StatelessWidget {
  OpenKundliScreen({Key? key}) : super(key: key);
  final KundliMatchingController kundliMatchingController = Get.find<KundliMatchingController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CommonPadding2(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<KundliController>(builder: (kundliController) {
              return FutureBuilder(
                  future: global.translatedText("Search Kundli by name"),
                  builder: (context, snapshot) {
                    return SizedBox(
                      height: 40,
                      child: TextFormField(
                        onChanged: (value) {
                          kundliController.searchKundli(value);
                        },
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                          helperStyle: TextStyle(color: COLORS().primaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: COLORS().primaryColor),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          hintText: snapshot.data ?? "Search Kundli by name",
                          prefixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Recently Opened",
                style: Theme.of(context).primaryTextTheme.subtitle1,
              ).translate(),
            ),
            Expanded(
              child: GetBuilder<KundliController>(builder: (kundliController) {
                return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                  itemCount: kundliController.searchKundliList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        kundliMatchingController.openKundliData(kundliController.searchKundliList, index);
                        kundliMatchingController.onHomeTabBarIndexChanged(1);
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                          radius: 20,
                          child: Text(
                            kundliController.searchKundliList[index].name[0],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              kundliController.searchKundliList[index].name,
                              style: Theme.of(context).primaryTextTheme.headline3,
                            ).translate(),
                            Text(
                              "${DateFormat("dd MMM yyyy").format(kundliController.searchKundliList[index].birthDate)},${kundliController.searchKundliList[index].birthTime}",
                              style: Theme.of(context).primaryTextTheme.subtitle2,
                            ),
                            Text(
                              kundliController.searchKundliList[index].birthPlace,
                              style: Theme.of(context).primaryTextTheme.subtitle2,
                            ).translate(),
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Get.dialog(
                              AlertDialog(
                                title: const Text("Are you sure you want to permanently delete this kundli?").translate(),
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text(MessageConstants.CANCEL).translate(),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        global.showOnlyLoaderDialog();
                                        await kundliController.deleteKundli(kundliController.searchKundliList[index].id!);
                                        await kundliController.getKundliList();
                                        Get.back();
                                        global.hideLoader();
                                      },
                                      child: const Text(MessageConstants.YES).translate(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
