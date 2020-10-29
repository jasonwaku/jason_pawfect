// To parse this JSON data, do
//
//     final dailyGuideModel = dailyGuideModelFromJson(jsonString);

import 'dart:convert';

List<DailyGuideModel> dailyGuideModelFromJson(String str) => List<DailyGuideModel>.from(json.decode(str).map((x) => DailyGuideModel.fromJson(x)));

String dailyGuideModelToJson(List<DailyGuideModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DailyGuideModel {
  DailyGuideModel({
    this.id,
    this.name,
    this.nutrientGuidelines,
    this.dailyAllowanceGuidelines,
  });

  int id;
  String name;
  List<NutrientGuideline> nutrientGuidelines;
  List<DailyAllowanceGuideline> dailyAllowanceGuidelines;

  factory DailyGuideModel.fromJson(Map<String, dynamic> json) => DailyGuideModel(
    id: json["id"],
    name: json["name"],
    nutrientGuidelines: List<NutrientGuideline>.from(json["nutrient_guidelines"].map((x) => NutrientGuideline.fromJson(x))),
    dailyAllowanceGuidelines: List<DailyAllowanceGuideline>.from(json["daily_allowance_guidelines"].map((x) => DailyAllowanceGuideline.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "nutrient_guidelines": List<dynamic>.from(nutrientGuidelines.map((x) => x.toJson())),
    "daily_allowance_guidelines": List<dynamic>.from(dailyAllowanceGuidelines.map((x) => x.toJson())),
  };
}

class DailyAllowanceGuideline {
  DailyAllowanceGuideline({
    this.id,
    this.percentage,
    this.dailyAllowanceType,
  });

  int id;
  double percentage;
  DailyAllowanceType dailyAllowanceType;

  factory DailyAllowanceGuideline.fromJson(Map<String, dynamic> json) => DailyAllowanceGuideline(
    id: json["id"],
    percentage: json["percentage"].toDouble(),
    dailyAllowanceType: DailyAllowanceType.fromJson(json["daily_allowance_type"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "percentage": percentage,
    "daily_allowance_type": dailyAllowanceType.toJson(),
  };
}

class DailyAllowanceType {
  DailyAllowanceType({
    this.id,
    this.hasBones,
    this.name,
  });

  int id;
  bool hasBones;
  String name;

  factory DailyAllowanceType.fromJson(Map<String, dynamic> json) => DailyAllowanceType(
    id: json["id"],
    hasBones: json["has_bones"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "has_bones": hasBones,
    "name": name,
  };
}

class NutrientGuideline {
  NutrientGuideline({
    this.id,
    this.amount,
    this.imperialAmount,
    this.unit,
    this.nutrient,
  });

  int id;
  double amount;
  double imperialAmount;
  Unit unit;
  Nutrient nutrient;

  factory NutrientGuideline.fromJson(Map<String, dynamic> json) => NutrientGuideline(
    id: json["id"],
    amount: json["amount"].toDouble(),
    imperialAmount: json["imperial_amount"] == null ? null : json["imperial_amount"].toDouble(),
    unit: unitValues.map[json["unit"]],
    nutrient: Nutrient.fromJson(json["nutrient"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "imperial_amount": imperialAmount == null ? null : imperialAmount,
    "unit": unitValues.reverse[unit],
    "nutrient": nutrient.toJson(),
  };
}

class Nutrient {
  Nutrient({
    this.id,
    this.category,
    this.name,
  });

  int id;
  Category category;
  String name;

  factory Nutrient.fromJson(Map<String, dynamic> json) => Nutrient(
    id: json["id"],
    category: categoryValues.map[json["category"]],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category": categoryValues.reverse[category],
    "name": name,
  };
}

enum Category { MACRO, MICRO }

final categoryValues = EnumValues({
  "macro": Category.MACRO,
  "micro": Category.MICRO
});

enum Unit { G, RATIO, MG, MCG }

final unitValues = EnumValues({
  "g": Unit.G,
  "mcg": Unit.MCG,
  "mg": Unit.MG,
  "ratio": Unit.RATIO
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}