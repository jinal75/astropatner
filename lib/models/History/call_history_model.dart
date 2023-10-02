// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

class CallHistoryModel {
  CallHistoryModel({
    this.id,
    this.userId,
    this.astrologerId,
    this.callStatus,
    this.channelName,
    this.token,
    this.totalMin,
    this.callRate,
    this.deduction,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.contactNo,
    this.astrologerName,
    this.charge,
    this.profile,
    this.chatId,
    this.sId,
    this.sId1,
  });

  int? id;
  int? userId;
  int? astrologerId;
  String? callStatus;
  String? channelName;
  String? token;
  String? totalMin;
  String? callRate;
  int? deduction;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? name;
  String? contactNo;
  String? astrologerName;
  int? charge;
  String? profile;
  String? chatId;
  String? sId;
  String? sId1;

  CallHistoryModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
      userId = json["userId"];
      astrologerId = json["astrologerId"];
      callStatus = json["callStatus"];
      channelName = json["channelName"] ?? "";
      token = json["token"] ?? "";
      totalMin = json["totalMin"] ?? "";
      callRate = json["callRate"] ?? "0";
      deduction = json["deduction"] ?? 0;
      createdAt = DateTime.parse(json["created_at"] ?? DateTime.now().toIso8601String());
      updatedAt = DateTime.parse(json["updated_at"] ?? DateTime.now().toIso8601String());
      name = json["name"] ?? "";
      contactNo = json["contactNo"] ?? "";
      astrologerName = json["astrologerName"] ?? "";
      charge = json["charge"] ?? 0;
      profile = json["profile"] ?? "";
      chatId = json["chatId"] ?? "";
      sId = json["sId"] ?? "";
      sId1 = json["sId1"] ?? "";
    } catch (e) {
      print('Exception: call_history_model.dart - CallHistoryModel.fromJson():-' + e.toString());
    }
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "astrologerId": astrologerId,
        "callStatus": callStatus,
        "channelName": channelName,
        "token": token,
        "totalMin": totalMin,
        "callRate": callRate,
        "deduction": deduction,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "name": name,
        "contactNo": contactNo,
        "astrologerName": astrologerName,
        "charge": charge,
        "profile": profile,
        "chatId": chatId,
        "sId": sId ?? "",
      };
}
