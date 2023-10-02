// ignore_for_file: file_names, must_be_immutable, avoid_print, prefer_interpolation_to_compose_strings

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/constants/messageConst.dart';
import 'package:astrologer_app/controllers/HomeController/wallet_controller.dart';
import 'package:astrologer_app/models/wallet_model.dart';
import 'package:astrologer_app/views/HomeScreen/Drawer/Wallet/add_amount_screen.dart';
import 'package:astrologer_app/views/HomeScreen/home_screen.dart';
import 'package:astrologer_app/widgets/app_bar_widget.dart';
import 'package:astrologer_app/widgets/common_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';
import 'package:astrologer_app/utils/global.dart' as global;

class WalletScreen extends StatelessWidget {
  WalletScreen({super.key});
  WalletController walletController = Get.find<WalletController>();

  WalletModel walletModel = WalletModel();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.to(() => HomeScreen());
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: MyCustomAppBar(
          height: 80,
          title: const Text("Wallet screen").translate(),
          backgroundColor: COLORS().primaryColor,
        ),
        body: GetBuilder<WalletController>(
          builder: (walletController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: SizedBox(
                      child: Column(
                        children: [
                          Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Get.theme.primaryColor),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const Icon(
                                    Icons.account_balance_wallet_outlined,
                                    color: Colors.black,
                                    size: 70,
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Center(
                                      child: Text(
                                        'Wallet Amount ',
                                        style: Theme.of(context).textTheme.subtitle2,
                                      ).translate(),
                                    ),
                                  ),
                                  subtitle: SizedBox(
                                    height: 50,
                                    child: Card(
                                      shadowColor: COLORS().primaryColor,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ',
                                            style: Get.theme.textTheme.bodyText1,
                                          ),
                                          Text(
                                            walletController.withdraw.walletAmount != null ? walletController.withdraw.walletAmount!.toStringAsFixed(0) : " 0",
                                            style: Get.theme.textTheme.bodyText1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  trailing: walletController.withdraw.walletAmount != null
                                      ? GestureDetector(
                                          onTap: () {
                                            walletController.updateAmountId = null;
                                            walletController.clearAmount();

                                            Get.to(() => AddAmountScreen());
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Get.theme.primaryColor,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                'Withdraw',
                                                style: Get.theme.textTheme.subtitle2,
                                              ).translate(),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ),
                                const Divider(color: Colors.black, thickness: 2),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            'Pending\n Withdraw',
                                            style: Theme.of(context).textTheme.subtitle2,
                                            textAlign: TextAlign.center,
                                          ).translate(),
                                          SizedBox(
                                            height: 50,
                                            child: Card(
                                              shadowColor: COLORS().primaryColor,
                                              child: Padding(
                                                padding: const EdgeInsets.all(5),
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ',
                                                        style: Get.theme.textTheme.bodyText1,
                                                      ),
                                                      Text(
                                                        walletController.withdraw.totalPending != null ? walletController.withdraw.totalPending.toString() : "0",
                                                        style: Get.theme.textTheme.bodyText1,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            'Withdraw\nAmount',
                                            style: Theme.of(context).textTheme.subtitle2,
                                            textAlign: TextAlign.center,
                                          ).translate(),
                                          SizedBox(
                                            height: 50,
                                            child: Card(
                                              shadowColor: COLORS().primaryColor,
                                              child: Padding(
                                                padding: const EdgeInsets.all(5),
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ',
                                                        style: Get.theme.textTheme.bodyText1,
                                                      ),
                                                      Text(
                                                        walletController.withdraw.withdrawAmount != null ? walletController.withdraw.withdrawAmount! : "0",
                                                        style: Get.theme.textTheme.bodyText1,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            'Total\nEarning',
                                            style: Theme.of(context).textTheme.subtitle2,
                                            textAlign: TextAlign.center,
                                          ).translate(),
                                          SizedBox(
                                            height: 50,
                                            child: Card(
                                              shadowColor: COLORS().primaryColor,
                                              child: Padding(
                                                padding: const EdgeInsets.all(5),
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ',
                                                        style: Get.theme.textTheme.bodyText1,
                                                      ),
                                                      Text(
                                                        walletController.withdraw.totalEarning != null ? walletController.withdraw.totalEarning.toString() : " 0",
                                                        style: Get.theme.textTheme.bodyText1,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: DefaultTabController(
                              initialIndex: 0,
                              length: 2,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: TabBar(
                                        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                                        labelColor: Colors.black,
                                        unselectedLabelColor: Colors.grey,
                                        isScrollable: true,
                                        indicatorSize: TabBarIndicatorSize.label,
                                        indicatorColor: Get.theme.primaryColor,
                                        labelPadding: EdgeInsets.zero,
                                        indicator: BoxDecoration(
                                          color: COLORS().primaryColor,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          ),
                                        ),
                                        tabs: [
                                          FutureBuilder(
                                              future: global.translatedText("Withdraw History"),
                                              builder: (context, snapshot) {
                                                return SizedBox(
                                                  width: Get.width * 0.4,
                                                  child: Tab(
                                                    text: snapshot.data ?? 'Withdraw History',
                                                  ),
                                                );
                                              }),
                                          FutureBuilder(
                                              future: global.translatedText("Wallet History"),
                                              builder: (context, snapshot) {
                                                return SizedBox(
                                                  width: Get.width * 0.4,
                                                  child: Tab(
                                                    text: snapshot.data ?? 'Wallet History',
                                                  ),
                                                );
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: SizedBox(
                                        height: Get.height * 0.45,
                                        child: TabBarView(
                                          physics: const NeverScrollableScrollPhysics(),
                                          children: [
                                            walletController.withdraw.walletModel!.isEmpty && walletController.withdraw.walletModel == null
                                                ? Center(
                                                    child: const Text("You don't have any withdraw history here!").translate(),
                                                  )
                                                : RefreshIndicator(
                                                    onRefresh: () async {
                                                      await walletController.getAmountList();
                                                      walletController.update();
                                                    },
                                                    child: ListView.builder(
                                                      itemCount: walletController.withdraw.walletModel!.length,
                                                      shrinkWrap: true,
                                                      itemBuilder: (context, index) {
                                                        return Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ',
                                                                            style: Get.theme.textTheme.bodyText1,
                                                                          ),
                                                                          Text(
                                                                            walletController.withdraw.walletModel![index].withdrawAmount.toString(),
                                                                            style: Get.theme.textTheme.bodyText1,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 5),
                                                                        child: Row(
                                                                          children: [
                                                                            const Icon(
                                                                              Icons.schedule,
                                                                              color: Colors.black,
                                                                              size: 12,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 4),
                                                                              child: Text(
                                                                                DateFormat('hh:mm a').format(DateTime.parse(walletController.withdraw.walletModel![index].createdAt.toString())),
                                                                                style: Get.theme.textTheme.bodyText2,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                            DateFormat('dd-MM-yyyy').format(DateTime.parse(walletController.withdraw.walletModel![index].createdAt.toString())),
                                                                            style: Get.theme.textTheme.bodyText2,
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(top: 5),
                                                                            child: Text(
                                                                              walletController.withdraw.walletModel![index].status!,
                                                                              style: Get.theme.textTheme.bodyText2,
                                                                            ).translate(),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      walletController.withdraw.walletModel![index].status == 'Pending'
                                                                          ? Padding(
                                                                              padding: const EdgeInsets.only(left: 10),
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  walletController.fillAmount(walletController.withdraw.walletModel![index]);
                                                                                  walletController.updateAmountId = walletController.withdraw.walletModel![index].id;
                                                                                  Get.to(() => AddAmountScreen());

                                                                                  walletController.update();
                                                                                },
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    color: Get.theme.primaryColor,
                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(10),
                                                                                    child: Text(
                                                                                      'Update',
                                                                                      style: Get.theme.textTheme.subtitle2,
                                                                                    ).translate(),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : const SizedBox(),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const Divider(color: Colors.black),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                            walletController.withdraw.walletTransactionModel!.isEmpty && walletController.withdraw.walletTransactionModel == null
                                                ? Center(
                                                    child: const Text("You don't have any wallet transation history here!").translate(),
                                                  )
                                                : RefreshIndicator(
                                                    onRefresh: () async {
                                                      await walletController.getAmountList();
                                                      walletController.update();
                                                    },
                                                    child: ListView.builder(
                                                      itemCount: walletController.withdraw.walletTransactionModel!.length,
                                                      shrinkWrap: true,
                                                      itemBuilder: (context, index) {
                                                        return Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            'Amount : ',
                                                                            style: Get.theme.textTheme.bodyText1,
                                                                          ).translate(),
                                                                          Text(
                                                                            '${global.getSystemFlagValue(global.systemFlagNameList.currency)} ${walletController.withdraw.walletTransactionModel![index].amount.toString()}',
                                                                            style: Get.theme.textTheme.bodyText2,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top: 5),
                                                                        child: Row(
                                                                          children: [
                                                                            Text(
                                                                              'Transaction type : ',
                                                                              style: Get.theme.textTheme.bodyText1,
                                                                            ).translate(),
                                                                            Text(
                                                                              walletController.withdraw.walletTransactionModel![index].transactionType.toString(),
                                                                              style: Get.theme.textTheme.bodyText2,
                                                                            ).translate(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(top: 5),
                                                                            child: Text(
                                                                              DateFormat('dd-MM-yyyy').format(DateTime.parse(walletController.withdraw.walletTransactionModel![index].createdAt.toString())),
                                                                              style: Get.theme.textTheme.bodyText2,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const Divider(color: Colors.black),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  //Withdraw amount
  void withdrawAmount({int? index}) {
    try {
      Get.defaultDialog(
        title: walletController.updateAmountId != null ? 'UPDATE AN AMOUNT' : 'ADD AN AMOUNT',
        titleStyle: Get.theme.textTheme.subtitle2,
        content: Column(
          children: [
            Icon(
              Icons.account_balance_outlined,
              size: 50,
              color: COLORS().blackColor,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CommonTextFieldWidget(
                textEditingController: walletController.cWithdrawAmount,
                hintText: "Add Amount",
                keyboardType: TextInputType.number,
                formatter: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 10,
                counterText: '',
                prefix: Icon(
                  Icons.currency_rupee_outlined,
                  color: Get.theme.primaryColor,
                  size: 25,
                ),
              ),
            )
          ],
        ),
        confirm: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ElevatedButton(
            onPressed: () {
              if (walletController.updateAmountId != null) {
                if (double.parse(walletController.cWithdrawAmount.text) <= double.parse(walletController.withdraw.walletAmount.toString())) {
                  walletController.updateAmount(walletController.withdraw.walletModel![index!].id!);
                } else {
                  global.showToast(message: "Please enter a valid amount");
                }
              } else {
                if (double.parse(walletController.cWithdrawAmount.text) <= double.parse(walletController.withdraw.walletAmount.toString())) {
                  walletController.addAmount();
                } else {
                  global.showToast(message: "Please enter a valid amount");
                }
              }
              walletController.getAmountList();
              walletController.update();
            },
            child: const Text(MessageConstants.WITHDRAW).translate(),
          ),
        ),
      );
      walletController.update();
    } catch (e) {
      print('Exception :  Wallet_screen - withdrawAmount() :' + e.toString());
    }
  }
}
