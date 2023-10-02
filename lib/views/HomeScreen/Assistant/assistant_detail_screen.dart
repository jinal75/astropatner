// ignore_for_file: must_be_immutable

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/controllers/AssistantController/add_assistant_controller.dart';
import 'package:astrologer_app/models/astrologerAssistant_model.dart';
import 'package:astrologer_app/views/HomeScreen/Assistant/assistant_screen.dart';
import 'package:astrologer_app/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';
import 'package:astrologer_app/utils/global.dart' as global;

class AssistantDetailScreen extends StatelessWidget {
  final AstrologerAssistantModel? astrologerAssistant;
  AssistantDetailScreen({Key? key, this.astrologerAssistant}) : super(key: key);
  AddAssistantController assistantController = Get.find<AddAssistantController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.to(() => AssistantScreen());
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: MyCustomAppBar(
            height: 80,
            backgroundColor: COLORS().primaryColor,
            title: const Text('Assistant Details').translate(),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: astrologerAssistant!.profile != null
                        ? Container(
                            height: Get.height * 0.12,
                            width: Get.height * 0.12,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: COLORS().primaryColor,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage("${global.imgBaseurl}${astrologerAssistant!.profile}"),
                              ),
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: COLORS().primaryColor,
                            radius: 50,
                            backgroundImage: const AssetImage(
                              "assets/images/no_customer_image.png",
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ListTile(
                      enabled: true,
                      tileColor: Colors.white,
                      title: Text(
                        "Name",
                        style: Theme.of(context).primaryTextTheme.headline3,
                      ).translate(),
                      trailing: Text(
                        '${astrologerAssistant!.name}',
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                      ).translate(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListTile(
                      enabled: true,
                      tileColor: Colors.white,
                      title: Text(
                        "Mobile Number",
                        style: Theme.of(context).primaryTextTheme.headline3,
                      ).translate(),
                      trailing: Text(
                        '${astrologerAssistant!.contactNo}',
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListTile(
                      enabled: true,
                      tileColor: Colors.white,
                      title: Text(
                        "Email",
                        style: Theme.of(context).primaryTextTheme.headline3,
                      ).translate(),
                      trailing: Text(
                        '${astrologerAssistant!.email}',
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListTile(
                      enabled: true,
                      tileColor: Colors.white,
                      title: Text(
                        "Gender",
                        style: Theme.of(context).primaryTextTheme.headline3,
                      ).translate(),
                      trailing: Text(
                        '${astrologerAssistant!.gender}',
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                      ).translate(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListTile(
                      enabled: true,
                      tileColor: Colors.white,
                      title: Text(
                        "Date of Birth",
                        style: Theme.of(context).primaryTextTheme.headline3,
                      ).translate(),
                      trailing: Text(
                        DateFormat('dd-MM-yyyy').format(DateTime.parse(astrologerAssistant!.birthdate!.toString())),
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListTile(
                      enabled: true,
                      tileColor: Colors.white,
                      title: Text(
                        "Primary Skill",
                        style: Theme.of(context).primaryTextTheme.headline3,
                      ).translate(),
                      trailing: Text(
                        astrologerAssistant!.assistantPrimarySkillId!.map((e) => e.name).toList().toString().replaceAll('[', '').replaceAll(']', ''),
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                      ).translate(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListTile(
                      enabled: true,
                      tileColor: Colors.white,
                      title: Text(
                        "All Skill",
                        style: Theme.of(context).primaryTextTheme.headline3,
                      ).translate(),
                      trailing: Text(
                        astrologerAssistant!.assistantAllSkillId!.map((e) => e.name).toList().toString().replaceAll('[', '').replaceAll(']', ''),
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                      ).translate(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListTile(
                      enabled: true,
                      tileColor: Colors.white,
                      title: Text(
                        "Language",
                        style: Theme.of(context).primaryTextTheme.headline3,
                      ).translate(),
                      trailing: Text(
                        astrologerAssistant!.assistantLanguageId!.map((e) => e.name).toList().toString().replaceAll('[', '').replaceAll(']', ''),
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                      ).translate(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListTile(
                      enabled: true,
                      tileColor: Colors.white,
                      title: Text(
                        "Expirence In Year",
                        style: Theme.of(context).primaryTextTheme.headline3,
                      ).translate(),
                      trailing: Text(
                        '${astrologerAssistant!.experienceInYears}',
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
