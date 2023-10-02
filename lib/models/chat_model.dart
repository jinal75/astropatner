// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

class ChatModel {
  String screen = 'chat_model.dart';
  ChatModel({
    this.id,
    this.name,
    this.contactNo,
    this.email,
    this.password,
    this.birthDate,
    this.birthTime,
    this.profile,
    this.birthPlace,
    this.addressLine1,
    this.addressLine2,
    this.location,
    this.pincode,
    this.gender,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    required this.chatId,
    this.senderId,
  });

  int? id;
  String? name;
  String? contactNo;
  String? email;
  String? password;
  DateTime? birthDate;
  String? birthTime;
  String? profile;
  String? birthPlace;
  String? addressLine1;
  String? addressLine2;
  String? location;
  int? pincode;
  String? gender;
  int? isActive;
  int? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? chatId;
  String? senderId;
  String? fcmToken;

  ChatModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
      name = json["name"] ?? 'User';
      contactNo = json["contactNo"] ?? '';
      email = json["email"] ?? '';
      password = json["password"] ?? '';
      birthDate = DateTime.parse(json["birthDate"] ?? DateTime.now().toIso8601String());
      birthTime = json["birthTime"] ?? '';
      profile = json["profile"] ?? '';
      birthPlace = json["birthPlace"] ?? '';
      addressLine1 = json["addressLine1"] ?? '';
      addressLine2 = json["addressLine2"] ?? '';
      location = json["location"] ?? '';
      pincode = json["pincode"] ?? 0;
      gender = json["gender"] ?? '';
      isActive = json["isActive"];
      isDelete = json["isDelete"];
      createdAt = DateTime.parse(json["created_at"]);
      updatedAt = DateTime.parse(json["updated_at"]);
      chatId = json["chatId"];
      senderId = json["senderId"] ?? "";
      fcmToken = json["fcmToken"] ?? "";
    } catch (e) {
      print('Exception: $screen - ChatModel.fromJson():-' + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "contactNo": contactNo,
        "email": email,
        "password": password,
        "birthDate": birthDate!.toIso8601String(),
        "birthTime": birthTime,
        "profile": profile,
        "birthPlace": birthPlace,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "location": location,
        "pincode": pincode,
        "gender": gender,
        "isActive": isActive,
        "isDelete": isDelete,
        "created_at": createdAt != null ? createdAt!.toIso8601String() : null,
        "updated_at": updatedAt != null ? updatedAt!.toIso8601String() : null,
        "chatId": chatId,
        "senderId": senderId,
        "fcmToken": fcmToken,
      };
}
