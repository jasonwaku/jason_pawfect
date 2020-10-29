// To parse this JSON data, do
//
//     final mealPlanModel = mealPlanModelFromJson(jsonString);

import 'dart:convert';

MealPlanModel mealPlanModelFromJson(String str) => MealPlanModel.fromJson(json.decode(str));

String mealPlanModelToJson(MealPlanModel data) => json.encode(data.toJson());

class MealPlanModel {
  MealPlanModel({
    this.success,
    this.feedingPlan,
  });

  bool success;
  FeedingPlan feedingPlan;

  factory MealPlanModel.fromJson(Map<String, dynamic> json) => MealPlanModel(
    success: json["success"],
    feedingPlan: FeedingPlan.fromJson(json["feeding_plan"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "feeding_plan": feedingPlan.toJson(),
  };
}

class FeedingPlan {
  FeedingPlan({
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
  dynamic dailyCaloriesFromThisMealPlan;
  dynamic imperialWeightOfOneMeal;
  double mealIngredientsWouldMake;
  double mealsPerDay;
  List<dynamic> nutrientValue;
  String petName;
  bool showWeightOfBalancedMeal;
  dynamic suggestion;
  double totalCaloriesInAMealPlan;
  double totalImperialWeightOfAMealPlan;
  double totalWeightOfAMealPlan;
  dynamic weightOfOneMeal;
  List<dynamic> feedingPlanDetails;

  factory FeedingPlan.fromJson(Map<String, dynamic> json) => FeedingPlan(
    id: json["id"],
    dailyAllowanceActualPercentage: DailyAllowanceActualPercentage.fromJson(json["daily_allowance_actual_percentage"]),
    dailyCaloriesFromThisMealPlan: json["daily_calories_from_this_meal_plan"].toString(),
    imperialWeightOfOneMeal: json["imperial_weight_of_one_meal"].toString(),
    mealIngredientsWouldMake: json["meal_ingredients_would_make"] != null?json["meal_ingredients_would_make"].toDouble():0.0,
    mealsPerDay: json["meals_per_day"]!=null?json["meals_per_day"].toDouble():0.0,
    nutrientValue: List<dynamic>.from(json["nutrient_value"].map((x) => x)),
    petName: json["pet_name"],
    showWeightOfBalancedMeal: json["show_weight_of_balanced_meal"],
    suggestion: json["suggestion"],
    totalCaloriesInAMealPlan: json["total_calories_in_a_meal_plan"]!=null?json["total_calories_in_a_meal_plan"].toDouble():0.0,
    totalImperialWeightOfAMealPlan: json["total_imperial_weight_of_a_meal_plan"] != null?json["total_imperial_weight_of_a_meal_plan"].toDouble():0.0,
    totalWeightOfAMealPlan: json["total_weight_of_a_meal_plan"] != null ?json["total_weight_of_a_meal_plan"].toDouble():0.0,
    weightOfOneMeal: json["weight_of_one_meal"].toString(),
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
    this.muscleMeat,
    this.organMeat,
    this.fruitAndVeg,
  });

  List<dynamic> bone;
  List<dynamic> muscleMeat;
  List<dynamic> organMeat;
  List<dynamic> fruitAndVeg;

  factory DailyAllowanceActualPercentage.fromJson(Map<String, dynamic> json) => DailyAllowanceActualPercentage(
    // bone: List<dynamic>.from(json["Bone"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Bone": List<dynamic>.from(bone.map((x) => x)),
    "Muscle Meat": List<dynamic>.from(muscleMeat.map((x) => x)),
    "Organ Meat": List<dynamic>.from(organMeat.map((x) => x)),
    "Fruit and Veg": List<dynamic>.from(fruitAndVeg.map((x) => x)),
  };
}
