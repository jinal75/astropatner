// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_interpolation_to_compose_strings, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:astrologer_app/controllers/Authentication/signup_controller.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/all_skill_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/astrologer_category_list_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/language_list_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/primary_skill_model.dart';
import 'package:astrologer_app/models/time_availability_model.dart';
import 'package:astrologer_app/models/user_model.dart';
import 'package:astrologer_app/models/week_model.dart';
import 'package:astrologer_app/services/apiHelper.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:intl/intl.dart';

class EditProfileController extends GetxController {
  String screen = 'edit_profile__controller.dart';
  int index = 0;
  APIHelper apiHelper = APIHelper();
  CurrentUser user = CurrentUser();

  final SignupController signupController = Get.find<SignupController>();

  int? updateId;

  List<AstrolgoerCategoryModel> astroId = [];
  List<PrimarySkillModel> primaryId = [];
  List<AllSkillModel> allId = [];
  List<LanguageModel> lId = [];

//--------------------Personal Details----------------------
//Name
  final TextEditingController cName = TextEditingController();
  final FocusNode fName = FocusNode();
//Email
  final TextEditingController cEmail = TextEditingController();
  final FocusNode fEmail = FocusNode();
//Mobile Numer
  final TextEditingController cMobileNumber = TextEditingController();
  final FocusNode fMobileNumber = FocusNode();
//Terms ANd Condition
  RxBool termAndCondtion = true.obs;
//--------------------------Skills Details----------------------
//User Image
  Uint8List? tImage;
  File? selectedImage;
  File? imageFile;
  File? userFile;
  String profile = "";

  var imagePath = ''.obs;
  onOpenCamera() async {
    selectedImage = await openCamera(Get.theme.primaryColor).obs();
    update();
  }

  onOpenGallery() async {
    selectedImage = await openGallery(Get.theme.primaryColor).obs();
    update();
  }

  Future<File> imageService(ImageSource imageSource) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? selectedImage = await picker.pickImage(source: imageSource);
      imageFile = File(selectedImage!.path);

      // ignore: unnecessary_null_comparison
      if (selectedImage != null) {
        imageFile;
      }
    } catch (e) {
      print("Exception - businessRule.dart - _openGallery() ${e.toString()}");
    }
    return imageFile!;
  }

  Future<File?> openCamera(Color color, {bool isProfile = true}) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? _selectedImage = await picker.pickImage(source: ImageSource.camera);

      if (_selectedImage != null) {
        CroppedFile? _croppedFile = await ImageCropper().cropImage(
          sourcePath: _selectedImage.path,
          aspectRatio: isProfile ? const CropAspectRatio(ratioX: 1, ratioY: 1) : null,
          uiSettings: [
            AndroidUiSettings(
              initAspectRatio: isProfile ? CropAspectRatioPreset.square : CropAspectRatioPreset.original,
              backgroundColor: Colors.grey,
              toolbarColor: Colors.grey[100],
              toolbarWidgetColor: color,
              activeControlsWidgetColor: color,
              cropFrameColor: color,
              lockAspectRatio: isProfile ? true : false,
            ),
          ],
        );
        if (_croppedFile != null) {
          return File(_croppedFile.path);
        }
      }
    } catch (e) {
      print("Exception - $screen - openCamera():" + e.toString());
    }
    return null;
  }

  Future<File?> openGallery(Color color, {bool isProfile = true}) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? _selectedImage = await picker.pickImage(source: ImageSource.gallery);

      if (_selectedImage != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: _selectedImage.path,
          aspectRatio: isProfile ? const CropAspectRatio(ratioX: 1, ratioY: 1) : null,
          uiSettings: [
            AndroidUiSettings(
              initAspectRatio: isProfile ? CropAspectRatioPreset.square : CropAspectRatioPreset.original,
              backgroundColor: Colors.grey,
              toolbarColor: Colors.grey[100],
              toolbarWidgetColor: color,
              activeControlsWidgetColor: color,
              cropFrameColor: color,
              lockAspectRatio: isProfile ? true : false,
            ),
          ],
        );

        if (croppedFile != null) {
          selectedImage = File(croppedFile.path);
          List<int> imageBytes = selectedImage!.readAsBytesSync();
          print(imageBytes);
          imagePath.value = base64Encode(imageBytes);
          update();

          return File(imagePath.value);
        }
      }
    } catch (e) {
      print("Exception - $screen - openGallery()" + e.toString());
    }
    return null;
  }

