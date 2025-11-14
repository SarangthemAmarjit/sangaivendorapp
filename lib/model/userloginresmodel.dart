// To parse this JSON data, do
//
//     final userloginresponsemodel = userloginresponsemodelFromJson(jsonString);

import 'dart:convert';

Userloginresponsemodel userloginresponsemodelFromJson(String str) =>
    Userloginresponsemodel.fromJson(json.decode(str));

String userloginresponsemodelToJson(Userloginresponsemodel data) =>
    json.encode(data.toJson());

class Userloginresponsemodel {
  final String message;
  final int userId;
  final String fullName;
  final String username;
  final String role;

  Userloginresponsemodel({
    required this.message,
    required this.userId,
    required this.fullName,
    required this.username,
    required this.role,
  });

  factory Userloginresponsemodel.fromJson(Map<String, dynamic> json) =>
      Userloginresponsemodel(
        message: json["message"],
        userId: json["UserId"],
        fullName: json["FullName"],
        username: json["Username"],
        role: json["Role"],
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "UserId": userId,
    "FullName": fullName,
    "Username": username,
    "Role": role,
  };
}
