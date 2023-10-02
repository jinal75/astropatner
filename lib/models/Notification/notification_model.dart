// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

class NotificationModel {
  NotificationModel({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.notificationId,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.modifiedBy,
  });

  int? id;
  int? userId;
  String? title;
  String? description;
  int? notificationId;
  int? isActive;
  int? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? createdBy;
  int? modifiedBy;

  NotificationModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
      userId = json["userId"];
      title = json["title"] ?? "";
      description = json["description"] ?? "";
      notificationId = json["notificationId"] ?? 0;
      isActive = json["isActive"] ?? 0;
      isDelete = json["isDelete"] ?? 0;
      createdAt = DateTime.parse(json["created_at"] ?? DateTime.now().toIso8601String());
      updatedAt = DateTime.parse(json["updated_at"] ?? DateTime.now().toIso8601String());
      createdBy = json["createdBy"];
      modifiedBy = json["modifiedBy"];
    } catch (e) {
      print('Exception: notification_model.dart - NotificationModel.fromJson():-' + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "title": title,
        "description": description,
        "notificationId": notificationId,
        "isActive": isActive,
        "isDelete": isDelete,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
      };
}
