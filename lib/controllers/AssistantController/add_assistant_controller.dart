// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_interpolation_to_compose_strings, avoid_print, unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'package:astrologer_app/models/astrologerAssistant_model.dart';
import 'package:astrologer_app/services/apiHelper.dart';
import 'package:astrologer_app/views/HomeScreen/Assistant/assistant_screen.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:intl/intl.dart';
import '../../models/Master Table Model/assistant/assistant_all_skill_model.dart';
import '../../models/Master Table Model/assistant/assistant_language_list_model.dart';
import '../../models/Master Table Model/assistant/assistant_primary_skill_model.dart';

class AddAssistantController extends GetxController {
  String screen = 'add_assistant_controller.dart';
  APIHelper apiHelper = APIHelper();

  //Models
  List<AstrologerAssistantModel> astrologerAssistantList = [];
  List<AssistantLanguageModel> assistantLanguagesId = [];
  List<AssistantPrimarySkillModel> assistantPrimaryId = [];
  List<AssistantAllSkillModel> assistantAllId = [];
  File? imageFile;
  File? userFile;
  String profile = "";

  onOpenCamera() async {
    selectedImage = await openCamera(Get.theme.primaryColor).obs();
    update();
  }

  //Update id
  int? updateAssistantId;

  @override
  void onInit() async {
    _init();
    super.onInit();
  }

  _init() async {
    await getAstrologerAssistantList();
  }

  //model
  AstrologerAssistantModel assistant = AstrologerAssistantModel();
  //User Image
  Uint8List? tImage;
  File? selectedImage;
  var imagePath = ''.obs;

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
          selectedImage = File(_croppedFile.path);
          List<int> imageBytes = selectedImage!.readAsBytesSync();
          print(imageBytes);
          imagePath.value = base64Encode(imageBytes);
          update();

          return File(imagePath.value);
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

          return File(imagePath.value);
        }
      }

      update();
    } catch (e) {
      print("Exception - $screen - openGallery()" + e.toString());
    }
    return null;
  }

//Name
  final TextEditingController cName = TextEditingController();
  final FocusNode fName = FocusNode();
//Email
  final TextEditingController cEmail = TextEditingController();
  final FocusNode fEmail = FocusNode();
//Mobile Numer
  final TextEditingController cMobileNumber = TextEditingController();
  final FocusNode fMobileNumber = FocusNode();
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
  dynamic selectGender = "Male";
//Primary Skills
  final TextEditingController cAssistantPrimarySkill = TextEditingController();
//All Skill
  final TextEditingController cAssistantAllSkill = TextEditingController();
//Language
  final TextEditingController cAssistantLanguage = TextEditingController();
//Expirence
  final TextEditingController cExpirence = TextEditingController();
  final FocusNode fExpirence = FocusNode();

  int? flagId;

