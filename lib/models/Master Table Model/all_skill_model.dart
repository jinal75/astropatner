// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

class AllSkillModel {
  AllSkillModel({
    this.id,
    this.name,
    this.displayOrder,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.modifiedBy,
    this.isCheck = false,
  });

  int? id;
  String? name;
  int? displayOrder;
  int? isActive;
  int? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? createdBy;
  int? modifiedBy;
  bool? isCheck = false;

  AllSkillModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
      name = json["name"] ?? '';
      displayOrder = json["displayOrder"] ?? 0;
      isActive = json["isActive"] ?? 0;
      isDelete = json["isDelete"] ?? 0;
      createdAt = json["created_at"] != null ? DateTime.parse(json["created_at"]) : null;
      updatedAt = json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null;
      createdBy = json["createdBy"] ?? 0;
      modifiedBy = json["modifiedBy"] ?? 0;
    } catch (e) {
      print('Exception: all_skill_model.dart.dart - AllSkillModel.fromJson(): ' + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name ?? "",
        "displayOrder": displayOrder ?? 0,
        "isActive": isActive ?? 0,
        "isDelete": isDelete ?? 0,
        "created_at": createdAt != null ? createdAt!.toIso8601String() : null,
        "updated_at": updatedAt != null ? updatedAt!.toIso8601String() : null,
        "createdBy": createdBy ?? 0,
        "modifiedBy": modifiedBy ?? 0,
      };
}
