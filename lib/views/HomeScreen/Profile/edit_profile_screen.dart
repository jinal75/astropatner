import 'dart:convert';

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/constants/messageConst.dart';
import 'package:astrologer_app/controllers/HomeController/edit_profile_controller.dart';
import 'package:astrologer_app/controllers/HomeController/home_controller.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/all_skill_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/astrologer_category_list_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/language_list_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/primary_skill_model.dart';
import 'package:astrologer_app/models/time_availability_model.dart';
import 'package:astrologer_app/widgets/common_drop_down.dart';
import 'package:astrologer_app/widgets/common_padding.dart';
import 'package:astrologer_app/widgets/common_textfield_widget.dart';
import 'package:astrologer_app/widgets/primary_text_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);
  final EditProfileController editProfileController = Get.put(EditProfileController());
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<EditProfileController>(
          init: editProfileController,
          builder: (controller) {
            return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: Scaffold(
                backgroundColor: Colors.grey[200],
                body: Column(
                  children: [
                    SizedBox(
                      height: 75, //Height Of Scroll Stepper Widget
                      width: MediaQuery.of(context).size.width,
                      child: Theme(
                        data: ThemeData(
                          colorScheme: ColorScheme.fromSwatch().copyWith(
                            primary: COLORS().primaryColor,
                          ),
                          canvasColor: Colors.grey[200],
                        ),
                        child: Stepper(
                          physics: const NeverScrollableScrollPhysics(),
                          elevation: 0,
                          type: StepperType.horizontal,
                          currentStep: editProfileController.index,
                          steps: <Step>[
                            Step(
                              isActive: editProfileController.index >= 0 ? true : false,
                              title: const SizedBox(),
                              content: const SizedBox(),
                            ),
                            Step(
                              isActive: editProfileController.index >= 1 ? true : false,
                              title: const SizedBox(),
                              content: const SizedBox(),
                            ),
                            Step(
                              isActive: editProfileController.index >= 2 ? true : false,
                              title: const SizedBox(),
                              content: const SizedBox(),
                            ),
                            Step(
                              isActive: editProfileController.index >= 3 ? true : false,
                              title: const SizedBox(),
                              content: const SizedBox(),
                            ),
                            Step(
                              isActive: editProfileController.index >= 4 ? true : false,
                              title: const SizedBox(),
                              content: const SizedBox(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    editProfileController.index == 0
                        ? Expanded(
                            child: CommonPadding(
                              child: ListView(
                                children: [
                                  //----------------------Personal Details-------------------------
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Center(
                                      child: Text(
                                        "Personal Details",
                                        style: Get.theme.primaryTextTheme.headline2,
                                      ).translate(),
                                    ),
                                  ),
                                  //Name
                                  const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: PrimaryTextWidget(text: "Name"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: CommonTextFieldWidget(
                                      hintText: "Name",
                                      keyboardType: TextInputType.text,
                                      textCapitalization: TextCapitalization.words,
                                      formatter: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
                                      textEditingController: editProfileController.cName,
                                      focusNode: editProfileController.fName,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).requestFocus(editProfileController.fEmail);
                                      },
                                    ),
                                  ),
                                  //Email
                                  const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: PrimaryTextWidget(text: "Email"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: CommonTextFieldWidget(
                                      readOnly: true,
                                      hintText: "user@gmail.com",
                                      keyboardType: TextInputType.emailAddress,
                                      textEditingController: editProfileController.cEmail,
                                      focusNode: editProfileController.fEmail,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).requestFocus(editProfileController.fMobileNumber);
                                      },
                                    ),
                                  ),
                                  //Mobile Number
                                  const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: PrimaryTextWidget(text: "Mobile Number"),
                                  ),
                                  Container(
                                    height: 48,
                                    margin: const EdgeInsets.only(top: 5),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(7)),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                                child: IntlPhoneField(
                                              autovalidateMode: null,
                                              showDropdownIcon: false,
                                              onCountryChanged: (value) {},
                                              enabled: false,
                                              controller: editProfileController.cMobileNumber,
                                              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                              readOnly: true,
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  disabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  errorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  errorText: null,
                                                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                                  hintText: 'Mobile Number',
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    fontFamily: "verdana_regular",
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  counterText: ''),
                                              initialCountryCode: 'IN',
                                              focusNode: editProfileController.fMobileNumber,
                                              onSubmitted: (f) {
                                                FocusScope.of(context).unfocus();
                                              },
                                              onChanged: (phone) {
                                                // ignore: avoid_print
                                                print('length ${phone.number.length}');
                                              },
                                            )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //Term & Condition
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Row(
                                      children: [
                                        Obx(
                                          () => Container(
                                            margin: const EdgeInsets.only(right: 5),
                                            height: 24,
                                            width: 24,
                                            child: Checkbox(
                                              activeColor: COLORS().primaryColor,
                                              value: editProfileController.termAndCondtion.value,
                                              onChanged: (value) {
                                                editProfileController.termAndCondtion.value = value!;
                                              },
                                            ),
                                          ),
                                        ),
                                        const PrimaryTextWidget(text: "I Agree to the Terms And Condition"),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    editProfileController.index == 1
                        ? Expanded(
                            child: CommonPadding(
                              child: ListView(
                                children: [
                                  //----------------------------Skill Details-----------------------------
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Center(
                                      child: Text(
                                        "Skill Details",
                                        style: Get.theme.primaryTextTheme.headline2,
                                      ).translate(),
                                    ),
                                  ),
                                  //User Image
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      // ignore: unrelated_type_equality_checks
                                      editProfileController.userFile != null && editProfileController.userFile != ''
                                          ? Center(
                                              child: Container(
                                                height: 100,
                                                width: 100,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(7),
                                                    color: Get.theme.primaryColor,
                                                    image: DecorationImage(
                                                      image: FileImage(editProfileController.userFile!),
                                                      fit: BoxFit.cover,
                                                    )),
                                              ),
                                            )
                                          : global.user.imagePath != null && global.user.imagePath != ''
                                              ? Center(
                                                  child: Container(
                                                    margin: const EdgeInsets.only(top: 12),
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(7),
                                                      color: Get.theme.primaryColor,
                                                      image: DecorationImage(
                                                        image: NetworkImage("${global.imgBaseurl}${global.user.imagePath}"),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Center(
                                                  child: Container(
                                                    margin: const EdgeInsets.only(top: 12),
                                                    height: 80,
                                                    width: 100,
                                                    decoration: const BoxDecoration(
                                                      color: Colors.grey,
                                                    ),
                                                    child: Icon(
                                                      Icons.person,
                                                      size: 70,
                                                      color: COLORS().primaryColor,
                                                    ),
                                                  ),
                                                ),
                                      Positioned(
                                        bottom: -20,
                                        width: MediaQuery.of(context).size.width + 20,
                                        child: IconButton(
                                          onPressed: () {
                                            Get.bottomSheet(selectImageBottomSheetWidget(context), backgroundColor: Colors.white);
                                          },
                                          icon: Icon(
                                            FontAwesomeIcons.penToSquare,
                                            color: COLORS().blackColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  //Gender
                                  const Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: PrimaryTextWidget(text: "Gender"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: CommonDropDown(
                                      val: editProfileController.selectedGender,
                                      list: global.genderList,
                                      onTap: () {},
                                      onChanged: (selectedValue) {
                                        editProfileController.selectedGender = selectedValue;
                                        editProfileController.update();
                                      },
                                    ),
                                  ),
                                  //Date of Birth
                                  const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: PrimaryTextWidget(text: "DOB"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: CommonTextFieldWidget(
                                      hintText: "Select Birth Date",
                                      textEditingController: editProfileController.cBirthDate,
                                      obscureText: false,
                                      readOnly: true,
                                      suffixIcon: Icons.calendar_month,
                                      onTap: () {
                                        _selectDate(context);
                                        editProfileController.update();
                                      },
                                    ),
                                  ),
                                  //Astrologer category
                                  const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: PrimaryTextWidget(text: "Astrologer category"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: GetBuilder<EditProfileController>(
                                        init: editProfileController,
                                        builder: (controller) {
                                          return CommonTextFieldWidget(
                                            hintText: "Choose Your category",
                                            textEditingController: editProfileController.cSelectCategory,
                                            obscureText: false,
                                            readOnly: true,
                                            suffixIcon: Icons.arrow_drop_down,
                                            onTap: () {
                                              Get.dialog(
                                                GetBuilder<EditProfileController>(
                                                  init: editProfileController,
                                                  builder: (controller) {
                                                    return AlertDialog(
                                                      title: const Text("Select category").translate(),
                                                      content: SizedBox(
                                                        height: Get.height * 1 / 3,
                                                        width: Get.width,
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: global.astrologerCategoryModelList!.length,
                                                          itemBuilder: (context, index) {
                                                            return CheckboxListTile(
                                                              tristate: false,
                                                              value: global.astrologerCategoryModelList![index].isCheck,
                                                              onChanged: (value) {
                                                                global.astrologerCategoryModelList![index].isCheck = value;
                                                                editProfileController.update();
                                                              },
                                                              title: Text(
                                                                global.astrologerCategoryModelList![index].name ?? "No category",
                                                                style: Get.theme.primaryTextTheme.subtitle1,
                                                              ),
                                                              activeColor: COLORS().primaryColor,
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      actions: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            for (int i = 0; i < global.astrologerCategoryModelList!.length; i++) {
                                                              if (global.astrologerCategoryModelList![i].isCheck == true) {
                                                                global.astrologerCategoryModelList![i].isCheck = false;
                                                              }
                                                            }
                                                            editProfileController.cSelectCategory.text = "";
                                                            Get.back();
                                                            editProfileController.update();
                                                          },
                                                          child: const Text("Clear").translate(),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            global.user.astrologerCategoryId = [];
                                                            editProfileController.cSelectCategory.text = "";
                                                            for (int i = 0; i < global.astrologerCategoryModelList!.length; i++) {
                                                              if (global.astrologerCategoryModelList![i].isCheck == true) {
                                                                editProfileController.cSelectCategory.text += "${global.astrologerCategoryModelList![i].name},";
                                                              }
                                                              if (i == global.astrologerCategoryModelList!.length - 1) {
                                                                editProfileController.cSelectCategory.text = editProfileController.cSelectCategory.text.substring(0, editProfileController.cSelectCategory.text.length - 1); //remove last ","
                                                              }
                                                              editProfileController.astroId = global.astrologerCategoryModelList!.where((element) => element.isCheck == true).toList();
                                                            }
                                                            for (int j = 0; j < editProfileController.astroId.length; j++) {
                                                              global.user.astrologerCategoryId!.add(AstrolgoerCategoryModel(id: editProfileController.astroId[j].id));
                                                            }
                                                            Get.back();
                                                            editProfileController.update();
                                                          },
                                                          child: const Text("Done").translate(),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          );
                                        }),
                                  ),
                                  //Primary Skills
                                  const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: PrimaryTextWidget(text: "Primary Skills"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: GetBuilder<EditProfileController>(
                                        init: editProfileController,
                                        builder: (controller) {
                                          return CommonTextFieldWidget(
                                            hintText: "Choose Your Primary Skills",
                                            textEditingController: editProfileController.cPrimarySkill,
                                            obscureText: false,
                                            readOnly: true,
                                            suffixIcon: Icons.arrow_drop_down,
                                            onTap: () {
                                              Get.dialog(
                                                GetBuilder<EditProfileController>(
                                                    init: editProfileController,
                                                    builder: (controller) {
                                                      return AlertDialog(
                                                        title: const Text("Primary Skills").translate(),
                                                        content: SizedBox(
                                                          height: Get.height * 1 / 3,
                                                          width: Get.width,
                                                          child: ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: global.skillModelList!.length,
                                                            itemBuilder: (context, index) {
                                                              return CheckboxListTile(
                                                                value: global.skillModelList![index].isCheck,
                                                                onChanged: (value) {
                                                                  global.skillModelList![index].isCheck = value ?? false;
                                                                  editProfileController.update();
                                                                },
                                                                title: Text(
                                                                  global.skillModelList![index].name ?? "No Skills",
                                                                  style: Get.theme.primaryTextTheme.subtitle1,
                                                                ),
                                                                activeColor: COLORS().primaryColor,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        actions: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              for (int i = 0; i < global.skillModelList!.length; i++) {
                                                                if (global.skillModelList![i].isCheck == true) {
                                                                  global.skillModelList![i].isCheck = false;
                                                                }
                                                              }
                                                              editProfileController.cPrimarySkill.text = "";
                                                              Get.back();
                                                              editProfileController.update();
                                                            },
                                                            child: const Text("Clear").translate(),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              global.user.primarySkillId = [];
                                                              editProfileController.cPrimarySkill.text = "";
                                                              for (int i = 0; i < global.skillModelList!.length; i++) {
                                                                if (global.skillModelList![i].isCheck == true) {
                                                                  editProfileController.cPrimarySkill.text += "${global.skillModelList![i].name},";
                                                                }
                                                                if (i == global.skillModelList!.length - 1) {
                                                                  editProfileController.cPrimarySkill.text = editProfileController.cPrimarySkill.text.substring(0, editProfileController.cPrimarySkill.text.length - 1); //remove last ","
                                                                }
                                                                editProfileController.primaryId = global.skillModelList!.where((element) => element.isCheck == true).toList();
                                                              }
                                                              for (int j = 0; j < editProfileController.primaryId.length; j++) {
                                                                global.user.primarySkillId!.add(PrimarySkillModel(id: editProfileController.primaryId[j].id!));
                                                              }
                                                              Get.back();
                                                              editProfileController.update();
                                                            },
                                                            child: const Text("Done").translate(),
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                              );
                                            },
                                          );
                                        }),
                                  ),
                                  //All Skills
                                  const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: PrimaryTextWidget(text: "All Skills"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: GetBuilder<EditProfileController>(
                                        init: editProfileController,
                                        builder: (controller) {
                                          return CommonTextFieldWidget(
                                            hintText: "Choose Your All Skills",
                                            textEditingController: editProfileController.cAllSkill,
                                            obscureText: false,
                                            readOnly: true,
                                            suffixIcon: Icons.arrow_drop_down,
                                            onTap: () {
                                              Get.dialog(
                                                GetBuilder<EditProfileController>(
                                                    init: editProfileController,
                                                    builder: (controller) {
                                                      return AlertDialog(
                                                        title: const Text("All Skills").translate(),
                                                        content: SizedBox(
                                                          height: Get.height * 1 / 3,
                                                          width: Get.width,
                                                          child: ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: global.allSkillModelList!.length,
                                                            itemBuilder: (context, index) {
                                                              return CheckboxListTile(
                                                                value: global.allSkillModelList![index].isCheck,
                                                                onChanged: (value) {
                                                                  global.allSkillModelList![index].isCheck = value ?? false;
                                                                  editProfileController.update();
                                                                },
                                                                title: Text(
                                                                  global.allSkillModelList![index].name ?? "No Skills",
                                                                  style: Get.theme.primaryTextTheme.subtitle1,
                                                                ).translate(),
                                                                activeColor: COLORS().primaryColor,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        actions: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              for (int i = 0; i < global.allSkillModelList!.length; i++) {
                                                                if (global.allSkillModelList![i].isCheck == true) {
                                                                  global.allSkillModelList![i].isCheck = false;
                                                                }
                                                              }
                                                              editProfileController.cAllSkill.text = "";
                                                              Get.back();
                                                              editProfileController.update();
                                                            },
                                                            child: const Text("Clear").translate(),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              global.user.allSkillId = [];
                                                              editProfileController.cAllSkill.text = "";
                                                              for (int i = 0; i < global.allSkillModelList!.length; i++) {
                                                                if (global.allSkillModelList![i].isCheck == true) {
                                                                  editProfileController.cAllSkill.text += "${global.allSkillModelList![i].name},";
                                                                }
                                                                if (i == global.allSkillModelList!.length - 1) {
                                                                  editProfileController.cAllSkill.text = editProfileController.cAllSkill.text.substring(0, editProfileController.cAllSkill.text.length - 1); //remove last ","
                                                                }
                                                                editProfileController.allId = global.allSkillModelList!.where((element) => element.isCheck == true).toList();
                                                              }
                                                              for (int j = 0; j < editProfileController.allId.length; j++) {
                                                                global.user.allSkillId!.add(AllSkillModel(id: editProfileController.allId[j].id!));
                                                              }
                                                              Get.back();
                                                              editProfileController.update();
                                                            },
                                                            child: const Text("Done").translate(),
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                              );
                                            },
                                          );
                                        }),
                                  ),
                                  //Language
                                  const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: PrimaryTextWidget(text: "Language"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: GetBuilder<EditProfileController>(
                                        init: editProfileController,
                                        builder: (controller) {
                                          return CommonTextFieldWidget(
                                            hintText: "Choose Your Language",
                                            textEditingController: editProfileController.cLanguage,
                                            obscureText: false,
                                            readOnly: true,
                                            suffixIcon: Icons.arrow_drop_down,
                                            onTap: () {
                                              Get.dialog(
                                                GetBuilder<EditProfileController>(
                                                    init: editProfileController,
                                                    builder: (controller) {
                                                      return AlertDialog(
                                                        title: const Text("All Language").translate(),
                                                        content: SizedBox(
                                                          height: Get.height * 1 / 3,
                                                          width: Get.width,
                                                          child: ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: global.languageModelList!.length,
                                                            itemBuilder: (context, index) {
                                                              return CheckboxListTile(
                                                                value: global.languageModelList![index].isCheck,
                                                                onChanged: (value) {
                                                                  global.languageModelList![index].isCheck = value ?? false;
                                                                  editProfileController.update();
                                                                },
                                                                title: Text(
                                                                  global.languageModelList![index].name ?? "No Skills",
                                                                  style: Get.theme.primaryTextTheme.subtitle1,
                                                                ),
                                                                activeColor: COLORS().primaryColor,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        actions: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              for (int i = 0; i < global.languageModelList!.length; i++) {
                                                                if (global.languageModelList![i].isCheck == true) {
                                                                  global.languageModelList![i].isCheck = false;
                                                                }
                                                              }
                                                              editProfileController.cLanguage.text = "";
                                                              Get.back();
                                                              editProfileController.update();
                                                            },
                                                            child: const Text("Clear").translate(),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              global.user.languageId = [];
                                                              editProfileController.cLanguage.text = "";
                                                              for (int i = 0; i < global.languageModelList!.length; i++) {
                                                                if (global.languageModelList![i].isCheck == true) {
                                                                  editProfileController.cLanguage.text += "${global.languageModelList![i].name},";
                                                                }
                                                                if (i == global.languageModelList!.length - 1) {
                                                                  editProfileController.cLanguage.text = editProfileController.cLanguage.text.substring(0, editProfileController.cLanguage.text.length - 1); //remove last ","
                                                                }
                                                                editProfileController.lId = global.languageModelList!.where((element) => element.isCheck == true).toList();
                                                              }
                                                              for (int j = 0; j < editProfileController.lId.length; j++) {
                                                                global.user.languageId!.add(LanguageModel(id: editProfileController.lId[j].id!));
                                                              }
                                                              Get.back();
                                                              editProfileController.update();
                                                            },
                                                            child: const Text("Done").translate(),
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                              );
                                            },
                                          );
                                        }),
                                  ),
                                  //Charge
                                  const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: PrimaryTextWidget(text: "Add your charge's (as per Minute)"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: CommonTextFieldWidget(
                                      textEditingController: editProfileController.cCharges,
                                      focusNode: editProfileController.fCharges,
                                      counterText: '',
                                      maxLength: 4,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).requestFocus(editProfileController.fVideoCharges);
                                      },
                                      hintText: "${global.getSystemFlagValue(global.systemFlagNameList.currency)}20",
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                                    ),
                                  ),
                                  //Video charges
                                  const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: PrimaryTextWidget(text: "Add your video charge's"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: CommonTextFieldWidget(
                                      textEditingController: editProfileController.cVideoCharges,
                                      focusNode: editProfileController.fVideoCharges,
                                      counterText: '',
                                      maxLength: 4,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).requestFocus(editProfileController.fReportCharges);
                                      },
                                      hintText: "${global.getSystemFlagValue(global.systemFlagNameList.currency)}20",
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                                    ),
                                  ),
                                  //Report charges
                                  const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: PrimaryTextWidget(text: "Add your report charge's"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: CommonTextFieldWidget(
                                      textEditingController: editProfileController.cReportCharges,
                                      focusNode: editProfileController.fReportCharges,
                                      counterText: '',
                                      maxLength: 4,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).requestFocus(editProfileController.fExpirence);
                                      },
                                      hintText: "${global.getSystemFlagValue(global.systemFlagNameList.currency)}20",
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                                    ),
                                  ),
                                  //Expirence
                                  const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: PrimaryTextWidget(text: "Experience In Years"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: CommonTextFieldWidget(
                                      textEditingController: editProfileController.cExpirence,
                                      focusNode: editProfileController.fExpirence,
                                      counterText: '',
                                      maxLength: 2,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).requestFocus(editProfileController.fContributionHours);
                                      },
                                      hintText: "Enter Your Expirence",
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                                    ),
                                  ),
                                  //Contribution Hours
                                  const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: PrimaryTextWidget(text: "How many hours you can contribute daily?"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: CommonTextFieldWidget(
                                      textEditingController: editProfileController.cContributionHours,
                                      focusNode: editProfileController.fContributionHours,
                                      counterText: '',
                                      maxLength: 2,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).requestFocus(editProfileController.fHearAboutAstroGuru);
                                      },
                                      hintText: "Enter Your Expirence",
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                                    ),
                                  ),
                                  //hear about AstroGuru
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Text("Where did you hear about AstroGuru?", style: Get.theme.primaryTextTheme.subtitle1).translate(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: CommonTextFieldWidget(
                                      focusNode: editProfileController.fHearAboutAstroGuru,
                                      keyboardType: TextInputType.text,
                                      textCapitalization: TextCapitalization.sentences,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).unfocus();
                                      },
                                      textEditingController: editProfileController.cHearAboutAstroGuru,
                                      hintText: "Youtube,Facebook",
                                    ),
                                  ),
                                  //Working On Any Other Platform
                                  const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: PrimaryTextWidget(text: "Are you working on any other platform?"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            Radio(
                                                value: 1,
                                                groupValue: editProfileController.anyOnlinePlatform,
                                                activeColor: COLORS().primaryColor,
                                                onChanged: (val) {
                                                  editProfileController.setOnlinePlatform(val);
                                                }),
                                            Text(
                                              MessageConstants.YES,
                                              style: Theme.of(context).primaryTextTheme.subtitle1,
                                            ).translate()
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Radio(
                                                value: 2,
                                                groupValue: editProfileController.anyOnlinePlatform,
                                                activeColor: COLORS().primaryColor,
                                                onChanged: (val) {
                                                  editProfileController.setOnlinePlatform(val);
                                                }),
                                            Text(
                                              MessageConstants.No,
                                              style: Theme.of(context).primaryTextTheme.subtitle1,
                                            ).translate()
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  editProfileController.anyOnlinePlatform == 1
                                      ? DottedBorder(
                                          color: Colors.black,
                                          strokeWidth: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(top: 12),
                                                  child: PrimaryTextWidget(text: "Name of platform?"),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 5.0),
                                                  child: CommonTextFieldWidget(
                                                    textEditingController: editProfileController.cNameOfPlatform,
                                                    focusNode: editProfileController.fNameOfPlatform,
                                                    keyboardType: TextInputType.text,
                                                    textCapitalization: TextCapitalization.sentences,
                                                    onFieldSubmitted: (f) {
                                                      FocusScope.of(context).requestFocus(editProfileController.fMonthlyEarning);
                                                    },
                                                    hintText: "Company Name",
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.only(top: 12),
                                                  child: PrimaryTextWidget(text: "Monthly Earning?"),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 5.0),
                                                  child: CommonTextFieldWidget(
                                                    textEditingController: editProfileController.cMonthlyEarning,
                                                    focusNode: editProfileController.fMonthlyEarning,
                                                    formatter: [FilteringTextInputFormatter.digitsOnly],
                                                    maxLength: 7,
                                                    counterText: '',
                                                    onFieldSubmitted: (f) {
                                                      FocusScope.of(context).unfocus();
                                                    },
                                                    hintText: "${global.getSystemFlagValue(global.systemFlagNameList.currency)}20000",
                                                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    editProfileController.index == 2
                        ? Expanded(
                            child: CommonPadding(
                              child: ListView(
                                children: [
                                  //--------------------------Other Details------------------
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Center(
                                      child: Text(
                                        "Other Details",
                                        style: Get.theme.primaryTextTheme.headline2,
                                      ).translate(),
                                    ),
                                  ),
                                  //onBoard you
                                  const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: PrimaryTextWidget(text: "Why do you think we should onboard you?"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: CommonTextFieldWidget(
                                      hintText: "Why we should on board you?",
                                      textEditingController: editProfileController.cOnBoardYou,
                                      focusNode: editProfileController.fOnBoardYou,
                                      keyboardType: TextInputType.text,
                                      textCapitalization: TextCapitalization.sentences,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).requestFocus(editProfileController.fTimeForInterview);
                                      },
                                    ),
                                  ),
                                  //Time for Interview
                                  const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: PrimaryTextWidget(text: "What is suitable time for interview?"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: CommonTextFieldWidget(
                                      hintText: "Enter Suitable Time For Interview",
                                      textEditingController: editProfileController.cTimeForInterview,
                                      focusNode: editProfileController.fTimeForInterview,
                                      keyboardType: TextInputType.text,
                                      textCapitalization: TextCapitalization.sentences,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).requestFocus(editProfileController.fLiveCity);
                                      },
                                    ),
                                  ),
                                  //Live City
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Text(
                                      "Which city do you currently live in?",
                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                    ).translate(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: CommonTextFieldWidget(
                                      hintText: "Bardoli",
                                      textEditingController: editProfileController.cLiveCity,
                                      focusNode: editProfileController.fLiveCity,
                                      keyboardType: TextInputType.text,
                                      textCapitalization: TextCapitalization.sentences,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).unfocus();
                                      },
                                    ),
                                  ),
                                  //source Of Bussiness
                                  const Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: PrimaryTextWidget(text: "Main source of business(other than astrology)?"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: CommonDropDown(
                                      val: editProfileController.selectedSourceOfBusiness,
                                      list: global.mainSourceBusinessModelList!
                                          .map(
                                            (e) => e.jobName,
                                          )
                                          .toList(),
                                      onTap: () {},
                                      onChanged: (selectedValue) {
                                        editProfileController.selectedSourceOfBusiness = selectedValue;
                                        editProfileController.update();
                                      },
                                    ),
                                  ),
                                  //highest qualification
                                  const Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: PrimaryTextWidget(text: "Select your highest qualification"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: CommonDropDown(
                                      val: editProfileController.selectedHighestQualification,
                                      list: global.highestQualificationModelList!
                                          .map(
                                            (e) => e.qualificationName,
                                          )
                                          .toList(),
                                      onTap: () {},
                                      onChanged: (selectedValue) {
                                        editProfileController.selectedHighestQualification = selectedValue;
                                        editProfileController.update();
                                      },
                                    ),
                                  ),
                                  //degree/diploma
                                  const Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: PrimaryTextWidget(text: "Degree / Diploma"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: CommonDropDown(
                                      val: editProfileController.selectedDegreeDiploma,
                                      list: global.degreeDiplomaList!
                                          .map(
                                            (e) => e.degreeName,
                                          )
                                          .toList(),
                                      onTap: () {},
                                      onChanged: (selectedValue) {
                                        editProfileController.selectedDegreeDiploma = selectedValue;
                                        editProfileController.update();
                                      },
                                    ),
                                  ),
                                  //College/School/University
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Text(
                                      "College/School/University",
                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                    ).translate(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: CommonTextFieldWidget(
                                      hintText: "Enter your College/School/University Name",
                                      textEditingController: editProfileController.cCollegeSchoolUniversity,
                                      focusNode: editProfileController.fCollegeSchoolUniversity,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).requestFocus(editProfileController.fLearnAstroLogy);
                                      },
                                    ),
                                  ),
                                  //Learn Astrology
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Text(
                                      "From where did you learn Astrology?",
                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                    ).translate(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: CommonTextFieldWidget(
                                      hintText: "From where did you learn Astrology?",
                                      textEditingController: editProfileController.cLearnAstrology,
                                      focusNode: editProfileController.fLearnAstroLogy,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).requestFocus(editProfileController.fInsta);
                                      },
                                    ),
                                  ),
                                  //Insta
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Text(
                                      "Instagram profile link",
                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                    ).translate(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: CommonTextFieldWidget(
                                      hintText: "Please let us know your instagram profile",
                                      textEditingController: editProfileController.cInsta,
                                      focusNode: editProfileController.fInsta,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).requestFocus(editProfileController.fFacebook);
                                      },
                                    ),
                                  ),
                                  //Facebook
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Text(
                                      "Facebook profile link",
                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                    ).translate(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: CommonTextFieldWidget(
                                      hintText: "Please let us know your Facebook profile",
                                      textEditingController: editProfileController.cFacebook,
                                      focusNode: editProfileController.fFacebook,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).requestFocus(editProfileController.fLinkedIn);
                                      },
                                    ),
                                  ),
                                  //LinkedIn
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Text(
                                      "LinkedIn profile link",
                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                    ).translate(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: CommonTextFieldWidget(
                                      hintText: "Please let us know your LinkedIn profile",
                                      textEditingController: editProfileController.cLinkedIn,
                                      focusNode: editProfileController.fLinkedIn,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).requestFocus(editProfileController.fYoutube);
                                      },
                                    ),
                                  ),
                                  //Youtube
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Text(
                                      "Youtube profile link",
                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                    ).translate(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: CommonTextFieldWidget(
                                      hintText: "Please let us know your Youtube profile",
                                      textEditingController: editProfileController.cYoutube,
                                      focusNode: editProfileController.fYoutube,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).requestFocus(editProfileController.fWebSite);
                                      },
                                    ),
                                  ),
                                  //WebSite
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Text(
                                      "Website profile link",
                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                    ).translate(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: CommonTextFieldWidget(
                                      hintText: "Please let us know your Website profile",
                                      textEditingController: editProfileController.cWebSite,
                                      focusNode: editProfileController.fWebSite,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).unfocus();
                                      },
                                    ),
                                  ),
                                  //Refer person
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Text(
                                      "Did anybody refer you to AstroGuru?",
                                      style: Theme.of(context).primaryTextTheme.subtitle1,
                                    ).translate(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            Radio(
                                                value: 1,
                                                groupValue: editProfileController.referPerson,
                                                activeColor: COLORS().primaryColor,
                                                onChanged: (val) {
                                                  editProfileController.setReferPerson(val);
                                                }),
                                            Text(
                                              MessageConstants.YES,
                                              style: Theme.of(context).primaryTextTheme.subtitle1,
                                            ).translate()
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Radio(
                                                value: 2,
                                                groupValue: editProfileController.referPerson,
                                                activeColor: COLORS().primaryColor,
                                                onChanged: (val) {
                                                  editProfileController.setReferPerson(val);
                                                }),
                                            Text(
                                              MessageConstants.No,
                                              style: Theme.of(context).primaryTextTheme.subtitle1,
                                            ).translate(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  editProfileController.referPerson == 1
                                      ? DottedBorder(
                                          color: Colors.black,
                                          strokeWidth: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 12),
                                                  child: Text(
                                                    "Name of the person who referred you?",
                                                    style: Theme.of(context).primaryTextTheme.subtitle1,
                                                  ).translate(),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 5.0),
                                                  child: CommonTextFieldWidget(
                                                    textEditingController: editProfileController.cNameOfReferPerson,
                                                    formatter: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
                                                    focusNode: editProfileController.fNameOfReferPerson,
                                                    keyboardType: TextInputType.text,
                                                    textCapitalization: TextCapitalization.sentences,
                                                    onFieldSubmitted: (f) {
                                                      FocusScope.of(context).requestFocus(editProfileController.fExpectedMinimumEarning);
                                                    },
                                                    hintText: "Person Name",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  //minimum earning expectation
                                  const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: PrimaryTextWidget(text: "Minimum Earning Expectation from AstroGuru"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: CommonTextFieldWidget(
                                      textEditingController: editProfileController.cExptectedMinimumEarning,
                                      focusNode: editProfileController.fExpectedMinimumEarning,
                                      counterText: '',
                                      maxLength: 5,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).requestFocus(editProfileController.fExpectedMaximumEarning);
                                      },
                                      hintText: "${global.getSystemFlagValue(global.systemFlagNameList.currency)}20",
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                                    ),
                                  ),
                                  //maximum earning Expectation
                                  const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: PrimaryTextWidget(text: "Maximum Earning Expectation from AstroGuru"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: CommonTextFieldWidget(
                                      textEditingController: editProfileController.cExpectedMaximumEarning,
                                      focusNode: editProfileController.fExpectedMaximumEarning,
                                      counterText: '',
                                      maxLength: 7,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).requestFocus(editProfileController.fLongBio);
                                      },
                                      hintText: "${global.getSystemFlagValue(global.systemFlagNameList.currency)}20",
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                                    ),
                                  ),
                                  //Long bio
                                  const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: PrimaryTextWidget(text: "Long bio"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: CommonTextFieldWidget(
                                      maxLines: 5,
                                      textEditingController: editProfileController.cLongBio,
                                      focusNode: editProfileController.fLongBio,
                                      keyboardType: TextInputType.text,
                                      textCapitalization: TextCapitalization.sentences,
                                      contentPadding: const EdgeInsets.all(5),
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).unfocus();
                                      },
                                      hintText: "Describe Bio",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    editProfileController.index == 3
                        ? Expanded(
                            child: CommonPadding(
                              child: ListView(
                                children: [
                                  //-----------------------Assignment----------------------------

                                  //foreign country
                                  const Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: PrimaryTextWidget(text: "Number of the foreign countries you lived/travelled to?"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: CommonDropDown(
                                      val: editProfileController.selectedForeignCountryCount,
                                      list: global.foreignCountryCountList
                                          .map(
                                            (e) => e,
                                          )
                                          .toList(),
                                      onTap: () {},
                                      onChanged: (selectedValue) {
                                        editProfileController.selectedForeignCountryCount = selectedValue;
                                        editProfileController.update();
                                      },
                                    ),
                                  ),
                                  //full time job ?
                                  const Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: PrimaryTextWidget(text: "Are you currently working a fulltime job?"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: CommonDropDown(
                                      val: editProfileController.selectedCurrentlyWorkingJob,
                                      list: global.jobWorkingList!
                                          .map(
                                            (e) => e.workName,
                                          )
                                          .toList(),
                                      onTap: () {},
                                      onChanged: (selectedValue) {
                                        editProfileController.selectedCurrentlyWorkingJob = selectedValue;
                                        editProfileController.update();
                                      },
                                    ),
                                  ),
                                  //good quality of astrologer
                                  const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: PrimaryTextWidget(text: "What are some good qualities of a perfect astrologer?"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: CommonTextFieldWidget(
                                      maxLines: 5,
                                      textEditingController: editProfileController.cGoodQuality,
                                      focusNode: editProfileController.fGoodQuality,
                                      keyboardType: TextInputType.text,
                                      textCapitalization: TextCapitalization.sentences,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).requestFocus(editProfileController.fBiggestChallenge);
                                      },
                                      hintText: "Describe Here",
                                    ),
                                  ),
                                  //biggest challenge
                                  const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: PrimaryTextWidget(text: "What was the biggest challenge you faced and how did you overcome it?"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: CommonTextFieldWidget(
                                      maxLines: 5,
                                      textEditingController: editProfileController.cBiggestChallenge,
                                      focusNode: editProfileController.fBiggestChallenge,
                                      keyboardType: TextInputType.text,
                                      textCapitalization: TextCapitalization.sentences,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).requestFocus(editProfileController.fRepeatedQuestion);
                                      },
                                      hintText: "Describe Here",
                                    ),
                                  ),
                                  //same question repeatedly
                                  const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: PrimaryTextWidget(text: "A customer is asking the same question repeatedly: what will you do?"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: CommonTextFieldWidget(
                                      maxLines: 5,
                                      textEditingController: editProfileController.cRepeatedQuestion,
                                      focusNode: editProfileController.fRepeatedQuestion,
                                      keyboardType: TextInputType.text,
                                      textCapitalization: TextCapitalization.sentences,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).unfocus();
                                      },
                                      hintText: "Describe Here",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    editProfileController.index == 4
                        ? Expanded(
                            child: CommonPadding(
                              child: ListView(
                                children: [
                                  //------------------------------Availability-----------------------
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Center(
                                      child: Text(
                                        "Set Your Availability",
                                        style: Get.theme.primaryTextTheme.headline2,
                                      ).translate(),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      'Daily Schedual Time',
                                      style: Get.theme.primaryTextTheme.headline2,
                                    ).translate(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: editProfileController.week!.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return editProfileController.week![index].day != ""
                                            ? Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(right: 5),
                                                      child: Text(
                                                        '${editProfileController.week![index].day}',
                                                        style: Get.theme.primaryTextTheme.subtitle1,
                                                      ).translate(),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: editProfileController.week![index].timeAvailabilityList!.length,
                                                        itemBuilder: (context, i) {
                                                          return GestureDetector(
                                                            onTap: () {},
                                                            child: Container(
                                                              margin: const EdgeInsets.only(bottom: 8.0),
                                                              height: 35,
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(4),
                                                              ),
                                                              child: Stack(
                                                                alignment: Alignment.centerRight,
                                                                children: [
                                                                  editProfileController.week![index].timeAvailabilityList![i].fromTime != "" && editProfileController.week![index].timeAvailabilityList![i].fromTime != null
                                                                      ? editProfileController.week![index].timeAvailabilityList!.length != 1
                                                                          ? Padding(
                                                                              padding: const EdgeInsets.only(right: 5),
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  Get.dialog(
                                                                                    AlertDialog(
                                                                                      title: const Text("Are you sure you want delete this time?").translate(),
                                                                                      content: Row(
                                                                                        children: [
                                                                                          Expanded(
                                                                                            flex: 4,
                                                                                            child: ElevatedButton(
                                                                                              onPressed: () {
                                                                                                Get.back();
                                                                                              },
                                                                                              child: const Text(MessageConstants.No).translate(),
                                                                                            ),
                                                                                          ),
                                                                                          const SizedBox(
                                                                                            width: 10,
                                                                                          ),
                                                                                          Expanded(
                                                                                            flex: 4,
                                                                                            child: ElevatedButton(
                                                                                              onPressed: () {
                                                                                                editProfileController.week![index].timeAvailabilityList!.removeWhere((element) => element.fromTime == editProfileController.week![index].timeAvailabilityList![i].fromTime);
                                                                                                Get.back();
                                                                                                editProfileController.update();
                                                                                              },
                                                                                              child: const Text(MessageConstants.YES).translate(),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                                child: const Icon(
                                                                                  Icons.cancel,
                                                                                  color: Colors.red,
                                                                                  size: 25,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : const SizedBox()
                                                                      : const SizedBox(),
                                                                  Center(
                                                                    child: Text(
                                                                      editProfileController.week![index].timeAvailabilityList![i].fromTime != "" && editProfileController.week![index].timeAvailabilityList![i].fromTime != null ? "${editProfileController.week![index].timeAvailabilityList![i].fromTime} - " "${editProfileController.week![index].timeAvailabilityList![i].toTime}" : "",
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 10),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        editProfileController.clearTime();
                                                        for (int j = 0; j < editProfileController.week![index].timeAvailabilityList!.length; j++) {
                                                          if (editProfileController.week![index].timeAvailabilityList!.last.fromTime != "") {
                                                            editProfileController.week![index].timeAvailabilityList!.add(
                                                              TimeAvailabilityModel(fromTime: "", toTime: ""),
                                                            );
                                                          }
                                                        }

                                                        showAvailabilityDialog(context, 1, editProfileController.week![index].day!, index);
                                                        editProfileController.update();
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: Get.theme.primaryColor,
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        child: const Padding(
                                                          padding: EdgeInsets.all(5),
                                                          child: Icon(
                                                            Icons.add,
                                                            size: 25,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox();
                                      },
                                    ),
                                  ),

                                  //---End--
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: editProfileController.index == 0
                      ? Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: COLORS().primaryColor,
                                  maximumSize: Size(MediaQuery.of(context).size.width, 100),
                                  minimumSize: Size(MediaQuery.of(context).size.width, 48),
                                ),
                                onPressed: () {
                                  homeController.isSelectedBottomIcon = 4;
                                  homeController.update();
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  MessageConstants.BACK,
                                  style: TextStyle(color: Colors.black),
                                ).translate(),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              flex: 4,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: COLORS().primaryColor,
                                  maximumSize: Size(MediaQuery.of(context).size.width, 100),
                                  minimumSize: Size(MediaQuery.of(context).size.width, 48),
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  editProfileController.updateValidateForm(0);
                                },
                                child: const Text(
                                  MessageConstants.NEXT,
                                  style: TextStyle(color: Colors.black),
                                ).translate(),
                              ),
                            ),
                          ],
                        )
                      : editProfileController.index == 1
                          ? Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: COLORS().primaryColor,
                                      maximumSize: Size(MediaQuery.of(context).size.width, 100),
                                      minimumSize: Size(MediaQuery.of(context).size.width, 48),
                                    ),
                                    onPressed: () {
                                      editProfileController.userFile = null;
                                      editProfileController.profile = '';
                                      FocusScope.of(context).unfocus();
                                      editProfileController.onStepBack();
                                    },
                                    child: const Text(
                                      MessageConstants.BACK,
                                      style: TextStyle(color: Colors.black),
                                    ).translate(),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  flex: 4,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: COLORS().primaryColor,
                                      maximumSize: Size(MediaQuery.of(context).size.width, 100),
                                      minimumSize: Size(MediaQuery.of(context).size.width, 48),
                                    ),
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      if (editProfileController.index == 1) {
                                        editProfileController.updateValidateForm(1);
                                      }
                                    },
                                    child: const Text(
                                      MessageConstants.NEXT,
                                      style: TextStyle(color: Colors.black),
                                    ).translate(),
                                  ),
                                ),
                              ],
                            )
                          : editProfileController.index == 2 || editProfileController.index == 3 || editProfileController.index == 4
                              ? Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: COLORS().primaryColor,
                                          maximumSize: Size(MediaQuery.of(context).size.width, 100),
                                          minimumSize: Size(MediaQuery.of(context).size.width, 48),
                                        ),
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          editProfileController.onStepBack();
                                        },
                                        child: const Text(
                                          MessageConstants.BACK,
                                          style: TextStyle(color: Colors.black),
                                        ).translate(),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: COLORS().primaryColor,
                                          maximumSize: Size(MediaQuery.of(context).size.width, 100),
                                          minimumSize: Size(MediaQuery.of(context).size.width, 48),
                                        ),
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();

                                          if (editProfileController.index == 2) {
                                            editProfileController.updateValidateForm(2);
                                          } else if (editProfileController.index == 3) {
                                            editProfileController.updateValidateForm(3, context: context);
                                            editProfileController.update();
                                          } else if (editProfileController.index == 4) {
                                            //Astrologer category
                                            global.user.astrologerCategoryId = [];
                                            editProfileController.cSelectCategory.text = "";
                                            for (int i = 0; i < global.astrologerCategoryModelList!.length; i++) {
                                              if (global.astrologerCategoryModelList![i].isCheck == true) {
                                                editProfileController.cSelectCategory.text += "${global.astrologerCategoryModelList![i].name},";
                                              }
                                              if (i == global.astrologerCategoryModelList!.length - 1) {
                                                editProfileController.cSelectCategory.text = editProfileController.cSelectCategory.text.substring(0, editProfileController.cSelectCategory.text.length - 1); //remove last ","
                                              }
                                              editProfileController.astroId = global.astrologerCategoryModelList!.where((element) => element.isCheck == true).toList();
                                            }
                                            for (int j = 0; j < editProfileController.astroId.length; j++) {
                                              global.user.astrologerCategoryId!.add(AstrolgoerCategoryModel(id: editProfileController.astroId[j].id));
                                            }
                                            editProfileController.update();
                                            //primary skill
                                            global.user.primarySkillId = [];
                                            editProfileController.cPrimarySkill.text = "";
                                            for (int i = 0; i < global.skillModelList!.length; i++) {
                                              if (global.skillModelList![i].isCheck == true) {
                                                editProfileController.cPrimarySkill.text += "${global.skillModelList![i].name},";
                                              }
                                              if (i == global.skillModelList!.length - 1) {
                                                editProfileController.cPrimarySkill.text = editProfileController.cPrimarySkill.text.substring(0, editProfileController.cPrimarySkill.text.length - 1); //remove last ","
                                              }
                                              editProfileController.primaryId = global.skillModelList!.where((element) => element.isCheck == true).toList();
                                            }
                                            for (int j = 0; j < editProfileController.primaryId.length; j++) {
                                              global.user.primarySkillId!.add(PrimarySkillModel(id: editProfileController.primaryId[j].id!));
                                            }
                                            editProfileController.update();
                                            //all skill
                                            global.user.allSkillId = [];
                                            editProfileController.cAllSkill.text = "";
                                            for (int i = 0; i < global.allSkillModelList!.length; i++) {
                                              if (global.allSkillModelList![i].isCheck == true) {
                                                editProfileController.cAllSkill.text += "${global.allSkillModelList![i].name},";
                                              }
                                              if (i == global.allSkillModelList!.length - 1) {
                                                editProfileController.cAllSkill.text = editProfileController.cAllSkill.text.substring(0, editProfileController.cAllSkill.text.length - 1); //remove last ","
                                              }
                                              editProfileController.allId = global.allSkillModelList!.where((element) => element.isCheck == true).toList();
                                            }
                                            for (int j = 0; j < editProfileController.allId.length; j++) {
                                              global.user.allSkillId!.add(AllSkillModel(id: editProfileController.allId[j].id!));
                                            }
                                            editProfileController.update();
                                            //language
                                            global.user.languageId = [];
                                            editProfileController.cLanguage.text = "";
                                            for (int i = 0; i < global.languageModelList!.length; i++) {
                                              if (global.languageModelList![i].isCheck == true) {
                                                editProfileController.cLanguage.text += "${global.languageModelList![i].name},";
                                              }
                                              if (i == global.languageModelList!.length - 1) {
                                                editProfileController.cLanguage.text = editProfileController.cLanguage.text.substring(0, editProfileController.cLanguage.text.length - 1); //remove last ","
                                              }
                                              editProfileController.lId = global.languageModelList!.where((element) => element.isCheck == true).toList();
                                            }
                                            for (int j = 0; j < editProfileController.lId.length; j++) {
                                              global.user.languageId!.add(LanguageModel(id: editProfileController.lId[j].id!));
                                            }
                                            editProfileController.update();
                                            editProfileController.updateValidateForm(4);
                                          }
                                        },
                                        child: Text(
                                          editProfileController.index != 4 ? MessageConstants.NEXT : MessageConstants.SUBMIT_CAPITAL,
                                          style: const TextStyle(color: Colors.black),
                                        ).translate(),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                ),
              ),
            );
          }),
    );
  }

