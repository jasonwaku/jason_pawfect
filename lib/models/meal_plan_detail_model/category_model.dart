// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

List<CategoryModel> categoryModelFromJson(String str) => List<CategoryModel>.from(json.decode(str).map((x) => CategoryModel.fromJson(x)));

String categoryModelToJson(List<CategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel {
  CategoryModel({
    this.id,
    this.name,
    this.foods,
  });

  int id;
  String name;
  List<Food> foods;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json["id"],
    name: json["name"],
    foods: List<Food>.from(json["foods"].map((x) => Food.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
  };
}

class Food {
  Food({
    this.id,
    this.bonePercentage,
    this.calciumPhosphorousRatio,
    this.name,
    this.omegaRatio,
  });

  int id;
  double bonePercentage;
  double calciumPhosphorousRatio;
  String name;
  double omegaRatio;

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    id: json["id"],
    bonePercentage: json["bone_percentage"].toDouble(),
    calciumPhosphorousRatio: json["calcium_phosphorous_ratio"].toDouble(),
    name: json["name"],
    omegaRatio: json["omega_ratio"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bone_percentage": bonePercentage,
    "calcium_phosphorous_ratio": calciumPhosphorousRatio,
    "name": name,
    "omega_ratio": omegaRatio,
  };
}
