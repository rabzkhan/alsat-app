// To parse this JSON data, do
//
//     final userDataModel = userDataModelFromJson(jsonString);

import 'dart:convert';

UserDataModel userDataModelFromJson(String str) =>
    UserDataModel.fromJson(json.decode(str));

String userDataModelToJson(UserDataModel data) => json.encode(data.toJson());

class UserDataModel {
  String? id;

  List<dynamic>? messaging;
  String? picture;
  Location? location;
  String? phone;
  String? userName;
  List<dynamic>? categories;
  String? plan;
  bool? active;
  String? email;
  num? rating;
  num? votes;
  bool? requestDeletion;

  UserDataModel({
    this.id,
    this.messaging,
    this.picture,
    this.location,
    this.phone,
    this.userName,
    this.categories,
    this.plan,
    this.active,
    this.email,
    this.rating,
    this.votes,
    this.requestDeletion,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
        id: json["_id"],
        messaging: json["messaging"] == null
            ? []
            : List<dynamic>.from(json["messaging"]!.map((x) => x)),
        picture: json["picture"],
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        phone: json["phone"],
        userName: json["user_name"],
        categories: json["categories"] == null
            ? []
            : List<dynamic>.from(json["categories"]!.map((x) => x)),
        plan: json["plan"],
        active: json["active"],
        email: json["email"],
        rating: json["rating"],
        votes: json["votes"],
        requestDeletion: json["request_deletion"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "messaging": messaging == null
            ? []
            : List<dynamic>.from(messaging!.map((x) => x)),
        "picture": picture,
        "location": location?.toJson(),
        "phone": phone,
        "user_name": userName,
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x)),
        "plan": plan,
        "active": active,
        "email": email,
        "rating": rating,
        "votes": votes,
        "request_deletion": requestDeletion,
      };
}

class Location {
  String? province;
  String? city;

  Location({
    this.province,
    this.city,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        province: json["province"],
        city: json["city"],
      );

  Map<String, dynamic> toJson() => {
        "province": province,
        "city": city,
      };
}
