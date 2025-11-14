// To parse this JSON data, do
//
//     final userresponsemodel = userresponsemodelFromJson(jsonString);

import 'dart:convert';

Userresponsemodel userresponsemodelFromJson(String str) =>
    Userresponsemodel.fromJson(json.decode(str));

String userresponsemodelToJson(Userresponsemodel data) =>
    json.encode(data.toJson());

class Userresponsemodel {
  final int userId;
  final String fullName;
  final String username;
  final String role;

  Userresponsemodel({
    required this.userId,
    required this.fullName,
    required this.username,
    required this.role,
  });

  factory Userresponsemodel.fromJson(Map<String, dynamic> json) =>
      Userresponsemodel(
        userId: json["UserId"],
        fullName: json["FullName"],
        username: json["Username"],
        role: json["Role"],
      );

  Map<String, dynamic> toJson() => {
    "UserId": userId,
    "FullName": fullName,
    "Username": username,
    "Role": role,
  };
}