//Validate Add my assistant
  validateAssistantForm() {
    try {
      if (userFile != null && cName.text != "" && (cEmail.text != '' && GetUtils.isEmail(cEmail.text)) && (cMobileNumber.text != "" && cMobileNumber.text.length == 10) && selectedDate != null && (cAssistantPrimarySkill.text != "" && cAssistantAllSkill.text != "" && cAssistantLanguage.text != "" && cExpirence.text != "")) {
        addAstrologerAssistant();
      } else if (cName.text == "") {
        global.showToast(message: "Please Enter Valid Name");
      } else if (cEmail.text == '' || !GetUtils.isEmail(cEmail.text)) {
        global.showToast(message: "Please Enter Valid Email Address");
      } else if (cMobileNumber.text == '' || cMobileNumber.text.length != 10) {
        global.showToast(message: "Please Enter Valid Mobile Number");
      } else if (selectedDate == null) {
        global.showToast(message: "Please Enter birthdate");
      } else if (cAssistantPrimarySkill.text == "") {
        global.showToast(message: "Please Enter primary skill");
      } else if (cAssistantAllSkill.text == "") {
        global.showToast(message: "Please Enter all skill");
      } else if (cAssistantLanguage.text == "") {
        global.showToast(message: "Please Enter language");
      } else if (cExpirence.text == "") {
        global.showToast(message: "Please Enter experience");
      } else if (userFile == null) {
        global.showToast(message: "Please Select Image");
      } else {
        global.showToast(message: "Something Wrong in astrologer assistant Form");
      }
    } catch (e) {
      print("Exception - $screen - validateAssistantForm(): " + e.toString());
    }
  }

  Future<File> imageService(ImageSource imageSource) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? selectedImage = await picker.pickImage(source: imageSource);
      imageFile = File(selectedImage!.path);

      if (selectedImage != null) {
        imageFile;
      }
    } catch (e) {
      print("Exception - businessRule.dart - _openGallery() ${e.toString()}");
    }
    return imageFile!;
  }

  //Add assistant
  addAstrologerAssistant() async {
    try {
      await global.checkBody().then(
        (networkResult) async {
          if (networkResult) {
            assistant.astrologerId = global.user.id;
            assistant.name = cName.text;
            assistant.email = cEmail.text;
            assistant.contactNo = cMobileNumber.text;
            assistant.gender = selectGender;
            assistant.birthdate = selectedDate;
            assistant.primarySkill = cAssistantPrimarySkill.text;
            assistant.allSkill = cAssistantAllSkill.text;
            assistant.languageKnown = cAssistantLanguage.text;
            assistant.assistantPrimarySkillId = [];
            assistant.assistantAllSkillId = [];
            assistant.assistantLanguageId = [];

            for (var i = 0; i < assistantPrimaryId.length; i++) {
              assistant.assistantPrimarySkillId!.addAll(assistantPrimaryId);
            }
            for (var i = 0; i < assistantAllId.length; i++) {
              assistant.assistantAllSkillId!.addAll(assistantAllId);
            }
            for (var i = 0; i < assistantLanguagesId.length; i++) {
              assistant.assistantLanguageId!.addAll(assistantLanguagesId);
            }

            assistant.experienceInYears = int.parse(cExpirence.text);
            if (profile != null && profile != '') {
              assistant.profile = profile;
            }
            assistant.imageFile = imageFile;
            // assistant.profile = imagePath.value;
            // assistant.imageFile = imageFile;

            await apiHelper.astrologerAssistantAdd(assistant).then(
              (apiResult) async {
                if (apiResult.status == '200') {
                  assistant = apiResult.recordList;
                  Get.to(() => AssistantScreen());
                  await getAstrologerAssistantList();
                  global.showToast(message: "You have succesfully add astrologer assistant");
                } else if (apiResult.status == '400') {
                  global.showToast(message: apiResult.message);
                  update();
                } else {
                  global.showToast(message: "Something went wrong please try again later");
                }
              },
            );
          } else {
            global.showToast(message: "No Network Available");
          }
        },
      );
    } catch (e) {
      print("Exception: $screen - addAstrologerAssistant(): " + e.toString());
    }
  }

  //Fill up details
  fillAstrologerAssistant(AstrologerAssistantModel assistant) {
    try {
      if (assistant.name != null && assistant.name != '') {
        cName.text = assistant.name!;
      }
      if (assistant.email != null && assistant.email != '') {
        cEmail.text = assistant.email!;
      }
      if (assistant.contactNo != null && assistant.contactNo != '') {
        cMobileNumber.text = assistant.contactNo!;
      }
      if (assistant.gender != null && assistant.gender != '') {
        selectGender = assistant.gender;
      }
      if (assistant.primarySkill != null && assistant.primarySkill != '') {
        cAssistantPrimarySkill.text = assistant.primarySkill!;
      }
      if (assistant.allSkill != null && assistant.allSkill != '') {
        cAssistantAllSkill.text = assistant.allSkill!;
      }
      if (assistant.languageKnown != null && assistant.languageKnown != '') {
        cAssistantLanguage.text = assistant.languageKnown!;
      }
      if (assistant.birthdate != null) {
        selectedDate = assistant.birthdate;
        cBirthDate.text = DateFormat('dd-MM-yyyy').format(DateTime.parse(assistant.birthdate.toString()));
      }

      if (assistant.profile != null) {
        selectedImage = File(assistant.profile!);
      }
      //selectedImage = null;

      //Primary skill
      if (assistant.assistantPrimarySkillId != null && assistant.assistantPrimarySkillId != []) {
        cAssistantPrimarySkill.text = assistant.assistantPrimarySkillId!.map((e) => e.name).toList().toString().replaceAll('[', '').replaceAll(']', '');
        for (var i = 0; i < global.assistantPrimarySkillModelList!.length; i++) {
          global.assistantPrimarySkillModelList![i].isCheck = false;
          for (var j = 0; j < assistant.assistantPrimarySkillId!.length; j++) {
            if (assistant.assistantPrimarySkillId![j].id == global.assistantPrimarySkillModelList![i].id) {
              global.assistantPrimarySkillModelList![i].isCheck = true;
            }
          }
        }
      }
      //All skill
      if (assistant.assistantAllSkillId != null && assistant.assistantAllSkillId != []) {
        cAssistantAllSkill.text = assistant.assistantAllSkillId!.map((e) => e.name).toList().toString().replaceAll('[', '').replaceAll(']', '');
        for (var i = 0; i < global.assistantAllSkillModelList!.length; i++) {
          global.assistantAllSkillModelList![i].isCheck = false;
          for (var j = 0; j < assistant.assistantAllSkillId!.length; j++) {
            if (assistant.assistantAllSkillId![j].id == global.assistantAllSkillModelList![i].id) {
              global.assistantAllSkillModelList![i].isCheck = true;
            }
          }
        }
      }
      //Language
      if (assistant.assistantLanguageId != null && assistant.assistantLanguageId != []) {
        cAssistantLanguage.text = assistant.assistantLanguageId!.map((e) => e.name).toList().toString().replaceAll('[', '').replaceAll(']', '');
        for (var i = 0; i < global.assistantLanguageModelList!.length; i++) {
          global.assistantLanguageModelList![i].isCheck = false;
          for (var j = 0; j < assistant.assistantLanguageId!.length; j++) {
            if (assistant.assistantLanguageId![j].id == global.assistantLanguageModelList![i].id) {
              global.assistantLanguageModelList![i].isCheck = true;
            }
          }
        }
      }
      if (assistant.experienceInYears != null) {
        cExpirence.text = assistant.experienceInYears.toString();
      }
    } catch (e) {
      print("Exception: $screen - fillAstrologerAssistant(): " + e.toString());
    }
  }

  //Update assistant form
  updateValidateAssistantForm(int id) {
    try {
      if (profile != null && profile != '' && cName.text != "" && (cEmail.text != '' && GetUtils.isEmail(cEmail.text)) && (cMobileNumber.text != "" && cMobileNumber.text.length == 10) && selectedDate != null && (cAssistantPrimarySkill.text != "" && assistantPrimaryId != [] && cAssistantAllSkill.text != "" && assistantAllId != [] && cAssistantLanguage.text != "" && assistantLanguagesId != [] && cExpirence.text != "")) {
        updateAstrologerAssistant(id);
      } else if (cName.text == "") {
        global.showToast(message: "Please Enter Valid Name");
      } else if (cEmail.text == '' || !GetUtils.isEmail(cEmail.text)) {
        global.showToast(message: "Please Enter Valid Email Address");
      } else if (cMobileNumber.text == '' || cMobileNumber.text.length != 10) {
        global.showToast(message: "Please Enter Valid Mobile Number");
      } else if (selectedDate == null && cBirthDate.text == '') {
        global.showToast(message: "Please Enter birthdate");
      } else if (cAssistantPrimarySkill.text == "") {
        global.showToast(message: "Please Enter primary skill");
      } else if (cAssistantAllSkill.text == "") {
        global.showToast(message: "Please Enter all skill");
      } else if (cAssistantLanguage.text == "") {
        global.showToast(message: "Please Enter language");
      } else if (cExpirence.text == "") {
        global.showToast(message: "Please Enter experience");
      } else if (profile == null) {
        global.showToast(message: "Please Select image");
      } else if (profile == '') {
        global.showToast(message: "Please Select image");
      } else {
        global.showToast(message: "Something Wrong in astrologer assistant Form");
      }
    } catch (e) {
      print("Exception - $screen - validateAssistantForm(): " + e.toString());
    }
  }

  //Update assistant
  updateAstrologerAssistant(int id) async {
    try {
      await global.checkBody().then(
        (networkResult) async {
          if (networkResult) {
            assistant.id = id;
            assistant.astrologerId = global.user.id;
            assistant.name = cName.text;
            assistant.email = cEmail.text;
            assistant.contactNo = cMobileNumber.text;
            assistant.gender = selectGender;
            assistant.birthdate = selectedDate;
            assistant.primarySkill = cAssistantPrimarySkill.text;
            assistant.allSkill = cAssistantAllSkill.text;
            assistant.languageKnown = cAssistantLanguage.text;
            assistant.assistantPrimarySkillId = [];
            assistant.assistantAllSkillId = [];
            assistant.assistantLanguageId = [];
            for (var i = 0; i < assistantPrimaryId.length; i++) {
              assistant.assistantPrimarySkillId!.addAll(assistantPrimaryId);
            }
            for (var i = 0; i < assistantAllId.length; i++) {
              assistant.assistantAllSkillId!.addAll(assistantAllId);
            }
            for (var i = 0; i < assistantLanguagesId.length; i++) {
              assistant.assistantLanguageId!.addAll(assistantLanguagesId);
            }
            assistant.experienceInYears = int.parse(cExpirence.text);
            if (profile != null && profile != '') {
              assistant.profile = profile;
            }
            assistant.imageFile = imageFile;

            await apiHelper.astrologerAssistantUpdate(assistant).then(
              (apiResult) async {
                if (apiResult.status == '200') {
                  assistant = apiResult.recordList;
                  Get.to(() => AssistantScreen());
                  await getAstrologerAssistantList();
                  global.showToast(message: "You have succesfully update astrologer assistant");
                } else if (apiResult.status == '400') {
                  global.showToast(message: apiResult.message.toString());
                  update();
                } else {
                  global.showToast(message: "Something went wrong, please try again later");
                }
              },
            );
          } else {
            global.showToast(message: "No Network Available");
          }
        },
      );
    } catch (e) {
      print("Exception - $screen - updateAstrologerAssistant(): " + e.toString());
    }
  }

  //Get astrologer assistant list
  Future getAstrologerAssistantList() async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            int id = global.user.id ?? 0;
            await apiHelper.getAstrologerAssistant(id).then(
              (result) {
                global.hideLoader();
                if (result.status == "200") {
                  astrologerAssistantList = result.recordList;
                  update();
                } else {
                  global.showToast(message: "No assistant list is here");
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - getAstrologerAssistantList(): ' + e.toString());
    }
  }

  //Delete assistant
  Future deleteAsssistant(int id) async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            await apiHelper.assistantDelete(id).then(
              (result) async {
                global.hideLoader();
                if (result.status == "200") {
                  global.showToast(message: result.message.toString());
                  await getAstrologerAssistantList();
                  update();
                } else {
                  global.showToast(message: "No assistant is here");
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - deleteAsssistant(): ' + e.toString());
    }
  }

  //Clear form of astrologer
  clearAstrologerAssistant() {
    try {
      cName.text = '';
      cEmail.text = '';
      cMobileNumber.text = '';
      cBirthDate.text = '';
      cAssistantPrimarySkill.text = '';
      cAssistantAllSkill.text = '';
      cAssistantLanguage.text = '';
      cExpirence.text = '';
      selectedImage = null;
      for (var i = 0; i < global.assistantPrimarySkillModelList!.length; i++) {
        global.assistantPrimarySkillModelList![i].isCheck = false;
      }
      for (var i = 0; i < global.assistantAllSkillModelList!.length; i++) {
        global.assistantAllSkillModelList![i].isCheck = false;
      }
      for (var i = 0; i < global.assistantLanguageModelList!.length; i++) {
        global.assistantLanguageModelList![i].isCheck = false;
      }
      update();
    } catch (e) {
      print('Exception: $screen - clearAstrologer(): ' + e.toString());
    }
  }
}
