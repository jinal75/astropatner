// ignore_for_file: file_names, prefer_interpolation_to_compose_strings, empty_catches, avoid_print

import 'package:flutter/cupertino.dart';

class CustomerReviewModel {
  CustomerReviewModel({
    this.name,
    this.profile,
    this.id,
    this.userId,
    this.rating,
    this.review,
    this.astrologerId,
    this.astromallProductId,
    this.reply,
    this.isActive,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.modifiedBy,
    this.isPublic,
    this.reviewReply,
  });

  String? name;
  String? profile;
  int? id;
  int? userId;
  double? rating;
  String? review;
  int? astrologerId;
  int? astromallProductId;
  String? reply;
  int? isActive;
  int? isDelete;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? createdBy;
  int? modifiedBy;
  int? isPublic;
  TextEditingController? reviewReply = TextEditingController();

  CustomerReviewModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
      astrologerId = json["astrologerId"];
      name = json["userName"] ?? "";
      profile = json["profile"] ?? "";
      userId = json["userId"];
      rating = json["rating"].toDouble();
      review = json["review"] ?? "";
      astromallProductId = json["astromallProductId"] ?? 0;
      reply = json["reply"] ?? "";
      isActive = json["isActive"] ?? 0;
      isDelete = json["isDelete"] ?? 0;
      createdAt = DateTime.parse(json["created_at"] ?? DateTime.now().toIso8601String());
      updatedAt = DateTime.parse(json["updated_at"] ?? DateTime.now().toIso8601String());
      createdBy = json["createdBy"] ?? 0;
      modifiedBy = json["modifiedBy"] ?? 0;
      isPublic = json["isPublic"] ?? 0;
      reviewReply = json["reviewReply"] ?? TextEditingController();
    } catch (e) {
      print('Exception: customerReview_model.dart - CustomerReviewModel.fromJson():-' + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "userName": name,
        "profile": profile,
        "userId": userId,
        "rating": rating ?? 0,
        "review": review ?? "",
        "astrologerId": astrologerId,
        "astromallProductId": astromallProductId ?? 0,
        "reply": reply ?? "",
        "isActive": isActive ?? 0,
        "isDelete": isDelete ?? 0,
        "created_at": createdAt != null ? createdAt!.toIso8601String() : null,
        "updated_at": updatedAt != null ? updatedAt!.toIso8601String() : null,
        "createdBy": createdBy ?? 0,
        "modifiedBy": modifiedBy ?? 0,
        "isPublic": isPublic ?? 0,
        "reviewReply": reviewReply ?? TextEditingController(),
      };
}
