// To parse this JSON data, do
//
//     final varifiedModel = varifiedModelFromJson(jsonString);

import 'dart:convert';

VerifiedModel varifiedModelFromJson(String str) =>
    VerifiedModel.fromJson(json.decode(str));

String varifiedModelToJson(VerifiedModel data) => json.encode(data.toJson());

class VerifiedModel {
  User? user;
  String? token;
  String? refreshToken;
  int? expiry;

  VerifiedModel({
    this.user,
    this.token,
    this.refreshToken,
    this.expiry,
  });

  factory VerifiedModel.fromJson(Map<String, dynamic> json) => VerifiedModel(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        token: json["token"],
        refreshToken: json["refresh_token"],
        expiry: json["expiry"],
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "token": token,
        "refresh_token": refreshToken,
        "expiry": expiry,
      };
}

class User {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? accessedAt;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  List<String>? capabilities;
  bool? active;

  User({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.accessedAt,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.capabilities,
    this.active,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        accessedAt: json["accessed_at"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phone: json["phone"],
        email: json["email"],
        capabilities: json["capabilities"] == null
            ? []
            : List<String>.from(json["capabilities"]!.map((x) => x)),
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "accessed_at": accessedAt,
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "email": email,
        "capabilities": capabilities == null
            ? []
            : List<dynamic>.from(capabilities!.map((x) => x)),
        "active": active,
      };
}
