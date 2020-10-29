// To parse this JSON data, do
//
//     final mealPlanDetailModel = mealPlanDetailModelFromJson(jsonString);

import 'dart:convert';

MealPlanDetailModel mealPlanDetailModelFromJson(String str) => MealPlanDetailModel.fromJson(json.decode(str));

String mealPlanDetailModelToJson(MealPlanDetailModel data) => json.encode(data.toJson());

class MealPlanDetailModel {
  MealPlanDetailModel({
    this.success,
    this.feedingPlanDetail,
  });

  bool success;
  FeedingPlanDetail feedingPlanDetail;

  factory MealPlanDetailModel.fromJson(Map<String, dynamic> json) => MealPlanDetailModel(
    success: json["success"],
    feedingPlanDetail: FeedingPlanDetail.fromJson(json["feeding_plan_detail"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "feeding_plan_detail": feedingPlanDetail.toJson(),
  };
}

class FeedingPlanDetail {
  FeedingPlanDetail({
    this.id,
    this.imperialQuantity,
    this.quantity,
    this.food,
  });

  int id;
  double imperialQuantity;
  double quantity;
  Food food;

  factory FeedingPlanDetail.fromJson(Map<String, dynamic> json) => FeedingPlanDetail(
    id: json["id"],
    imperialQuantity: json["imperial_quantity"].toDouble(),
    quantity: json["quantity"].toDouble(),
    food: Food.fromJson(json["food"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "imperial_quantity": imperialQuantity,
    "quantity": quantity,
    "food": food.toJson(),
  };
}

class Food {
  Food({
    this.id,
    this.creatorId,
    this.updaterId,
    this.deleterId,
    this.deletedAt,
    this.bonePercentage,
    this.dailyAllowanceTypeId,
    this.foodCategoryId,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  dynamic creatorId;
  dynamic updaterId;
  dynamic deleterId;
  dynamic deletedAt;
  double bonePercentage;
  int dailyAllowanceTypeId;
  int foodCategoryId;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    id: json["id"],
    creatorId: json["creator_id"],
    updaterId: json["updater_id"],
    deleterId: json["deleter_id"],
    deletedAt: json["deleted_at"],
    bonePercentage: json["bone_percentage"].toDouble(),
    dailyAllowanceTypeId: json["daily_allowance_type_id"],
    foodCategoryId: json["food_category_id"],
    name: json["name"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "creator_id": creatorId,
    "updater_id": updaterId,
    "deleter_id": deleterId,
    "deleted_at": deletedAt,
    "bone_percentage": bonePercentage,
    "daily_allowance_type_id": dailyAllowanceTypeId,
    "food_category_id": foodCategoryId,
    "name": name,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
