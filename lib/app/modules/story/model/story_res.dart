// To parse this JSON data, do
//
//     final storyModel = storyModelFromJson(jsonString);

import 'dart:convert';

List<StoryModel> storyModelFromJson(String str) =>
    List<StoryModel>.from(json.decode(str).map((x) => StoryModel.fromJson(x)));

String storyModelToJson(List<StoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoryModel {
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? accessedAt;
  final Media? media;

  StoryModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.accessedAt,
    this.media,
  });

  StoryModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? accessedAt,
    Media? media,
  }) =>
      StoryModel(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        accessedAt: accessedAt ?? this.accessedAt,
        media: media ?? this.media,
      );

  factory StoryModel.fromJson(Map<String, dynamic> json) => StoryModel(
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
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "accessed_at": accessedAt?.toIso8601String(),
        "media": media?.toJson(),
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
