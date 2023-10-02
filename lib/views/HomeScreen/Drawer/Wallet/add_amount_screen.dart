// ignore_for_file: must_be_immutable

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/controllers/HomeController/wallet_controller.dart';
import 'package:astrologer_app/views/HomeScreen/Drawer/Wallet/Wallet_screen.dart';
import 'package:astrologer_app/widgets/app_bar_widget.dart';
import 'package:astrologer_app/widgets/common_textfield_widget.dart';
import 'package:astrologer_app/widgets/primary_text_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

class AddAmountScreen extends StatelessWidget {
  AddAmountScreen({super.key});
  WalletController walletController = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.to(() => WalletScreen());
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: MyCustomAppBar(
          height: 80,
          title: const Text("Withdraw screen").translate(),
          backgroundColor: COLORS().primaryColor,
        ),
        body: GetBuilder<WalletController>(
          builder: (walletController) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: PrimaryTextWidget(text: "Enter Amount"),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: DottedBorder(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          'Choose a Bank account or UPI ID',
                          style: Get.theme.primaryTextTheme.headline4,
                        ).translate(),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Radio(
                            activeColor: COLORS().primaryColor,
                            value: 1,
                            groupValue: walletController.wallet,
                            onChanged: ((value) {
                              walletController.changeAccount(value);
                              walletController.update();
                            }),
                          ),
                          Text(
                            'Bank Account',
                            style: Theme.of(context).textTheme.subtitle2,
                          ).translate(),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            activeColor: COLORS().primaryColor,
                            value: 2,
                            groupValue: walletController.wallet,
                            onChanged: ((value) {
                              walletController.changeAccount(value);
                              walletController.update();
                            }),
                          ),
                          Text(
                            'UPI ID',
                            style: Theme.of(context).textTheme.subtitle2,
                          ).translate(),
                        ],
                      ),
                    ],
                  ),
                  walletController.wallet == 1
                      ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: PrimaryTextWidget(text: "Account number"),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: CommonTextFieldWidget(
                                  hintText: "Account number",
                                  textEditingController: walletController.cBankNumber,
                                  keyboardType: TextInputType.number,
                                  formatter: [FilteringTextInputFormatter.digitsOnly],
                                  maxLength: 16,
                                  counterText: '',
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: PrimaryTextWidget(text: "IFSC number"),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: CommonTextFieldWidget(
                                  hintText: "IFSC number",
                                  textEditingController: walletController.cIfscCode,
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: PrimaryTextWidget(text: "Holder name"),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0, bottom: 20),
                                child: CommonTextFieldWidget(
                                  hintText: "Holder name",
                                  textEditingController: walletController.cAccountHolder,
                                  keyboardType: TextInputType.text,
                                  formatter: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: PrimaryTextWidget(text: "UPI ID"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: CommonTextFieldWidget(
                                  hintText: "UPI ID",
                                  textEditingController: walletController.cUPI,
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                  //SUBMIT BUTTON
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          if (walletController.updateAmountId != null) {
                            if (walletController.cWithdrawAmount.text != "" && double.parse(walletController.cWithdrawAmount.text) <= double.parse(walletController.withdraw.walletAmount.toString())) {
                              walletController.validateUpdateAmount(walletController.updateAmountId!);
                            } else if (walletController.cWithdrawAmount.text != "" && int.parse(walletController.cWithdrawAmount.text) < int.parse(walletController.cWithdrawAmount.text)) {
                              walletController.validateUpdateAmount(walletController.updateAmountId!);
                            } else {
                              global.showToast(message: "Please enter a valid amount");
                            }
                          } else {
                            if (walletController.cWithdrawAmount.text != "" && double.parse(walletController.cWithdrawAmount.text) <= double.parse(walletController.withdraw.walletAmount.toString())) {
                              walletController.validateAmount();
                            } else {
                              global.showToast(message: "Please enter a valid amount");
                            }
                          }
                          await walletController.getAmountList();
                          walletController.update();
                        } catch (e) {
                          // ignore: avoid_print
                          print('Exception in add_amount_screen :- SUBMIT button:- $e');
                        }
                      },
                      child: const Text("SUBMIT").translate(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
