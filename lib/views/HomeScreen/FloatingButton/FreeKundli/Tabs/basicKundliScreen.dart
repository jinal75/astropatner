// ignore_for_file: file_names

import 'package:astrologer_app/controllers/free_kundli_controller.dart';
import 'package:astrologer_app/models/kundliModel.dart';
import 'package:astrologer_app/widgets/FreeKundliWidget/container_list_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

import 'package:intl/intl.dart';

class BasicKundliScreen extends StatelessWidget {
  final KundliModel? usreDetails;
  // ignore: prefer_const_constructors_in_immutables
  BasicKundliScreen({Key? key, this.usreDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetBuilder<KundliController>(builder: (kundliController) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  'Basic Details',
                  style: Get.textTheme.bodyText1,
                ).translate(),
              ),
              const SizedBox(height: 15),
              Container(
                  padding: const EdgeInsets.only(left: 1.5, right: 1.5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: kundliController.kundliBasicDetail != null
                      ? Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: const Text('Name').translate(),
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: Text('${usreDetails?.name}').translate(),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: const Text('Date').translate(),
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: Text(
                                      // ignore: unnecessary_string_interpolations
                                      "${DateFormat("dd MMMM yyyy").format(usreDetails!.birthDate)}",
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: const Text('Time').translate(),
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: Text(
                                      // ignore: unnecessary_string_interpolations
                                      "${usreDetails!.birthTime}",
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: const Text('Place').translate(),
                                  ),
                                  SizedBox(
                                    width: 180,
                                    // ignore: unnecessary_string_interpolations
                                    child: Text('${usreDetails!.birthPlace}').translate(),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: const Text('Latitude').translate(),
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: Text('${kundliController.kundliBasicDetail!.lat}').translate(),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: const Text('Longitude').translate(),
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: Text('${kundliController.kundliBasicDetail!.lon}'),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: const Text('Timezone').translate(),
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: Text('${kundliController.kundliBasicDetail!.tzone}'),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: const Text('Sunrise').translate(),
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: Text('${kundliController.kundliBasicDetail!.sunrise}'),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: const Text('Sunset').translate(),
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: Text('${kundliController.kundliBasicDetail!.sunset}'),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: const Text('Ayanamsha').translate(),
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: Text('${kundliController.kundliBasicDetail!.ayanamsha}'),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      : const SizedBox()),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Maglik Analysis',
                style: Get.textTheme.bodyText1,
              ).translate(),
              const SizedBox(
                height: 10,
              ),
              ContainerListTileWidget(
                color: Colors.green,
                title: '${usreDetails?.name}',
                doshText: 'NO',
                subTitle: '',
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Panchang Details',
                style: Get.textTheme.bodyText1,
              ).translate(),
              const SizedBox(
                height: 15,
              ),
              Container(
                  padding: const EdgeInsets.only(left: 1.5, right: 1.5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: const Text('Tithi').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliBasicPanchangDetail!.tithi}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: const Text('Karan').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliBasicPanchangDetail!.karan}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: const Text('Yog').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliBasicPanchangDetail!.yog}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: const Text('Nakshtra').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliBasicPanchangDetail!.nakshatra}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: const Text('Sunrise').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliBasicPanchangDetail!.sunrise}'),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: const Text('Sunset').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliBasicPanchangDetail!.sunset}'),
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Avakhada Details',
                style: Get.textTheme.bodyText1,
              ).translate(),
              const SizedBox(
                height: 15,
              ),
              Container(
                  padding: const EdgeInsets.only(left: 1.5, right: 1.5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: const Text('Varna').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.varna}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: const Text('Vashya').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text(
                                "${kundliController.kundliAvakhadaDetail!.vashya}",
                              ).translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: const Text('Yoni').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text(
                                "${kundliController.kundliAvakhadaDetail!.yoni}",
                              ).translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: const Text('Gan').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.gan}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: const Text('Nadi').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.nadi}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: const Text('Sign').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.sign}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: const Text('Sign Lord').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.signLord}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              child: const Text('Nakshatra-Charan').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.naksahtra}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: const Text('Yog').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.yog}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: const Text('Karan').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.karan}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: const Text('Tithi').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.tithi}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Colors.transparent),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: const Text('Yunja').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.yunja}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: const Text('Tatva').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.tatva}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Colors.transparent),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              child: const Text('Name albhabet').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.nameAlphabet}').translate(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Color.fromARGB(255, 235, 231, 198)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 90,
                              child: const Text('Paya').translate(),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text('${kundliController.kundliAvakhadaDetail!.paya}').translate(),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ],
          ),
        );
      }),
    );
  }
}
