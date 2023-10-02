import 'dart:convert';
import 'dart:io';

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/constants/messageConst.dart';
import 'package:astrologer_app/controllers/Authentication/signup_controller.dart';
import 'package:astrologer_app/controllers/Authentication/signup_otp_controller.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/all_skill_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/astrologer_category_list_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/language_list_model.dart';
import 'package:astrologer_app/models/Master%20Table%20Model/primary_skill_model.dart';
import 'package:astrologer_app/models/time_availability_model.dart';
import 'package:astrologer_app/models/week_model.dart';
import 'package:astrologer_app/views/HomeScreen/Drawer/Setting/term_and_condition_screen.dart';
import 'package:astrologer_app/widgets/app_bar_widget.dart';
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
import 'package:intl_phone_field/intl_phone_field.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);
  final SignupController signupController = Get.find<SignupController>();
  final SignupOtpController signupOtpController = Get.find<SignupOtpController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<SignupController>(
          init: signupController,
          builder: (controller) {
            return Scaffold(
              appBar: Platform.isIOS ? const MyCustomAppBar(height: 80) : null,
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
                        currentStep: signupController.index,
                        steps: <Step>[
                          Step(
                            isActive: signupController.index >= 0 ? true : false,
                            title: const SizedBox(),
                            content: const SizedBox(),
                          ),
                          Step(
                            isActive: signupController.index >= 1 ? true : false,
                            title: const SizedBox(),
                            content: const SizedBox(),
                          ),
                          Step(
                            isActive: signupController.index >= 2 ? true : false,
                            title: const SizedBox(),
                            content: const SizedBox(),
                          ),
                          Step(
                            isActive: signupController.index >= 3 ? true : false,
                            title: const SizedBox(),
                            content: const SizedBox(),
                          ),
                          Step(
                            isActive: signupController.index >= 4 ? true : false,
                            title: const SizedBox(),
                            content: const SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  signupController.index == 0
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
                                    textEditingController: signupController.cName,
                                    focusNode: signupController.fName,
                                    onFieldSubmitted: (f) {
                                      FocusScope.of(context).requestFocus(signupController.fEmail);
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
                                    hintText: "user@gmail.com",
                                    keyboardType: TextInputType.emailAddress,
                                    textEditingController: signupController.cEmail,
                                    focusNode: signupController.fEmail,
                                    onFieldSubmitted: (f) {
                                      FocusScope.of(context).requestFocus(signupController.fMobileNumber);
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
                                        child: FutureBuilder(
                                            future: global.translatedText("Mobile Number"),
                                            builder: (context, snapshot) {
                                              return Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                    child: IntlPhoneField(
                                                  autovalidateMode: null,
                                                  showDropdownIcon: false,
                                                  onCountryChanged: (value) {
                                                    signupOtpController.updateCountryCode(value);
                                                  },
                                                  controller: signupController.cMobileNumber,
                                                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                  decoration: InputDecoration(
                                                      border: const OutlineInputBorder(
                                                        borderSide: BorderSide.none,
                                                      ),
                                                      enabledBorder: const OutlineInputBorder(
                                                        borderSide: BorderSide.none,
                                                      ),
                                                      disabledBorder: const OutlineInputBorder(
                                                        borderSide: BorderSide.none,
                                                      ),
                                                      focusedBorder: const OutlineInputBorder(
                                                        borderSide: BorderSide.none,
                                                      ),
                                                      errorBorder: const OutlineInputBorder(
                                                        borderSide: BorderSide.none,
                                                      ),
                                                      errorText: null,
                                                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                                      hintText: snapshot.data ?? 'Mobile Number',
                                                      hintStyle: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16,
                                                        fontFamily: "verdana_regular",
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                      counterText: ''),
                                                  initialCountryCode: 'IN',
                                                  focusNode: signupController.fMobileNumber,
                                                  onSubmitted: (f) {
                                                    FocusScope.of(context).unfocus();
                                                  },
                                                  onChanged: (phone) {
                                                    // ignore: avoid_print
                                                    print('length ${phone.number.length}');
                                                  },
                                                )),
                                              );
                                            }),
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
                                            value: signupController.termAndCondtion.value,
                                            onChanged: (value) {
                                              signupController.termAndCondtion.value = value!;
                                            },
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(() => const TermAndConditionScreen());
                                        },
                                        child: const PrimaryTextWidget(text: "I Agree to the Terms And Condition"),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  signupController.index == 1
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
                                    signupController.selectedImage != null
                                        ? Center(
                                            child: Container(
                                              margin: const EdgeInsets.only(top: 12),
                                              height: 100,
                                              width: 100,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(50),
                                                child: Image.memory(
                                                  base64Decode(signupController.imagePath.value),
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
                                                shape: BoxShape.circle,
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
                                    val: signupController.selectedGender,
                                    list: global.genderList
                                        .map(
                                          (e) => e,
                                        )
                                        .toList(),
                                    onTap: () {},
                                    onChanged: (selectedValue) {
                                      signupController.selectedGender = selectedValue;
                                      signupController.update();
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
                                    textEditingController: signupController.cBirthDate,
                                    obscureText: false,
                                    readOnly: true,
                                    suffixIcon: Icons.calendar_month,
                                    onTap: () {
                                      _selectDate(context);
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
                                  child: GetBuilder<SignupController>(
                                      init: signupController,
                                      builder: (controller) {
                                        return CommonTextFieldWidget(
                                          hintText: "Choose Your category",
                                          textEditingController: signupController.cSelectCategory,
                                          obscureText: false,
                                          readOnly: true,
                                          suffixIcon: Icons.arrow_drop_down,
                                          onTap: () {
                                            Get.dialog(
                                              GetBuilder<SignupController>(
                                                init: signupController,
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
                                                              signupController.update();
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
                                                          signupController.cSelectCategory.text = "";
                                                          Get.back();
                                                          signupController.update();
                                                        },
                                                        child: const Text("Clear").translate(),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          global.user.astrologerCategoryId = [];
                                                          signupController.cSelectCategory.text = '';
                                                          for (int i = 0; i < global.astrologerCategoryModelList!.length; i++) {
                                                            if (global.astrologerCategoryModelList![i].isCheck == true) {
                                                              signupController.cSelectCategory.text += "${global.astrologerCategoryModelList![i].name},";
                                                            }
                                                            if (i == global.astrologerCategoryModelList!.length - 1) {
                                                              signupController.cSelectCategory.text = signupController.cSelectCategory.text.substring(0, signupController.cSelectCategory.text.length - 1); //remove last ","
                                                            }
                                                            signupController.astroId = global.astrologerCategoryModelList!.where((element) => element.isCheck == true).toList();
                                                          }
                                                          for (int j = 0; j < signupController.astroId.length; j++) {
                                                            global.user.astrologerCategoryId!.add(AstrolgoerCategoryModel(id: signupController.astroId[j].id));
                                                          }
                                                          Get.back();
                                                          signupController.update();
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
                                  child: GetBuilder<SignupController>(
                                      init: signupController,
                                      builder: (controller) {
                                        return CommonTextFieldWidget(
                                          hintText: "Choose your primary skills",
                                          textEditingController: signupController.cPrimarySkill,
                                          obscureText: false,
                                          readOnly: true,
                                          suffixIcon: Icons.arrow_drop_down,
                                          onTap: () {
                                            Get.dialog(
                                              GetBuilder<SignupController>(
                                                  init: signupController,
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
                                                              tristate: false,
                                                              value: global.skillModelList![index].isCheck,
                                                              onChanged: (value) {
                                                                global.skillModelList![index].isCheck = value;
                                                                signupController.update();
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

                                                            signupController.cPrimarySkill.text = "";
                                                            Get.back();
                                                            signupController.update();
                                                          },
                                                          child: const Text("Clear").translate(),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            global.user.primarySkillId = [];
                                                            signupController.cPrimarySkill.text = '';
                                                            for (int i = 0; i < global.skillModelList!.length; i++) {
                                                              if (global.skillModelList![i].isCheck == true) {
                                                                signupController.cPrimarySkill.text += "${global.skillModelList![i].name},";
                                                              }
                                                              if (i == global.skillModelList!.length - 1) {
                                                                signupController.cPrimarySkill.text = signupController.cPrimarySkill.text.substring(0, signupController.cPrimarySkill.text.length - 1); //remove last ","
                                                              }
                                                              signupController.primaryId = global.skillModelList!.where((element) => element.isCheck == true).toList();
                                                            }
                                                            for (int j = 0; j < signupController.primaryId.length; j++) {
                                                              global.user.primarySkillId!.add(PrimarySkillModel(id: signupController.primaryId[j].id!));
                                                            }
                                                            Get.back();
                                                            signupController.update();
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
                                  child: GetBuilder<SignupController>(
                                      init: signupController,
                                      builder: (controller) {
                                        return CommonTextFieldWidget(
                                          hintText: "Choose your all skills",
                                          textEditingController: signupController.cAllSkill,
                                          obscureText: false,
                                          readOnly: true,
                                          suffixIcon: Icons.arrow_drop_down,
                                          onTap: () {
                                            Get.dialog(
                                              GetBuilder<SignupController>(
                                                  init: signupController,
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
                                                              tristate: false,
                                                              value: global.allSkillModelList![index].isCheck,
                                                              onChanged: (value) {
                                                                global.allSkillModelList![index].isCheck = value ?? false;
                                                                signupController.update();
                                                              },
                                                              title: Text(
                                                                global.allSkillModelList![index].name ?? "No Skills",
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
                                                            for (int i = 0; i < global.allSkillModelList!.length; i++) {
                                                              if (global.allSkillModelList![i].isCheck == true) {
                                                                global.allSkillModelList![i].isCheck = false;
                                                              }
                                                            }
                                                            signupController.cAllSkill.text = "";
                                                            Get.back();
                                                            signupController.update();
                                                          },
                                                          child: const Text("Clear").translate(),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            global.user.allSkillId = [];
                                                            signupController.cAllSkill.text = '';
                                                            for (int i = 0; i < global.allSkillModelList!.length; i++) {
                                                              if (global.allSkillModelList![i].isCheck == true) {
                                                                signupController.cAllSkill.text += "${global.allSkillModelList![i].name},";
                                                              }
                                                              if (i == global.allSkillModelList!.length - 1) {
                                                                signupController.cAllSkill.text = signupController.cAllSkill.text.substring(0, signupController.cAllSkill.text.length - 1); //remove last ","
                                                              }
                                                              signupController.allId = global.allSkillModelList!.where((element) => element.isCheck == true).toList();
                                                            }
                                                            for (int j = 0; j < signupController.allId.length; j++) {
                                                              global.user.allSkillId!.add(AllSkillModel(id: signupController.allId[j].id!));
                                                            }
                                                            Get.back();
                                                            signupController.update();
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
                                  child: GetBuilder<SignupController>(
                                      init: signupController,
                                      builder: (controller) {
                                        return CommonTextFieldWidget(
                                          hintText: "Choose Your Language",
                                          textEditingController: signupController.cLanguage,
                                          obscureText: false,
                                          readOnly: true,
                                          suffixIcon: Icons.arrow_drop_down,
                                          onTap: () {
                                            Get.dialog(
                                              GetBuilder<SignupController>(
                                                  init: signupController,
                                                  builder: (controller) {
                                                    return AlertDialog(
                                                      title: const Text("All Language").translate(),
                                                      content: SizedBox(
                                                        height: MediaQuery.of(context).size.height * 1 / 2.3,
                                                        width: Get.width,
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: global.languageModelList!.length,
                                                          itemBuilder: (context, index) {
                                                            return CheckboxListTile(
                                                              tristate: false,
                                                              value: global.languageModelList![index].isCheck,
                                                              onChanged: (value) {
                                                                global.languageModelList![index].isCheck = value ?? false;
                                                                signupController.update();
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
                                                            signupController.cLanguage.text = "";
                                                            Get.back();
                                                            signupController.update();
                                                          },
                                                          child: const Text("Clear").translate(),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            global.user.languageId = [];
                                                            signupController.cLanguage.text = '';
                                                            for (int i = 0; i < global.languageModelList!.length; i++) {
                                                              if (global.languageModelList![i].isCheck == true) {
                                                                signupController.cLanguage.text += "${global.languageModelList![i].name},";
                                                              }
                                                              if (i == global.languageModelList!.length - 1) {
                                                                signupController.cLanguage.text = signupController.cLanguage.text.substring(0, signupController.cLanguage.text.length - 1); //remove last ","
                                                              }
                                                              signupController.lId = global.languageModelList!.where((element) => element.isCheck == true).toList();
                                                            }
                                                            for (int j = 0; j < signupController.lId.length; j++) {
                                                              global.user.languageId!.add(LanguageModel(id: signupController.lId[j].id!));
                                                            }
                                                            Get.back();
                                                            signupController.update();
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
                                    textEditingController: signupController.cCharges,
                                    focusNode: signupController.fCharges,
                                    formatter: [FilteringTextInputFormatter.digitsOnly],
                                    counterText: '',
                                    maxLength: 4,
                                    onFieldSubmitted: (f) {
                                      FocusScope.of(context).requestFocus(signupController.fVideoCharges);
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
                                    textEditingController: signupController.cVideoCharges,
                                    focusNode: signupController.fVideoCharges,
                                    counterText: '',
                                    maxLength: 4,
                                    onFieldSubmitted: (f) {
                                      FocusScope.of(context).requestFocus(signupController.fReportCharges);
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
                                    textEditingController: signupController.cReportCharges,
                                    focusNode: signupController.fReportCharges,
                                    counterText: '',
                                    maxLength: 4,
                                    onFieldSubmitted: (f) {
                                      FocusScope.of(context).requestFocus(signupController.fExpirence);
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
                                    textEditingController: signupController.cExpirence,
                                    focusNode: signupController.fExpirence,
                                    counterText: '',
                                    maxLength: 2,
                                    onFieldSubmitted: (f) {
                                      FocusScope.of(context).requestFocus(signupController.fContributionHours);
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
                                    textEditingController: signupController.cContributionHours,
                                    focusNode: signupController.fContributionHours,
                                    formatter: [FilteringTextInputFormatter.digitsOnly],
                                    counterText: '',
                                    maxLength: 2,
                                    onFieldSubmitted: (f) {
                                      FocusScope.of(context).requestFocus(signupController.fHearAboutAstroGuru);
                                    },
                                    hintText: "Enter your contribution daily",
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                                  ),
                                ),
//hear about AstroGuru
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Text(
                                    "Where did you hear about AstroGuru?",
                                    style: Get.theme.primaryTextTheme.subtitle1,
                                  ).translate(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: CommonTextFieldWidget(
                                    formatter: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
                                    focusNode: signupController.fHearAboutAstroGuru,
                                    onFieldSubmitted: (f) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    textEditingController: signupController.cHearAboutAstroGuru,
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
                                            groupValue: signupController.anyOnlinePlatform,
                                            activeColor: COLORS().primaryColor,
                                            onChanged: (val) {
                                              signupController.setOnlinePlatform(val);
                                              signupController.update();
                                            },
                                          ),
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
                                            groupValue: signupController.anyOnlinePlatform,
                                            activeColor: COLORS().primaryColor,
                                            onChanged: (val) {
                                              signupController.setOnlinePlatform(val);
                                              signupController.update();
                                            },
                                          ),
                                          Text(
                                            MessageConstants.No,
                                            style: Theme.of(context).primaryTextTheme.subtitle1,
                                          ).translate()
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                signupController.anyOnlinePlatform == 1
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
                                                  textEditingController: signupController.cNameOfPlatform,
                                                  focusNode: signupController.fNameOfPlatform,
                                                  formatter: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
                                                  onFieldSubmitted: (f) {
                                                    FocusScope.of(context).requestFocus(signupController.fMonthlyEarning);
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
                                                  textEditingController: signupController.cMonthlyEarning,
                                                  focusNode: signupController.fMonthlyEarning,
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
                  signupController.index == 2
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
                                    textEditingController: signupController.cOnBoardYou,
                                    focusNode: signupController.fOnBoardYou,
                                    formatter: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
                                    onFieldSubmitted: (f) {
                                      FocusScope.of(context).requestFocus(signupController.fTimeForInterview);
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
                                    textEditingController: signupController.cTimeForInterview,
                                    focusNode: signupController.fTimeForInterview,
                                    onFieldSubmitted: (f) {
                                      FocusScope.of(context).requestFocus(signupController.fLiveCity);
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
                                    textEditingController: signupController.cLiveCity,
                                    focusNode: signupController.fLiveCity,
                                    formatter: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
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
                                    val: signupController.selectedSourceOfBusiness,
                                    list: global.mainSourceBusinessModelList!
                                        .map(
                                          (e) => e.jobName,
                                        )
                                        .toList(),
                                    onTap: () {},
                                    onChanged: (selectedValue) {
                                      signupController.selectedSourceOfBusiness = selectedValue;
                                      signupController.update();
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
                                    val: signupController.selectedHighestQualification,
                                    list: global.highestQualificationModelList!
                                        .map(
                                          (e) => e.qualificationName,
                                        )
                                        .toList(),
                                    onTap: () {},
                                    onChanged: (selectedValue) {
                                      signupController.selectedHighestQualification = selectedValue;
                                      signupController.update();
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
                                    val: signupController.selectedDegreeDiploma,
                                    list: global.degreeDiplomaList!
                                        .map(
                                          (e) => e.degreeName,
                                        )
                                        .toList(),
                                    onTap: () {},
                                    onChanged: (selectedValue) {
                                      signupController.selectedDegreeDiploma = selectedValue;
                                      signupController.update();
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
                                    textEditingController: signupController.cCollegeSchoolUniversity,
                                    focusNode: signupController.fCollegeSchoolUniversity,
                                    formatter: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
                                    onFieldSubmitted: (f) {
                                      FocusScope.of(context).requestFocus(signupController.fLearnAstroLogy);
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
                                    textEditingController: signupController.cLearnAstrology,
                                    formatter: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
                                    focusNode: signupController.fLearnAstroLogy,
                                    onFieldSubmitted: (f) {
                                      FocusScope.of(context).requestFocus(signupController.fInsta);
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
                                    textEditingController: signupController.cInsta,
                                    focusNode: signupController.fInsta,
                                    onFieldSubmitted: (f) {
                                      FocusScope.of(context).requestFocus(signupController.fFacebook);
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
                                    textEditingController: signupController.cFacebook,
                                    focusNode: signupController.fFacebook,
                                    onFieldSubmitted: (f) {
                                      FocusScope.of(context).requestFocus(signupController.fLinkedIn);
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
                                    textEditingController: signupController.cLinkedIn,
                                    focusNode: signupController.fLinkedIn,
                                    onFieldSubmitted: (f) {
                                      FocusScope.of(context).requestFocus(signupController.fYoutube);
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
                                    textEditingController: signupController.cYoutube,
                                    focusNode: signupController.fYoutube,
                                    onFieldSubmitted: (f) {
                                      FocusScope.of(context).requestFocus(signupController.fWebSite);
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
                                    textEditingController: signupController.cWebSite,
                                    focusNode: signupController.fWebSite,
                                    onFieldSubmitted: (f) {
                                      FocusScope.of(context).unfocus();
                                    },
                                  ),
                                ),
//refer person
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
                                              groupValue: signupController.referPerson,
                                              activeColor: COLORS().primaryColor,
                                              onChanged: (val) {
                                                signupController.setReferPerson(val);
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
                                              groupValue: signupController.referPerson,
                                              activeColor: COLORS().primaryColor,
                                              onChanged: (val) {
                                                signupController.setReferPerson(val);
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
                                signupController.referPerson == 1
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
                                                  textEditingController: signupController.cNameOfReferPerson,
                                                  formatter: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))],
                                                  focusNode: signupController.fNameOfReferPerson,
                                                  onFieldSubmitted: (f) {
                                                    FocusScope.of(context).requestFocus(signupController.fExpectedMinimumEarning);
                                                  },
                                                  hintText: "Refer person name",
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
                                    textEditingController: signupController.cExptectedMinimumEarning,
                                    formatter: [FilteringTextInputFormatter.digitsOnly],
                                    focusNode: signupController.fExpectedMinimumEarning,
                                    counterText: '',
                                    maxLength: 5,
                                    onFieldSubmitted: (f) {
                                      FocusScope.of(context).requestFocus(signupController.fExpectedMaximumEarning);
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
                                    textEditingController: signupController.cExpectedMaximumEarning,
                                    formatter: [FilteringTextInputFormatter.digitsOnly],
                                    focusNode: signupController.fExpectedMaximumEarning,
                                    counterText: '',
                                    maxLength: 7,
                                    onFieldSubmitted: (f) {
                                      FocusScope.of(context).requestFocus(signupController.fLongBio);
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
                                    textEditingController: signupController.cLongBio,
                                    focusNode: signupController.fLongBio,
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
                  signupController.index == 3
                      ? Expanded(
                          child: CommonPadding(
                            child: ListView(
                              children: [
//-----------------------Assignment----------------------------
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Center(
                                    child: Text(
                                      "Assignment",
                                      style: Get.theme.primaryTextTheme.headline2,
                                    ).translate(),
                                  ),
                                ),
//foreign country
                                const Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: PrimaryTextWidget(text: "Number of the foreign countries you lived/travelled to?"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: CommonDropDown(
                                    val: signupController.selectedForeignCountryCount,
                                    list: global.foreignCountryCountList
                                        .map(
                                          (e) => e,
                                        )
                                        .toList(),
                                    onTap: () {},
                                    onChanged: (selectedValue) {
                                      signupController.selectedForeignCountryCount = selectedValue;
                                      signupController.update();
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
                                    height: 60,
                                    val: signupController.selectedCurrentlyWorkingJob,
                                    list: global.jobWorkingList!
                                        .map(
                                          (e) => e.workName,
                                        )
                                        .toList(),
                                    onTap: () {},
                                    onChanged: (selectedValue) {
                                      signupController.selectedCurrentlyWorkingJob = selectedValue;
                                      signupController.update();
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
                                    textEditingController: signupController.cGoodQuality,
                                    focusNode: signupController.fGoodQuality,
                                    onFieldSubmitted: (f) {
                                      FocusScope.of(context).requestFocus(signupController.fBiggestChallenge);
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
                                    textEditingController: signupController.cBiggestChallenge,
                                    focusNode: signupController.fBiggestChallenge,
                                    onFieldSubmitted: (f) {
                                      FocusScope.of(context).requestFocus(signupController.fRepeatedQuestion);
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
                                    textEditingController: signupController.cRepeatedQuestion,
                                    focusNode: signupController.fRepeatedQuestion,
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
                  signupController.index == 4
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
                                    shrinkWrap: true,
                                    itemCount: signupController.week!.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return signupController.week![index].day != ""
                                          ? Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 5),
                                                    child: Text(
                                                      '${signupController.week![index].day}',
                                                      style: Get.theme.primaryTextTheme.subtitle1,
                                                    ).translate(),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: ListView.builder(
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: signupController.week![index].timeAvailabilityList!.length,
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
                                                                signupController.week![index].timeAvailabilityList![i].fromTime != "" && signupController.week![index].timeAvailabilityList![i].fromTime != null
                                                                    ? signupController.week![index].timeAvailabilityList!.length != 1
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
                                                                                              signupController.week![index].timeAvailabilityList!.removeWhere((element) => element.fromTime == signupController.week![index].timeAvailabilityList![i].fromTime);
                                                                                              Get.back();
                                                                                              signupController.update();
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
                                                                    signupController.week![index].timeAvailabilityList![i].fromTime != "" && signupController.week![index].timeAvailabilityList![i].fromTime != null ? "${signupController.week![index].timeAvailabilityList![i].fromTime} - " "${signupController.week![index].timeAvailabilityList![i].toTime}" : "",
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
                                                      signupController.clearTime();
                                                      for (int j = 0; j < signupController.week![index].timeAvailabilityList!.length; j++) {
                                                        if (signupController.week![index].timeAvailabilityList!.last.fromTime != "") {
                                                          signupController.week![index].timeAvailabilityList!.add(
                                                            TimeAvailabilityModel(fromTime: "", toTime: ""),
                                                          );
                                                        }
                                                      }
                                                      showAvailabilityDialog(context, 1, signupController.week![index].day!, index);
                                                      signupController.update();
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
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: signupController.index == 0
                    ? TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: COLORS().primaryColor,
                          maximumSize: Size(MediaQuery.of(context).size.width, 100),
                          minimumSize: Size(MediaQuery.of(context).size.width, 48),
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          signupController.validateForm(0);
                        },
                        child: const Text(
                          MessageConstants.GET_OTP,
                          style: TextStyle(color: Colors.black),
                        ).translate(),
                      )
                    : signupController.index == 1
                        ? TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: COLORS().primaryColor,
                              maximumSize: Size(MediaQuery.of(context).size.width, 100),
                              minimumSize: Size(MediaQuery.of(context).size.width, 48),
                            ),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              signupController.validateForm(1);
                            },
                            child: const Text(
                              MessageConstants.NEXT,
                              style: TextStyle(color: Colors.black),
                            ).translate(),
                          )
                        : signupController.index == 2 || signupController.index == 3 || signupController.index == 4
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
                                        signupController.onStepBack();
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
                                        if (signupController.index == 2) {
                                          signupController.validateForm(2);
                                        } else if (signupController.index == 3) {
                                          signupController.validateForm(3, context: context);
                                          signupController.week = [];
                                          signupController.week!.add(Week(day: "Sunday", timeAvailabilityList: [TimeAvailabilityModel(fromTime: "", toTime: "")]));
                                          signupController.week!.add(Week(day: "Monday", timeAvailabilityList: [TimeAvailabilityModel(fromTime: "", toTime: "")]));
                                          signupController.week!.add(Week(day: "Tuesday", timeAvailabilityList: [TimeAvailabilityModel(fromTime: "", toTime: "")]));
                                          signupController.week!.add(Week(day: "Wednesday", timeAvailabilityList: [TimeAvailabilityModel(fromTime: "", toTime: "")]));
                                          signupController.week!.add(Week(day: "Thursday", timeAvailabilityList: [TimeAvailabilityModel(fromTime: "", toTime: "")]));
                                          signupController.week!.add(Week(day: "Friday", timeAvailabilityList: [TimeAvailabilityModel(fromTime: "", toTime: "")]));
                                          signupController.week!.add(Week(day: "Saturday", timeAvailabilityList: [TimeAvailabilityModel(fromTime: "", toTime: "")]));

                                          signupController.update();
                                        } else if (signupController.index == 4) {
                                          signupController.validateForm(4);
                                        }
                                      },
                                      child: Text(
                                        signupController.index != 4 ? MessageConstants.NEXT : MessageConstants.SUBMIT_CAPITAL,
                                        style: const TextStyle(color: Colors.black),
                                      ).translate(),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
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
      signupController.onDateSelected(picked);
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
                Get.back();
                signupController.onOpenCamera();
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
                Get.back();
                signupController.onOpenGallery();
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
                        textEditingController: signupController.cStartTime,
                        hintText: 'Select Time',
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        readOnly: true,
                        suffixIcon: Icons.schedule_outlined,
                        onTap: () {
                          signupController.selectStartTime(context);
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
                        textEditingController: signupController.cEndTime,
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        hintText: 'Select Time',
                        readOnly: true,
                        suffixIcon: Icons.schedule_outlined,
                        onTap: () {
                          signupController.selectEndTime(context);
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
                for (int j = 0; j < signupController.week![widgetIndex].timeAvailabilityList!.length; j++) {
                  if (signupController.week![widgetIndex].timeAvailabilityList![j].fromTime == "") {
                    signupController.week![widgetIndex].timeAvailabilityList![j].fromTime = signupController.cStartTime.text;
                    signupController.week![widgetIndex].timeAvailabilityList![j].toTime = signupController.cEndTime.text;
                  }
                }
              } else if (isTapDay == "Monday") {
                for (int j = 0; j < signupController.week![widgetIndex].timeAvailabilityList!.length; j++) {
                  if (signupController.week![widgetIndex].timeAvailabilityList![j].fromTime == "") {
                    signupController.week![widgetIndex].timeAvailabilityList![j].fromTime = signupController.cStartTime.text;
                    signupController.week![widgetIndex].timeAvailabilityList![j].toTime = signupController.cEndTime.text;
                  }
                }
              } else if (isTapDay == "Tuesday") {
                for (int j = 0; j < signupController.week![widgetIndex].timeAvailabilityList!.length; j++) {
                  if (signupController.week![widgetIndex].timeAvailabilityList![j].fromTime == "") {
                    signupController.week![widgetIndex].timeAvailabilityList![j].fromTime = signupController.cStartTime.text;
                    signupController.week![widgetIndex].timeAvailabilityList![j].toTime = signupController.cEndTime.text;
                  }
                }
              } else if (isTapDay == "Wednesday") {
                for (int j = 0; j < signupController.week![widgetIndex].timeAvailabilityList!.length; j++) {
                  if (signupController.week![widgetIndex].timeAvailabilityList![j].fromTime == "") {
                    signupController.week![widgetIndex].timeAvailabilityList![j].fromTime = signupController.cStartTime.text;
                    signupController.week![widgetIndex].timeAvailabilityList![j].toTime = signupController.cEndTime.text;
                  }
                }
              } else if (isTapDay == "Thursday") {
                for (int j = 0; j < signupController.week![widgetIndex].timeAvailabilityList!.length; j++) {
                  if (signupController.week![widgetIndex].timeAvailabilityList![j].fromTime == "") {
                    signupController.week![widgetIndex].timeAvailabilityList![j].fromTime = signupController.cStartTime.text;
                    signupController.week![widgetIndex].timeAvailabilityList![j].toTime = signupController.cEndTime.text;
                  }
                }
              } else if (isTapDay == "Friday") {
                for (int j = 0; j < signupController.week![widgetIndex].timeAvailabilityList!.length; j++) {
                  if (signupController.week![widgetIndex].timeAvailabilityList![j].fromTime == "") {
                    signupController.week![widgetIndex].timeAvailabilityList![j].fromTime = signupController.cStartTime.text;
                    signupController.week![widgetIndex].timeAvailabilityList![j].toTime = signupController.cEndTime.text;
                  }
                }
              } else if (isTapDay == "Saturday") {
                for (int j = 0; j < signupController.week![widgetIndex].timeAvailabilityList!.length; j++) {
                  if (signupController.week![widgetIndex].timeAvailabilityList![j].fromTime == "") {
                    signupController.week![widgetIndex].timeAvailabilityList![j].fromTime = signupController.cStartTime.text;
                    signupController.week![widgetIndex].timeAvailabilityList![j].toTime = signupController.cEndTime.text;
                  }
                }
              } else {
                global.showToast(message: "Please Select Any One Time");
              }

              Get.back();
              signupController.update();
            },
            child: const Text("Done").translate(),
          ),
        ],
      ),
    );
  }
}
