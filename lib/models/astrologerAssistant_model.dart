// ignore_for_file: file_names, prefer_interpolation_to_compose_strings, avoid_print

import 'dart:io';

import 'package:astrologer_app/models/Master%20Table%20Model/assistant/assistant_all_skill_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/assistant/assistant_language_list_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/assistant/assistant_primary_skill_model.dart';

class AstrologerAssistantModel {
  AstrologerAssistantModel({
    this.id,
    this.astrologerId,
    this.name,
    this.email,
    this.contactNo,
    this.gender,
    this.birthdate,
    this.primarySkill,
    this.allSkill,
    this.languageKnown,
    this.experienceInYears,
    this.profile,
    this.assistantPrimarySkillId,
    this.assistantAllSkillId,
    this.assistantLanguageId,
    this.imageFile,
  });

  int? id;
  int? astrologerId;
  String? name;
  String? email;
  String? contactNo;
  String? gender;
  DateTime? birthdate;
  String? primarySkill;
  String? allSkill;
  String? languageKnown;
  int? experienceInYears;
  String? profile;
  List<AssistantPrimarySkillModel>? assistantPrimarySkillId = [];
  List<AssistantAllSkillModel>? assistantAllSkillId = [];
  List<AssistantLanguageModel>? assistantLanguageId = [];
  File? imageFile;

  AstrologerAssistantModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
      astrologerId = json["astrologerId"];
      name = json["name"] ?? '';
      email = json["email"] ?? '';
      contactNo = json["contactNo"] ?? '';
      gender = json["gender"] ?? '';
      birthdate = DateTime.parse(json["birthdate"] ?? DateTime.now().toIso8601String());
      experienceInYears = json["experienceInYears"] ?? 0;
      profile = json["profile"] ?? '';
      assistantPrimarySkillId = (json['primarySkill'] != null && json['primarySkill'] != []) ? List<AssistantPrimarySkillModel>.from(json['primarySkill'].map((e) => AssistantPrimarySkillModel.fromJson(e))) : [];
      assistantAllSkillId = (json['allSkill'] != null && json['allSkill'] != []) ? List<AssistantAllSkillModel>.from(json['allSkill'].map((e) => AssistantAllSkillModel.fromJson(e))) : [];
      assistantLanguageId = (json['languageKnown'] != null && json['languageKnown'] != []) ? List<AssistantLanguageModel>.from(json['languageKnown'].map((e) => AssistantLanguageModel.fromJson(e))) : [];
    } catch (e) {
      print('Exception: astrologerAssistant_model.dart - AstrologerAssistantModel.fromJson(): ' + e.toString());
    }
  }

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "astrologerId": astrologerId,
        "name": name ?? '',
        "email": email ?? '',
        "contactNo": contactNo ?? '',
        "gender": gender ?? '',
        "birthdate": birthdate != null ? birthdate!.toIso8601String() : null,
        "experienceInYears": experienceInYears ?? 0,
        "profile": profile ?? '',
        "assistantPrimarySkillId": assistantPrimarySkillId ?? [],
        "assistantAllSkillId": assistantAllSkillId ?? [],
        "assistantLanguageId": assistantLanguageId ?? [],
      };
}
