class CallModel {
  CallModel({
    required this.id,
    required this.name,
    this.contactNo,
    this.email,
    this.password,
    this.birthDate,
    this.birthTime,
    required this.profile,
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
    required this.callId,
    this.fcmToken,
  });

  int id;
  String name;
  String? contactNo;
  dynamic email;
  dynamic password;
  DateTime? birthDate;
  String? birthTime;
  String profile;
  dynamic birthPlace;
  dynamic addressLine1;
  dynamic addressLine2;
  dynamic location;
  int? pincode;
  String? gender;
  int? isActive;
  int? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  int callId;
  String? fcmToken;

  factory CallModel.fromJson(Map<String, dynamic> json) => CallModel(
        id: json["id"],
        name: json["name"] ?? "User",
        contactNo: json["contactNo"] ?? "",
        email: json["email"] ?? "",
        password: json["password"] ?? "",
        birthDate: DateTime.parse(json["birthDate"] ?? DateTime.now().toIso8601String()),
        birthTime: json["birthTime"] ?? "",
        profile: json["profile"] ?? "",
        birthPlace: json["birthPlace"] ?? "",
        addressLine1: json["addressLine1"] ?? "",
        addressLine2: json["addressLine2"] ?? "",
        location: json["location"] ?? "",
        pincode: json["pincode"] ?? 0,
        gender: json["gender"] ?? "",
        isActive: json["isActive"] ?? "",
        isDelete: json["isDelete"] ?? "",
        createdAt: DateTime.parse(json["created_at"] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toIso8601String()),
        callId: json["callId"],
        fcmToken: json['fcmToken'] ?? "",
      );

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
        "callId": callId,
        "fcmToken": fcmToken,
      };
}
