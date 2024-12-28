// To parse this JSON data, do
//
//     final allUserInformationRes = allUserInformationResFromJson(jsonString);

import 'dart:convert';

import 'user_data_model.dart';

AllUserInformationRes allUserInformationResFromJson(String str) =>
    AllUserInformationRes.fromJson(json.decode(str));

String allUserInformationResToJson(AllUserInformationRes data) =>
    json.encode(data.toJson());

class AllUserInformationRes {
  final Data? data;
  final bool? hasMore;

  AllUserInformationRes({
    this.data,
    this.hasMore,
  });

  factory AllUserInformationRes.fromJson(Map<String, dynamic> json) =>
      AllUserInformationRes(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        hasMore: json["has_more"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "has_more": hasMore,
      };
}

class Data {
  final List<UserDataModel>? users;
  final int? premiumCount;
  final int? ordinaryCount;
  final int? totalCount;

  Data({
    this.users,
    this.premiumCount,
    this.ordinaryCount,
    this.totalCount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        users: json["users"] == null
            ? []
            : List<UserDataModel>.from(
                json["users"]!.map((x) => UserDataModel.fromJson(x))),
        premiumCount: json["premium_count"],
        ordinaryCount: json["ordinary_count"],
        totalCount: json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "users": users == null
            ? []
            : List<dynamic>.from(users!.map((x) => x.toJson())),
        "premium_count": premiumCount,
        "ordinary_count": ordinaryCount,
        "total_count": totalCount,
      };
}
