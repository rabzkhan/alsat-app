// To parse this JSON data, do
//
//     final proudctPostListRes = proudctPostListResFromJson(jsonString);

import 'dart:convert';

ProudctPostListRes proudctPostListResFromJson(String str) =>
    ProudctPostListRes.fromJson(json.decode(str));

String proudctPostListResToJson(ProudctPostListRes data) =>
    json.encode(data.toJson());

class ProudctPostListRes {
  final List<ProductModel>? data;
  final bool? hasMore;

  ProudctPostListRes({
    this.data,
    this.hasMore,
  });

  ProudctPostListRes copyWith({
    List<ProductModel>? data,
    bool? hasMore,
  }) =>
      ProudctPostListRes(
        data: data ?? this.data,
        hasMore: hasMore ?? this.hasMore,
      );

  factory ProudctPostListRes.fromJson(Map<String, dynamic> json) =>
      ProudctPostListRes(
        data: json["data"] == null
            ? []
            : List<ProductModel>.from(
                json["data"]!.map((x) => ProductModel.fromJson(x))),
        hasMore: json["has_more"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "has_more": hasMore,
      };
}

class ProductModel {
  final String? id;
  final String? createdAt;
  final DateTime? updatedAt;
  final DateTime? accessedAt;
  final String? title;
  final String? type;
  final String? categoryId;
  final String? description;
  final List<Media>? media;
  final IndividualInfo? individualInfo;
  final PriceInfo? priceInfo;
  final String? userId;
  final CarInfo? carInfo;
  final PhoneInfo? phoneInfo;
  final EstateInfo? estateInfo;
  final bool liked;

  ProductModel({
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
    this.userId,
    this.carInfo,
    this.phoneInfo,
    this.estateInfo,
    this.liked = false,
  });

