// To parse this JSON data, do
//
//     final allMealPlanModel = allMealPlanModelFromJson(jsonString);

import 'dart:convert';

List<AllMealPlanModel> allMealPlanModelFromJson(String str) => List<AllMealPlanModel>.from(json.decode(str).map((x) => AllMealPlanModel.fromJson(x)));

String allMealPlanModelToJson(List<AllMealPlanModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllMealPlanModel {
  AllMealPlanModel({
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
  List<NutrientValue> nutrientValue;
  String petName;
  bool showWeightOfBalancedMeal;
  dynamic suggestion;
  double totalCaloriesInAMealPlan;
  double totalImperialWeightOfAMealPlan;
  double totalWeightOfAMealPlan;
  dynamic weightOfOneMeal;
  List<FeedingPlanDetail> feedingPlanDetails;

  factory AllMealPlanModel.fromJson(Map<String, dynamic> json) => AllMealPlanModel(
    id: json["id"],
    dailyAllowanceActualPercentage: DailyAllowanceActualPercentage.fromJson(json["daily_allowance_actual_percentage"]),
    dailyCaloriesFromThisMealPlan: json["daily_calories_from_this_meal_plan"].toString(),
    imperialWeightOfOneMeal: json["imperial_weight_of_one_meal"].toString(),
    mealIngredientsWouldMake: json["meal_ingredients_would_make"]!= null ? json["meal_ingredients_would_make"].toDouble() : 0.0,
    mealsPerDay: json["meals_per_day"]!= null?json["meals_per_day"].toDouble(): 0.0,
    nutrientValue: List<NutrientValue>.from(json["nutrient_value"].map((x) => NutrientValue.fromJson(x))),
    petName: json["pet_name"],
    showWeightOfBalancedMeal: json["show_weight_of_balanced_meal"],
    suggestion: json["suggestion"],
    totalCaloriesInAMealPlan: json["total_calories_in_a_meal_plan"]!=null?json["total_calories_in_a_meal_plan"].toDouble():0.0,
    totalImperialWeightOfAMealPlan: json["total_imperial_weight_of_a_meal_plan"]!=null?json["total_imperial_weight_of_a_meal_plan"].toDouble():0.0,
    totalWeightOfAMealPlan: json["total_weight_of_a_meal_plan"]!=null?json["total_weight_of_a_meal_plan"].toDouble():0.0,
    weightOfOneMeal: json["weight_of_one_meal"].toString(),
    feedingPlanDetails: List<FeedingPlanDetail>.from(json["feeding_plan_details"].map((x) => FeedingPlanDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "daily_allowance_actual_percentage": dailyAllowanceActualPercentage.toJson(),
    "daily_calories_from_this_meal_plan": dailyCaloriesFromThisMealPlan,
    "imperial_weight_of_one_meal": imperialWeightOfOneMeal,
    "meal_ingredients_would_make": mealIngredientsWouldMake,
    "meals_per_day": mealsPerDay,
    "nutrient_value": List<dynamic>.from(nutrientValue.map((x) => x.toJson())),
    "pet_name": petName,
    "show_weight_of_balanced_meal": showWeightOfBalancedMeal,
    "suggestion": suggestion,
    "total_calories_in_a_meal_plan": totalCaloriesInAMealPlan,
    "total_imperial_weight_of_a_meal_plan": totalImperialWeightOfAMealPlan,
    "total_weight_of_a_meal_plan": totalWeightOfAMealPlan,
    "weight_of_one_meal": weightOfOneMeal,
    "feeding_plan_details": List<dynamic>.from(feedingPlanDetails.map((x) => x.toJson())),
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
    // muscleMeat: List<dynamic>.from(json["Muscle Meat"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Bone": List<dynamic>.from(bone.map((x) => x)),
    "Muscle Meat": List<dynamic>.from(muscleMeat.map((x) => x)),
    "Organ Meat": List<dynamic>.from(organMeat.map((x) => x)),
    "Fruit and Veg": List<dynamic>.from(fruitAndVeg.map((x) => x)),
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
    this.bonePercentage,
    this.calciumPhosphorousRatio,
    this.name,
    this.omegaRatio,
    this.omegaRatioColor,
    this.calciumPhosphorousRatioColor,
  });

  int id;
  double bonePercentage;
  double calciumPhosphorousRatio;
  String name;
  double omegaRatio;
  String omegaRatioColor;
  String calciumPhosphorousRatioColor;

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    id: json["id"],
    bonePercentage: json["bone_percentage"].toDouble(),
    calciumPhosphorousRatio: json["calcium_phosphorous_ratio"].toDouble(),
    name: json["name"],
    omegaRatio: json["omega_ratio"].toDouble(),
    omegaRatioColor: json["omega_ratio_color"],
    calciumPhosphorousRatioColor: json["calcium_phosphorous_ratio_color"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bone_percentage": bonePercentage,
    "calcium_phosphorous_ratio": calciumPhosphorousRatio,
    "name": name,
    "omega_ratio": omegaRatio,
    "omega_ratio_color": omegaRatioColor,
    "calcium_phosphorous_ratio_color": calciumPhosphorousRatioColor,
  };
}

class NutrientValue {
  NutrientValue({
    this.calcium,
    this.choline,
    this.copper,
    this.crudeFat,
    this.folate,
    this.iodine,
    this.iron,
    this.magnesium,
    this.manganese,
    this.niacinB3,
    this.omega3ExclAlaAndSda,
    this.omega6,
    this.pantothenicAcidB5,
    this.phosphorus,
    this.potassium,
    this.protein,
    this.riboflavinB2,
    this.selenium,
    this.sodiumNa,
    this.thiaminB1,
    this.vitaminA,
    this.vitaminC,
    this.vitaminD,
    this.vitaminE,
    this.zincZn,
    this.calories,
  });

  List<dynamic> calcium;
  List<dynamic> choline;
  List<dynamic> copper;
  List<dynamic> crudeFat;
  List<dynamic> folate;
  List<dynamic> iodine;
  List<dynamic> iron;
  List<dynamic> magnesium;
  List<dynamic> manganese;
  List<dynamic> niacinB3;
  List<dynamic> omega3ExclAlaAndSda;
  List<dynamic> omega6;
  List<dynamic> pantothenicAcidB5;
  List<dynamic> phosphorus;
  List<dynamic> potassium;
  List<dynamic> protein;
  List<dynamic> riboflavinB2;
  List<dynamic> selenium;
  List<dynamic> sodiumNa;
  List<dynamic> thiaminB1;
  List<dynamic> vitaminA;
  List<dynamic> vitaminC;
  List<dynamic> vitaminD;
  List<dynamic> vitaminE;
  List<dynamic> zincZn;
  List<dynamic> calories;

  factory NutrientValue.fromJson(Map<String, dynamic> json) => NutrientValue(
    calcium: json["Calcium"] == null ? null : List<dynamic>.from(json["Calcium"].map((x) => x)),
    choline: json["Choline"] == null ? null : List<dynamic>.from(json["Choline"].map((x) => x)),
    copper: json["Copper"] == null ? null : List<dynamic>.from(json["Copper"].map((x) => x)),
    crudeFat: json["Crude fat"] == null ? null : List<dynamic>.from(json["Crude fat"].map((x) => x)),
    folate: json["Folate"] == null ? null : List<dynamic>.from(json["Folate"].map((x) => x)),
    iodine: json["Iodine"] == null ? null : List<dynamic>.from(json["Iodine"].map((x) => x)),
    iron: json["Iron"] == null ? null : List<dynamic>.from(json["Iron"].map((x) => x)),
    magnesium: json["Magnesium"] == null ? null : List<dynamic>.from(json["Magnesium"].map((x) => x)),
    manganese: json["Manganese"] == null ? null : List<dynamic>.from(json["Manganese"].map((x) => x)),
    niacinB3: json["Niacin (B3)"] == null ? null : List<dynamic>.from(json["Niacin (B3)"].map((x) => x)),
    omega3ExclAlaAndSda: json["Omega-3 excl. ALA and SDA"] == null ? null : List<dynamic>.from(json["Omega-3 excl. ALA and SDA"].map((x) => x)),
    omega6: json["Omega-6"] == null ? null : List<dynamic>.from(json["Omega-6"].map((x) => x)),
    pantothenicAcidB5: json["Pantothenic acid (B5)"] == null ? null : List<dynamic>.from(json["Pantothenic acid (B5)"].map((x) => x)),
    phosphorus: json["Phosphorus"] == null ? null : List<dynamic>.from(json["Phosphorus"].map((x) => x)),
    potassium: json["Potassium"] == null ? null : List<dynamic>.from(json["Potassium"].map((x) => x)),
    protein: json["Protein"] == null ? null : List<dynamic>.from(json["Protein"].map((x) => x)),
    riboflavinB2: json["Riboflavin (B2)"] == null ? null : List<dynamic>.from(json["Riboflavin (B2)"].map((x) => x)),
    selenium: json["Selenium"] == null ? null : List<dynamic>.from(json["Selenium"].map((x) => x)),
    sodiumNa: json["Sodium (Na)"] == null ? null : List<dynamic>.from(json["Sodium (Na)"].map((x) => x)),
    thiaminB1: json["Thiamin (B1)"] == null ? null : List<dynamic>.from(json["Thiamin (B1)"].map((x) => x)),
    vitaminA: json["Vitamin A"] == null ? null : List<dynamic>.from(json["Vitamin A"].map((x) => x)),
    vitaminC: json["Vitamin C"] == null ? null : List<dynamic>.from(json["Vitamin C"].map((x) => x)),
    vitaminD: json["Vitamin D"] == null ? null : List<dynamic>.from(json["Vitamin D"].map((x) => x)),
    vitaminE: json["Vitamin E"] == null ? null : List<dynamic>.from(json["Vitamin E"].map((x) => x)),
    zincZn: json["Zinc (Zn)"] == null ? null : List<dynamic>.from(json["Zinc (Zn)"].map((x) => x)),
    calories: json["Calories"] == null ? null : List<dynamic>.from(json["Calories"].map((x) => x == null ? null : x)),
  );

  Map<String, dynamic> toJson() => {
    "Calcium": calcium == null ? null : List<dynamic>.from(calcium.map((x) => x)),
    "Choline": choline == null ? null : List<dynamic>.from(choline.map((x) => x)),
    "Copper": copper == null ? null : List<dynamic>.from(copper.map((x) => x)),
    "Crude fat": crudeFat == null ? null : List<dynamic>.from(crudeFat.map((x) => x)),
    "Folate": folate == null ? null : List<dynamic>.from(folate.map((x) => x)),
    "Iodine": iodine == null ? null : List<dynamic>.from(iodine.map((x) => x)),
    "Iron": iron == null ? null : List<dynamic>.from(iron.map((x) => x)),
    "Magnesium": magnesium == null ? null : List<dynamic>.from(magnesium.map((x) => x)),
    "Manganese": manganese == null ? null : List<dynamic>.from(manganese.map((x) => x)),
    "Niacin (B3)": niacinB3 == null ? null : List<dynamic>.from(niacinB3.map((x) => x)),
    "Omega-3 excl. ALA and SDA": omega3ExclAlaAndSda == null ? null : List<dynamic>.from(omega3ExclAlaAndSda.map((x) => x)),
    "Omega-6": omega6 == null ? null : List<dynamic>.from(omega6.map((x) => x)),
    "Pantothenic acid (B5)": pantothenicAcidB5 == null ? null : List<dynamic>.from(pantothenicAcidB5.map((x) => x)),
    "Phosphorus": phosphorus == null ? null : List<dynamic>.from(phosphorus.map((x) => x)),
    "Potassium": potassium == null ? null : List<dynamic>.from(potassium.map((x) => x)),
    "Protein": protein == null ? null : List<dynamic>.from(protein.map((x) => x)),
    "Riboflavin (B2)": riboflavinB2 == null ? null : List<dynamic>.from(riboflavinB2.map((x) => x)),
    "Selenium": selenium == null ? null : List<dynamic>.from(selenium.map((x) => x)),
    "Sodium (Na)": sodiumNa == null ? null : List<dynamic>.from(sodiumNa.map((x) => x)),
    "Thiamin (B1)": thiaminB1 == null ? null : List<dynamic>.from(thiaminB1.map((x) => x)),
    "Vitamin A": vitaminA == null ? null : List<dynamic>.from(vitaminA.map((x) => x)),
    "Vitamin C": vitaminC == null ? null : List<dynamic>.from(vitaminC.map((x) => x)),
    "Vitamin D": vitaminD == null ? null : List<dynamic>.from(vitaminD.map((x) => x)),
    "Vitamin E": vitaminE == null ? null : List<dynamic>.from(vitaminE.map((x) => x)),
    "Zinc (Zn)": zincZn == null ? null : List<dynamic>.from(zincZn.map((x) => x)),
    "Calories": calories == null ? null : List<dynamic>.from(calories.map((x) => x == null ? null : x)),
  };
}
