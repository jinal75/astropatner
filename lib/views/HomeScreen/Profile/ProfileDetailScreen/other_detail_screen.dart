import 'package:astrologer_app/constants/colorConst.dart';
import 'package:astrologer_app/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';

class OtherDetailScreen extends StatelessWidget {
  const OtherDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(height: 80, backgroundColor: COLORS().primaryColor, title: const Text("Other Detail").translate()),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  child: ExpansionTile(
                    childrenPadding: const EdgeInsets.symmetric(horizontal: 5),
                    title: Text(
                      "Why do you think we should onboard you ?",
                      style: Theme.of(context).primaryTextTheme.headline3,
                    ).translate(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          global.user.onboardYou != null && global.user.onboardYou != '' ? '${global.user.onboardYou}' : "Beacuse I am Professional",
                          style: Theme.of(context).primaryTextTheme.subtitle1,
                        ).translate(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListTile(
                    enabled: true,
                    tileColor: Colors.white,
                    title: Text(
                      "Suitable time for interview",
                      style: Theme.of(context).primaryTextTheme.headline3,
                    ).translate(),
                    trailing: Text(
                      global.user.suitableInterviewTime != null && global.user.suitableInterviewTime != '' ? '${global.user.suitableInterviewTime}' : "",
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                    ).translate(),
                  ),
                ),
                global.user.currentCity != null && global.user.currentCity != ''
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListTile(
                          enabled: true,
                          tileColor: Colors.white,
                          title: Text(
                            "Currently Live City",
                            style: Theme.of(context).primaryTextTheme.headline3,
                          ).translate(),
                          trailing: Text(
                            global.user.currentCity != null && global.user.currentCity != '' ? '${global.user.currentCity}' : "",
                            style: Theme.of(context).primaryTextTheme.subtitle1,
                          ).translate(),
                        ),
                      )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListTile(
                    enabled: true,
                    tileColor: Colors.white,
                    title: Text(
                      "Main source of business",
                      style: Theme.of(context).primaryTextTheme.headline3,
                    ).translate(),
                    trailing: SizedBox(
                      width: 190,
                      child: Text(
                        global.user.mainSourceOfBusiness != null && global.user.mainSourceOfBusiness != '' ? '${global.user.mainSourceOfBusiness}' : "",
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                        textAlign: TextAlign.end,
                      ).translate(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListTile(
                    enabled: true,
                    tileColor: Colors.white,
                    title: Text(
                      "Highest Qualification",
                      style: Theme.of(context).primaryTextTheme.headline3,
                    ).translate(),
                    trailing: SizedBox(
                      width: 190,
                      child: Text(
                        global.user.highestQualification != null && global.user.highestQualification != '' ? '${global.user.highestQualification}' : "",
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
                    title: Text(
                      "Degree/Diploma",
                      style: Theme.of(context).primaryTextTheme.headline3,
                    ).translate(),
                    trailing: SizedBox(
                      width: 150,
                      child: Text(
                        global.user.degreeDiploma != null && global.user.degreeDiploma != '' ? '${global.user.degreeDiploma}' : "",
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ),
                global.user.collegeSchoolUniversity != null && global.user.collegeSchoolUniversity != ''
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListTile(
                          enabled: true,
                          tileColor: Colors.white,
                          title: Text(
                            "College/School/University",
                            style: Theme.of(context).primaryTextTheme.headline3,
                          ).translate(),
                          trailing: SizedBox(
                            width: 190,
                            child: Text(
                              global.user.collegeSchoolUniversity != null && global.user.collegeSchoolUniversity != '' ? '${global.user.collegeSchoolUniversity}' : "",
                              style: Theme.of(context).primaryTextTheme.subtitle1,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                global.user.learnAstrology != null && global.user.learnAstrology != ''
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListTile(
                          enabled: true,
                          tileColor: Colors.white,
                          title: Text(
                            "Your learning platform",
                            style: Theme.of(context).primaryTextTheme.headline3,
                          ).translate(),
                          trailing: Text(
                            global.user.learnAstrology != null && global.user.learnAstrology != '' ? '${global.user.learnAstrology}' : "",
                            style: Theme.of(context).primaryTextTheme.subtitle1,
                          ).translate(),
                        ),
                      )
                    : const SizedBox(),
                global.user.instagramProfileLink != null && global.user.instagramProfileLink != ''
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListTile(
                          enabled: true,
                          tileColor: Colors.white,
                          title: Text(
                            "InstaGram Link",
                            style: Theme.of(context).primaryTextTheme.headline3,
                          ).translate(),
                          trailing: Text(
                            global.user.instagramProfileLink != null && global.user.instagramProfileLink != '' ? '${global.user.instagramProfileLink}' : "",
                            style: Theme.of(context).primaryTextTheme.subtitle1,
                          ),
                        ),
                      )
                    : const SizedBox(),
                global.user.facebookProfileLink != null && global.user.facebookProfileLink != ''
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListTile(
                          enabled: true,
                          tileColor: Colors.white,
                          title: Text(
                            "Facebook Link",
                            style: Theme.of(context).primaryTextTheme.headline3,
                          ).translate(),
                          trailing: Text(
                            global.user.facebookProfileLink != null && global.user.facebookProfileLink != '' ? '${global.user.facebookProfileLink}' : "",
                            style: Theme.of(context).primaryTextTheme.subtitle1,
                          ),
                        ),
                      )
                    : const SizedBox(),
                global.user.linkedInProfileLink != null && global.user.linkedInProfileLink != ''
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListTile(
                          enabled: true,
                          tileColor: Colors.white,
                          title: Text(
                            "LinkedIn",
                            style: Theme.of(context).primaryTextTheme.headline3,
                          ).translate(),
                          trailing: Text(
                            global.user.linkedInProfileLink != null && global.user.linkedInProfileLink != '' ? '${global.user.linkedInProfileLink}' : "",
                            style: Theme.of(context).primaryTextTheme.subtitle1,
                          ),
                        ),
                      )
                    : const SizedBox(),
                global.user.youtubeProfileLink != null && global.user.youtubeProfileLink != ''
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListTile(
                          enabled: true,
                          tileColor: Colors.white,
                          title: Text(
                            "Youtube",
                            style: Theme.of(context).primaryTextTheme.headline3,
                          ).translate(),
                          trailing: Text(
                            global.user.youtubeProfileLink != null && global.user.youtubeProfileLink != '' ? '${global.user.youtubeProfileLink}' : "",
                            style: Theme.of(context).primaryTextTheme.subtitle1,
                          ),
                        ),
                      )
                    : const SizedBox(),
                global.user.webSiteProfileLink != null && global.user.webSiteProfileLink != ''
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListTile(
                          enabled: true,
                          tileColor: Colors.white,
                          title: Text(
                            "Website",
                            style: Theme.of(context).primaryTextTheme.headline3,
                          ).translate(),
                          trailing: Text(
                            global.user.webSiteProfileLink != null && global.user.webSiteProfileLink != '' ? '${global.user.webSiteProfileLink}' : "",
                            style: Theme.of(context).primaryTextTheme.subtitle1,
                          ),
                        ),
                      )
                    : const SizedBox(),
                global.user.referedPersonName != null && global.user.referedPersonName != ''
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListTile(
                          enabled: true,
                          tileColor: Colors.white,
                          title: Text(
                            "Refferences Name",
                            style: Theme.of(context).primaryTextTheme.headline3,
                          ).translate(),
                          trailing: Text(
                            global.user.referedPersonName != null && global.user.referedPersonName != '' ? '${global.user.referedPersonName}' : "",
                            style: Theme.of(context).primaryTextTheme.subtitle1,
                          ).translate(),
                        ),
                      )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListTile(
                    enabled: true,
                    tileColor: Colors.white,
                    title: Text(
                      "Expected Minimum Earning",
                      style: Theme.of(context).primaryTextTheme.headline3,
                    ).translate(),
                    trailing: Text(
                      global.user.expectedMinimumEarning != null ? '${global.user.expectedMinimumEarning}' : "${global.getSystemFlagValue(global.systemFlagNameList.currency)} 0",
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
                      "Expected Maximum Earning",
                      style: Theme.of(context).primaryTextTheme.headline3,
                    ).translate(),
                    trailing: Text(
                      global.user.expectedMaximumEarning != null ? '${global.user.expectedMaximumEarning}' : "${global.getSystemFlagValue(global.systemFlagNameList.currency)} 0",
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: ExpansionTile(
                    title: Text(
                      "Long Bio",
                      style: Theme.of(context).primaryTextTheme.headline3,
                    ).translate(),
                    childrenPadding: const EdgeInsets.symmetric(horizontal: 8),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          global.user.longBio != null && global.user.longBio != '' ? '${global.user.longBio}' : "My Name is developer And i am working as astrologer in this company",
                          style: Theme.of(context).primaryTextTheme.subtitle1,
                        ).translate(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
