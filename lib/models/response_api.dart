// To parse this JSON data, do
//
//     final responseApi = responseApiFromJson(jsonString);

import 'dart:convert';

ResponseApi responseApiFromJson(String str) => ResponseApi.fromJson(json.decode(str));

String responseApiToJson(ResponseApi data) => json.encode(data.toJson());

class ResponseApi {
  ResponseApi({
    this.message,
    this.status,
    this.success,
  });

  String message;
  String status;
  bool success;

  factory ResponseApi.fromJson(Map<String, dynamic> json) => ResponseApi(
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