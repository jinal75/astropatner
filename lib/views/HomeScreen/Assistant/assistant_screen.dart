// ignore_for_file: must_be_immutable

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/constants/messageConst.dart';
import 'package:astrologer_app/controllers/AssistantController/add_assistant_controller.dart';
import 'package:astrologer_app/models/astrologerAssistant_model.dart';
import 'package:astrologer_app/views/HomeScreen/Assistant/add_or_edit_assistant_screen.dart';
import 'package:astrologer_app/views/HomeScreen/Assistant/assistant_detail_screen.dart';
import 'package:astrologer_app/views/HomeScreen/home_screen.dart';
import 'package:astrologer_app/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

class AssistantScreen extends StatelessWidget {
  AssistantScreen({Key? key, this.assistantModel}) : super(key: key);
  AddAssistantController assistantController = Get.find<AddAssistantController>();
  AstrologerAssistantModel? assistantModel;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.to(() => HomeScreen());
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: MyCustomAppBar(
            height: 80,
            backgroundColor: COLORS().primaryColor,
            title: const Text("My Assistant").translate(),
            actions: [
              assistantController.astrologerAssistantList.length == 1 || assistantController.astrologerAssistantList.isNotEmpty
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        assistantController.clearAstrologerAssistant();
                        Get.to(() => AddAssistantScreen(
                              flagId: 1,
                            ));
                      },
                      icon: const Icon(Icons.add),
                    ),
            ],
          ),
          body: GetBuilder<AddAssistantController>(
            builder: (assistantController) {
              return assistantController.astrologerAssistantList.isEmpty
                  ? Center(
                      child: const Text("You don't have any assistant here!").translate(),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await assistantController.getAstrologerAssistantList();
                      },
                      child: ListView.builder(
                        itemCount: assistantController.astrologerAssistantList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: assistantController.astrologerAssistantList[index].profile!.isEmpty || assistantController.astrologerAssistantList[index].profile == null
                                    ? Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          color: COLORS().primaryColor,
                                          image: const DecorationImage(
                                            image: AssetImage(
                                              "assets/images/no_customer_image.png",
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: Get.height * 0.1,
                                        width: Get.height * 0.07,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          color: COLORS().primaryColor,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage("${global.imgBaseurl}${assistantController.astrologerAssistantList[index].profile}"),
                                          ),
                                        ),
                                      ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      assistantController.astrologerAssistantList[index].name!,
                                      style: Theme.of(context).primaryTextTheme.headline3,
                                    ).translate(),
                                    SizedBox(
                                      width: Get.width,
                                      child: Text(
                                        assistantController.astrologerAssistantList[index].assistantPrimarySkillId != null ? assistantController.astrologerAssistantList[index].assistantPrimarySkillId!.map((e) => e.name).toList().toString().replaceAll('[', '').replaceAll(']', '') : '',
                                        style: Theme.of(context).primaryTextTheme.subtitle1,
                                      ).translate(),
                                    ),
                                  ],
                                ),
                                trailing: PopupMenuButton(
                                  icon: const Icon(Icons.more_vert, color: Colors.black),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: ListTile(
                                        title: Text(
                                          "Edit",
                                          style: Theme.of(context).primaryTextTheme.subtitle1,
                                        ).translate(),
                                        trailing: const Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                        ),
                                        onTap: () {
                                          assistantModel = AstrologerAssistantModel(
                                            id: assistantController.astrologerAssistantList[index].id,
                                            astrologerId: assistantController.astrologerAssistantList[index].astrologerId,
                                            name: assistantController.astrologerAssistantList[index].name,
                                            contactNo: assistantController.astrologerAssistantList[index].contactNo,
                                            email: assistantController.astrologerAssistantList[index].email,
                                            gender: assistantController.astrologerAssistantList[index].gender,
                                            birthdate: assistantController.astrologerAssistantList[index].birthdate,
                                            experienceInYears: assistantController.astrologerAssistantList[index].experienceInYears,
                                            assistantPrimarySkillId: assistantController.astrologerAssistantList[index].assistantPrimarySkillId,
                                            assistantAllSkillId: assistantController.astrologerAssistantList[index].assistantAllSkillId,
                                            assistantLanguageId: assistantController.astrologerAssistantList[index].assistantLanguageId,
                                            primarySkill: assistantController.astrologerAssistantList[index].primarySkill,
                                            allSkill: assistantController.astrologerAssistantList[index].allSkill,
                                            languageKnown: assistantController.astrologerAssistantList[index].languageKnown,
                                            profile: assistantController.astrologerAssistantList[index].profile,
                                            imageFile: assistantController.astrologerAssistantList[index].imageFile,
                                          );
                                          assistantController.fillAstrologerAssistant(assistantModel!);
                                          assistantController.updateAssistantId = assistantController.astrologerAssistantList[index].id;
                                          assistantController.update();
                                          Get.to(() => AddAssistantScreen(
                                                assistantModel: assistantModel,
                                                flagId: 2,
                                              ));
                                        },
                                      ),
                                    ),
                                    PopupMenuItem(
                                      child: ListTile(
                                        title: Text(
                                          "View",
                                          style: Theme.of(context).primaryTextTheme.subtitle1,
                                        ).translate(),
                                        trailing: const Icon(
                                          Icons.visibility,
                                          color: Colors.black,
                                        ),
                                        onTap: () {
                                          Get.to(
                                            () => AssistantDetailScreen(
                                              astrologerAssistant: assistantController.astrologerAssistantList[index],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    PopupMenuItem(
                                      child: ListTile(
                                        title: Text(
                                          "Delete",
                                          style: Theme.of(context).primaryTextTheme.subtitle1,
                                        ).translate(),
                                        trailing: const Icon(
                                          Icons.delete,
                                          color: Colors.black,
                                        ),
                                        onTap: () {
                                          Get.dialog(
                                            AlertDialog(
                                              title: const Text("Are you sure you want remove an assistant?").translate(),
                                              content: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        Get.back();
                                                        Get.back();
                                                      },
                                                      child: const Text(MessageConstants.No).translate(),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    flex: 2,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        assistantController.deleteAsssistant(assistantController.astrologerAssistantList[index].id!);
                                                        Get.back();
                                                        Get.back();
                                                        assistantController.update();
                                                      },
                                                      child: const Text(MessageConstants.YES).translate(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
