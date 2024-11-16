// To parse this JSON data, do
//
//     final proudctPostCommentRes = proudctPostCommentResFromJson(jsonString);

import 'dart:convert';

ProudctPostCommentRes proudctPostCommentResFromJson(String str) =>
    ProudctPostCommentRes.fromJson(json.decode(str));

String proudctPostCommentResToJson(ProudctPostCommentRes data) =>
    json.encode(data.toJson());

class ProudctPostCommentRes {
  final List<CommentModel>? data;
  final bool? hasMore;

  ProudctPostCommentRes({
    this.data,
    this.hasMore,
  });

  ProudctPostCommentRes copyWith({
    List<CommentModel>? data,
    bool? hasMore,
  }) =>
      ProudctPostCommentRes(
        data: data ?? this.data,
        hasMore: hasMore ?? this.hasMore,
      );

  factory ProudctPostCommentRes.fromJson(Map<String, dynamic> json) =>
      ProudctPostCommentRes(
        data: json["data"] == null
            ? []
            : List<CommentModel>.from(
                json["data"]!.map((x) => CommentModel.fromJson(x))),
        hasMore: json["has_more"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "has_more": hasMore,
      };
}

class CommentModel {
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? accessedAt;
  final User? user;
  final String? content;

  CommentModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.accessedAt,
    this.user,
    this.content,
  });

  CommentModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? accessedAt,
    User? user,
    String? content,
  }) =>
      CommentModel(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        accessedAt: accessedAt ?? this.accessedAt,
        user: user ?? this.user,
        content: content ?? this.content,
      );

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
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
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "accessed_at": accessedAt?.toIso8601String(),
        "user": user?.toJson(),
        "content": content,
      };
}

class User {
  final String? id;
  final String? userName;
  final String? picture;

  User({
    this.id,
    this.userName,
    this.picture,
  });

  User copyWith({
    String? id,
    String? userName,
    String? picture,
  }) =>
      User(
        id: id ?? this.id,
        userName: userName ?? this.userName,
        picture: picture ?? this.picture,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
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
