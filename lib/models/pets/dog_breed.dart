// To parse this JSON data, do
//
//     final dogBreed = dogBreedFromJson(jsonString);

import 'dart:convert';

List<DogBreed> dogBreedFromJson(String str) => List<DogBreed>.from(json.decode(str).map((x) => DogBreed.fromJson(x)));

String dogBreedToJson(List<DogBreed> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DogBreed {
  DogBreed({
    this.id,
    this.giant,
    this.name,
  });

  int id;
  dynamic giant;
  String name;

  factory DogBreed.fromJson(Map<String, dynamic> json) => DogBreed(
    id: json["id"],
    giant: json["giant"].toString(),
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "giant": giant,
    "name": name,
  };
}