// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, avoid_print, duplicate_ignore

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:astrologer_app/controllers/Authentication/signup_otp_controller.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/all_skill_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/astrologer_category_list_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/language_list_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/primary_skill_model.dart';
import 'package:astrologer_app/models/time_availability_model.dart';
import 'package:astrologer_app/models/user_model.dart';
import 'package:astrologer_app/models/week_model.dart';
import 'package:astrologer_app/services/apiHelper.dart';
import 'package:astrologer_app/views/Authentication/OtpScreens/signup_otp_screen.dart';
import 'package:astrologer_app/views/Authentication/success_registration_screen.dart';
import 'package:date_format/date_format.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:astrologer_app/utils/global.dart' as global;

class SignupController extends GetxController {
//Class
  APIHelper apiHelper = APIHelper();
  String screen = 'signup_controller.dart';

  final cReply = TextEditingController();
  void clearReply() {
    cReply.text = '';
  }

  List<CurrentUser> astrologerList = [];

  //List of checkbox
  List<AstrolgoerCategoryModel> astroId = [];
  List<PrimarySkillModel> primaryId = [];
  List<AllSkillModel> allId = [];
  List<LanguageModel> lId = [];

//static List
  List<Week>? week = [];
  List<TimeAvailabilityModel>? timeAvailabilityList = [];
  List<String?> daysList = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

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
  RxBool termAndCondtion = false.obs;
//--------------------------Skills Details----------------------
//User Image
  Uint8List? tImage;
  File? selectedImage;
  var imagePath = ''.obs;
  onOpenCamera() async {
    selectedImage = await openCamera(Get.theme.primaryColor).obs();
    update();
  }

  onOpenGallery() async {
    selectedImage = await openGallery(Get.theme.primaryColor).obs();
    update();
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

          List<int> decodedbytes = base64.decode(imagePath.value);
          return File(decodedbytes.toString());
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

  bool select = false;
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

  void clearTime() {
    cStartTime.text = '';
    cEndTime.text = '';
  }

// dynamic Availability Widget
  Widget dynamicWeekFieldWidget(BuildContext? context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        height: 35,
        child: Container(
          padding: const EdgeInsets.only(bottom: 8.0),
          height: 35,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(""),
        ),
      ),
    );
  }

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
      print('Exception  - $screen - selectStartTime():' + e.toString());
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

