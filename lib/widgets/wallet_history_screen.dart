// ignore_for_file: must_be_immutable

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/controllers/Authentication/signup_controller.dart';
import 'package:astrologer_app/controllers/HomeController/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';

class WalletHistoryScreen extends StatelessWidget {
  WalletHistoryScreen({Key? key}) : super(key: key);
  WalletController walletController = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GetBuilder<SignupController>(
      builder: (signupController) {
        return signupController.astrologerList.isEmpty
            ? SizedBox(
                child: Center(
                  child: const Text('Please Wait!!!!').translate(),
                ),
              )
            : signupController.astrologerList[0].wallet!.isEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 10, bottom: 200),
                        child: ElevatedButton(
                          onPressed: () async {
                            signupController.astrologerList.clear();
                            await signupController.astrologerProfileById(false);
                            signupController.update();
                          },
                          child: const Icon(
                            Icons.refresh_outlined,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Center(
                        child: const Text("You don't have any history yet!").translate(),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 10, right: 10),
                        child: Text("Available Balance", style: TextStyle(color: COLORS().blackColor, fontWeight: FontWeight.w400, fontSize: 15)).translate(),
                      ),
                      GetBuilder<WalletController>(
                        builder: (walletController) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              walletController.withdraw.walletAmount != null ? '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ${walletController.withdraw.walletAmount!.toStringAsFixed(0)}' : " 0",
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 20),
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      Expanded(
                        child: GetBuilder<SignupController>(
                          builder: (signupController) {
                            return RefreshIndicator(
                              onRefresh: () async {
                                await signupController.astrologerProfileById(false);
                                signupController.update();
                              },
                              child: ListView.builder(
                                itemCount: signupController.astrologerList[0].wallet!.length,
                                controller: signupController.walletHistoryScrollController,
                                physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    width: width,
                                    child: Column(
                                      children: [
                                        Card(
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: Get.width * 0.7,
                                                      child: signupController.astrologerList[0].wallet![index].transactionType == 'Gift'
                                                          ? Text(
                                                              signupController.astrologerList[0].wallet![index].name != null ? 'Recived gift from ${signupController.astrologerList[0].wallet![index].name}' : "Recived gift from user",
                                                              style: Get.theme.primaryTextTheme.headline3,
                                                              textAlign: TextAlign.justify,
                                                            ).translate()
                                                          : signupController.astrologerList[0].wallet![index].transactionType == 'Call'
                                                              ? Text(
                                                                  signupController.astrologerList[0].wallet![index].name != null ? '${signupController.astrologerList[0].wallet![index].transactionType}ed with ${signupController.astrologerList[0].wallet![index].name == '' ? 'user' : signupController.astrologerList[0].wallet![index].name} for ${signupController.astrologerList[0].wallet![index].totalMin!} minutes' : "Recived gift",
                                                                  style: Get.theme.primaryTextTheme.headline3,
                                                                  textAlign: TextAlign.justify,
                                                                ).translate()
                                                              : signupController.astrologerList[0].wallet![index].transactionType == 'Chat'
                                                                  ? Text(
                                                                      signupController.astrologerList[0].wallet![index].name != null ? '${signupController.astrologerList[0].wallet![index].transactionType}ed with ${signupController.astrologerList[0].wallet![index].name == '' ? 'user' : signupController.astrologerList[0].wallet![index].name} for ${signupController.astrologerList[0].wallet![index].totalMin!} minutes' : "Recived gift",
                                                                      style: Get.theme.primaryTextTheme.headline3,
                                                                      textAlign: TextAlign.justify,
                                                                    ).translate()
                                                                  : signupController.astrologerList[0].wallet![index].transactionType == 'Report'
                                                                      ? Text(
                                                                          signupController.astrologerList[0].wallet![index].name != null ? '${signupController.astrologerList[0].wallet![index].transactionType} Request from ${signupController.astrologerList[0].wallet![index].name == '' ? 'user' : signupController.astrologerList[0].wallet![index].name}' : "Report request from user",
                                                                          style: Get.theme.primaryTextTheme.headline3,
                                                                          textAlign: TextAlign.justify,
                                                                        ).translate()
                                                                      : Text(
                                                                          signupController.astrologerList[0].wallet![index].name != null ? '${signupController.astrologerList[0].wallet![index].transactionType} with ${signupController.astrologerList[0].wallet![index].name!} for ${signupController.astrologerList[0].wallet![index].totalMin!} minutes' : "Recived gift",
                                                                          style: Get.theme.primaryTextTheme.headline3,
                                                                          textAlign: TextAlign.justify,
                                                                        ).translate(),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 2),
                                                      child: Text(
                                                        DateFormat('dd MMM yyyy , hh:mm a').format(DateTime.parse(signupController.astrologerList[0].wallet![index].createdAt!.toString())),
                                                        style: Get.theme.primaryTextTheme.subtitle2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  ' ${global.getSystemFlagValue(global.systemFlagNameList.currency)} ${signupController.astrologerList[0].wallet![index].amount}',
                                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        signupController.isMoreDataAvailable == true && !signupController.isAllDataLoaded && signupController.astrologerList[0].wallet!.length - 1 == index ? const CircularProgressIndicator() : const SizedBox(),
                                        index == signupController.astrologerList[0].wallet!.length - 1
                                            ? const SizedBox(
                                                height: 20,
                                              )
                                            : const SizedBox()
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
      },
    );
  }
}
