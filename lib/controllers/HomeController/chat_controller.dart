// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'package:astrologer_app/models/chat_model.dart';
import 'package:astrologer_app/services/apiHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrologer_app/utils/global.dart' as global;

import '../../models/chat_message_model.dart';
import '../../views/HomeScreen/chat_screen.dart';

class ChatController extends GetxController {
  String screen = 'chat_controller.dart';
  String? enteredMessage = '';
  APIHelper apiHelper = APIHelper();
  List<ChatModel> chatList = [];
  //customer agorachat userId
  String agorapeerUserId = "";
  //astrologer agorachat userId
  String agoraUserId = "";
  //chatId from database
  int? chatId;
  String chatusersId = "";
  String firebaseChatId = "";

  int? userId;
  CollectionReference userChatCollectionRef = FirebaseFirestore.instance.collection("chats");

  ScrollController scrollController = ScrollController();
  int fetchRecord = 5;
  int startIndex = 0;
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isMoreDataAvailable = false;
  bool isInChatScreen = false;

  @override
  // ignore: unnecessary_overrides
  void onInit() async {
    super.onInit();
  }

//Get a chat list
  Future getChatList(bool isLazyLoading) async {
    try {
      startIndex = 0;
      if (chatList.isNotEmpty) {
        startIndex = chatList.length;
      }
      if (!isLazyLoading) {
        isDataLoaded = false;
      }
      await global.checkBody().then(
        (result) async {
          if (result) {
            global.showOnlyLoaderDialog();
            int id = global.user.id ?? 0;
            await apiHelper.getchatRequest(id, startIndex, fetchRecord).then((result) {
              global.hideLoader();
              if (result.status == "200") {
                chatList.addAll(result.recordList);
                print('chat list length ${chatList.length} ');
                if (result.recordList.length == 0) {
                  isMoreDataAvailable = false;
                  isAllDataLoaded = true;
                }
                update();
              } else {
                global.showToast(message: "No chat list is here");
              }
            });
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - getChatList():- ' + e.toString());
    }
  }

  storeChatId(int partnerId, int chatId) async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            await apiHelper.addChatId(global.currentUserId!, partnerId, chatId).then(
              (result) {
                if (result.status == "200") {
                  firebaseChatId = result.recordList['recordList'];
                  update();
                  print('chat id genrated:- $firebaseChatId');
                } else {
                  global.showToast(message: "there are some problem");
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception: $screen - storeChatId(): ' + e.toString());
    }
  }

//Reject a chat by id
  Future rejectChatRequest(int chatId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.showOnlyLoaderDialog();
          await apiHelper.chatReject(chatId).then((result) async {
            global.hideLoader();
            if (result.status == "200") {
              global.showToast(message: "Reject a chat request sucessfully");
              chatList.clear();
              isAllDataLoaded = false;
              update();
              await getChatList(false);
              Get.back();
            } else {
              global.showToast(message: result.message.toString());
            }
          });
        }
      });
      update();
    } catch (e) {
      print("Exception: $screen - rejectChatRequest():" + e.toString());
    }
  }

  //accept chat request
  Future acceptChatRequest(int chatId, String customerName, String customerProfile, int customerId, String fcmToken) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.showOnlyLoaderDialog();
          await apiHelper.acceptChatRequest(chatId).then((result) async {
            global.hideLoader();
            if (result.status == "200") {
              global.showToast(message: "This chat is  accepted");
              await storeChatId(customerId, chatId);
              isInChatScreen = true;
              Get.to(() => ChatScreen(
                    flagId: 1,
                    customerName: customerName,
                    customerProfile: customerProfile,
                    customerId: customerId,
                    fcmToken: fcmToken,
                    // fireBasechatId: '${customerId}_${global.currentUserId}',
                  ));
              chatList.clear();
              isAllDataLoaded = false;
              update();
              await getChatList(false);
            } else {
              global.showToast(message: "This chat is not rejected");
            }
            update();
          });
        }
      });
    } catch (e) {
      print("Exception: $screen - acceptChatRequest():" + e.toString());
    }
  }

  bool isMe = true;
  Stream<QuerySnapshot<Map<String, dynamic>>>? getChatMessages(String firebaseChatId1, int? currentUserId) {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> data = FirebaseFirestore.instance.collection('chats/$firebaseChatId1/userschat').doc('$currentUserId').collection('messages').orderBy("createdAt", descending: true).snapshots(); //orderBy("createdAt", descending: true)
      return data;
    } catch (err) {
      print("Exception - apiHelper.dart - getChatMessages()" + err.toString());
      return null;
    }
  }

  Future<void> sendMessage(String message, int partnerId, bool isEndMessage) async {
    // if (chatId != null) {
    try {
      if (message.trim() != '') {
        ChatMessageModel chaMessage = ChatMessageModel(
          message: message,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDelete: false,
          isRead: true,
          userId1: '${global.currentUserId}',
          userId2: '$partnerId',
          isEndMessage: isEndMessage,
        );
        update();
        await uploadMessage(firebaseChatId, '$partnerId', chaMessage);
      } else {}
    } catch (e) {
      print('Exception in sendMessage ${e.toString()}');
    }
  }

  Future uploadMessage(String idUser, String partnerId, ChatMessageModel anonymous) async {
    try {
      final String globalId = global.currentUserId.toString();
      final refMessages = userChatCollectionRef.doc(idUser).collection('userschat').doc(globalId).collection('messages');
      final refMessages1 = userChatCollectionRef.doc(idUser).collection('userschat').doc(partnerId).collection('messages');
      final newMessage1 = anonymous;

      final newMessage2 = anonymous;
      newMessage2.messageId = refMessages1.id;

      var messageResult = await refMessages.add(newMessage1.toJson()).catchError((e) {
        print('send mess exception' + e);
      });
      newMessage1.messageId = messageResult.id;
      await userChatCollectionRef.doc(idUser).collection('userschat').doc(globalId).collection('messages').doc(newMessage1.messageId).update({"messageId": newMessage1.messageId});

      newMessage2.isRead = false;
      var message1Result = await refMessages1.add(newMessage2.toJson()).catchError((e) {
        print('send mess exception' + e);
      });
      // newMessage2.messageId = message1Result.id;
      await userChatCollectionRef.doc(idUser).collection('userschat').doc(partnerId).collection('messages').doc(newMessage1.messageId).update({"messageId": newMessage1.messageId});
      return {
        'user1': messageResult.id,
        'user2': message1Result.id,
      };
    } catch (err) {
      print('uploadMessage err $err');
    }
  }
}