//Date of Birth
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Get.theme.primaryColor),
            ),
            colorScheme: ColorScheme.light(
              primary: Get.theme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      editProfileController.onDateSelected(picked);
    }
  }

//User Image
  Widget selectImageBottomSheetWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                color: COLORS().blackColor,
              ),
              title: Text(
                "Camera",
                style: Get.theme.primaryTextTheme.subtitle1,
              ).translate(),
              onTap: () async {
                editProfileController.imageFile = await editProfileController.imageService(ImageSource.camera);
                editProfileController.userFile = editProfileController.imageFile;
                editProfileController.profile = base64.encode(editProfileController.imageFile!.readAsBytesSync());
                editProfileController.update();
                Get.back();
                // editProfileController.onOpenCamera();

                // _tImage = await br.openCamera(Theme.of(context).primaryColor, isProfile: true);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Colors.blue,
              ),
              title: Text(
                "Gallery",
                style: Get.theme.primaryTextTheme.subtitle1,
              ).translate(),
              onTap: () async {
                editProfileController.imageFile = await editProfileController.imageService(ImageSource.gallery);
                editProfileController.userFile = editProfileController.imageFile;
                editProfileController.profile = base64.encode(editProfileController.imageFile!.readAsBytesSync());
                editProfileController.update();
                Get.back();
                // editProfileController.onOpenGallery();
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel, color: COLORS().errorColor),
              title: Text(
                "Cancel",
                style: Get.theme.primaryTextTheme.subtitle1,
              ).translate(),
              onTap: () {
                Get.back();
              },
            ),
          ],
        ),
      ],
    );
  }