//----------------------Button On Tap-------------------
  int index = 0;
  onStepBack() {
    try {
      if (index >= 0) {
        index -= 1;
        update();
      }
    } catch (err) {
      global.printException("singup_controller.dart", "onStepBack", err);
    }
  }

  onStepNext() {
    try {
      if (index == 0 || index > 0) {
        index += 1;
        update();
      }
    } catch (err) {
      global.printException("singup_controller.dart", "onStepNext", err);
    }
  }

  validateForm(int index, {BuildContext? context}) {
    try {
//------Validation_of_Personal_Detail-----------------
      if (index == 0) {
        if (cName.text != "" && (cEmail.text != '' && GetUtils.isEmail(cEmail.text)) && (cMobileNumber.text != "" && cMobileNumber.text.length == 10) && termAndCondtion.value == true) {
          print("index = 0");
          checkContactExist(cMobileNumber.text);
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
          // } else if (selectedImage == null) {
          //   global.showToast(message: "Please Select Image");
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
        // signupAstrologer();
        if (cStartTime.text != '' && cEndTime.text != '') {
          signupAstrologer();
        } else {
          global.showToast(message: "Please select time");
        }
      } else {
        global.showToast(message: "No Index Found");
      }
    } catch (err) {
      global.printException("signup_controller.dart", "validateForm()", err);
    }
  }

//Register astrologer
  Future signupAstrologer() async {
    try {
      await global.checkBody().then(
        (networkResult) async {
          if (networkResult) {
            await global.getDeviceData();
            global.user.roleId = 2;
            global.user.name = cName.text;
            global.user.email = cEmail.text;
            global.user.contactNo = cMobileNumber.text;
            global.user.imagePath = imagePath.value;
            global.user.gender = selectedGender;
            global.user.birthDate = selectedDate;
            global.user.primarySkill = cPrimarySkill.text;
            global.user.astrologerCategory = cSelectCategory.text;
            global.user.allSkill = cAllSkill.text;
            global.user.languageKnown = cLanguage.text;
            global.user.charges = int.parse(cCharges.text);
            global.user.videoCallRate = int.parse(cVideoCharges.text);
            global.user.reportRate = int.parse(cReportCharges.text);
            global.user.expirenceInYear = int.parse(cExpirence.text);
            global.user.dailyContributionHours = int.parse(cContributionHours.text);
            global.user.hearAboutAstroGuru = cHearAboutAstroGuru.text;
            global.user.isWorkingOnAnotherPlatform = anyOnlinePlatform;
            global.user.otherPlatformName = cNameOfPlatform.text;
            global.user.otherPlatformMonthlyEarning = cMonthlyEarning.text;
            global.user.onboardYou = cOnBoardYou.text;
            global.user.suitableInterviewTime = cTimeForInterview.text;
            global.user.currentCity = cLiveCity.text;
            global.user.mainSourceOfBusiness = selectedSourceOfBusiness;
            global.user.highestQualification = selectedHighestQualification;
            global.user.degreeDiploma = selectedDegreeDiploma;
            global.user.collegeSchoolUniversity = cCollegeSchoolUniversity.text;
            global.user.learnAstrology = cLearnAstrology.text;
            global.user.instagramProfileLink = cInsta.text;
            global.user.facebookProfileLink = cFacebook.text;
            global.user.linkedInProfileLink = cLinkedIn.text;
            global.user.youtubeProfileLink = cYoutube.text;
            global.user.webSiteProfileLink = cWebSite.text;
            global.user.isAnyBodyRefer = referPerson;
            global.user.referedPersonName = cNameOfReferPerson.text;
            global.user.expectedMinimumEarning = int.parse(cExptectedMinimumEarning.text);
            global.user.expectedMaximumEarning = int.parse(cExpectedMaximumEarning.text);
            global.user.longBio = cLongBio.text;
            global.user.foreignCountryCount = selectedForeignCountryCount;
            global.user.currentlyWorkingJob = selectedCurrentlyWorkingJob;
            global.user.goodQualityOfAstrologer = cGoodQuality.text;
            global.user.biggestChallengeFaced = cBiggestChallenge.text;
            global.user.repeatedQuestion = cRepeatedQuestion.text;
            global.user.astrologerCategoryId = [];
            global.user.primarySkillId = [];
            global.user.allSkillId = [];
            global.user.languageId = [];

            for (var i = 0; i < astroId.length; i++) {
              global.user.astrologerCategoryId!.addAll(astroId);
            }
            for (var i = 0; i < primaryId.length; i++) {
              global.user.primarySkillId!.addAll(primaryId);
            }
            for (var i = 0; i < allId.length; i++) {
              global.user.allSkillId!.addAll(allId);
            }
            for (var i = 0; i < lId.length; i++) {
              global.user.languageId!.addAll(lId);
            }

            global.user.week = [];
            for (var i = 0; i < week!.length; i++) {
              if (week![i].timeAvailabilityList!.isNotEmpty) {
                global.user.week!.add(Week(day: week![i].day, timeAvailabilityList: week![i].timeAvailabilityList));
              }
            }
            global.user.week!.removeWhere((element) => element.day == "");
            global.showOnlyLoaderDialog();
            await apiHelper.signUp(global.user).then(
              (apiRresult) async {
                global.hideLoader();
                if (apiRresult.status == '200') {
                  global.user = apiRresult.recordList;
                  Get.offUntil(MaterialPageRoute(builder: (context) => const SuccessRegistrationScreen()), (route) => false);
                  global.showToast(message: "You Have Succesfully Register User");
                } else if (apiRresult.status == '400') {
                  global.showToast(message: apiRresult.message);
                  update();
                } else {
                  global.showToast(message: "Somehing Went Wrong, Please Try Again Later");
                }
              },
            );
          } else {
            global.showToast(message: "No Network Available");
          }
        },
      );
    } catch (err) {
      global.printException("singup_controller.dart", "signupAstrologer", err);
    }
  }

//Check contact number exist or not
  checkContactExist(String phoneNumber) async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            await apiHelper.checkExistContactNumber(phoneNumber).then(
              (result) {
                global.hideLoader();
                if (result.status == "200") {
                  sendOTP(phoneNumber);
                } else {
                  global.hideLoader();
                  global.showToast(message: "Contact Number is Already Register");
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print("Exception - SignUpControoler.dart - checkContactExist(): " + e.toString());
    }
  }

//----------------------OTP sent-----------------------------------//
  RxBool isLoading = false.obs;
  String smsCode = "";
  Timer? countDown;

//Send otp to mobile number
  Future<void> sendOTP(String phoneNumber) async {
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      _auth.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {
          print("Select $credential");
        },
        verificationFailed: (FirebaseAuthException e) {
          global.showToast(message: "Please try Again!");
          //Please try agains some time
          print('Login Screen - > failed');
        },
        codeSent: (String verificationId, int? resendToken) async {
          Get.find<SignupOtpController>().second = 60;
          update();

          global.showToast(message: 'OTP has been send to your mobile number');
          Get.find<SignupOtpController>().timer();
          Get.to(() => SignupOtpScreen(
                mobileNumber: cMobileNumber.text,
                verificationId: verificationId,
              ));
          print('Login Screen -> code sent');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print(verificationId);
          print('Login Screen-> time out');
        },
      );
    } catch (e) {
      print("Exception - $screen - sendOTP():" + e.toString());
    }
  }