//Date oF Birth
  final TextEditingController cBirthDate = TextEditingController();
  DateTime? selectedDate;
  onDateSelected(DateTime? picked) {
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      cBirthDate.text = selectedDate.toString();
      cBirthDate.text = formatDate(selectedDate!, [dd, '-', mm, '-', yyyy]);
    }
    update();
  }

//Gender List
  String selectedGender = "Male";
  //Choose category
  final cSelectCategory = TextEditingController();
//Primary Skills
  final TextEditingController cPrimarySkill = TextEditingController();
//All Skills
  final TextEditingController cAllSkill = TextEditingController();
//Language
  final TextEditingController cLanguage = TextEditingController();
//Charge
  final TextEditingController cCharges = TextEditingController();
  final FocusNode fCharges = FocusNode();
  //Video call Charge
  final TextEditingController cVideoCharges = TextEditingController();
  final FocusNode fVideoCharges = FocusNode();
  //Charge
  final TextEditingController cReportCharges = TextEditingController();
  final FocusNode fReportCharges = FocusNode();
//Expirence
  final TextEditingController cExpirence = TextEditingController();
  final FocusNode fExpirence = FocusNode();
//Contribution Hours
  final TextEditingController cContributionHours = TextEditingController();
  final FocusNode fContributionHours = FocusNode();
//Hear about astrotalk
  final TextEditingController cHearAboutAstroGuru = TextEditingController();
  final FocusNode fHearAboutAstroGuru = FocusNode();

//Working on Any Other Platform
  final TextEditingController cNameOfPlatform = TextEditingController();
  final FocusNode fNameOfPlatform = FocusNode();
  final TextEditingController cMonthlyEarning = TextEditingController();
  final FocusNode fMonthlyEarning = FocusNode();
  int? anyOnlinePlatform;
  void setOnlinePlatform(int? index) {
    anyOnlinePlatform = index;
    update();
  }

//----------------Other Details--------------

//on board you
  final TextEditingController cOnBoardYou = TextEditingController();
  final FocusNode fOnBoardYou = FocusNode();
//time for interview
  final TextEditingController cTimeForInterview = TextEditingController();
  final FocusNode fTimeForInterview = FocusNode();
//live city
  final TextEditingController cLiveCity = TextEditingController();
  final FocusNode fLiveCity = FocusNode();
//source of business
  String? selectedSourceOfBusiness;
//source of business
  String? selectedHighestQualification;
//source of business
  String? selectedDegreeDiploma;
//College/School/university
  final TextEditingController cCollegeSchoolUniversity = TextEditingController();
  final FocusNode fCollegeSchoolUniversity = FocusNode();
//Learn Astrology
  final TextEditingController cLearnAstrology = TextEditingController();
  final FocusNode fLearnAstroLogy = FocusNode();
//Insta
  final TextEditingController cInsta = TextEditingController();
  final FocusNode fInsta = FocusNode();
//Facebook
  final TextEditingController cFacebook = TextEditingController();
  final FocusNode fFacebook = FocusNode();
//LinkedIn
  final TextEditingController cLinkedIn = TextEditingController();
  final FocusNode fLinkedIn = FocusNode();
//Youtube
  final TextEditingController cYoutube = TextEditingController();
  final FocusNode fYoutube = FocusNode();
//Website
  final TextEditingController cWebSite = TextEditingController();
  final FocusNode fWebSite = FocusNode();
//refer
  final TextEditingController cNameOfReferPerson = TextEditingController();
  final FocusNode fNameOfReferPerson = FocusNode();
  int? referPerson;
  void setReferPerson(int? index) {
    referPerson = index;
    update();
  }