//Availability Dialog
  showAvailabilityDialog(BuildContext context, int days, String isTapDay, int widgetIndex) {
    return Get.dialog(
      AlertDialog(
        title: Center(
          child: const Text("Set Your Time").translate(),
        ),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 1 / 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Time Start',
                      style: Get.theme.primaryTextTheme.subtitle1,
                    ).translate(),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: CommonTextFieldWidget(
                        textEditingController: editProfileController.cStartTime,
                        hintText: 'Select Time',
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        readOnly: true,
                        suffixIcon: Icons.schedule_outlined,
                        onTap: () {
                          editProfileController.selectStartTime(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        'Available Time End',
                        style: Get.theme.primaryTextTheme.subtitle1,
                      ).translate(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: CommonTextFieldWidget(
                        textEditingController: editProfileController.cEndTime,
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        hintText: 'Select Time',
                        readOnly: true,
                        suffixIcon: Icons.schedule_outlined,
                        onTap: () {
                          editProfileController.selectEndTime(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (isTapDay == "Sunday") {
                for (int j = 0; j < editProfileController.week![widgetIndex].timeAvailabilityList!.length; j++) {
                  if (editProfileController.week![widgetIndex].timeAvailabilityList![j].fromTime == "") {
                    editProfileController.week![widgetIndex].timeAvailabilityList![j].fromTime = editProfileController.cStartTime.text;
                    editProfileController.week![widgetIndex].timeAvailabilityList![j].toTime = editProfileController.cEndTime.text;
                  }
                }
              } else if (isTapDay == "Monday") {
                for (int j = 0; j < editProfileController.week![widgetIndex].timeAvailabilityList!.length; j++) {
                  if (editProfileController.week![widgetIndex].timeAvailabilityList![j].fromTime == "") {
                    editProfileController.week![widgetIndex].timeAvailabilityList![j].fromTime = editProfileController.cStartTime.text;
                    editProfileController.week![widgetIndex].timeAvailabilityList![j].toTime = editProfileController.cEndTime.text;
                  }
                }
              } else if (isTapDay == "Tuesday") {
                for (int j = 0; j < editProfileController.week![widgetIndex].timeAvailabilityList!.length; j++) {
                  if (editProfileController.week![widgetIndex].timeAvailabilityList![j].fromTime == "") {
                    editProfileController.week![widgetIndex].timeAvailabilityList![j].fromTime = editProfileController.cStartTime.text;
                    editProfileController.week![widgetIndex].timeAvailabilityList![j].toTime = editProfileController.cEndTime.text;
                  }
                }
              } else if (isTapDay == "Wednesday") {
                for (int j = 0; j < editProfileController.week![widgetIndex].timeAvailabilityList!.length; j++) {
                  if (editProfileController.week![widgetIndex].timeAvailabilityList![j].fromTime == "") {
                    editProfileController.week![widgetIndex].timeAvailabilityList![j].fromTime = editProfileController.cStartTime.text;
                    editProfileController.week![widgetIndex].timeAvailabilityList![j].toTime = editProfileController.cEndTime.text;
                  }
                }
              } else if (isTapDay == "Thursday") {
                for (int j = 0; j < editProfileController.week![widgetIndex].timeAvailabilityList!.length; j++) {
                  if (editProfileController.week![widgetIndex].timeAvailabilityList![j].fromTime == "") {
                    editProfileController.week![widgetIndex].timeAvailabilityList![j].fromTime = editProfileController.cStartTime.text;
                    editProfileController.week![widgetIndex].timeAvailabilityList![j].toTime = editProfileController.cEndTime.text;
                  }
                }
              } else if (isTapDay == "Friday") {
                for (int j = 0; j < editProfileController.week![widgetIndex].timeAvailabilityList!.length; j++) {
                  if (editProfileController.week![widgetIndex].timeAvailabilityList![j].fromTime == "") {
                    editProfileController.week![widgetIndex].timeAvailabilityList![j].fromTime = editProfileController.cStartTime.text;
                    editProfileController.week![widgetIndex].timeAvailabilityList![j].toTime = editProfileController.cEndTime.text;
                  }
                }
              } else if (isTapDay == "Saturday") {
                for (int j = 0; j < editProfileController.week![widgetIndex].timeAvailabilityList!.length; j++) {
                  if (editProfileController.week![widgetIndex].timeAvailabilityList![j].fromTime == "") {
                    editProfileController.week![widgetIndex].timeAvailabilityList![j].fromTime = editProfileController.cStartTime.text;
                    editProfileController.week![widgetIndex].timeAvailabilityList![j].toTime = editProfileController.cEndTime.text;
                  }
                }
              } else {
                global.showToast(message: "Please Select Any One Time");
              }
              Get.back();
              editProfileController.update();
            },
            child: const Text("Done").translate(),
          ),
        ],
      ),
    );
  }
}
