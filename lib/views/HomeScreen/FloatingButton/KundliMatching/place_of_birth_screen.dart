// ignore_for_file: avoid_print

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/controllers/free_kundli_controller.dart';
import 'package:astrologer_app/controllers/kundli_matchig_controller.dart';
import 'package:astrologer_app/controllers/search_place_controller.dart';
import 'package:astrologer_app/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:astrologer_app/utils/global.dart' as global;

// ignore: must_be_immutable
class PlaceOfBirthSearchScreen extends StatelessWidget {
  final int? flagId;
  PlaceOfBirthSearchScreen({Key? key, this.flagId}) : super(key: key);

  KundliController kundliController = Get.find<KundliController>();

  KundliMatchingController kundliMatchingController = Get.find<KundliMatchingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: MyCustomAppBar(
          height: 80,
          title: const Text("Place of Birth").translate(),
          backgroundColor: COLORS().primaryColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetBuilder<SearchPlaceController>(builder: (searchPlaceController) {
          return Column(
            children: [
              SizedBox(
                height: 40,
                child: FutureBuilder(
                    future: global.translatedText("Search City"),
                    builder: (context, snapshot) {
                      return TextField(
                        onChanged: (value) async {
                          await searchPlaceController.autoCompleteSearch(value);
                        },
                        controller: searchPlaceController.searchController,
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
                            hintText: snapshot.data ?? 'Search City',
                            hintStyle: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500)),
                      );
                    }),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: searchPlaceController.predictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const CircleAvatar(
                        child: Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(searchPlaceController.predictions[index].description ?? "null"),
                      onTap: () async {
                        List<Location> location = await locationFromAddress(searchPlaceController.predictions[index].description.toString());
                        kundliController.lat = location[0].latitude;
                        kundliController.long = location[0].longitude;

                        kundliMatchingController.lat = location[0].latitude;
                        kundliMatchingController.long = location[0].longitude;
                        print('${location[0].latitude} :- location');
                        print('${location[0].longitude} :- location');
                        await kundliController.getGeoCodingLatLong(latitude: location[0].latitude, longitude: location[0].latitude);
                        searchPlaceController.searchController.text = searchPlaceController.predictions[index].description!;
                        searchPlaceController.update();
                        kundliController.birthKundliPlaceController.text = searchPlaceController.predictions[index].description!;
                        kundliController.update();
                        kundliController.editBirthPlaceController.text = searchPlaceController.predictions[index].description!;
                        kundliController.update();
                        if (flagId == 1) {
                          kundliMatchingController.cBoysBirthPlace.text = searchPlaceController.predictions[index].description!;
                          kundliMatchingController.update();
                        }
                        if (flagId == 2) {
                          kundliMatchingController.cGirlBirthPlace.text = searchPlaceController.predictions[index].description!;
                          kundliMatchingController.update();
                        }
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
