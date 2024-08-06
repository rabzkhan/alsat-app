// To parse this JSON data, do
//
//     final itemModel = itemModelFromJson(jsonString);

import 'dart:convert';

List<ItemModel> itemModelFromJson(String str) =>
    List<ItemModel>.from(json.decode(str).map((x) => ItemModel.fromJson(x)));

String itemModelToJson(List<ItemModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemModel {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? accessedAt;
  String? title;
  String? type;
  String? categoryId;
  String? description;
  List<Media>? media;
  IndividualInfo? individualInfo;
  PriceInfo? priceInfo;
  CarInfo? carInfo;

  ItemModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.accessedAt,
    this.title,
    this.type,
    this.categoryId,
    this.description,
    this.media,
    this.individualInfo,
    this.priceInfo,
    this.carInfo,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        id: json["_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        accessedAt: json["accessed_at"],
        title: json["title"],
        type: json["type"],
        categoryId: json["category_id"],
        description: json["description"],
        media: json["media"] == null ? [] : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
        individualInfo: json["individual_info"] == null ? null : IndividualInfo.fromJson(json["individual_info"]),
        priceInfo: json["price_info"] == null ? null : PriceInfo.fromJson(json["price_info"]),
        carInfo: json["car_info"] == null ? null : CarInfo.fromJson(json["car_info"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "accessed_at": accessedAt,
        "title": title,
        "type": type,
        "category_id": categoryId,
        "description": description,
        "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x.toJson())),
        "individual_info": individualInfo?.toJson(),
        "price_info": priceInfo?.toJson(),
        "car_info": carInfo?.toJson(),
      };
}

class CarInfo {
  String? condition;
  String? brand;
  String? model;
  String? bodyType;
  String? transmission;
  String? engineType;
  int? passedKm;
  int? year;
  String? color;
  String? vinCode;

  CarInfo({
    this.condition,
    this.brand,
    this.model,
    this.bodyType,
    this.transmission,
    this.engineType,
    this.passedKm,
    this.year,
    this.color,
    this.vinCode,
  });

  factory CarInfo.fromJson(Map<String, dynamic> json) => CarInfo(
        condition: json["condition"],
        brand: json["brand"],
        model: json["model"],
        bodyType: json["body_type"],
        transmission: json["transmission"],
        engineType: json["engine_type"],
        passedKm: json["passed_km"],
        year: json["year"],
        color: json["color"],
        vinCode: json["vin_code"],
      );

  Map<String, dynamic> toJson() => {
        "condition": condition,
        "brand": brand,
        "model": model,
        "body_type": bodyType,
        "transmission": transmission,
        "engine_type": engineType,
        "passed_km": passedKm,
        "year": year,
        "color": color,
        "vin_code": vinCode,
      };
}

class IndividualInfo {
  String? location;
  String? phoneNumber;
  String? freeToCallFrom;
  String? freeToCallTo;
  bool? allowToCall;
  bool? contactOnlyInChat;

  IndividualInfo({
    this.location,
    this.phoneNumber,
    this.freeToCallFrom,
    this.freeToCallTo,
    this.allowToCall,
    this.contactOnlyInChat,
  });

  factory IndividualInfo.fromJson(Map<String, dynamic> json) => IndividualInfo(
        location: json["location"],
        phoneNumber: json["phone_number"],
        freeToCallFrom: json["free_to_call_from"],
        freeToCallTo: json["free_to_call_to"],
        allowToCall: json["allow_to_call"],
        contactOnlyInChat: json["contact_only_in_chat"],
      );

  Map<String, dynamic> toJson() => {
        "location": location,
        "phone_number": phoneNumber,
        "free_to_call_from": freeToCallFrom,
        "free_to_call_to": freeToCallTo,
        "allow_to_call": allowToCall,
        "contact_only_in_chat": contactOnlyInChat,
      };
}

class Media {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? accessedAt;
  String? name;
  String? type;
  int? size;
  String? hash;

  Media({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.accessedAt,
    this.name,
    this.type,
    this.size,
    this.hash,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        id: json["_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        accessedAt: json["accessed_at"],
        name: json["name"],
        type: json["type"],
        size: json["size"],
        hash: json["hash"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "accessed_at": accessedAt,
        "name": name,
        "type": type,
        "size": size,
        "hash": hash,
      };
}

class PriceInfo {
  double? price;
  bool? possibleExchange;
  bool? credit;

  PriceInfo({
    this.price,
    this.possibleExchange,
    this.credit,
  });

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
