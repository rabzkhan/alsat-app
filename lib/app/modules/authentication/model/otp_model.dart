// To parse this JSON data, do
//
//     final otpModel = otpModelFromJson(jsonString);

import 'dart:convert';

OtpModel otpModelFromJson(String str) => OtpModel.fromJson(json.decode(str));

String otpModelToJson(OtpModel data) => json.encode(data.toJson());

class OtpModel {
  String? phone;
  String? otp;
  String? sms;

  OtpModel({
    this.phone,
    this.otp,
    this.sms,
  });

  factory OtpModel.fromJson(Map<String, dynamic> json) => OtpModel(
        phone: json["phone"],
        otp: json["otp"],
        sms: json["sms"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "otp": otp,
        "sms": sms,
      };
}
