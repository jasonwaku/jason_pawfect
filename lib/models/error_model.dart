// To parse this JSON data, do
//
//     final errorModel = errorModelFromJson(jsonString);

import 'dart:convert';

ErrorModel errorModelFromJson(String str) => ErrorModel.fromJson(json.decode(str));

String errorModelToJson(ErrorModel data) => json.encode(data.toJson());

class ErrorModel {
  ErrorModel({
    this.message,
    this.status,
    this.success,
  });

  String message;
  String status;
  bool success;

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
    message: json["message"],
    status: json["status"],
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "success": success,
  };
}