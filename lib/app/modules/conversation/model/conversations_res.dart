import 'dart:convert';

import 'conversation_messages_res.dart';

class ConversationListRes {
  final List<ConversationModel>? data;
  final bool? hasMore;

  ConversationListRes({
    this.data,
    this.hasMore,
  });

  factory ConversationListRes.fromRawJson(String str) =>
      ConversationListRes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConversationListRes.fromJson(Map<String, dynamic> json) =>
      ConversationListRes(
        data: json["data"] == null
            ? []
            : List<ConversationModel>.from(
                json["data"]!.map((x) => ConversationModel.fromJson(x))),
        hasMore: json["has_more"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "has_more": hasMore,
      };
}

class ConversationModel {
  final String? id;
  final String? createdAt;
  final DateTime? updatedAt;
  final DateTime? accessedAt;
  final List<Participant>? participants;
  MessageModel? lastMessage;
  final int? notReadedCount;
  final bool? haveBlocked;
  final bool? isBlocked;
  final bool? isAdminChat;

  ConversationModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.accessedAt,
    this.participants,
    this.lastMessage,
    this.notReadedCount,
    this.haveBlocked,
    this.isBlocked,
    this.isAdminChat,
  });

  factory ConversationModel.fromRawJson(String str) =>
      ConversationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      ConversationModel(
        id: json["_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        accessedAt: json["accessed_at"] == null
            ? null
            : DateTime.parse(json["accessed_at"]),
        participants: json["participants"] == null
            ? []
            : List<Participant>.from(
                json["participants"]!.map((x) => Participant.fromJson(x))),
        lastMessage: json["last_message"] == null
            ? null
            : MessageModel.fromJson(json["last_message"]),
        notReadedCount: json["not_readed_count"],
        haveBlocked: json["have_blocked"],
        isBlocked: json["is_blocked"],
        isAdminChat: json["is_admin_chat"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "created_at": createdAt,
        "updated_at": updatedAt?.toIso8601String(),
        "accessed_at": accessedAt?.toIso8601String(),
        "participants": participants == null
            ? []
            : List<dynamic>.from(participants!.map((x) => x.toJson())),
        "last_message": lastMessage?.toJson(),
        "not_readed_count": notReadedCount,
        "have_blocked": haveBlocked,
        "is_blocked": isBlocked,
        "is_admin_chat": isAdminChat,
      };
}
