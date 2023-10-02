// ignore_for_file: file_names

import 'package:astrologer_app/constants/imageConst.dart';
import 'package:astrologer_app/views/HomeScreen/FloatingButton/DailyHoroscope/dailyHoroscopeScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

class DailyHoroscopeContainer extends StatelessWidget {
  final bool? isFreeServices;
  final String moodOfDay;
  final String? colorCode;
  final String? date;
  final String? luckyNumber;
  final String? luckyTime;
  const DailyHoroscopeContainer({Key? key, this.isFreeServices = false, this.date, this.luckyNumber, this.luckyTime, this.colorCode, required this.moodOfDay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
          image: const DecorationImage(image: AssetImage(IMAGECONST.sky), fit: BoxFit.cover),
        ),
        child: Column(children: [
          isFreeServices!
              ? const SizedBox()
              : SizedBox(
                  width: MediaQuery.of(context).size.width / 1.8,
                  height: 20,
                  child: Row(
                    children: [
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 6.0),
                          child: Divider(
                            color: Colors.white,
                            thickness: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('$date', style: Get.textTheme.subtitle1!.copyWith(color: Colors.white)),
                      const SizedBox(
                        width: 10,
                      ),
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 6.0),
                          child: Divider(
                            color: Colors.white,
                            thickness: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your Daily horoscope is ready!', style: Get.textTheme.subtitle1!.copyWith(fontSize: 13, color: Colors.white)).translate(),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      colorCode == null || colorCode == "" ? const SizedBox() : Text('Lucky Colour', style: Get.textTheme.subtitle1!.copyWith(fontSize: 10, color: Colors.white)).translate(),
                      const SizedBox(
                        width: 25,
                      ),
                      moodOfDay == "" ? const SizedBox() : Text('Mood of day', style: Get.textTheme.subtitle1!.copyWith(fontSize: 10, color: Colors.white)).translate()
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: colorCode != null ? Color(int.parse("FF$colorCode", radix: 16)) : Colors.transparent,
                        radius: 7,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      const SizedBox(
                        width: 72,
                      ),
                      Text(moodOfDay, style: Get.textTheme.subtitle1!.copyWith(fontSize: 10, color: Colors.white))
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      luckyNumber == "" ? const SizedBox() : Text('Lucky Number', style: Get.textTheme.subtitle1!.copyWith(fontSize: 10, color: Colors.white)).translate(),
                      const SizedBox(
                        width: 25,
                      ),
                      luckyTime == "" ? const SizedBox() : Text('Lucky Time', style: Get.textTheme.subtitle1!.copyWith(fontSize: 10, color: Colors.white)).translate()
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(luckyNumber ?? "", style: Get.textTheme.subtitle1!.copyWith(fontSize: 10, color: Colors.white)),
                      const SizedBox(
                        width: 88,
                      ),
                      Text(luckyTime ?? "", style: Get.textTheme.subtitle1!.copyWith(fontSize: 10, color: Colors.white))
                    ],
                  )
                ],
              ),
              CachedNetworkImage(
                height: 80,
                width: 80,
                imageUrl: '${global.imgBaseurl}${global.hororscopeSignList.firstWhere((e) => e.isSelected).image}',
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.grid_view_rounded, size: 20),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          isFreeServices!
              ? InkWell(
                  onTap: () {
                    Get.to(() => DailyHoroscopeScreen());
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                      const Text('View Your Detailed Horoscope').translate(),
                      const CircleAvatar(
                          radius: 14,
                          backgroundColor: Color.fromARGB(255, 241, 239, 221),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Colors.black,
                          ))
                    ]),
                  ),
                )
              : const SizedBox()
        ]),
      ),
    );
  }
}
