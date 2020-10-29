// To parse this JSON data, do
//
//     final activityLevel = activityLevelFromJson(jsonString);

import 'dart:convert';

List<ActivityLevel> activityLevelFromJson(String str) => List<ActivityLevel>.from(json.decode(str).map((x) => ActivityLevel.fromJson(x)));

String activityLevelToJson(List<ActivityLevel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ActivityLevel {
  ActivityLevel({
    this.id,
    this.name,
    this.weighting,
  });

  int id;
  String name;
  double weighting;

  factory ActivityLevel.fromJson(Map<String, dynamic> json) => ActivityLevel(
    id: json["id"],
    name: json["name"],
    weighting: json["weighting"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "weighting": weighting,
  };
}
