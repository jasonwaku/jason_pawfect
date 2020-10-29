// To parse this JSON data, do
//
//     final cloneMealPlanModel = cloneMealPlanModelFromJson(jsonString);

import 'dart:convert';

CloneMealPlanModel cloneMealPlanModelFromJson(String str) => CloneMealPlanModel.fromJson(json.decode(str));

String cloneMealPlanModelToJson(CloneMealPlanModel data) => json.encode(data.toJson());

class CloneMealPlanModel {
  CloneMealPlanModel({
    this.id,
    this.dailyAllowanceActualPercentage,
    this.dailyCaloriesFromThisMealPlan,
    this.imperialWeightOfOneMeal,
    this.mealIngredientsWouldMake,
    this.mealsPerDay,
    this.nutrientValue,
    this.petName,
    this.showWeightOfBalancedMeal,
    this.suggestion,
    this.totalCaloriesInAMealPlan,
    this.totalImperialWeightOfAMealPlan,
    this.totalWeightOfAMealPlan,
    this.weightOfOneMeal,
    this.feedingPlanDetails,
  });

  int id;
  DailyAllowanceActualPercentage dailyAllowanceActualPercentage;
  int dailyCaloriesFromThisMealPlan;
  int imperialWeightOfOneMeal;
  int mealIngredientsWouldMake;
  int mealsPerDay;
  List<dynamic> nutrientValue;
  String petName;
  bool showWeightOfBalancedMeal;
  dynamic suggestion;
  int totalCaloriesInAMealPlan;
  dynamic totalImperialWeightOfAMealPlan;
  dynamic totalWeightOfAMealPlan;
  int weightOfOneMeal;
  List<dynamic> feedingPlanDetails;

  factory CloneMealPlanModel.fromJson(Map<String, dynamic> json) => CloneMealPlanModel(
    id: json["id"],
    dailyAllowanceActualPercentage: DailyAllowanceActualPercentage.fromJson(json["daily_allowance_actual_percentage"]),
    dailyCaloriesFromThisMealPlan: json["daily_calories_from_this_meal_plan"],
    imperialWeightOfOneMeal: json["imperial_weight_of_one_meal"],
    mealIngredientsWouldMake: json["meal_ingredients_would_make"],
    mealsPerDay: json["meals_per_day"],
    nutrientValue: List<dynamic>.from(json["nutrient_value"].map((x) => x)),
    petName: json["pet_name"],
    showWeightOfBalancedMeal: json["show_weight_of_balanced_meal"],
    suggestion: json["suggestion"],
    totalCaloriesInAMealPlan: json["total_calories_in_a_meal_plan"],
    totalImperialWeightOfAMealPlan: json["total_imperial_weight_of_a_meal_plan"],
    totalWeightOfAMealPlan: json["total_weight_of_a_meal_plan"],
    weightOfOneMeal: json["weight_of_one_meal"],
    feedingPlanDetails: List<dynamic>.from(json["feeding_plan_details"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "daily_allowance_actual_percentage": dailyAllowanceActualPercentage.toJson(),
    "daily_calories_from_this_meal_plan": dailyCaloriesFromThisMealPlan,
    "imperial_weight_of_one_meal": imperialWeightOfOneMeal,
    "meal_ingredients_would_make": mealIngredientsWouldMake,
    "meals_per_day": mealsPerDay,
    "nutrient_value": List<dynamic>.from(nutrientValue.map((x) => x)),
    "pet_name": petName,
    "show_weight_of_balanced_meal": showWeightOfBalancedMeal,
    "suggestion": suggestion,
    "total_calories_in_a_meal_plan": totalCaloriesInAMealPlan,
    "total_imperial_weight_of_a_meal_plan": totalImperialWeightOfAMealPlan,
    "total_weight_of_a_meal_plan": totalWeightOfAMealPlan,
    "weight_of_one_meal": weightOfOneMeal,
    "feeding_plan_details": List<dynamic>.from(feedingPlanDetails.map((x) => x)),
  };
}

class DailyAllowanceActualPercentage {
  DailyAllowanceActualPercentage({
    this.bone,
  });

  List<dynamic> bone;

  factory DailyAllowanceActualPercentage.fromJson(Map<String, dynamic> json) => DailyAllowanceActualPercentage(
    bone: List<dynamic>.from(json["Bone"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Bone": List<dynamic>.from(bone.map((x) => x)),
  };
}
