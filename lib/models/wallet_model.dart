// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

class WalletModel {
  WalletModel({
    this.id,
    this.astrologerId,
    this.withdrawAmount,
    this.status,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.modifiedBy,
    this.name,
    this.contactNo,
    this.profileImage,
    this.userId,
    this.paymentMethod,
    this.upiId,
    this.accountNumber,
    this.ifscCode,
    this.accountHolderName,
    this.selectTransaction,
  });

  int? id;
  int? astrologerId;
  String? withdrawAmount;
  String? status;
  int? isActive;
  int? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? createdBy;
  int? modifiedBy;
  String? name;
  String? contactNo;
  String? profileImage;
  int? userId;
  String? paymentMethod;
  String? upiId;
  String? accountNumber;
  String? ifscCode;
  String? accountHolderName;
  int? selectTransaction;

  WalletModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
      astrologerId = json["astrologerId"];
      withdrawAmount = json["withdrawAmount"] ?? "";
      status = json["status"] ?? "";
      isActive = json["isActive"] ?? 0;
      isDelete = json["isDelete"] ?? 0;
      createdAt = DateTime.parse(json["created_at"] ?? DateTime.now().toIso8601String());
      updatedAt = DateTime.parse(json["updated_at"] ?? DateTime.now().toIso8601String());
      createdBy = json["createdBy"] ?? 0;
      modifiedBy = json["modifiedBy"] ?? 0;
      name = json["name"] ?? "";
      contactNo = json["contactNo"] ?? "";
      profileImage = json["profileImage"] ?? "";
      userId = json["userId"];
      paymentMethod = json["paymentMethod"] ?? "";
      upiId = json["upiId"] ?? "";
      accountNumber = json["accountNumber"] ?? "";
      ifscCode = json["ifscCode"] ?? "";
      accountHolderName = json["accountHolderName"] ?? "";
      selectTransaction = json["selectTransaction"] ?? 0;
    } catch (e) {
      print('Exception: wallet_model.dart - WalletModel.fromJson(): ' + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "astrologerId": astrologerId,
        "withdrawAmount": withdrawAmount ?? 0,
        "status": status ?? "",
        "isActive": isActive ?? 0,
        "isDelete": isDelete ?? 0,
        "created_at": createdAt != null ? createdAt!.toIso8601String() : null,
        "updated_at": updatedAt != null ? updatedAt!.toIso8601String() : null,
        "createdBy": createdBy ?? 0,
        "modifiedBy": modifiedBy ?? 0,
        "name": name ?? "",
        "contactNo": contactNo ?? "",
        "profileImage": profileImage ?? "",
        "userId": userId,
        "paymentMethod": paymentMethod ?? "",
        "upiId": upiId ?? "",
        "accountNumber": accountNumber ?? "",
        "ifscCode": ifscCode ?? "",
        "accountHolderName": accountHolderName ?? "",
        "selectTransaction": selectTransaction ?? 0,
      };
}

//Wallet transaction
class WalletTransactionModel {
  WalletTransactionModel({
    this.id,
    this.amount,
    this.userId,
    this.transactionType,
    this.orderId,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.modifiedBy,
    this.isCredit,
    this.astrologerId,
  });

  int? id;
  double? amount;
  int? userId;
  String? transactionType;
  int? orderId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? createdBy;
  int? modifiedBy;
  int? isCredit;
  int? astrologerId;

  WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
      amount = json["amount"] != null ? double.parse(json["amount"].toString()) : 0;
      userId = json["userId"];
      transactionType = json["transactionType"] ?? "";
      orderId = json["orderId"] ?? 0;
      createdAt = DateTime.parse(json["created_at"] ?? DateTime.now().toIso8601String());
      updatedAt = DateTime.parse(json["updated_at"] ?? DateTime.now().toIso8601String());
      createdBy = json["createdBy"] ?? 0;
      modifiedBy = json["modifiedBy"] ?? 0;
      isCredit = json["isCredit"] ?? 0;
      astrologerId = json["astrologerId"] ?? 0;
    } catch (e) {
      print('Exception: wallet_model.dart - WalletTransaction.fromJson(): ' + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "userId": userId,
        "transactionType": transactionType ?? "",
        "orderId": orderId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "isCredit": isCredit,
        "astrologerId": astrologerId,
      };
}

//Second model for total amount(Main model)
class Withdraw {
  Withdraw({
    this.walletModel,
    this.walletTransactionModel,
    this.withdrawAmount,
    this.totalPending,
    this.totalEarning,
  });

  List<WalletModel>? walletModel = [];
  List<WalletTransactionModel>? walletTransactionModel = [];
  double? walletAmount;
  String? totalPending;
  int? totalEarning;
  String? withdrawAmount;

  Withdraw.fromJson(Map<String, dynamic> json) {
    try {
      walletModel = (json['withdrawl'] != null && json['withdrawl'].length > 0) ? List<WalletModel>.from(json['withdrawl'].map((e) => WalletModel.fromJson(e))) : [];
      walletTransactionModel = (json['walletTransaction'] != null && json['walletTransaction'].length > 0) ? List<WalletTransactionModel>.from(json['walletTransaction'].map((e) => WalletTransactionModel.fromJson(e))) : [];
      walletAmount = json["walletAmount"] != null ? double.parse(json["walletAmount"].toString()) : 0;
      totalPending = json["totalPending"] ?? 0;
      totalEarning = json["totalEarning"] ?? 0;
      withdrawAmount = json["withdrawAmount"] != null ? json["withdrawAmount"].toString() : "0";
    } catch (e) {
      print('Exception: wallet_model.dart - Withdraw.fromJson(): ' + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        "withdrawl": walletModel ?? [],
        "walletTransaction": walletTransactionModel ?? [],
        "withdrawAmount": withdrawAmount ?? 0,
        "totalPending": totalPending ?? "0",
        "totalEarning": totalEarning ?? 0,
        "walletAmount": walletAmount ?? 0,
      };
}
