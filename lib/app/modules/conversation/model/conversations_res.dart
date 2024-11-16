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
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? accessedAt;
  List<Participant>? participants;
  MessageModel? lastMessage;
  int? notReadedCount;

  ConversationModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.accessedAt,
    this.participants,
    this.lastMessage,
    this.notReadedCount,
  });

  factory ConversationModel.fromRawJson(String str) =>
      ConversationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      ConversationModel(
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
        participants: json["participants"] == null
            ? []
            : List<Participant>.from(
                json["participants"]!.map((x) => Participant.fromJson(x))),
        lastMessage: json["last_message"] == null
            ? null
            : MessageModel.fromJson(json["last_message"]),
        notReadedCount: json["not_readed_count"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "accessed_at": accessedAt?.toIso8601String(),
        "participants": participants == null
            ? []
            : List<dynamic>.from(participants!.map((x) => x.toJson())),
        "last_message": lastMessage?.toJson(),
        "not_readed_count": notReadedCount,
      };
}

class DataClass {
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? accessedAt;
  final String? title;
  final String? description;
  final PriceInfo? priceInfo;
  final String? locationProvince;
  final String? locationCity;
  final String? userId;

  DataClass({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.accessedAt,
    this.title,
    this.description,
    this.priceInfo,
    this.locationProvince,
    this.locationCity,
    this.userId,
  });

  factory DataClass.fromRawJson(String str) =>
      DataClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataClass.fromJson(Map<String, dynamic> json) => DataClass(
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
        title: json["title"],
        description: json["description"],
        priceInfo: json["price_info"] == null
            ? null
            : PriceInfo.fromJson(json["price_info"]),
        locationProvince: json["location_province"],
        locationCity: json["location_city"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "accessed_at": accessedAt?.toIso8601String(),
        "title": title,
        "description": description,
        "price_info": priceInfo?.toJson(),
        "location_province": locationProvince,
        "location_city": locationCity,
        "user_id": userId,
      };
}

class PriceInfo {
  final double? price;
  final bool? possibleExchange;
  final bool? credit;

  PriceInfo({
    this.price,
    this.possibleExchange,
    this.credit,
  });

  factory PriceInfo.fromRawJson(String str) =>
      PriceInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PriceInfo.fromJson(Map<String, dynamic> json) => PriceInfo(
        price: json["price"]?.toDouble(),
        possibleExchange: json["possible_exchange"],
        credit: json["credit"],
      );

  Map<String, dynamic> toJson() => {
        "price": price,
        "possible_exchange": possibleExchange,
        "credit": credit,
      };
}
