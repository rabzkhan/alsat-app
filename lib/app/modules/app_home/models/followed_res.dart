// To parse this JSON data, do
//
//     final followedRes = followedResFromJson(jsonString);

import 'dart:convert';

FollowedRes followedResFromJson(String str) =>
    FollowedRes.fromJson(json.decode(str));

String followedResToJson(FollowedRes data) => json.encode(data.toJson());

class FollowedRes {
  final List<Datum>? data;
  final bool? hasMore;

  FollowedRes({
    this.data,
    this.hasMore,
  });

  FollowedRes copyWith({
    List<Datum>? data,
    bool? hasMore,
  }) =>
      FollowedRes(
        data: data ?? this.data,
        hasMore: hasMore ?? this.hasMore,
      );

  factory FollowedRes.fromJson(Map<String, dynamic> json) => FollowedRes(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        hasMore: json["has_more"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "has_more": hasMore,
      };
}

class Datum {
  final Followed? followed;
  final DateTime? followedAt;

  Datum({
    this.followed,
    this.followedAt,
  });

  Datum copyWith({
    Followed? followed,
    DateTime? followedAt,
  }) =>
      Datum(
        followed: followed ?? this.followed,
        followedAt: followedAt ?? this.followedAt,
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        followed: json["followed"] == null
            ? null
            : Followed.fromJson(json["followed"]),
        followedAt: json["followed_at"] == null
            ? null
            : DateTime.parse(json["followed_at"]),
      );

  Map<String, dynamic> toJson() => {
        "followed": followed?.toJson(),
        "followed_at": followedAt?.toIso8601String(),
      };
}

class Followed {
  final String? id;
  final String? userName;
  final String? picture;

  Followed({
    this.id,
    this.userName,
    this.picture,
  });

  Followed copyWith({
    String? id,
    String? userName,
    String? picture,
  }) =>
      Followed(
        id: id ?? this.id,
        userName: userName ?? this.userName,
        picture: picture ?? this.picture,
      );

  factory Followed.fromJson(Map<String, dynamic> json) => Followed(
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
