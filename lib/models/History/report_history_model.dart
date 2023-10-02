// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

class ReportHistoryModel {
  ReportHistoryModel({
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.contactNo,
    this.gender,
    this.birthDate,
    this.birthTime,
    this.birthPlace,
    this.occupation,
    this.maritalStatus,
    this.answerLanguage,
    this.partnerName,
    this.partnerBirthDate,
    this.partnerBirthTime,
    this.partnerBirthPlace,
    this.comments,
    this.reportFile,
    this.reportType,
    this.astrologerId,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.modifiedBy,
    this.userName,
    this.profile,
  });

  int? id;
  int? userId;
  String? firstName;
  String? lastName;
  String? contactNo;
  String? gender;
  DateTime? birthDate;
  String? birthTime;
  String? birthPlace;
  String? occupation;
  String? maritalStatus;
  String? answerLanguage;
  String? partnerName;
  DateTime? partnerBirthDate;
  String? partnerBirthTime;
  String? partnerBirthPlace;
  String? comments;
  String? reportFile;
  int? astrologerId;
  int? isActive;
  int? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? createdBy;
  int? modifiedBy;
  String? userName;
  String? profile;
  String? reportImage;
  String? reportType;

  ReportHistoryModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
      userId = json["userId"];
      firstName = json["firstName"] ?? "";
      lastName = json["lastName"] ?? "";
      contactNo = json["contactNo"] ?? "";
      gender = json["gender"] ?? "";
      birthDate = DateTime.parse(json["birthDate"]);
      birthTime = json["birthTime"] ?? "";
      birthPlace = json["birthPlace"] ?? "";
      occupation = json["occupation"] ?? "";
      maritalStatus = json["maritalStatus"] ?? "";
      answerLanguage = json["answerLanguage"] ?? "";
      partnerName = json["partnerName"] ?? "";
      partnerBirthDate = json["partnerBirthDate"] != null ? DateTime.parse(json["partnerBirthDate"]) : null;
      partnerBirthTime = json["partnerBirthTime"] ?? "";
      partnerBirthPlace = json["partnerBirthPlace"] ?? "";
      comments = json["comments"] ?? "";
      reportFile = json["reportFile"] ?? "";
      reportType = json["reportType"] ?? "";
      astrologerId = json["astrologerId"];
      isActive = json["isActive"] ?? 0;
      isDelete = json["isDelete"] ?? 0;
      createdAt = DateTime.parse(json["created_at"] ?? DateTime.now().toIso8601String());
      updatedAt = DateTime.parse(json["updated_at"] ?? DateTime.now().toIso8601String());
      createdBy = json["createdBy"] ?? 0;
      modifiedBy = json["modifiedBy"] ?? 0;
      userName = json["userName"] ?? "";
      profile = json["profile"] ?? "";
      reportImage = json["reportImage"] ?? "";
    } catch (e) {
      print('Exception: report_history_model.dart - ReportHistoryModel.fromJson():-' + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "contactNo": contactNo,
        "gender": gender,
        "birthDate": birthDate!.toIso8601String(),
        "birthTime": birthTime,
        "birthPlace": birthPlace,
        "occupation": occupation,
        "maritalStatus": maritalStatus,
        "answerLanguage": answerLanguage,
        "partnerName": partnerName,
        "partnerBirthDate": partnerBirthDate!.toIso8601String(),
        "partnerBirthTime": partnerBirthTime,
        "partnerBirthPlace": partnerBirthPlace,
        "comments": comments,
        "reportFile": reportFile,
        "reportType": reportType,
        "astrologerId": astrologerId,
        "isActive": isActive,
        "isDelete": isDelete,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "userName": userName,
        "profile": profile,
        "reportImage": reportImage,
      };
}