//Astrologer profile
  ScrollController walletHistoryScrollController = ScrollController();
  ScrollController callHistoryScrollController = ScrollController();
  ScrollController chatHistoryScrollController = ScrollController();
  ScrollController reportHistoryScrollController = ScrollController();
  int fetchRecord = 10;
  int startIndex = 0;
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isMoreDataAvailable = false;

  @override
  onInit() {
    init();
    super.onInit();
  }

  init() async {
    paginateTask();
  }

  void paginateTask() {
    walletHistoryScrollController.addListener(() async {
      if (walletHistoryScrollController.position.pixels == walletHistoryScrollController.position.maxScrollExtent && !isAllDataLoaded) {
        isMoreDataAvailable = true;
        print('scroll my following');
        update();
        await astrologerProfileById(true);
      }
    });
    chatHistoryScrollController.addListener(() async {
      if (chatHistoryScrollController.position.pixels == chatHistoryScrollController.position.maxScrollExtent && !isAllDataLoaded) {
        isMoreDataAvailable = true;
        print('scroll my following');
        update();
        await astrologerProfileById(true);
      }
    });
    callHistoryScrollController.addListener(() async {
      if (callHistoryScrollController.position.pixels == callHistoryScrollController.position.maxScrollExtent && !isAllDataLoaded) {
        isMoreDataAvailable = true;
        print('scroll my following');
        update();
        await astrologerProfileById(true);
      }
    });
    reportHistoryScrollController.addListener(() async {
      if (reportHistoryScrollController.position.pixels == reportHistoryScrollController.position.maxScrollExtent && !isAllDataLoaded) {
        isMoreDataAvailable = true;
        print('scroll my following');
        update();
        await astrologerProfileById(true);
      }
    });
  }

  Future astrologerProfileById(bool isLazyLoading) async {
    try {
      startIndex = 0;
      if (astrologerList.isNotEmpty) {
        startIndex = astrologerList.length;
      }
      if (!isLazyLoading) {
        isDataLoaded = false;
      }
      global.checkBody().then(
        (result) {
          if (result) {
            global.showOnlyLoaderDialog();
            int id = global.user.id ?? 0;
            apiHelper.getAstrologerProfile(id, startIndex, fetchRecord).then((result) {
              global.hideLoader();
              if (result.status == "200") {
                astrologerList.addAll(result.recordList);
                update();
                print("object added in astrologerList");
                print('List length is ${astrologerList.length} ');
                if (result.recordList.length == 0) {
                  isMoreDataAvailable = false;
                  isAllDataLoaded = true;
                }
                if (result.recordList.length < fetchRecord) {
                  isMoreDataAvailable = false;
                  isAllDataLoaded = true;
                }
              } else {
                global.showToast(message: result.message.toString());
              }
              update();
            });
          }
        },
      );
    } catch (e) {
      print('Exception: $screen - astrologerProfileById():-' + e.toString());
    }
  }

//Delete astrologer account
  deleteAstrologer(int id) async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            await apiHelper.astrologerDelete(id).then(
              (result) async {
                global.hideLoader();
                if (result.status == "200") {
                  global.showToast(message: result.message.toString());
                  Get.back();
                } else {
                  global.showToast(message: result.message.toString());
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - rejectCallRequest(): ' + e.toString());
    }
  }

//Clear astrologer data
  clearAstrologer() {
    try {
      //Astrologer category
      for (var i = 0; i < global.astrologerCategoryModelList!.length; i++) {
        global.astrologerCategoryModelList![i].isCheck = false;
      }
      //Primary skill
      for (var i = 0; i < global.skillModelList!.length; i++) {
        global.skillModelList![i].isCheck = false;
      }
      //All skill
      for (var i = 0; i < global.allSkillModelList!.length; i++) {
        global.allSkillModelList![i].isCheck = false;
      }
      //Language
      for (var i = 0; i < global.languageModelList!.length; i++) {
        global.languageModelList![i].isCheck = false;
      }
    } catch (e) {
      print("Exception - $screen - clearAstrologer():" + e.toString());
    }
  }

//send reply
  Future sendReply(int id, String reply) async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            await apiHelper.astrologerReply(id, reply).then(
              (result) {
                global.hideLoader();
                if (result.status == "200") {
                  cReply.text = '';
                  global.showToast(message: result.message.toString());
                  astrologerList.clear();
                  isAllDataLoaded = false;
                  update();
                  astrologerProfileById(false);
                } else {
                  global.showToast(message: "Review is not send");
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - sendReply():-' + e.toString());
    }
  }
}
