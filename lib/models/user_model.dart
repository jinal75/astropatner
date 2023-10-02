// ignore_for_file: prefer_if_null_operators, avoid_print, prefer_interpolation_to_compose_strings

import 'package:astrologer_app/models/History/call_history_model.dart';
import 'package:astrologer_app/models/History/chat_history_model.dart';
import 'package:astrologer_app/models/History/report_history_model.dart';
import 'package:astrologer_app/models/History/wallet_history_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/all_skill_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/astrologer_category_list_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/language_list_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/primary_skill_model.dart';
import 'package:astrologer_app/models/customerReview_model.dart';
import 'package:astrologer_app/models/systemFlagModel.dart';
import 'package:astrologer_app/models/week_model.dart';

class CurrentUser {
  int? id;
  int? userId;
  int? roleId;
  List<AstrolgoerCategoryModel>? astrologerCategoryId = [];
  List<PrimarySkillModel>? primarySkillId = [];
  List<AllSkillModel>? allSkillId = [];
  List<LanguageModel>? languageId = [];
  int? isVerified;
  int? isAnyBodyRefer;
  int? isWorkingOnAnotherPlatform;
  String? name;
  String? email;
  String? contactNo;
  //ImageModel? image = ImageModel();
  String? imagePath;
  String? gender;
  DateTime? birthDate;
  String? astrologerCategory;
  String? primarySkill;
  String? allSkill;
  String? languageKnown;
  int? charges;
  int? videoCallRate;
  int? reportRate;
  int? expirenceInYear;
  int? dailyContributionHours;
  String? hearAboutAstroGuru;
  String? otherPlatformName;
  String? otherPlatformMonthlyEarning;
  String? onboardYou;
  String? suitableInterviewTime;
  String? currentCity;
  String? mainSourceOfBusiness;
  String? highestQualification;
  String? degreeDiploma;
  String? collegeSchoolUniversity;
  String? learnAstrology;
  String? instagramProfileLink;
  String? facebookProfileLink;
  String? linkedInProfileLink;
  String? youtubeProfileLink;
  String? webSiteProfileLink;
  String? referedPersonName;
  int? expectedMinimumEarning;
  int? expectedMaximumEarning;
  String? longBio;
  String? foreignCountryCount;
  String? currentlyWorkingJob;
  String? goodQualityOfAstrologer;
  String? biggestChallengeFaced;
  String? repeatedQuestion;
  List<Week>? week;
  String? sessionToken;
  String? token;
  String? tokenType;
  bool? isOAuth = false;
  List<ChatHistoryModel>? chatHistory;
  List<CallHistoryModel>? callHistory;
  List<WalletHistoryModel>? wallet;
  List<ReportHistoryModel>? reportHistory;
  List<CustomerReviewModel>? review;
  List<SystemFlag>? systemFlagList;
  String? chatStatus;
  String? callStatus;
  String? dateTime;
  DateTime? chatWaitTime;
  DateTime? callWaitTime;

  CurrentUser(
      {this.id,
      this.userId,
      this.roleId,
      this.astrologerCategoryId,
      this.primarySkillId,
      this.allSkillId,
      this.languageId,
      this.name,
      this.email,
      this.contactNo,
      //this.image,
      this.imagePath,
      this.gender,
      this.dateTime,
      this.birthDate,
      this.primarySkill,
      this.allSkill,
      this.languageKnown,
      this.astrologerCategory,
      this.charges,
      this.videoCallRate,
      this.reportRate,
      this.expirenceInYear,
      this.dailyContributionHours,
      this.hearAboutAstroGuru,
      this.otherPlatformName,
      this.otherPlatformMonthlyEarning,
      this.onboardYou,
      this.suitableInterviewTime,
      this.currentCity,
      this.mainSourceOfBusiness,
      this.highestQualification,
      this.degreeDiploma,
      this.collegeSchoolUniversity,
      this.learnAstrology,
      this.instagramProfileLink,
      this.facebookProfileLink,
      this.linkedInProfileLink,
      this.youtubeProfileLink,
      this.webSiteProfileLink,
      this.referedPersonName,
      this.expectedMinimumEarning,
      this.expectedMaximumEarning,
      this.longBio,
      this.foreignCountryCount,
      this.currentlyWorkingJob,
      this.goodQualityOfAstrologer,
      this.biggestChallengeFaced,
      this.repeatedQuestion,
      this.week,
      this.sessionToken,
      this.isOAuth,
      this.isWorkingOnAnotherPlatform,
      this.token,
      this.tokenType,
      this.callHistory,
      this.chatHistory,
      this.wallet,
      this.reportHistory,
      this.review,
      this.callStatus,
      this.callWaitTime,
      this.chatStatus,
      this.chatWaitTime});

