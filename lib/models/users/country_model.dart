// To parse this JSON data, do
//
//     final countryModel = countryModelFromJson(jsonString);

import 'dart:convert';

List<CountryModel> countryModelFromJson(String str) => List<CountryModel>.from(json.decode(str).map((x) => CountryModel.fromJson(x)));

String countryModelToJson(List<CountryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CountryModel {
  CountryModel({
    this.id,
    this.code,
    this.dial_code,
    this.name,
  });

  int id;
  String code;
  String dial_code;
  String name;

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
    id: json["id"],
    code: json["code"],
    dial_code: json["dial_code"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "dial_code": dial_code,
    "name": name,
  };
}

// // To parse this JSON data, do
// //
// //     final countryModel = countryModelFromJson(jsonString);
//
// import 'dart:convert';
//
// List<CountryModel> countryModelFromJson(String str) => List<CountryModel>.from(json.decode(str).map((x) => CountryModel.fromJson(x)));
//
// String countryModelToJson(List<CountryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// class CountryModel {
//   CountryModel({
//     this.id,
//     this.code,
//     this.countryId,
//     this.dialCode,
//     this.name,
//   });
//
//   int id;
//   String code;
//   String countryId;
//   String dialCode;
//   String name;
//
//   factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
//     id: json["id"],
//     code: json["code"],
//     countryId: json["country_id"],
//     dialCode: json["dial_code"],
//     name: json["name"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "code": code,
//     "country_id": countryId,
//     "dial_code": dialCode,
//     "name": name,
//   };
// }
