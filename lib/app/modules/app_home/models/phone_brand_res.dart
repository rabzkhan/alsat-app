// To parse this JSON data, do
//
//     final phoneBrandRes = phoneBrandResFromJson(jsonString);

import 'dart:convert';

PhoneBrandRes phoneBrandResFromJson(String str) => PhoneBrandRes.fromJson(json.decode(str));

String phoneBrandResToJson(PhoneBrandRes data) => json.encode(data.toJson());

class PhoneBrandRes {
  List<PhoneBrand>? data;
  bool? hasMore;

  PhoneBrandRes({
    this.data,
    this.hasMore,
  });

  factory PhoneBrandRes.fromJson(Map<String, dynamic> json) => PhoneBrandRes(
        data: json["data"] == null ? [] : List<PhoneBrand>.from(json["data"]!.map((x) => PhoneBrand.fromJson(x))),
        hasMore: json["has_more"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "has_more": hasMore,
      };
}

class PhoneBrand {
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? accessedAt;
  String? brand;

  PhoneBrand({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.accessedAt,
    this.brand,
  });

  factory PhoneBrand.fromJson(Map<String, dynamic> json) => PhoneBrand(
        id: json["_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        accessedAt: json["accessed_at"] == null ? null : DateTime.parse(json["accessed_at"]),
        brand: json["brand"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "accessed_at": accessedAt?.toIso8601String(),
        "brand": brand,
      };
}
