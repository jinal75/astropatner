// ignore_for_file: avoid_print

import 'package:astrologer_app/services/apiHelper.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CallDetailController extends GetxController {
  String screen = 'call_detail_controller.dart';
  double currentSliderValue = 0;

  APIHelper apiHelper = APIHelper();
  bool isPlay = false;
  var audioPlayer = AudioPlayer();
  var audioPlayer2 = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void onInit() {
    _inIt();
    super.onInit();
  }

  disposeAudioPlayer() {
    audioPlayer.dispose();
    audioPlayer2.dispose();
  }

  _inIt() {
    audioPlayer.onDurationChanged.listen((event) {
      duration = event;
      update();
    });
    audioPlayer.onPositionChanged.listen((event) {
      position = event;
      update();
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getChatMessages(String firebaseChatId, int? currentUserId) {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> data = FirebaseFirestore.instance.collection('chats2/$firebaseChatId/userschat').doc('$currentUserId').collection('messages').orderBy("createdAt", descending: true).snapshots(); //orderBy("createdAt", descending: true)
      return data;
    } catch (err) {
      print("Exception - apiHelper.dart - getChatMessages()$err");
      return null;
    }
  }
}
