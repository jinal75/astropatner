// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'package:astrologer_app/services/apiHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../models/assistant_chat_request_model.dart';
import '../../models/chat_message_model.dart';
import 'package:astrologer_app/utils/global.dart' as global;

class AstrologerAssistantChatController extends GetxController {
  CollectionReference userChatCollectionRef = FirebaseFirestore.instance.collection("assistantchats");

  bool isMe = true;
  APIHelper apiHelper = APIHelper();
  List<String> lastMessage = [];
  var assistantChatRequestList = <AssistantChatRequestModel>[];

  getAstrologerAssistantChatRequest() async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            print('current astrologer id ${global.currentUserId}');
            await apiHelper.getAssistantChatRequest(global.currentUserId!).then(
              (result) {
                if (result.status == "200") {
                  assistantChatRequestList = result.recordList;
                  for (int i = 0; i < assistantChatRequestList.length; i++) {
                    getLastMessages(chatId: assistantChatRequestList[i].chatId).then((value) {
                      assistantChatRequestList[i].lastMessage = value!.message;
                      assistantChatRequestList[i].lastMessageTime = value.createdAt;
                      update();
                    });
                  }
                  update();
                  print('Get chat requests');
                } else {
                  global.showToast(message: 'Failed to get Assistant chat request');
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception:- getAstrologerAssistantChatRequest(): ' + e.toString());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getChatMessages(String firebaseChatId, int? currentUserId) {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> data = FirebaseFirestore.instance.collection('assistantchats/$firebaseChatId/userschat').doc('$currentUserId').collection('messages').orderBy("createdAt", descending: true).snapshots(); //orderBy("createdAt", descending: true)
      return data;
    } catch (err) {
      print("Exception -  getChatMessages()$err");
      return null;
    }
  }

  Future<void> sendMessage(String message, String chatId, int partnerId) async {
    try {
      if (message.trim() != '') {
        ChatMessageModel chatMessage = ChatMessageModel(
          message: message,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDelete: false,
          isRead: true,
          userId1: '${global.currentUserId}',
          userId2: '$partnerId',
        );
        update();
        await uploadMessage(chatId, '$partnerId', chatMessage);
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

  Future<ChatMessageModel?> getLastMessages({String? chatId}) async {
    try {
      Stream<List<ChatMessageModel>> m = FirebaseFirestore.instance.collection('assistantchats').doc(chatId).collection('userschat').doc(global.user.id.toString()).collection('messages').orderBy("createdAt", descending: true).limit(1).snapshots().map((reviews) => reviews.docs.map((review) => ChatMessageModel.fromJson(review.data())).toList());
      print(m.length);
      List<ChatMessageModel> mm = await m.first;
      return mm.isNotEmpty
          ? mm[0]
          : ChatMessageModel(
              message: '',
              createdAt: DateTime.now().subtract(const Duration(days: 365)),
              url: '',
            );
    } catch (err) {
      print("Exception - getLastMessages()" + err.toString());
      return null;
    }
  }
}