  ProductModel copyWith({
    String? id,
    String? createdAt,
    DateTime? updatedAt,
    DateTime? accessedAt,
    String? title,
    String? type,
    String? categoryId,
    String? description,
    List<Media>? media,
    IndividualInfo? individualInfo,
    PriceInfo? priceInfo,
    String? userId,
    CarInfo? carInfo,
    PhoneInfo? phoneInfo,
    EstateInfo? estateInfo,
    bool? liked,
  }) =>
      ProductModel(
        id: id ?? this.id,
        liked: liked ?? this.liked,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        accessedAt: accessedAt ?? this.accessedAt,
        title: title ?? this.title,
        type: type ?? this.type,
        categoryId: categoryId ?? this.categoryId,
        description: description ?? this.description,
        media: media ?? this.media,
        individualInfo: individualInfo ?? this.individualInfo,
        priceInfo: priceInfo ?? this.priceInfo,
        userId: userId ?? this.userId,
        carInfo: carInfo ?? this.carInfo,
        phoneInfo: phoneInfo ?? this.phoneInfo,
        estateInfo: estateInfo ?? this.estateInfo,
      );

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["_id"],
        liked: json["liked"] ?? false,
        createdAt: json["created_at"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        accessedAt: json["accessed_at"] == null
            ? null
            : DateTime.parse(json["accessed_at"]),
        title: json["title"],
        type: json["type"],
        categoryId: json["category_id"],
        description: json["description"],
        media: json["media"] == null
            ? []
            : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
        individualInfo: json["individual_info"] == null
            ? null
            : IndividualInfo.fromJson(json["individual_info"]),
        priceInfo: json["price_info"] == null
            ? null
            : PriceInfo.fromJson(json["price_info"]),
        userId: json["user_id"],
        carInfo: json["car_info"] == null
            ? null
            : CarInfo.fromJson(json["car_info"]),
        phoneInfo: json["phone_info"] == null
            ? null
            : PhoneInfo.fromJson(json["phone_info"]),
        estateInfo: json["estate_info"] == null
            ? null
            : EstateInfo.fromJson(json["estate_info"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "liked": liked,
        "created_at": createdAt,
        "updated_at": updatedAt?.toIso8601String(),
        "accessed_at": accessedAt?.toIso8601String(),
        "title": title,
        "type": type,
        "category_id": categoryId,
        "description": description,
        "media": media == null
            ? []
            : List<dynamic>.from(media!.map((x) => x.toJson())),
        "individual_info": individualInfo?.toJson(),
        "price_info": priceInfo?.toJson(),
        "user_id": userId,
        "car_info": carInfo?.toJson(),
        "phone_info": phoneInfo?.toJson(),
        "estate_info": estateInfo?.toJson(),
      };
}

class CarInfo {
  final String? condition;
  final String? brand;
  final String? model;
  final String? carInfoClass;
  final String? bodyType;
  final String? transmission;
  final String? engineType;
  final int? passedKm;
  final int? year;
  final String? color;
  final String? vinCode;

  CarInfo({
    this.condition,
    this.brand,
    this.model,
    this.carInfoClass,
    this.bodyType,
    this.transmission,
    this.engineType,
    this.passedKm,
    this.year,
    this.color,
    this.vinCode,
  });

  CarInfo copyWith({
    String? condition,
    String? brand,
    String? model,
    String? carInfoClass,
    String? bodyType,
    String? transmission,
    String? engineType,
    int? passedKm,
    int? year,
    String? color,
    String? vinCode,
  }) =>
      CarInfo(
        condition: condition ?? this.condition,
        brand: brand ?? this.brand,
        model: model ?? this.model,
        carInfoClass: carInfoClass ?? this.carInfoClass,
        bodyType: bodyType ?? this.bodyType,
        transmission: transmission ?? this.transmission,
        engineType: engineType ?? this.engineType,
        passedKm: passedKm ?? this.passedKm,
        year: year ?? this.year,
        color: color ?? this.color,
        vinCode: vinCode ?? this.vinCode,
      );

  factory CarInfo.fromJson(Map<String, dynamic> json) => CarInfo(
        condition: json["condition"],
        brand: json["brand"],
        model: json["model"],
        carInfoClass: json["class"],
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
        "class": carInfoClass,
        "body_type": bodyType,
        "transmission": transmission,
        "engine_type": engineType,
        "passed_km": passedKm,
        "year": year,
        "color": color,
        "vin_code": vinCode,
      };
}

class EstateInfo {
  final String? type;
  final String? address;
  final String? dealType;
  final int? floor;
  final int? floorType;
  final int? room;
  final String? renov;
  final bool? lift;

  EstateInfo({
    this.type,
    this.address,
    this.dealType,
    this.floor,
    this.floorType,
    this.room,
    this.renov,
    this.lift,
  });

  EstateInfo copyWith({
    String? type,
    String? address,
    String? dealType,
    int? floor,
    int? floorType,
    int? room,
    String? renov,
    bool? lift,
  }) =>
      EstateInfo(
        type: type ?? this.type,
        address: address ?? this.address,
        dealType: dealType ?? this.dealType,
        floor: floor ?? this.floor,
        floorType: floorType ?? this.floorType,
        room: room ?? this.room,
        renov: renov ?? this.renov,
        lift: lift ?? this.lift,
      );

  factory EstateInfo.fromJson(Map<String, dynamic> json) => EstateInfo(
        type: json["type"],
        address: json["address"],
        dealType: json["deal_type"],
        floor: json["floor"],
        floorType: json["floor_type"],
        room: json["room"],
        renov: json["renov"],
        lift: json["lift"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "address": address,
        "deal_type": dealType,
        "floor": floor,
        "floor_type": floorType,
        "room": room,
        "renov": renov,
        "lift": lift,
      };
}

class IndividualInfo {
  final String? locationProvince;
  final String? locationCity;
  final LocationGeo? locationGeo;
  final String? phoneNumber;
  final String? freeToCallFrom;
  final String? freeToCallTo;
  final bool? allowToCall;
  final bool? contactOnlyInChat;
  final bool? canComment;

  IndividualInfo({
    this.locationProvince,
    this.locationCity,
    this.locationGeo,
    this.phoneNumber,
    this.freeToCallFrom,
    this.freeToCallTo,
    this.allowToCall,
    this.contactOnlyInChat,
    this.canComment,
  });

  IndividualInfo copyWith({
    String? locationProvince,
    String? locationCity,
    LocationGeo? locationGeo,
    String? phoneNumber,
    String? freeToCallFrom,
    String? freeToCallTo,
    bool? allowToCall,
    bool? contactOnlyInChat,
    bool? canComment,
  }) =>
      IndividualInfo(
        locationProvince: locationProvince ?? this.locationProvince,
        locationCity: locationCity ?? this.locationCity,
        locationGeo: locationGeo ?? this.locationGeo,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        freeToCallFrom: freeToCallFrom ?? this.freeToCallFrom,
        freeToCallTo: freeToCallTo ?? this.freeToCallTo,
        allowToCall: allowToCall ?? this.allowToCall,
        contactOnlyInChat: contactOnlyInChat ?? this.contactOnlyInChat,
        canComment: canComment ?? this.canComment,
      );

  factory IndividualInfo.fromJson(Map<String, dynamic> json) => IndividualInfo(
        locationProvince: json["location_province"],
        locationCity: json["location_city"],
        locationGeo: json["location_geo"] == null
            ? null
            : LocationGeo.fromJson(json["location_geo"]),
        phoneNumber: json["phone_number"],
        freeToCallFrom: json["free_to_call_from"],
        freeToCallTo: json["free_to_call_to"],
        allowToCall: json["allow_to_call"],
        contactOnlyInChat: json["contact_only_in_chat"],
        canComment: json["can_comment"],
      );

  Map<String, dynamic> toJson() => {
        "location_province": locationProvince,
        "location_city": locationCity,
        "location_geo": locationGeo?.toJson(),
        "phone_number": phoneNumber,
        "free_to_call_from": freeToCallFrom,
        "free_to_call_to": freeToCallTo,
        "allow_to_call": allowToCall,
        "contact_only_in_chat": contactOnlyInChat,
        "can_comment": canComment,
      };
}

class LocationGeo {
  final String? type;
  final List<double>? coordinates;

  LocationGeo({
    this.type,
    this.coordinates,
  });

  LocationGeo copyWith({
    String? type,
    List<double>? coordinates,
  }) =>
      LocationGeo(
        type: type ?? this.type,
        coordinates: coordinates ?? this.coordinates,
      );

  factory LocationGeo.fromJson(Map<String, dynamic> json) => LocationGeo(
        type: json["Type"],
        coordinates: json["Coordinates"] == null
            ? []
            : List<double>.from(json["Coordinates"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "Type": type,
        "Coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
      };
}

class Media {
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? accessedAt;
  final String? name;
  final String? type;
  final int? size;
  final String? hash;
  final String? contentType;

  Media({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.accessedAt,
    this.name,
    this.type,
    this.size,
    this.hash,
    this.contentType,
  });

  Media copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? accessedAt,
    String? name,
    String? type,
    int? size,
    String? hash,
    String? contentType,
  }) =>
      Media(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        accessedAt: accessedAt ?? this.accessedAt,
        name: name ?? this.name,
        type: type ?? this.type,
        size: size ?? this.size,
        hash: hash ?? this.hash,
        contentType: contentType ?? this.contentType,
      );

  factory Media.fromJson(Map<String, dynamic> json) => Media(
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
        name: json["name"],
        type: json["type"],
        size: json["size"],
        hash: json["hash"],
        contentType: json["content_type"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "accessed_at": accessedAt?.toIso8601String(),
        "name": name,
        "type": type,
        "size": size,
        "hash": hash,
        "content_type": contentType,
      };
}

class PhoneInfo {
  final String? brand;

  PhoneInfo({
    this.brand,
  });

  PhoneInfo copyWith({
    String? brand,
  }) =>
      PhoneInfo(
        brand: brand ?? this.brand,
      );

  factory PhoneInfo.fromJson(Map<String, dynamic> json) => PhoneInfo(
        brand: json["brand"],
      );

  Map<String, dynamic> toJson() => {
        "brand": brand,
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

  PriceInfo copyWith({
    double? price,
    bool? possibleExchange,
    bool? credit,
  }) =>
      PriceInfo(
        price: price ?? this.price,
        possibleExchange: possibleExchange ?? this.possibleExchange,
        credit: credit ?? this.credit,
      );

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
