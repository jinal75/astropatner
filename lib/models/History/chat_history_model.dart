// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

class ChatHistoryModel {
  ChatHistoryModel({
    this.id,
    this.userId,
    this.astrologerId,
    this.chatStatus,
    this.channelName,
    this.senderId,
    this.receiverId,
    this.deduction,
    this.chatId,
    this.totalMin,
    this.chatRate,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.contactNo,
    this.astrologerName,
    this.charge,
    this.profile,
  });

  int? id;
  int? userId;
  int? astrologerId;
  String? chatStatus;
  String? channelName;
  String? senderId;
  String? receiverId;
  int? deduction;
  String? chatId;
  String? totalMin;
  String? chatRate;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? name;
  String? contactNo;
  String? astrologerName;
  int? charge;
  String? profile;

  ChatHistoryModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
      userId = json["userId"];
      astrologerId = json["astrologerId"];
      chatStatus = json["chatStatus"] ?? "";
      channelName = json["channelName"] ?? "";
      senderId = json["senderId"] ?? "";
      receiverId = json["receiverId"] ?? "";
      deduction = json["deduction"] ?? 0;
      chatId = json["chatId"] ?? "";
      totalMin = json["totalMin"] ?? "";
      chatRate = json["chatRate"] ?? "";
      createdAt = DateTime.parse(json["created_at"] ?? DateTime.now().toIso8601String());
      updatedAt = DateTime.parse(json["updated_at"] ?? DateTime.now().toIso8601String());
      name = json["name"] ?? "";
      contactNo = json["contactNo"] ?? "";
      astrologerName = json["astrologerName"] ?? "";
      charge = json["charge"] ?? 0;
      profile = json["profile"] ?? "";
    } catch (e) {
      print('Exception: chat_history_model.dart - ChatHistoryModel.fromJson():-' + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "astrologerId": astrologerId,
        "chatStatus": chatStatus,
        "channelName": channelName,
        "senderId": senderId,
        "receiverId": receiverId,
        "deduction": deduction,
        "chatId": chatId,
        "totalMin": totalMin,
        "chatRate": chatRate,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "name": name,
        "contactNo": contactNo,
        "astrologerName": astrologerName,
        "charge": charge,
        "profile": profile,
      };
}
