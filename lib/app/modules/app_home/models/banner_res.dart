import 'dart:convert';

class BannerRes {
  List<BannerModel>? data;
  bool? hasMore;

  BannerRes({
    this.data,
    this.hasMore,
  });

  factory BannerRes.fromRawJson(String str) =>
      BannerRes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BannerRes.fromJson(Map<String, dynamic> json) => BannerRes(
        data: json["data"] == null
            ? []
            : List<BannerModel>.from(
                json["data"]!.map((x) => BannerModel.fromJson(x))),
        hasMore: json["has_more"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "has_more": hasMore,
      };
}

class BannerModel {
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? accessedAt;
  Media? media;
  bool? main;
  Location? location;
  String? entityId;
  String? type;

  BannerModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.accessedAt,
    this.media,
    this.main,
    this.location,
    this.entityId,
    this.type,
  });

  factory BannerModel.fromRawJson(String str) =>
      BannerModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
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
        media: json["media"] == null ? null : Media.fromJson(json["media"]),
        main: json["main"],
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        entityId: json["entity_id"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "accessed_at": accessedAt?.toIso8601String(),
        "media": media?.toJson(),
        "main": main,
        "location": location?.toJson(),
        "entity_id": entityId,
        "type": type,
      };
}

class Location {
  String? province;
  String? city;
  Geo? geo;

  Location({
    this.province,
    this.city,
    this.geo,
  });

  factory Location.fromRawJson(String str) =>
      Location.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        province: json["province"],
        city: json["city"],
        geo: json["geo"] == null ? null : Geo.fromJson(json["geo"]),
      );

  Map<String, dynamic> toJson() => {
        "province": province,
        "city": city,
        "geo": geo?.toJson(),
      };
}

class Geo {
  String? type;
  List<int>? coordinates;

  Geo({
    this.type,
    this.coordinates,
  });

  factory Geo.fromRawJson(String str) => Geo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Geo.fromJson(Map<String, dynamic> json) => Geo(
        type: json["Type"],
        coordinates: json["Coordinates"] == null
            ? []
            : List<int>.from(json["Coordinates"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Type": type,
        "Coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
      };
}

class Media {
  String? name;
  String? type;

  Media({
    this.name,
    this.type,
  });

  factory Media.fromRawJson(String str) => Media.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        name: json["name"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
      };
}
