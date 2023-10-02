class AssistantChatRequestModel {
  AssistantChatRequestModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.chatId,
    required this.createdAt,
    required this.updatedAt,
    required this.astrologerId,
    required this.customerId,
    required this.userName,
    this.profile,
    this.contactNo,
    this.lastMessage,
    this.lastMessageTime,
  });

  int id;
  int senderId;
  int receiverId;
  String chatId;
  DateTime createdAt;
  DateTime updatedAt;
  int astrologerId;
  int customerId;
  String userName;
  String? profile;
  String? contactNo;
  String? lastMessage;
  DateTime? lastMessageTime;

  factory AssistantChatRequestModel.fromJson(Map<String, dynamic> json) => AssistantChatRequestModel(
        id: json["id"],
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        chatId: json["chatId"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        astrologerId: json["astrologerId"],
        customerId: json["customerId"],
        userName: json["userName"] ?? "User",
        profile: json["profile"] ?? "",
        contactNo: json["contactNo"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "senderId": senderId,
        "receiverId": receiverId,
        "chatId": chatId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "astrologerId": astrologerId,
        "customerId": customerId,
        "userName": userName,
        "profile": profile ?? "",
        "contactNo": contactNo ?? "",
      };
}
