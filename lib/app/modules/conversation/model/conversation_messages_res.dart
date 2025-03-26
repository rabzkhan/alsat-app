// To parse this JSON data, do
//
//     final conversationMessagesRes = conversationMessagesResFromJson(jsonString);

import 'dart:convert';

ConversationMessagesRes conversationMessagesResFromJson(String str) =>
    ConversationMessagesRes.fromJson(json.decode(str));

String conversationMessagesResToJson(ConversationMessagesRes data) =>
    json.encode(data.toJson());

class ConversationMessagesRes {
  final Data? data;
  final bool? hasMore;

  ConversationMessagesRes({
    this.data,
    this.hasMore,
  });

  factory ConversationMessagesRes.fromJson(Map<String, dynamic> json) =>
      ConversationMessagesRes(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        hasMore: json["has_more"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "has_more": hasMore,
      };
}

class Data {
  final Map<String, Participant>? participants;
  final List<MessageModel>? messages;

  Data({
    this.participants,
    this.messages,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        participants: Map.from(json["participants"]!).map((k, v) =>
            MapEntry<String, Participant>(k, Participant.fromJson(v))),
        messages: json["messages"] == null
            ? []
            : List<MessageModel>.from(
                json["messages"]!.map((x) => MessageModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "participants": Map.from(participants!)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "messages": messages == null
            ? []
            : List<dynamic>.from(messages!.map((x) => x.toJson())),
      };
}

class MessageModel {
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? accessedAt;
  final String? senderId;
  final String? receiverId;
  final String? chatId;
  final String? content;
  final MessageModel? replyTo;
  final List<Attachment>? attachments;
  final String? status;

  MessageModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.accessedAt,
    this.senderId,
    this.receiverId,
    this.chatId,
    this.content,
    this.replyTo,
    this.attachments,
    this.status,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json["_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        accessedAt: json["accessed_at"] == null
            ? null
            : DateTime.parse(json["accessed_at"]),
        senderId: json["sender_id"] ?? json['sender']['_id'],
        receiverId: json["receiver_id"],
        chatId: json["chat_id"],
        content: json["content"],
        replyTo: json["reply_to"] == null
            ? null
            : MessageModel.fromJson(json["reply_to"]),
        attachments: json["attachments"] == null
            ? []
            : List<Attachment>.from(
                json["attachments"]!.map((x) => Attachment.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "accessed_at": accessedAt?.toIso8601String(),
        "sender_id": senderId,
        "receiver_id": receiverId,
        "chat_id": chatId,
        "content": content,
        "reply_to": replyTo?.toJson(),
        "attachments": attachments == null
            ? []
            : List<dynamic>.from(attachments!.map((x) => x.toJson())),
        "status": status,
      };
}

class Attachment {
  final String? type;
  final dynamic data;

  Attachment({
    this.type,
    this.data,
  });

  Attachment copyWith({
    String? type,
    dynamic data,
  }) =>
      Attachment(
        type: type ?? this.type,
        data: data ?? this.data,
      );

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        type: json["type"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "data": data,
      };
}

class ReplyTo {
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? accessedAt;
  final String? content;
  final Participant? sender;

  ReplyTo({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.accessedAt,
    this.content,
    this.sender,
  });

  factory ReplyTo.fromJson(Map<String, dynamic> json) => ReplyTo(
        id: json["_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        accessedAt: json["accessed_at"] == null
            ? null
            : DateTime.parse(json["accessed_at"]),
        content: json["content"],
        sender: json["sender"] == null
            ? null
            : Participant.fromJson(json["sender"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "accessed_at": accessedAt?.toIso8601String(),
        "content": content,
        "sender": sender?.toJson(),
      };
}

class Participant {
  final String? id;
  final String? userName;
  final String? picture;

  Participant({
    this.id,
    this.userName,
    this.picture,
  });

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
        id: json["_id"],
        userName: json["user_name"],
        picture: json["picture"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user_name": userName,
        "picture": picture,
      };
}