//Expected Minimum Earning from Astroguru
  final TextEditingController cExptectedMinimumEarning = TextEditingController();
  final FocusNode fExpectedMinimumEarning = FocusNode();
//Expected Maximum Earning
  final TextEditingController cExpectedMaximumEarning = TextEditingController();
  final FocusNode fExpectedMaximumEarning = FocusNode();
//Long Bio
  final TextEditingController cLongBio = TextEditingController();
  final FocusNode fLongBio = FocusNode();

//-------------------------Assignment----------------------------

//foreign country
  String? selectedForeignCountryCount;
//currently working as job
  String? selectedCurrentlyWorkingJob;

//Facebook
  final TextEditingController cGoodQuality = TextEditingController();
  final FocusNode fGoodQuality = FocusNode();
//LinkedIn
  final TextEditingController cBiggestChallenge = TextEditingController();
  final FocusNode fBiggestChallenge = FocusNode();
//Youtube
  final TextEditingController cRepeatedQuestion = TextEditingController();
  final FocusNode fRepeatedQuestion = FocusNode();

//--------------------------time------------------------------------
  List<Week>? week = [];
  List<TimeAvailabilityModel>? timeAvailabilityList = [];
  List<String?> daysList = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

  void clearTime() {
    cStartTime.text = '';
    cEndTime.text = '';
  }

//---------------------------Availability---------------------------
  final TextEditingController cSunday = TextEditingController();
  final TextEditingController cMonday = TextEditingController();
  final TextEditingController cTuesday = TextEditingController();
  final TextEditingController cWednesday = TextEditingController();
  final TextEditingController cThursday = TextEditingController();
  final TextEditingController cFriday = TextEditingController();
  final TextEditingController cSaturday = TextEditingController();

  final cStartTime = TextEditingController();
  final cEndTime = TextEditingController();

  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  //Available Time Start
  selectStartTime(BuildContext context) async {
    try {
      final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: selectedStartTime,
        initialEntryMode: TimePickerEntryMode.dial,
      );

      if (timeOfDay != null) {
        selectedStartTime = timeOfDay;
        cStartTime.text = timeOfDay.format(context);
      }
      update();
    } catch (e) {
      print('Exception - $screen - selectStartTime():' + e.toString());
    }
  }

  //Available Time End
  selectEndTime(BuildContext context) async {
    try {
      final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: selectedEndTime,
        initialEntryMode: TimePickerEntryMode.dial,
      );
      if (timeOfDay != null) {
        selectedEndTime = timeOfDay;
        cEndTime.text = timeOfDay.format(context);
      }
      update();
    } catch (e) {
      print('Exception - $screen - selectEndTime():' + e.toString());
    }
  }