  CurrentUser.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
      userId = json["userId"];
      roleId = json["roleId"] ?? 2;
      isVerified = json["isVerified"] ?? 0;
      name = json["name"] ?? "";
      email = json["email"] ?? "";
      contactNo = json["contactNo"] ?? "";
      imagePath = json['profileImage'] ?? "";
      gender = json["gender"] ?? "";
      birthDate = DateTime.parse(json["birthDate"] ?? DateTime.now().toIso8601String());
      charges = json["charge"] ?? 0;
      videoCallRate = json['videoCallRate'] ?? 0;
      reportRate = json['reportRate'] ?? 0;
      expirenceInYear = json["experienceInYears"] ?? 0;
      dailyContributionHours = json["dailyContribution"] ?? 0;
      hearAboutAstroGuru = json["hearAboutAstroguru"] ?? "";
      isWorkingOnAnotherPlatform = json["isWorkingOnAnotherPlatform"] ?? 0;
      otherPlatformName = json["nameofplateform"] ?? "";
      otherPlatformMonthlyEarning = json["monthlyEarning"] ?? "";
      onboardYou = json["whyOnBoard"] ?? "";
      suitableInterviewTime = json["interviewSuitableTime"] ?? "";
      currentCity = json["currentCity"] ?? "";
      mainSourceOfBusiness = json["mainSourceOfBusiness"] ?? "";
      highestQualification = json["highestQualification"] ?? "";
      degreeDiploma = json["degree"] ?? "";
      collegeSchoolUniversity = json["college"] ?? "";
      learnAstrology = json["learnAstrology"] ?? "";
      instagramProfileLink = json["instaProfileLink"] ?? "";
      facebookProfileLink = json["facebookProfileLink"] ?? "";
      linkedInProfileLink = json["linkedInProfileLink"] ?? "";
      youtubeProfileLink = json["youtubeChannelLink"] ?? "";
      webSiteProfileLink = json["websiteProfileLink"] ?? "";
      isAnyBodyRefer = json["isAnyBodyRefer"] ?? 0;
      referedPersonName = json["referedPerson"] ?? "";
      expectedMinimumEarning = json["minimumEarning"] ?? 0;
      expectedMaximumEarning = json["maximumEarning"] ?? 0;
      longBio = json["loginBio"] ?? "";
      foreignCountryCount = json["NoofforeignCountriesTravel"] ?? "";
      currentlyWorkingJob = json["currentlyworkingfulltimejob"] ?? "";
      goodQualityOfAstrologer = json["goodQuality"] ?? "";
      biggestChallengeFaced = json["biggestChallenge"] ?? "";
      repeatedQuestion = json["whatwillDo"] ?? "";
      week = (json["astrologerAvailability"] != null && json['astrologerAvailability'] != []) ? List<Week>.from(json['astrologerAvailability'].map((e) => Week.fromJson(e))) : [];
      sessionToken = json["sessionToken"] ?? "";
      token = json['token'] ?? "";
      tokenType = json['token_type'] ?? "";
      primarySkillId = (json['primarySkill'] != null && json['primarySkill'] != []) ? List<PrimarySkillModel>.from(json['primarySkill'].map((e) => PrimarySkillModel.fromJson(e))) : [];
      allSkillId = (json['allSkill'] != null && json['allSkill'] != []) ? List<AllSkillModel>.from(json['allSkill'].map((e) => AllSkillModel.fromJson(e))) : [];
      languageId = (json['languageKnown'] != null && json['languageKnown'] != []) ? List<LanguageModel>.from(json['languageKnown'].map((e) => LanguageModel.fromJson(e))) : [];
      astrologerCategoryId = (json['astrologerCategoryId'] != null && json['astrologerCategoryId'] != []) ? List<AstrolgoerCategoryModel>.from(json['astrologerCategoryId'].map((e) => AstrolgoerCategoryModel.fromJson(e))) : [];
      chatHistory = (json['chatHistory'] != null && json['chatHistory'] != []) ? List<ChatHistoryModel>.from(json["chatHistory"].map((x) => ChatHistoryModel.fromJson(x))) : [];
      callHistory = (json['callHistory'] != null && json['callHistory'] != []) ? List<CallHistoryModel>.from(json["callHistory"].map((x) => CallHistoryModel.fromJson(x))) : [];
      wallet = (json['wallet'] != null && json['wallet'] != []) ? List<WalletHistoryModel>.from(json["wallet"].map((x) => WalletHistoryModel.fromJson(x))) : [];
      reportHistory = (json['report'] != null && json['report'] != []) ? List<ReportHistoryModel>.from(json["report"].map((x) => ReportHistoryModel.fromJson(x))) : [];
      review = (json['review'] != null && json['review'] != []) ? List<CustomerReviewModel>.from(json["review"].map((x) => CustomerReviewModel.fromJson(x))) : [];
      systemFlagList = json['systemFlag'] != null ? List<SystemFlag>.from(json['systemFlag'].map((p) => SystemFlag.fromJson(p))) : [];
      chatStatus = json['chatStatus'] ?? "";
      callStatus = json['callStatus'] ?? "";
      chatWaitTime = json["chatWaitTime"] != null ? DateTime.parse(json["chatWaitTime"] ?? DateTime.now().toIso8601String()) : null;
      callWaitTime = json["callWaitTime"] != null ? DateTime.parse(json["callWaitTime"] ?? DateTime.now().toIso8601String()) : null;
    } catch (e) {
      print("Exception - user_model.dart - CurrentUser.fromJson():" + e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        "roleId": roleId ?? 2,
        "id": id,
        "userId": userId,
        "name": name ?? "",
        "email": email ?? "",
        "contactNo": contactNo ?? "",
        "profileImage": imagePath,
        "gender": gender ?? "",
        "birthDate": birthDate == null ? DateTime.now().toIso8601String() : birthDate!.toIso8601String(),
        "callWaitTime": callWaitTime == null ? DateTime.now().toIso8601String() : callWaitTime!.toIso8601String(),
        "chatWaitTime": chatWaitTime == null ? DateTime.now().toIso8601String() : chatWaitTime!.toIso8601String(),
        "charge": charges ?? 0,
        "videoCallRate": videoCallRate ?? 0,
        "reportRate": reportRate ?? 0,
        "experienceInYears": expirenceInYear ?? 0,
        "dailyContribution": dailyContributionHours ?? 0,
        "hearAboutAstroguru": hearAboutAstroGuru ?? "",
        "isWorkingOnAnotherPlatform": isWorkingOnAnotherPlatform,
        "nameofplateform": otherPlatformName ?? "",
        "monthlyEarning": otherPlatformMonthlyEarning ?? "",
        "whyOnBoard": onboardYou ?? "",
        "interviewSuitableTime": suitableInterviewTime ?? "",
        "currentCity": currentCity ?? "",
        "mainSourceOfBusiness": mainSourceOfBusiness ?? "",
        "highestQualification": highestQualification ?? "",
        "degree": degreeDiploma ?? "",
        "college": collegeSchoolUniversity ?? "",
        "learnAstrology": learnAstrology ?? "",
        "instaProfileLink": instagramProfileLink ?? "",
        "facebookProfileLink": facebookProfileLink ?? "",
        "linkedInProfileLink": linkedInProfileLink ?? "",
        "youtubeChannelLink": youtubeProfileLink ?? "",
        "websiteProfileLink": webSiteProfileLink ?? "",
        "isAnyBodyRefer": isAnyBodyRefer,
        "referedPerson": referedPersonName ?? "",
        "minimumEarning": expectedMinimumEarning ?? 0,
        "maximumEarning": expectedMaximumEarning ?? 0,
        "loginBio": longBio ?? "",
        "NoofforeignCountriesTravel": foreignCountryCount ?? "",
        "currentlyworkingfulltimejob": currentlyWorkingJob ?? "",
        "goodQuality": goodQualityOfAstrologer ?? "",
        "biggestChallenge": biggestChallengeFaced ?? "",
        "whatwillDo": repeatedQuestion ?? "",
        "astrologerAvailability": week ?? [],
        "primarySkill": primarySkillId ?? [],
        "allSkill": allSkillId ?? [],
        "languageKnown": languageId ?? [],
        "astrologerCategoryId": astrologerCategoryId ?? [],
        "token": token,
        "token_type": tokenType,
        "chatHistory": chatHistory ?? [],
        "callHistory": callHistory ?? [],
        "wallet": wallet ?? [],
        "report": reportHistory ?? [],
        "review": review ?? [],
        "systemFlag": systemFlagList ?? [],
        "chatStatus": chatStatus ?? "",
        "callStatus": callStatus ?? ""
      };
}
