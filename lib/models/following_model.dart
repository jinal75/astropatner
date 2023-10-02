// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

class FollowingModel {
  FollowingModel({
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
    this.fcmToken,
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
  String? fcmToken;

  FollowingModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
      name = json["name"] ?? "";
      contactNo = json["contactNo"] ?? "";
      email = json["email"] ?? "";
      password = json["password"] ?? "";
      birthDate = DateTime.parse(json["birthDate"] ?? DateTime.now().toIso8601String());
      birthTime = json["birthTime"] ?? "";
      profile = json["profile"] ?? "";
      birthPlace = json["birthPlace"] ?? "";
      addressLine1 = json["addressLine1"] ?? "";
      addressLine2 = json["addressLine2"] ?? "";
      location = json["location"] ?? "";
      pincode = json["pincode"] ?? 0;
      gender = json["gender"] ?? "";
      isActive = json["isActive"] ?? 0;
      isDelete = json["isDelete"] ?? 0;
      createdAt = DateTime.parse(json["created_at"]);
      updatedAt = DateTime.parse(json["updated_at"]);
      fcmToken = json["fcmToken"] ?? "";
    } catch (e) {
      print('Exception: following_model.dart - FollowingModel.fromJson():-' + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name ?? "",
        "contactNo": contactNo ?? "",
        "email": email ?? "",
        "password": password ?? "",
        "birthDate": birthDate != null ? birthDate!.toIso8601String() : null,
        "birthTime": birthTime ?? "",
        "profile": profile ?? "",
        "birthPlace": birthPlace ?? "",
        "addressLine1": addressLine1 ?? "",
        "addressLine2": addressLine2 ?? "",
        "location": location ?? "",
        "pincode": pincode ?? 0,
        "gender": gender ?? "",
        "isActive": isActive ?? 0,
        "isDelete": isDelete ?? 0,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
