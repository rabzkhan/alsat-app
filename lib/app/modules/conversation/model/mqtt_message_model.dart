// To parse this JSON data, do
//
//     final mqttMessageModel = mqttMessageModelFromJson(jsonString);

import 'dart:convert';

MqttMessageModel mqttMessageModelFromJson(String str) =>
    MqttMessageModel.fromJson(json.decode(str));

String mqttMessageModelToJson(MqttMessageModel data) =>
    json.encode(data.toJson());

class MqttMessageModel {
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? accessedAt;
  final Receiver? sender;
  final Receiver? receiver;
  final String? chatId;
  final String? content;
  final List<dynamic>? attachments;
  final String? status;

  MqttMessageModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.accessedAt,
    this.sender,
    this.receiver,
    this.chatId,
    this.content,
    this.attachments,
    this.status,
  });

  MqttMessageModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? accessedAt,
    Receiver? sender,
    Receiver? receiver,
    String? chatId,
    String? content,
    List<dynamic>? attachments,
    String? status,
  }) =>
      MqttMessageModel(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        accessedAt: accessedAt ?? this.accessedAt,
        sender: sender ?? this.sender,
        receiver: receiver ?? this.receiver,
        chatId: chatId ?? this.chatId,
        content: content ?? this.content,
        attachments: attachments ?? this.attachments,
        status: status ?? this.status,
      );

  factory MqttMessageModel.fromJson(Map<String, dynamic> json) =>
      MqttMessageModel(
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
        sender:
            json["sender"] == null ? null : Receiver.fromJson(json["sender"]),
        receiver: json["receiver"] == null
            ? null
            : Receiver.fromJson(json["receiver"]),
        chatId: json["chat_id"],
        content: json["content"],
        attachments: json["attachments"] == null
            ? []
            : List<dynamic>.from(json["attachments"]!.map((x) => x)),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "accessed_at": accessedAt?.toIso8601String(),
        "sender": sender?.toJson(),
        "receiver": receiver?.toJson(),
        "chat_id": chatId,
        "content": content,
        "attachments": attachments == null
            ? []
            : List<dynamic>.from(attachments!.map((x) => x)),
        "status": status,
      };
}

class Receiver {
  final String? id;
  final String? userName;
  final String? picture;

  Receiver({
    this.id,
    this.userName,
    this.picture,
  });

  Receiver copyWith({
    String? id,
    String? userName,
    String? picture,
  }) =>
      Receiver(
        id: id ?? this.id,
        userName: userName ?? this.userName,
        picture: picture ?? this.picture,
      );

  factory Receiver.fromJson(Map<String, dynamic> json) => Receiver(
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
