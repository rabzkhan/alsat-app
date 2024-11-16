// To parse this JSON data, do
//
//     final followerRes = followerResFromJson(jsonString);

import 'dart:convert';

FollowerRes followerResFromJson(String str) =>
    FollowerRes.fromJson(json.decode(str));

String followerResToJson(FollowerRes data) => json.encode(data.toJson());

class FollowerRes {
  final List<Datum>? data;
  final bool? hasMore;

  FollowerRes({
    this.data,
    this.hasMore,
  });

  FollowerRes copyWith({
    List<Datum>? data,
    bool? hasMore,
  }) =>
      FollowerRes(
        data: data ?? this.data,
        hasMore: hasMore ?? this.hasMore,
      );

  factory FollowerRes.fromJson(Map<String, dynamic> json) => FollowerRes(
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
  final Follower? follower;
  final DateTime? followedAt;

  Datum({
    this.follower,
    this.followedAt,
  });

  Datum copyWith({
    Follower? follower,
    DateTime? followedAt,
  }) =>
      Datum(
        follower: follower ?? this.follower,
        followedAt: followedAt ?? this.followedAt,
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        follower: json["follower"] == null
            ? null
            : Follower.fromJson(json["follower"]),
        followedAt: json["followed_at"] == null
            ? null
            : DateTime.parse(json["followed_at"]),
      );

  Map<String, dynamic> toJson() => {
        "follower": follower?.toJson(),
        "followed_at": followedAt?.toIso8601String(),
      };
}

class Follower {
  final String? id;
  final String? userName;
  final String? picture;

  Follower({
    this.id,
    this.userName,
    this.picture,
  });

  Follower copyWith({
    String? id,
    String? userName,
    String? picture,
  }) =>
      Follower(
        id: id ?? this.id,
        userName: userName ?? this.userName,
        picture: picture ?? this.picture,
      );

  factory Follower.fromJson(Map<String, dynamic> json) => Follower(
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