//----------Button On Tap---------
  onStepBack() {
    if (index >= 0) {
      index -= 1;
      update();
    }
  }

  onStepNext() {
    if (index == 0 || index > 0) {
      index += 1;
      update();
    }
  }

  //Fill data
  fillAstrologer(CurrentUser user) {
    try {
      if (global.user.name != null && global.user.name != '') {
        cName.text = global.user.name!;
      }
      if (global.user.email != null && global.user.email != '') {
        cEmail.text = global.user.email!;
      }
      if (global.user.contactNo != null && global.user.contactNo != '') {
        cMobileNumber.text = global.user.contactNo!;
      }
      if (global.user.imagePath != null && global.user.imagePath != '') {
        selectedImage = File(global.user.imagePath.toString());
        profile = global.user.imagePath!;
      }
      if (global.user.gender != null && global.user.gender != '') {
        selectedGender = global.user.gender!;
      }
      if (global.user.birthDate != null) {
        cBirthDate.text = DateFormat('dd-MM-yyyy').format(DateTime.parse(global.user.birthDate.toString()));
        selectedDate = DateTime.parse(global.user.birthDate.toString());
      }
      if (global.user.astrologerCategoryId != null && global.user.astrologerCategoryId != []) {
        cSelectCategory.text = global.user.astrologerCategoryId!.map((e) => e.name).toList().toString().replaceAll('[', '').replaceAll(']', '');
        for (var i = 0; i < global.astrologerCategoryModelList!.length; i++) {
          global.astrologerCategoryModelList![i].isCheck = false;
          for (var j = 0; j < global.user.astrologerCategoryId!.length; j++) {
            if (global.user.astrologerCategoryId![j].id == global.astrologerCategoryModelList![i].id) {
              global.astrologerCategoryModelList![i].isCheck = true;
            }
          }
        }
      }
      if (global.user.primarySkillId != null && global.user.primarySkillId != []) {
        cPrimarySkill.text = global.user.primarySkillId!.map((e) => e.name).toList().toString().replaceAll('[', '').replaceAll(']', '');
        for (var i = 0; i < global.skillModelList!.length; i++) {
          global.skillModelList![i].isCheck = false;
          for (var j = 0; j < global.user.primarySkillId!.length; j++) {
            if (global.user.primarySkillId![j].id == global.skillModelList![i].id) {
              global.skillModelList![i].isCheck = true;
            }
          }
        }
      }
      if (global.user.allSkillId != null && global.user.allSkillId != []) {
        cAllSkill.text = global.user.allSkillId!.map((e) => e.name).toList().toString().replaceAll('[', '').replaceAll(']', '');
        for (var i = 0; i < global.allSkillModelList!.length; i++) {
          global.allSkillModelList![i].isCheck = false;
          for (var j = 0; j < global.user.allSkillId!.length; j++) {
            if (global.user.allSkillId![j].id == global.allSkillModelList![i].id) {
              global.allSkillModelList![i].isCheck = true;
            }
          }
        }
      }
      if (global.user.languageId != null && global.user.languageId != []) {
        cLanguage.text = global.user.languageId!.map((e) => e.name).toList().toString().replaceAll('[', '').replaceAll(']', '');
        for (var i = 0; i < global.languageModelList!.length; i++) {
          global.languageModelList![i].isCheck = false;
          for (var j = 0; j < global.user.languageId!.length; j++) {
            if (global.user.languageId![j].id == global.languageModelList![i].id) {
              global.languageModelList![i].isCheck = true;
            }
          }
        }
      }
      if (global.user.charges != null) {
        cCharges.text = global.user.charges.toString();
      }
      if (global.user.videoCallRate != null) {
        cVideoCharges.text = global.user.videoCallRate.toString();
      }
      if (global.user.reportRate != null) {
        cReportCharges.text = global.user.reportRate.toString();
      }
      if (global.user.expirenceInYear != null) {
        cExpirence.text = global.user.expirenceInYear.toString();
      }
      if (global.user.dailyContributionHours != null) {
        cContributionHours.text = global.user.dailyContributionHours.toString();
      }
      if (global.user.hearAboutAstroGuru != null && global.user.hearAboutAstroGuru != '') {
        cHearAboutAstroGuru.text = global.user.hearAboutAstroGuru!;
      }
      if (global.user.isWorkingOnAnotherPlatform != null) {
        anyOnlinePlatform = global.user.isWorkingOnAnotherPlatform;
      }
      if (global.user.otherPlatformName != null && global.user.otherPlatformName != '') {
        cNameOfPlatform.text = global.user.otherPlatformName!;
      }
      if (global.user.otherPlatformMonthlyEarning != null && global.user.otherPlatformMonthlyEarning != '') {
        cMonthlyEarning.text = global.user.otherPlatformMonthlyEarning!;
      }
      if (global.user.onboardYou != null && global.user.onboardYou != '') {
        cOnBoardYou.text = global.user.onboardYou!;
      }
      if (global.user.suitableInterviewTime != null && global.user.suitableInterviewTime != '') {
        cTimeForInterview.text = global.user.suitableInterviewTime!;
      }
      if (global.user.currentCity != null && global.user.currentCity != '') {
        cLiveCity.text = global.user.currentCity!;
      }
      if (global.user.mainSourceOfBusiness != null && global.user.mainSourceOfBusiness != '') {
        selectedSourceOfBusiness = global.user.mainSourceOfBusiness!;
      }
      if (global.user.highestQualification != null && global.user.highestQualification != '') {
        selectedHighestQualification = global.user.highestQualification!;
      }
      if (global.user.degreeDiploma != null && global.user.degreeDiploma != '') {
        selectedDegreeDiploma = global.user.degreeDiploma!;
      }
      if (global.user.collegeSchoolUniversity != null && global.user.collegeSchoolUniversity != '') {
        cCollegeSchoolUniversity.text = global.user.collegeSchoolUniversity!;
      }
      if (global.user.learnAstrology != null && global.user.learnAstrology != '') {
        cLearnAstrology.text = global.user.learnAstrology!;
      }
      if (global.user.instagramProfileLink != null && global.user.instagramProfileLink != '') {
        cInsta.text = global.user.instagramProfileLink!;
      }
      if (global.user.facebookProfileLink != null && global.user.facebookProfileLink != '') {
        cFacebook.text = global.user.facebookProfileLink!;
      }
      if (global.user.linkedInProfileLink != null && global.user.linkedInProfileLink != '') {
        cLinkedIn.text = global.user.linkedInProfileLink!;
      }
      if (global.user.youtubeProfileLink != null && global.user.youtubeProfileLink != '') {
        cYoutube.text = global.user.youtubeProfileLink!;
      }
      if (global.user.webSiteProfileLink != null && global.user.webSiteProfileLink != '') {
        cWebSite.text = global.user.webSiteProfileLink!;
      }
      if (global.user.isAnyBodyRefer != null) {
        referPerson = global.user.isAnyBodyRefer;
      }
      if (global.user.referedPersonName != null && global.user.referedPersonName != '') {
        cNameOfReferPerson.text = global.user.referedPersonName!;
      }
      if (global.user.expectedMinimumEarning != null) {
        cExptectedMinimumEarning.text = global.user.expectedMinimumEarning.toString();
      }
      if (global.user.expectedMaximumEarning != null) {
        cExpectedMaximumEarning.text = global.user.expectedMaximumEarning.toString();
      }
      if (global.user.longBio != null && global.user.longBio != '') {
        cLongBio.text = global.user.longBio!;
      }
      if (global.user.foreignCountryCount != null && global.user.foreignCountryCount != '') {
        selectedForeignCountryCount = global.user.foreignCountryCount!;
      }
      if (global.user.currentlyWorkingJob != null && global.user.currentlyWorkingJob != '') {
        selectedCurrentlyWorkingJob = global.user.currentlyWorkingJob!;
      }
      if (global.user.goodQualityOfAstrologer != null && global.user.goodQualityOfAstrologer != '') {
        cGoodQuality.text = global.user.goodQualityOfAstrologer!;
      }
      if (global.user.biggestChallengeFaced != null && global.user.biggestChallengeFaced != '') {
        cBiggestChallenge.text = global.user.biggestChallengeFaced!;
      }
      if (global.user.repeatedQuestion != null && global.user.repeatedQuestion != '') {
        cRepeatedQuestion.text = global.user.repeatedQuestion!;
      }
      week = [];
      if (global.user.week != null && global.user.week != []) {
        for (var i = 0; i < global.user.week!.length; i++) {
          week!.add(Week(day: global.user.week![i].day, timeAvailabilityList: global.user.week![i].timeAvailabilityList));
        }
      }
    } catch (e) {
      print("Exception - $screen - fillAstrologer(): " + e.toString());
    }
  }

  updateValidateForm(int index, {BuildContext? context}) {
    try {
//------Validation_of_Personal_Detail-----------------
      if (index == 0) {
        if (cName.text != "" && (cEmail.text != '' && GetUtils.isEmail(cEmail.text)) && (cMobileNumber.text != "" && cMobileNumber.text.length == 10) && termAndCondtion.value == true) {
          print("index = 0");
          onStepNext();
        } else if (cName.text == "") {
          global.showToast(message: "Please Enter Valid Name");
        } else if (cEmail.text == '' || !GetUtils.isEmail(cEmail.text)) {
          global.showToast(message: "Please Enter Valid Email Address");
        } else if (cMobileNumber.text == '' || cMobileNumber.text.length != 10) {
          global.showToast(message: "Please Enter Valid Mobile Number");
        } else if (termAndCondtion.value == false) {
          global.showToast(message: "Please Agree With T&C");
        } else {
          global.showToast(message: "Something Wrong in Personal Detail Form");
        }
      }
//------Validation_of_Skill_Detail-----------------
      else if (index == 1) {
        if (selectedGender != "" &&
            selectedDate != null &&
            cSelectCategory.text != "" &&
            cPrimarySkill.text != "" &&
            cAllSkill.text != "" &&
            cLanguage.text != "" &&
            cCharges.text != "" &&
            cVideoCharges.text != "" &&
            cReportCharges.text != "" &&
            cExpirence.text != "" &&
            cContributionHours.text != "" &&
            (anyOnlinePlatform == 1 && cNameOfPlatform.text != "" || anyOnlinePlatform == 2 || anyOnlinePlatform == null) &&
            (anyOnlinePlatform == 1 && cMonthlyEarning.text != "" || anyOnlinePlatform == 2 || anyOnlinePlatform == null)) {
          print("index = 1");
          onStepNext();
        } else if (selectedGender == "") {
          global.showToast(message: "Please Select Gender");
        } else if (selectedDate == null) {
          global.showToast(message: "Please Select Date of Birth");
        } else if (cSelectCategory.text == "") {
          global.showToast(message: "Please Select astrologer category");
        } else if (cPrimarySkill.text == "") {
          global.showToast(message: "Please Select Primary Skill");
        } else if (cAllSkill.text == "") {
          global.showToast(message: "Please Select All Skill");
        } else if (cLanguage.text == "") {
          global.showToast(message: "Please Select Language");
        } else if (cCharges.text == "") {
          global.showToast(message: "Please Enter Charges");
        } else if (cVideoCharges.text == "") {
          global.showToast(message: "Please Enter video Charges");
        } else if (cReportCharges.text == "") {
          global.showToast(message: "Please Enter report Charges");
        } else if (cExpirence.text == "") {
          global.showToast(message: "Please Enter Expirence");
        } else if (cContributionHours.text == "") {
          global.showToast(message: "Please Enter Contribution Hours");
        } else if (anyOnlinePlatform == 1 && cNameOfPlatform.text == "") {
          global.showToast(message: "Please Enter Name Of Platform");
        } else if (anyOnlinePlatform == 1 && cMonthlyEarning.text == "") {
          global.showToast(message: "Please Enter Monthly Earning");
        } else {
          global.showToast(message: "Something Wrong in Skill Detail Form");
        }
      }
//------Validation_of_Other_Detail-----------------
      else if (index == 2) {
        if (cOnBoardYou.text != "" && cTimeForInterview.text != "" && (selectedSourceOfBusiness != "" && selectedSourceOfBusiness != null) && (selectedHighestQualification != "" && selectedHighestQualification != null) && (selectedDegreeDiploma != "" && selectedDegreeDiploma != null) && cExptectedMinimumEarning.text != "" && cExpectedMaximumEarning.text != "" && cLongBio.text != "") {
          print("index = 2");
          onStepNext();
        } else if (cOnBoardYou.text == "") {
          global.showToast(message: "Please Enter Why Should We Onboard You");
        } else if (cTimeForInterview.text == "") {
          global.showToast(message: "Please Enter Suitable Time For Interview");
        } else if (selectedSourceOfBusiness == null || selectedSourceOfBusiness == "") {
          global.showToast(message: "Please Select Source Of Business");
        } else if (selectedHighestQualification == null || selectedHighestQualification == "") {
          global.showToast(message: "Please Select Highest Qualification");
        } else if (selectedDegreeDiploma == null || selectedDegreeDiploma == "") {
          global.showToast(message: "Please Select Degree/Diploma");
        } else if (cExptectedMinimumEarning.text == "") {
          global.showToast(message: "Please Enter Minimum Earning");
        } else if (cExpectedMaximumEarning.text == "") {
          global.showToast(message: "Please Enter Maximum Earning");
        } else if (cLongBio.text == "") {
          global.showToast(message: "Please Enter Long Bio");
        } else {
          global.showToast(message: "Something Wrong in Other Detail Form");
        }
      }
//------Validation_of_Assignment-----------------
      else if (index == 3) {
        if ((selectedForeignCountryCount != "" && selectedForeignCountryCount != null) && (selectedCurrentlyWorkingJob != "" && selectedCurrentlyWorkingJob != null) && cGoodQuality.text != "" && cBiggestChallenge.text != "" && cRepeatedQuestion.text != "") {
          print("index = 3");
          onStepNext();
        } else if (selectedForeignCountryCount == "" || selectedForeignCountryCount == null) {
          global.showToast(message: "Please Select Number of Foreign Country You Lived");
        } else if (selectedCurrentlyWorkingJob == "" || selectedCurrentlyWorkingJob == null) {
          global.showToast(message: "Please Select Current Working Fulltime Job");
        } else if (cGoodQuality.text == "") {
          global.showToast(message: "Please Enter Good Quality");
        } else if (cBiggestChallenge.text == "") {
          global.showToast(message: "Please Enter Biggest Challenge");
        } else if (cRepeatedQuestion.text == "") {
          global.showToast(message: "Please Enter Repeated Question");
        } else {
          global.showToast(message: "Something Wrong in Assignment Form");
        }
      }
//------Validation_of_Availability_Detail-----------------
      else if (index == 4) {
        updateAstrologer(updateId!);
      } else {
        global.showToast(message: "No Index Found");
      }
    } catch (err) {
      global.printException("edit_profile_controller.dart", "updateValidateForm()", err);
    }
  }

