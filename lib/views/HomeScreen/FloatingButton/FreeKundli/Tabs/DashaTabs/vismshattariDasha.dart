// ignore_for_file: file_names

import 'package:astrologer_app/controllers/free_kundli_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class VismshattariDasha extends StatelessWidget {
  const VismshattariDasha({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetBuilder<KundliController>(builder: (kundliController) {
        return ListView(
          shrinkWrap: true,
          children: [
            const Text('Mahadasha').translate(),
            Container(
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 248, 242, 205),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: DataTable(
                columnSpacing: 20,
                dataTextStyle: Get.textTheme.bodyText2!.copyWith(fontSize: 10),
                horizontalMargin: 10,
                headingRowHeight: 48,
                columns: [
                  DataColumn(
                    label: const Text('Planet', textAlign: TextAlign.center).translate(),
                  ),
                  DataColumn(label: const Text('Start Date', textAlign: TextAlign.center).translate()),
                  DataColumn(
                    label: const Text('End Date', textAlign: TextAlign.center).translate(),
                  ),
                ],
                border: const TableBorder(
                  verticalInside: BorderSide(color: Colors.grey),
                  horizontalInside: BorderSide(color: Colors.grey),
                ),
                rows: kundliController.listOfVishattari // Loops through dataColumnText, each iteration assigning the value to element
                    .map(
                      ((element) => DataRow(
                            color: MaterialStateProperty.all(Colors.white),
                            cells: <DataCell>[
                              DataCell(Center(child: Text(element["planet"]!))),
                              DataCell(Center(
                                  child: Text(
                                element["start"]!,
                              ))),
                              DataCell(Center(
                                  child: Row(
                                children: [
                                  Text(element["end"]!),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 10,
                                    color: Colors.grey,
                                  )
                                ],
                              ))),
                            ],
                          )),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      }),
    );
  }
}
