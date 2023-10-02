import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:astrologer_app/controllers/HomeController/call_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/user_model.dart';

class AcceptCallScreen extends StatefulWidget {
  final int id;
  final String name;
  final String profile;
  final int callId;
  final String fcmToken;
  const AcceptCallScreen({super.key, required this.id, required this.fcmToken, required this.name, required this.profile, required this.callId});

  @override
  State<AcceptCallScreen> createState() => _AcceptCallScreenState();
}

class _AcceptCallScreenState extends State<AcceptCallScreen> {
  int uid = 0;
  int? remoteUid;
  late RtcEngine agoraEngine;
  bool isCalling = true;
  bool isMuted = false;
  bool isSpeaker = false;
  Timer? timer;
  Timer? secTimer;
  int callVolume = 50;
  int min = 0;
  int sec = 0;
  final CallController callController = CallController();
  @override
  void initState() {
    super.initState();
    // Set up an instance of Agora engine
    setupVoiceSDKEngine();
  }

  Future generateToken() async {
    try {
      global.sp = await SharedPreferences.getInstance();
      CurrentUser userData = CurrentUser.fromJson(json.decode(global.sp!.getString("currentUser") ?? ""));
      int id = userData.id ?? 0;
      global.agoraChannelName = '${global.channelName}${id}_${widget.id}';
      log('channel :- ${global.agoraChannelName}');
      await callController.getRtcToken(global.getSystemFlagValue(global.systemFlagNameList.agoraAppId), global.getSystemFlagValue(global.systemFlagNameList.agoraAppCertificate), "$uid", global.agoraChannelName);
      log("call token:-${global.agoraToken}");
      global.showOnlyLoaderDialog();
      await callController.sendCallToken(global.agoraToken, global.agoraChannelName, widget.callId);
      global.hideLoader();
      log("object");
    } catch (e) {
      // ignore: avoid_print
      print("Exception in gettting token: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        global.showToast(message: 'Please leave the call by pressing leave button');
        return false;
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20),
              color: Get.theme.primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.info),
                        onPressed: () async {
                          global.showOnlyLoaderDialog();
                          await callController.getFormIntakeData(widget.id);
                          // ignore: avoid_print
                          print('intakeData ${callController.intakeData}');
                          global.hideLoader();
                          showDialog(
                              context: context,
                              // barrierDismissible: false, // user must tap button for close dialog!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  scrollable: true,
                                  content: Stack(clipBehavior: Clip.none, children: [
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ListTile(
                                          enabled: true,
                                          tileColor: Colors.white,
                                          title: Text(
                                            "Name",
                                            style: Theme.of(context).primaryTextTheme.headline3,
                                          ).translate(),
                                          trailing: SizedBox(
                                            width: 120,
                                            child: Text(
                                              callController.intakeData[0].name ?? "User",
                                              style: Theme.of(context).primaryTextTheme.subtitle1,
                                              textAlign: TextAlign.end,
                                            ).translate(),
                                          ),
                                        ),
                                        ListTile(
                                          enabled: true,
                                          tileColor: Colors.white,
                                          title: Text(
                                            "Birth Date",
                                            style: Theme.of(context).primaryTextTheme.headline3,
                                          ).translate(),
                                          trailing: SizedBox(
                                            width: 120,
                                            child: Text(
                                              DateFormat('dd-MM-yyyy').format(DateTime.parse(callController.intakeData[0].birthDate.toString())),
                                              textAlign: TextAlign.end,
                                              style: Theme.of(context).primaryTextTheme.subtitle1,
                                            ).translate(),
                                          ),
                                        ),
                                        ListTile(
                                          enabled: true,
                                          tileColor: Colors.white,
                                          title: Text(
                                            "Birth Time",
                                            style: Theme.of(context).primaryTextTheme.headline3,
                                          ).translate(),
                                          trailing: Text(
                                            callController.intakeData[0].birthTime.toString(),
                                            style: Theme.of(context).primaryTextTheme.subtitle1,
                                          ).translate(),
                                        ),
                                        ListTile(
                                          enabled: true,
                                          tileColor: Colors.white,
                                          title: Text(
                                            "Birth Place",
                                            style: Theme.of(context).primaryTextTheme.headline3,
                                          ).translate(),
                                          trailing: SizedBox(
                                            width: 120,
                                            child: Text(
                                              callController.intakeData[0].birthPlace.toString(),
                                              style: Theme.of(context).primaryTextTheme.subtitle1,
                                              textAlign: TextAlign.end,
                                            ).translate(),
                                          ),
                                        ),
                                        ListTile(
                                          enabled: true,
                                          tileColor: Colors.white,
                                          title: Text(
                                            "Phone Number",
                                            style: Theme.of(context).primaryTextTheme.headline3,
                                          ).translate(),
                                          trailing: Text(
                                            callController.intakeData[0].phoneNumber.toString(),
                                            style: Theme.of(context).primaryTextTheme.subtitle1,
                                            textAlign: TextAlign.end,
                                          ).translate(),
                                        ),
                                        ListTile(
                                          enabled: true,
                                          tileColor: Colors.white,
                                          title: Text(
                                            "Occupation",
                                            style: Theme.of(context).primaryTextTheme.headline3,
                                          ).translate(),
                                          trailing: SizedBox(
                                            width: 120,
                                            child: Text(
                                              callController.intakeData[0].occupation.toString(),
                                              style: Theme.of(context).primaryTextTheme.subtitle1,
                                              textAlign: TextAlign.end,
                                            ).translate(),
                                          ),
                                        ),
                                        callController.intakeData[0].topicOfConcern == ""
                                            ? const SizedBox()
                                            : ListTile(
                                                enabled: true,
                                                tileColor: Colors.white,
                                                title: Text(
                                                  "Topic",
                                                  style: Theme.of(context).primaryTextTheme.headline3,
                                                ).translate(),
                                                trailing: SizedBox(
                                                  width: 120,
                                                  child: Text(
                                                    callController.intakeData[0].topicOfConcern.toString(),
                                                    style: Theme.of(context).primaryTextTheme.subtitle1,
                                                    textAlign: TextAlign.end,
                                                  ).translate(),
                                                ),
                                              ),
                                        callController.intakeData[0].partnerName != null && callController.intakeData[0].partnerName != ''
                                            ? ListTile(
                                                enabled: true,
                                                tileColor: Colors.white,
                                                title: Text(
                                                  "Partner Name",
                                                  style: Theme.of(context).primaryTextTheme.headline3,
                                                ).translate(),
                                                trailing: Text(
                                                  callController.intakeData[0].partnerName.toString(),
                                                  style: Theme.of(context).primaryTextTheme.subtitle1,
                                                  textAlign: TextAlign.end,
                                                ).translate(),
                                              )
                                            : const SizedBox(),
                                        callController.intakeData[0].partnerBirthDate != null
                                            ? ListTile(
                                                enabled: true,
                                                tileColor: Colors.white,
                                                title: Text(
                                                  "Partner Birth Date",
                                                  style: Theme.of(context).primaryTextTheme.headline3,
                                                ).translate(),
                                                trailing: SizedBox(
                                                  width: 120,
                                                  child: Text(
                                                    DateFormat('dd-MM-yyyy').format(DateTime.parse(callController.intakeData[0].partnerBirthDate.toString())),
                                                    style: Theme.of(context).primaryTextTheme.subtitle1,
                                                    textAlign: TextAlign.end,
                                                  ).translate(),
                                                ),
                                              )
                                            : const SizedBox(),
                                        callController.intakeData[0].partnerBirthTime != null && callController.intakeData[0].partnerBirthTime != ''
                                            ? ListTile(
                                                enabled: true,
                                                tileColor: Colors.white,
                                                title: Text(
                                                  "Partner Birth Time",
                                                  style: Theme.of(context).primaryTextTheme.headline3,
                                                ).translate(),
                                                trailing: Text(
                                                  callController.intakeData[0].partnerBirthTime.toString(),
                                                  style: Theme.of(context).primaryTextTheme.subtitle1,
                                                ).translate(),
                                              )
                                            : const SizedBox(),
                                        callController.intakeData[0].partnerBirthPlace != null && callController.intakeData[0].partnerBirthPlace != ''
                                            ? ListTile(
                                                enabled: true,
                                                tileColor: Colors.white,
                                                title: Text(
                                                  "Partner Birth Place",
                                                  style: Theme.of(context).primaryTextTheme.headline3,
                                                ).translate(),
                                                trailing: SizedBox(
                                                  width: 120,
                                                  child: Text(
                                                    callController.intakeData[0].partnerBirthPlace.toString(),
                                                    style: Theme.of(context).primaryTextTheme.subtitle1,
                                                    textAlign: TextAlign.end,
                                                  ).translate(),
                                                ),
                                              )
                                            : const SizedBox()
                                      ],
                                    ),
                                    Positioned(
                                        top: -5,
                                        right: -5,
                                        child: GestureDetector(
                                            onTap: () {
                                              Get.back();
                                            },
                                            child: const Icon(Icons.close)))
                                  ]),
                                  actionsAlignment: MainAxisAlignment.spaceBetween,
                                  actionsPadding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                                );
                              });
                        },
                      )),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          widget.name == '' ? 'User' : widget.name,
                          style: Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500, fontSize: 20),
                        ).translate(),
                        SizedBox(
                          child: status(),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  height: 120,
                  width: 120,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: Get.height * 0.1),
                  decoration: BoxDecoration(
                    border: Border.all(color: Get.theme.primaryColor),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 60,
                    // ignore: unnecessary_null_comparison
                    child: widget.profile == null || widget.profile == ""
                        ? Image.asset(
                            'assets/images/no_customer_image.png',
                            fit: BoxFit.contain,
                            height: 60,
                            width: 40,
                          )
                        : CachedNetworkImage(
                            imageUrl: '${global.imgBaseurl}${widget.profile}',
                            imageBuilder: (context, imageProvider) => CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.transparent,
                              child: Image.network(
                                '${global.imgBaseurl}${widget.profile}',
                                fit: BoxFit.contain,
                                height: 60,
                              ),
                            ),
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/no_customer_image.png',
                              fit: BoxFit.contain,
                              height: 60,
                              width: 40,
                            ),
                          ),
                  ),
                ),
              ),
            )
          ],
        ),
        bottomSheet: Container(
          height: Get.height * 0.1,
          padding: const EdgeInsets.all(10),
          color: Get.theme.primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    callVolume = 100;
                    isSpeaker = !isSpeaker;
                  });
                  onVolume(isSpeaker);
                },
                child: Icon(
                  Icons.volume_up,
                  color: isSpeaker ? Colors.blue : Colors.grey,
                ),
              ),
              InkWell(
                onTap: () {
                  global.callOnFcmApiSendPushNotifications(
                    fcmTokem: [widget.fcmToken],
                    title: "Astrologer Leave call",
                    subTitle: "",
                    sendData: {},
                  );
                  leave();
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isMuted = !isMuted;
                    log('mute $isMuted');
                  });
                  onMute(isMuted);
                },
                child: Icon(
                  Icons.mic_off,
                  color: isMuted ? Colors.blue : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> setupVoiceSDKEngine() async {
    // retrieve or request microphone permission
    await [Permission.microphone].request();
    //createClient();
    //agoraEngine.startAudioRecording(config);
    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(RtcEngineContext(appId: global.getSystemFlagValue(global.systemFlagNameList.agoraAppId)));

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          // ignore: avoid_print
          print('joined${connection.localUid}');
        },
        onUserJoined: (RtcConnection connection, int remoteUId, int elapsed) {
          setState(() {
            remoteUid = remoteUId;
          });
          // ignore: avoid_print
          print("RemoteId for call$remoteUid");
        },
        onUserOffline: (RtcConnection connection, int remoteUId, UserOfflineReasonType reason) {
          setState(() {
            remoteUid = null;
          });
          // ignore: avoid_print
          print('remote offline');
          leave();
        },
        onRtcStats: (connection, stats) {},
      ),
    );
    await generateToken();
    onVolume(isSpeaker);
    onMute(isMuted);
    join();
  }

  Widget status() {
    String statusText;
    if (remoteUid == null) {
      statusText = 'Calling...';
      return Text(statusText).translate();
    } else {
      statusText = 'Calling in progress';
      return CountdownTimer(
        endTime: DateTime.now().millisecondsSinceEpoch + 1000 * 300,
        widgetBuilder: (_, CurrentRemainingTime? time) {
          if (time == null) {
            return const Text('00 min 00 sec');
          }
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: time.min != null
                ? Text('${time.min} min ${time.sec} sec', style: const TextStyle(fontWeight: FontWeight.w500))
                : Text(
                    '${time.sec} sec',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
          );
        },
        onEnd: () {
          if (remoteUid != null) {
            leave();
          }
        },
      );
    }
  }

  void join() async {
    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );
    await agoraEngine.joinChannel(
      token: global.agoraToken,
      channelId: global.agoraChannelName,
      options: options,
      uid: uid,
    );
  }

  void onMute(bool mute) {
    agoraEngine.muteLocalAudioStream(mute);
  }

  void onVolume(bool isSpeaker) async {
    await agoraEngine.setEnableSpeakerphone(isSpeaker);
  }

  void leave() {
    if (mounted) {
      setState(() {
        remoteUid = null;
      });
    }
    if (timer != null) {
      timer!.cancel();
    }
    if (secTimer != null) {
      secTimer!.cancel();
    }
    agoraEngine.leaveChannel();
    agoraEngine.release(sync: true);
    Get.back();
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    if (secTimer != null) {
      secTimer!.cancel();
    }
    super.dispose();
  }
}
