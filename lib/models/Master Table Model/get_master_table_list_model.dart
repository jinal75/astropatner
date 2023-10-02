// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

import 'package:astrologer_app/models/Master%20Table%20Model/all_skill_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/assistant/assistant_all_skill_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/assistant/assistant_language_list_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/assistant/assistant_primary_skill_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/astrologer_category_list_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/highest_qualification_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/language_list_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/main_source_business_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/primary_skill_model.dart';
import 'package:astrologer_app/models/following_model.dart';
import 'package:astrologer_app/models/wallet_model.dart';

class GetMasterTableDataModel {
  GetMasterTableDataModel({
    this.astrologerCategory,
    this.skill,
    this.allskill,
    this.assistantPrimarySkill,
    this.assistantAllSkill,
    this.language,
    this.assistantLanguage,
    this.mainSourceBusiness,
    this.highestQualification,
    this.qualifications,
    this.jobs,
    this.countryTravel,
    this.follower,
    this.status,
    this.wallet,
  });

  List<AstrolgoerCategoryModel>? astrologerCategory = [];
  List<PrimarySkillModel>? skill = [];
  List<AllSkillModel>? allskill = [];
  List<LanguageModel>? language = [];
  List<AssistantPrimarySkillModel>? assistantPrimarySkill = [];
  List<AssistantAllSkillModel>? assistantAllSkill = [];
  List<AssistantLanguageModel>? assistantLanguage = [];
  List<MainSourceBusinessModel>? mainSourceBusiness = [];
  List<HighestQualificationModel>? highestQualification = [];
  List<CountryTravel>? qualifications = [];
  List<CountryTravel>? jobs = [];
  List<CountryTravel>? countryTravel = [];
  List<FollowingModel>? follower = [];
  List<WalletModel>? wallet = [];
  int? status;

  factory GetMasterTableDataModel.fromJson(Map<String, dynamic> json) {
    try {
      return GetMasterTableDataModel(
        astrologerCategory: List<AstrolgoerCategoryModel>.from(json["astrolgoerCategory"].map((x) => AstrolgoerCategoryModel.fromJson(x))),
        skill: List<PrimarySkillModel>.from(json["skill"].map((x) => PrimarySkillModel.fromJson(x))),
        allskill: List<AllSkillModel>.from(json["skill"].map((x) => AllSkillModel.fromJson(x))),
        assistantPrimarySkill: List<AssistantPrimarySkillModel>.from(json["skill"].map((x) => AssistantPrimarySkillModel.fromJson(x))),
        assistantAllSkill: List<AssistantAllSkillModel>.from(json["skill"].map((x) => AssistantAllSkillModel.fromJson(x))),
        language: List<LanguageModel>.from(json["language"].map((x) => LanguageModel.fromJson(x))),
        assistantLanguage: List<AssistantLanguageModel>.from(json["language"].map((x) => AssistantLanguageModel.fromJson(x))),
        mainSourceBusiness: List<MainSourceBusinessModel>.from(json["mainSourceBusiness"].map((x) => MainSourceBusinessModel.fromJson(x))),
        highestQualification: List<HighestQualificationModel>.from(json["highestQualification"].map((x) => HighestQualificationModel.fromJson(x))),
        qualifications: List<CountryTravel>.from(json["qualifications"].map((x) => CountryTravel.fromJson(x))),
        jobs: List<CountryTravel>.from(json["jobs"].map((x) => CountryTravel.fromJson(x))),
        countryTravel: List<CountryTravel>.from(json["countryTravel"].map((x) => CountryTravel.fromJson(x))),
        // wallet: List<WalletModel>.from(json["withdrawl"].map((x) => WalletModel.fromJson(x))),
        // follower: List<FollowingModel>.from(json["follower"].map((x) => FollowingModel.fromJson(x))),
        status: json["status"],
      );
    } catch (e) {
      print('Exception - GetMasterTableDataModel.fromJson -' + e.toString());
      return GetMasterTableDataModel();
    }
  }

  Map<String, dynamic> toJson() => {
        "astrologerCategory": List<dynamic>.from(astrologerCategory!.map((x) => x.toJson())),
        "skill": List<dynamic>.from(skill!.map((x) => x.toJson())),
        "allskill": List<dynamic>.from(allskill!.map((x) => x.toJson())),
        "language": List<dynamic>.from(language!.map((x) => x.toJson())),
        "assistantPrimarySkill": List<dynamic>.from(assistantPrimarySkill!.map((x) => x.toJson())),
        "assistantAllSkill": List<dynamic>.from(assistantAllSkill!.map((x) => x.toJson())),
        "assistantLanguage": List<dynamic>.from(assistantLanguage!.map((x) => x.toJson())),
        "mainSourceBusiness": List<dynamic>.from(mainSourceBusiness!.map((x) => x.toJson())),
        "highestQualification": List<dynamic>.from(highestQualification!.map((x) => x.toJson())),
        "qualifications": List<dynamic>.from(qualifications!.map((x) => x.toJson())),
        "jobs": List<dynamic>.from(jobs!.map((x) => x.toJson())),
        "countryTravel": List<dynamic>.from(countryTravel!.map((x) => x.toJson())),
        "status": status,
      };
}

class CountryTravel {
  CountryTravel({
    this.id,
    this.noOfCountriesTravell,
    this.createdAt,
    this.updatedAt,
    this.workName,
    this.degreeName,
  });

  int? id;
  String? noOfCountriesTravell;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? workName;
  String? degreeName;

  factory CountryTravel.fromJson(Map<String, dynamic> json) => CountryTravel(
        id: json["id"],
        noOfCountriesTravell: json["NoOfCountriesTravell"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        workName: json["workName"],
        degreeName: json["degreeName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "NoOfCountriesTravell": noOfCountriesTravell,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "workName": workName,
        "degreeName": degreeName,
      };
}
