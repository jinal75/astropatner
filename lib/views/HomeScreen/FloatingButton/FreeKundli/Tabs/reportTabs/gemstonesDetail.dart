// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:astrologer_app/controllers/free_kundli_controller.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

// ignore: must_be_immutable
class GemstonesDetail extends StatelessWidget {
  GemstonesDetail({Key? key}) : super(key: key);
  KundliController kundliController = Get.find<KundliController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Life Stone', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold)).translate(),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Life Stone', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500)).translate(),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('You will be connected to your concerned Astrologer via the chat window. You have to provide your name and gotra for sankalp You will be connected to your concerned Astrologer via the chat window. You have to provide your name and gotra for sankalp', style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)).translate(),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: 100,
                                        child: Text(
                                          'life stone',
                                          style: Get.textTheme.bodyText2!.copyWith(fontSize: 10),
                                        ).translate()),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    Expanded(
                                        child: Text(
                                      '${kundliController.gemstoneList!.lifeStone!.name}',
                                      style: Get.textTheme.bodyText2!.copyWith(fontSize: 10),
                                    ).translate()),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                color: const Color.fromARGB(255, 238, 235, 212),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: 100,
                                        child: Text(
                                          'How to wear',
                                          style: Get.textTheme.bodyText2!.copyWith(fontSize: 10),
                                        ).translate()),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    Expanded(
                                        child: Text(
                                      '${kundliController.gemstoneList!.lifeStone!.wearMetal}, ${kundliController.gemstoneList!.lifeStone!.wearFinger}',
                                      style: Get.textTheme.bodyText2!.copyWith(fontSize: 10),
                                    ).translate()),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Lucky Stone', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold)).translate(),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Lucky Gemstone', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500)).translate(),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('You will be connected to your concerned Astrologer via the chat window. You have to provide your name and gotra for sankalp You will be connected to your concerned Astrologer via the chat window. You have to provide your name and gotra for sankalp', style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)).translate(),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: 100,
                                        child: Text(
                                          'life stone',
                                          style: Get.textTheme.bodyText2!.copyWith(fontSize: 10),
                                        ).translate()),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    Expanded(
                                        child: Text(
                                      '${kundliController.gemstoneList!.luckyStone!.name}',
                                      style: Get.textTheme.bodyText2!.copyWith(fontSize: 10),
                                    ).translate()),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                color: const Color.fromARGB(255, 238, 235, 212),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: 100,
                                        child: Text(
                                          'How to wear',
                                          style: Get.textTheme.bodyText2!.copyWith(fontSize: 10),
                                        ).translate()),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    Expanded(
                                        child: Text(
                                      '${kundliController.gemstoneList!.luckyStone!.wearMetal}, ${kundliController.gemstoneList!.luckyStone!.wearFinger}',
                                      style: Get.textTheme.bodyText2!.copyWith(fontSize: 10),
                                    ).translate()),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fortune Stone', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold)).translate(),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fortune Stone', style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500)).translate(),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('You will be connected to your concerned Astrologer via the chat window. You have to provide your name and gotra for sankalp You will be connected to your concerned Astrologer via the chat window. You have to provide your name and gotra for sankalp', style: Get.textTheme.subtitle1!.copyWith(fontSize: 12)).translate(),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: 100,
                                        child: Text(
                                          'life stone',
                                          style: Get.textTheme.bodyText2!.copyWith(fontSize: 10),
                                        ).translate()),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    Expanded(
                                        child: Text(
                                      '${kundliController.gemstoneList!.fortuneStone!.name}',
                                      style: Get.textTheme.bodyText2!.copyWith(fontSize: 10),
                                    ).translate()),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                color: const Color.fromARGB(255, 238, 235, 212),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: 100,
                                        child: Text(
                                          'How to wear',
                                          style: Get.textTheme.bodyText2!.copyWith(fontSize: 10),
                                        ).translate()),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    Expanded(
                                        child: Text(
                                      '${kundliController.gemstoneList!.fortuneStone!.wearMetal}, ${kundliController.gemstoneList!.fortuneStone!.wearFinger}',
                                      style: Get.textTheme.bodyText2!.copyWith(fontSize: 10),
                                    ).translate()),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
