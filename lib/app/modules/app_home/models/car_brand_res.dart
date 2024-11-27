// To parse this JSON data, do
//
//     final carBrandRes = carBrandResFromJson(jsonString);

import 'dart:convert';

CarBrandRes carBrandResFromJson(String str) =>
    CarBrandRes.fromJson(json.decode(str));

String carBrandResToJson(CarBrandRes data) => json.encode(data.toJson());

class CarBrandRes {
  final List<BrandModel>? data;
  final bool? hasMore;

  CarBrandRes({
    this.data,
    this.hasMore,
  });

  CarBrandRes copyWith({
    List<BrandModel>? data,
    bool? hasMore,
  }) =>
      CarBrandRes(
        data: data ?? this.data,
        hasMore: hasMore ?? this.hasMore,
      );

  factory CarBrandRes.fromJson(Map<String, dynamic> json) => CarBrandRes(
        data: json["data"] == null
            ? []
            : List<BrandModel>.from(
                json["data"]!.map((x) => BrandModel.fromJson(x))),
        hasMore: json["has_more"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "has_more": hasMore,
      };
}

class BrandModel {
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? accessedAt;
  final String? brand;
  final List<CarModel>? model;

  BrandModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.accessedAt,
    this.brand,
    this.model,
  });

  BrandModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? accessedAt,
    String? brand,
    List<CarModel>? model,
  }) =>
      BrandModel(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        accessedAt: accessedAt ?? this.accessedAt,
        brand: brand ?? this.brand,
        model: model ?? this.model,
      );

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
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
        brand: json["brand"],
        model: json["model"] == null
            ? []
            : List<CarModel>.from(
                json["model"]!.map((x) => CarModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "accessed_at": accessedAt?.toIso8601String(),
        "brand": brand,
        "model": model == null
            ? []
            : List<dynamic>.from(model!.map((x) => x.toJson())),
      };
}

class CarModel {
  final String? name;
  final List<String>? modelClass;

  CarModel({
    this.name,
    this.modelClass,
  });

  CarModel copyWith({
    String? name,
    List<String>? modelClass,
  }) =>
      CarModel(
        name: name ?? this.name,
        modelClass: modelClass ?? this.modelClass,
      );

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
        name: json["name"],
        modelClass: json["class"] == null
            ? []
            : List<String>.from(json["class"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "class": modelClass == null
            ? []
            : List<dynamic>.from(modelClass!.map((x) => x)),
      };
}