//Update astrologer
  CurrentUser updateUser = CurrentUser();
  Future updateAstrologer(int id) async {
    try {
      await global.checkBody().then(
        (networkResult) async {
          if (networkResult) {
            int a = global.user.userId!;
            updateUser.id = id;
            updateUser.userId = a;
            updateUser.roleId = 2;
            updateUser.name = cName.text;
            updateUser.email = cEmail.text;
            updateUser.contactNo = cMobileNumber.text;
            // ignore: unnecessary_null_comparison
            if (profile != null && profile != '') {
              updateUser.imagePath = profile;
            }
            // updateUser.imagePath = imagePath.value;
            updateUser.gender = selectedGender;
            updateUser.birthDate = selectedDate;
            updateUser.primarySkill = cPrimarySkill.text;
            updateUser.astrologerCategory = cSelectCategory.text;
            updateUser.allSkill = cAllSkill.text;
            updateUser.languageKnown = cLanguage.text;
            updateUser.charges = int.parse(cCharges.text);
            updateUser.videoCallRate = int.parse(cVideoCharges.text);
            updateUser.reportRate = int.parse(cReportCharges.text);
            updateUser.expirenceInYear = int.parse(cExpirence.text);
            updateUser.dailyContributionHours = int.parse(cContributionHours.text);
            updateUser.hearAboutAstroGuru = cHearAboutAstroGuru.text;
            updateUser.isWorkingOnAnotherPlatform = anyOnlinePlatform;
            updateUser.otherPlatformName = cNameOfPlatform.text;
            updateUser.otherPlatformMonthlyEarning = cMonthlyEarning.text;
            updateUser.onboardYou = cOnBoardYou.text;
            updateUser.suitableInterviewTime = cTimeForInterview.text;
            updateUser.currentCity = cLiveCity.text;
            updateUser.mainSourceOfBusiness = selectedSourceOfBusiness;
            updateUser.highestQualification = selectedHighestQualification;
            updateUser.degreeDiploma = selectedDegreeDiploma;
            updateUser.collegeSchoolUniversity = cCollegeSchoolUniversity.text;
            updateUser.learnAstrology = cLearnAstrology.text;
            updateUser.instagramProfileLink = cInsta.text;
            updateUser.facebookProfileLink = cFacebook.text;
            updateUser.linkedInProfileLink = cLinkedIn.text;
            updateUser.youtubeProfileLink = cYoutube.text;
            updateUser.webSiteProfileLink = cWebSite.text;
            updateUser.isAnyBodyRefer = referPerson;
            updateUser.referedPersonName = cNameOfReferPerson.text;
            updateUser.expectedMinimumEarning = int.parse(cExptectedMinimumEarning.text);
            updateUser.expectedMaximumEarning = int.parse(cExpectedMaximumEarning.text);
            updateUser.longBio = cLongBio.text;
            updateUser.foreignCountryCount = selectedForeignCountryCount;
            updateUser.currentlyWorkingJob = selectedCurrentlyWorkingJob;
            updateUser.goodQualityOfAstrologer = cGoodQuality.text;
            updateUser.biggestChallengeFaced = cBiggestChallenge.text;
            updateUser.repeatedQuestion = cRepeatedQuestion.text;
            updateUser.token = global.user.token;
            updateUser.tokenType = global.user.tokenType;
            updateUser.week = [];

            for (var i = 0; i < week!.length; i++) {
              if (week![i].timeAvailabilityList!.isNotEmpty) {
                updateUser.week!.add(Week(day: week![i].day, timeAvailabilityList: week![i].timeAvailabilityList));
              }
            }

            //Astrologer category
            updateUser.astrologerCategoryId = [];
            if (astroId.isEmpty) {
              for (var i = 0; i < global.user.astrologerCategoryId!.length; i++) {
                updateUser.astrologerCategoryId!.add(global.user.astrologerCategoryId![i]);
              }
            } else {
              for (var i = 0; i < astroId.length; i++) {
                updateUser.astrologerCategoryId!.add(astroId[i]);
              }
            }

            //Primary skill
            updateUser.primarySkillId = [];
            if (primaryId.isEmpty) {
              for (var i = 0; i < global.user.primarySkillId!.length; i++) {
                updateUser.primarySkillId!.add(global.user.primarySkillId![i]);
              }
            } else {
              for (var i = 0; i < primaryId.length; i++) {
                updateUser.primarySkillId!.add(primaryId[i]);
              }
            }

            //All skill
            updateUser.allSkillId = [];
            if (allId.isEmpty) {
              for (var i = 0; i < global.user.allSkillId!.length; i++) {
                updateUser.allSkillId!.add(global.user.allSkillId![i]);
              }
            } else {
              for (var i = 0; i < allId.length; i++) {
                updateUser.allSkillId!.add(allId[i]);
              }
            }

            //language known
            updateUser.languageId = [];
            if (lId.isEmpty) {
              for (var i = 0; i < global.user.languageId!.length; i++) {
                updateUser.languageId!.add(global.user.languageId![i]);
              }
            } else {
              for (var i = 0; i < lId.length; i++) {
                updateUser.languageId!.add(lId[i]);
              }
            }

            await apiHelper.astrologerUpdate(updateUser).then(
              (apiResult) async {
                if (apiResult.status == '200') {
                  global.user = updateUser;
                  signupController.astrologerList.clear();
                  await signupController.astrologerProfileById(false);
                  update();
                  await global.sp!.setString('currentUser', json.encode(global.user.toJson()));
                  Get.back();
                  global.showToast(message: "Your profile has been updated");
                } else if (apiResult.status == '400') {
                  global.showToast(message: apiResult.message.toString());
                } else {
                  global.showToast(message: "Something Went Wrong, Please Try Again Later");
                }
              },
            );
          } else {
            global.showToast(message: "No Network Available");
          }
        },
      );
      update();
    } catch (err) {
      global.printException("edit_profile_controller.dart", "updateAstrologer", err);
    }
  }
}
