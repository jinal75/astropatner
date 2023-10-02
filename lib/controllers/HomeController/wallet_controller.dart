// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, prefer_typing_uninitialized_variables

import 'package:astrologer_app/models/wallet_model.dart';
import 'package:astrologer_app/services/apiHelper.dart';
import 'package:astrologer_app/views/HomeScreen/Drawer/Wallet/Wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;

class WalletController extends GetxController {
  String screen = 'wallet_controller.dart';
  APIHelper apiHelper = APIHelper();

  //Bank account
  final cBankNumber = TextEditingController();
  final cIfscCode = TextEditingController();
  final cAccountHolder = TextEditingController();
  final cUPI = TextEditingController();

  final cWithdrawAmount = TextEditingController();
  double? amount;

  int? updateAmountId;

  WalletModel walletModel = WalletModel();
  Withdraw withdraw = Withdraw();

  int? wallet; //Radio button value

  @override
  void onInit() {
    super.onInit();
    wallet = 1;
  }

  //choose Bank or UPI
  void changeAccount(int? index) {
    try {
      wallet = index;
      update();
    } catch (e) {
      print('Exception - $screen - changeAccount() :' + e.toString());
    }
  }

  //clear amount
  clearAmount() {
    cWithdrawAmount.text = '';
    cBankNumber.text = '';
    cIfscCode.text = '';
    cAccountHolder.text = '';
    cUPI.text = '';
  }

  //fill amount
  fillAmount(WalletModel walletModel) {
    if (walletModel.withdrawAmount != null) {
      cWithdrawAmount.text = walletModel.withdrawAmount.toString();
    }
    if (walletModel.accountNumber != null || walletModel.accountNumber!.isNotEmpty) {
      cBankNumber.text = walletModel.accountNumber.toString();
    }
    if (walletModel.ifscCode != null || walletModel.ifscCode!.isNotEmpty) {
      cIfscCode.text = walletModel.ifscCode.toString();
    }
    if (walletModel.accountHolderName != null || walletModel.accountHolderName!.isNotEmpty) {
      cAccountHolder.text = walletModel.accountHolderName.toString();
    }
    if (walletModel.upiId != null || walletModel.upiId!.isNotEmpty) {
      cUPI.text = walletModel.upiId.toString();
    }
  }

  validateAmount() {
    try {
      if (cWithdrawAmount.text != "" && (wallet == 1 && cBankNumber.text != "") && (wallet == 1 && cIfscCode.text != "") && (wallet == 1 && cAccountHolder.text != "") || (wallet == 2 && cUPI.text != "")) {
        addAmount();
      } else if (cWithdrawAmount.text == "") {
        global.showToast(message: "Please Enter Valid amount");
      } else if (wallet == 1 && cBankNumber.text == "") {
        global.showToast(message: "Please Enter account number");
      } else if (wallet == 1 && cIfscCode.text == "") {
        global.showToast(message: "Please Enter IFSC code");
      } else if (wallet == 1 && cAccountHolder.text == "") {
        global.showToast(message: "Please Enter account holder name");
      } else if (wallet == 2 && cUPI.text == "") {
        global.showToast(message: "Please Enter UPI Id");
      }
    } catch (e) {
      print("Exception: $screen - validateAmount(): " + e.toString());
    }
  }

  //Add Amount
  addAmount() async {
    try {
      await global.checkBody().then(
        (networkResult) async {
          if (networkResult) {
            int id = global.user.id ?? 0;
            amount = double.parse(cWithdrawAmount.text);
            walletModel.upiId = cUPI.text;
            walletModel.accountNumber = cBankNumber.text;
            walletModel.ifscCode = cIfscCode.text;
            walletModel.accountHolderName = cAccountHolder.text;
            walletModel.paymentMethod = wallet.toString();
            global.showOnlyLoaderDialog();
            await apiHelper.withdrawAdd(id, amount!, walletModel.paymentMethod!, walletModel.upiId!, walletModel.accountNumber!, walletModel.ifscCode!, walletModel.accountHolderName!).then(
              (apiResult) async {
                global.hideLoader();
                if (apiResult.status == '200') {
                  global.showToast(message: apiResult.message.toString());
                  await getAmountList();
                  Get.to(() => WalletScreen());
                } else if (apiResult.status == '400') {
                  global.showToast(message: apiResult.message.toString());
                  update();
                } else {
                  global.showToast(message: "Something went wrong please try again later");
                }
              },
            );
          } else {
            global.showToast(message: "No Network Available");
          }
        },
      );
    } catch (e) {
      print("Exception: $screen - addAmount(): " + e.toString());
    }
  }

  //Get amount
  Future getAmountList() async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            int id = global.user.id ?? 0;
            await apiHelper.getWithdrawAmount(id).then((result) {
              global.hideLoader();
              if (result.status == "200") {
                withdraw = result.recordList;
              } else {
                result = null;
                global.showToast(message: result.message);
              }
            });
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - getAmountList():- ' + e.toString());
    }
  }

  validateUpdateAmount(int id) {
    try {
      if (cWithdrawAmount.text != "" && (wallet == 1 && cBankNumber.text != "") && (wallet == 1 && cIfscCode.text != "") && (wallet == 1 && cAccountHolder.text != "") || (wallet == 2 && cUPI.text != "")) {
        updateAmount(id);
      } else if (cWithdrawAmount.text == "") {
        global.showToast(message: "Please Enter Valid amount");
      } else if (wallet == 1 && cBankNumber.text == "") {
        global.showToast(message: "Please Enter account number");
      } else if (wallet == 1 && cIfscCode.text == "") {
        global.showToast(message: "Please Enter IFSC code");
      } else if (wallet == 1 && cAccountHolder.text == "") {
        global.showToast(message: "Please Enter account holder name");
      } else if (wallet == 2 && cUPI.text == "") {
        global.showToast(message: "Please Enter UPI Id");
      }
    } catch (e) {
      print("Exception: $screen - validateAmount(): " + e.toString());
    }
  }

  //Update Amount
  updateAmount(int id) async {
    try {
      await global.checkBody().then(
        (networkResult) async {
          if (networkResult) {
            amount = double.parse(cWithdrawAmount.text);
            walletModel.upiId = cUPI.text;
            walletModel.accountNumber = cBankNumber.text;
            walletModel.ifscCode = cIfscCode.text;
            walletModel.accountHolderName = cAccountHolder.text;
            walletModel.paymentMethod = wallet.toString();
            global.showOnlyLoaderDialog();
            await apiHelper.withdrawUpdate(id, global.user.id ?? 0, amount!, walletModel.paymentMethod!, walletModel.upiId!, walletModel.accountNumber!, walletModel.ifscCode!, walletModel.accountHolderName!).then(
              (apiResult) async {
                global.hideLoader();
                if (apiResult.status == '200') {
                  global.showToast(message: apiResult.message);
                  //Get.back();
                  await getAmountList();
                  Get.to(() => WalletScreen());
                } else if (apiResult.status == '400') {
                  global.showToast(message: apiResult.message);
                } else {
                  global.showToast(message: "Something went wrong, please try again later");
                }
              },
            );
          } else {
            global.showToast(message: "No Network Available");
          }
        },
      );
      update();
    } catch (e) {
      print("Exception - $screen - updateAmount(): " + e.toString());
    }
  }
}
