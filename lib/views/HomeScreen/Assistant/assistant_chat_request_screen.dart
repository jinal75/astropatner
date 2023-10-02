import 'package:astrologer_app/controllers/AssistantController/astrologer_assistant_chat_controller.dart';
import 'package:astrologer_app/views/HomeScreen/Assistant/assistant_chat_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:astrologer_app/utils/global.dart' as global;
import 'package:get/get.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';

class AssistantChatRequestScreen extends StatelessWidget {
  AssistantChatRequestScreen({Key? key}) : super(key: key);
  final AstrologerAssistantChatController astrologerAssistantChatController = Get.find<AstrologerAssistantChatController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistant Chat Request').translate(),
      ),
      body: Container(
          width: double.infinity,
          height: Get.height,
          decoration: const BoxDecoration(),
          child: astrologerAssistantChatController.assistantChatRequestList.isEmpty
              ? Center(
                  child: const Text('There are no chat request for assistant').translate(),
                )
              : GetBuilder<AstrologerAssistantChatController>(builder: (c) {
                  return ListView.builder(
                      itemCount: astrologerAssistantChatController.assistantChatRequestList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            Get.to(() => ChatWithAstrologerAssistantScreen(
                                  flagId: 1,
                                  customerId: astrologerAssistantChatController.assistantChatRequestList[index].customerId,
                                  customerName: astrologerAssistantChatController.assistantChatRequestList[index].userName,
                                  fireBasechatId: astrologerAssistantChatController.assistantChatRequestList[index].chatId,
                                ));
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Get.theme.primaryColor),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: CircleAvatar(
                                      radius: 25,
                                      child: astrologerAssistantChatController.assistantChatRequestList[index].profile == ""
                                          ? CircleAvatar(
                                              radius: 24,
                                              backgroundColor: Colors.white,
                                              child: Image.asset(
                                                'assets/images/no_customer_image.png',
                                                fit: BoxFit.cover,
                                                height: 50,
                                                width: 40,
                                              ),
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: '${global.imgBaseurl}${astrologerAssistantChatController.assistantChatRequestList[index].profile}',
                                              imageBuilder: (context, imageProvider) => CircleAvatar(
                                                  radius: 24,
                                                  backgroundColor: Colors.white,
                                                  child: Image.network(
                                                    fit: BoxFit.cover,
                                                    height: 50,
                                                    width: 40,
                                                    '${global.imgBaseurl}${astrologerAssistantChatController.assistantChatRequestList[index].profile}',
                                                  )),
                                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) => Image.asset(
                                                'assets/images/no_customer_image.png',
                                                fit: BoxFit.cover,
                                                height: 50,
                                                width: 40,
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(astrologerAssistantChatController.assistantChatRequestList[index].userName).translate(),
                                      Text(
                                        astrologerAssistantChatController.assistantChatRequestList[index].lastMessage ?? '',
                                        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        DateFormat('dd MMM yyyy , hh:mm a').format(astrologerAssistantChatController.assistantChatRequestList[index].lastMessageTime ?? DateTime.now()),
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                })),
    );
  }
}
