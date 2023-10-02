import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';

class PersonalDetailScreen extends StatelessWidget {
  const PersonalDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(
          height: 80,
          backgroundColor: COLORS().primaryColor,
          title: const Text("Personal Detail").translate(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                enabled: true,
                tileColor: Colors.white,
                leading: const Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                title: Text(
                  "Name",
                  style: Theme.of(context).primaryTextTheme.headline3,
                ).translate(),
                trailing: Text(
                  global.user.name != null && global.user.name != '' ? '${global.user.name}' : "Astologer name",
                  style: Theme.of(context).primaryTextTheme.subtitle1,
                ).translate(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListTile(
                  enabled: true,
                  tileColor: Colors.white,
                  leading: const Icon(
                    Icons.email,
                    color: Colors.black,
                  ),
                  title: Text(
                    "Email",
                    style: Theme.of(context).primaryTextTheme.headline3,
                  ).translate(),
                  trailing: SizedBox(
                    width: 190,
                    child: Text(
                      global.user.email != null && global.user.email != '' ? '${global.user.email}' : "astri@gmail.com",
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListTile(
                  enabled: true,
                  tileColor: Colors.white,
                  leading: const Icon(
                    Icons.phone,
                    color: Colors.black,
                  ),
                  title: Text(
                    "Mobile Number",
                    style: Theme.of(context).primaryTextTheme.headline3,
                  ).translate(),
                  trailing: SizedBox(
                    width: Get.width * 0.34,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '+91 ',
                          style: Theme.of(context).primaryTextTheme.subtitle1,
                        ),
                        Text(
                          global.user.contactNo != null && global.user.contactNo != '' ? '${global.user.contactNo}' : "",
                          style: Theme.of(context).primaryTextTheme.subtitle1,
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
