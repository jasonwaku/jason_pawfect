// To parse this JSON data, do
//
//     final petCreate = petCreateFromJson(jsonString);

import 'dart:convert';

PetCreate petCreateFromJson(String str) => PetCreate.fromJson(json.decode(str));

String petCreateToJson(PetCreate data) => json.encode(data.toJson());

class PetCreate {
  PetCreate({
    this.success,
    this.message,
    this.pet,
  });

  bool success;
  String message;
  Pet pet;

  factory PetCreate.fromJson(Map<String, dynamic> json) => PetCreate(
    success: json["success"],
    message: json["message"],
    pet: Pet.fromJson(json["pet"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "pet": pet.toJson(),
  };
}

class Pet {
  Pet({
    this.id,
    this.activityLevelName,
    this.age,
    this.birthDate,
    this.breedName,
    this.dailyAllowanceGuidelinesDetails,
    this.eatbone,
    this.idealWeight,
    this.image,
    this.imperialIdealWeight,
    this.imperialWeight,
    this.name,
    this.nutrientGuidelineDetail,
    this.petLifeStageName,
    this.sex,
    this.totalDailyCalories,
    this.weight,
  });

  int id;
  String activityLevelName;
  int age;
  DateTime birthDate;
  String breedName;
  List<DailyAllowanceGuidelinesDetail> dailyAllowanceGuidelinesDetails;
  bool eatbone;
  double idealWeight;
  Image image;
  double imperialIdealWeight;
  double imperialWeight;
  String name;
  List<NutrientGuidelineDetail> nutrientGuidelineDetail;
  String petLifeStageName;
  String sex;
  String totalDailyCalories;
  double weight;

  factory Pet.fromJson(Map<String, dynamic> json) => Pet(
    id: json["id"],
    activityLevelName: json["activity_level_name"],
    age: json["age"],
    birthDate: DateTime.parse(json["birth_date"]),
    breedName: json["breed_name"],
    dailyAllowanceGuidelinesDetails: List<DailyAllowanceGuidelinesDetail>.from(json["daily_allowance_guidelines_details"].map((x) => DailyAllowanceGuidelinesDetail.fromJson(x))),
    eatbone: json["eatbone"],
    idealWeight: json["ideal_weight"],
    image: Image.fromJson(json["image"]),
    imperialIdealWeight: json["imperial_ideal_weight"].toDouble(),
    imperialWeight: json["imperial_weight"].toDouble(),
    name: json["name"],
    nutrientGuidelineDetail: List<NutrientGuidelineDetail>.from(json["nutrient_guideline_detail"].map((x) => NutrientGuidelineDetail.fromJson(x))),
    petLifeStageName: json["pet_life_stage_name"],
    sex: json["sex"],
    totalDailyCalories: json["total_daily_calories"],
    weight: json["weight"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "activity_level_name": activityLevelName,
    "age": age,
    "birth_date": "${birthDate.day.toString().padLeft(4, '0')}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.year.toString().padLeft(2, '0')}",
    "breed_name": breedName,
    "daily_allowance_guidelines_details": List<dynamic>.from(dailyAllowanceGuidelinesDetails.map((x) => x.toJson())),
    "eatbone": eatbone,
    "ideal_weight": idealWeight,
    "image": image.toJson(),
    "imperial_ideal_weight": imperialIdealWeight,
    "imperial_weight": imperialWeight,
    "name": name,
    "nutrient_guideline_detail": List<dynamic>.from(nutrientGuidelineDetail.map((x) => x.toJson())),
    "pet_life_stage_name": petLifeStageName,
    "sex": sex,
    "total_daily_calories": totalDailyCalories,
    "weight": weight,
  };
}

class DailyAllowanceGuidelinesDetail {
  DailyAllowanceGuidelinesDetail({
    this.name,
    this.bones,
    this.percentage,
  });

  String name;
  bool bones;
  double percentage;

  factory DailyAllowanceGuidelinesDetail.fromJson(Map<String, dynamic> json) => DailyAllowanceGuidelinesDetail(
    name: json["name"],
    bones: json["bones"],
    percentage: json["percentage"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "bones": bones,
    "percentage": percentage,
  };
}

class Image {
  Image({
    this.url,
    this.thumb,
  });

  dynamic url;
  Thumb thumb;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    url: json["url"],
    thumb: Thumb.fromJson(json["thumb"]),
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "thumb": thumb.toJson(),
  };
}

class Thumb {
  Thumb({
    this.url,
  });

  dynamic url;

  factory Thumb.fromJson(Map<String, dynamic> json) => Thumb(
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
  };
}

class NutrientGuidelineDetail {
  NutrientGuidelineDetail({
    this.name,
    this.amount,
    this.unit,
    this.imperialAmount,
  });

  String name;
  double amount;
  Unit unit;
  String imperialAmount;

  factory NutrientGuidelineDetail.fromJson(Map<String, dynamic> json) => NutrientGuidelineDetail(
    name: json["name"],
    amount: json["amount"].toDouble(),
    unit: unitValues.map[json["unit"]],
    imperialAmount: json["imperial_amount"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "amount": amount,
    "unit": unitValues.reverse[unit],
    "imperial_amount": imperialAmount,
  };
}

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

// // To parse this JSON data, do
// //
// //     final petCreate = petCreateFromJson(jsonString);
//
// import 'dart:convert';
//
// PetCreate petCreateFromJson(String str) => PetCreate.fromJson(json.decode(str));
//
// String petCreateToJson(PetCreate data) => json.encode(data.toJson());
//
// class PetCreate {
//   PetCreate({
//     this.success,
//     this.pet,
//   });
//
//   bool success;
//   Pet pet;
//
//   factory PetCreate.fromJson(Map<String, dynamic> json) => PetCreate(
//     success: json["success"],
//     pet: Pet.fromJson(json["pet"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "pet": pet.toJson(),
//   };
// }
//
// class Pet {
//   Pet({
//     this.id,
//     this.activityLevelName,
//     this.age,
//     this.birthDay,
//     this.birthMonth,
//     this.birthYear,
//     this.breedName,
//     this.dailyAllowanceGuidelinesDetails,
//     this.eatbone,
//     this.idealWeight,
//     this.image,
//     this.imperialWeight,
//     this.name,
//     this.nutrientGuidelineDetail,
//     this.petLifeStageName,
//     this.sex,
//     this.totalDailyCalories,
//     this.weight,
//   });
//
//   int id;
//   String activityLevelName;
//   int age;
//   String birthDay;
//   String birthMonth;
//   String birthYear;
//   String breedName;
//   List<DailyAllowanceGuidelinesDetail> dailyAllowanceGuidelinesDetails;
//   bool eatbone;
//   double idealWeight;
//   Image image;
//   double imperialWeight;
//   String name;
//   List<NutrientGuidelineDetail> nutrientGuidelineDetail;
//   String petLifeStageName;
//   String sex;
//   String totalDailyCalories;
//   double weight;
//
//   factory Pet.fromJson(Map<String, dynamic> json) => Pet(
//     id: json["id"],
//     activityLevelName: json["activity_level_name"],
//     age: json["age"],
//     birthDay: json["birth_day"],
//     birthMonth: json["birth_month"],
//     birthYear: json["birth_year"],
//     breedName: json["breed_name"],
//     dailyAllowanceGuidelinesDetails: List<DailyAllowanceGuidelinesDetail>.from(json["daily_allowance_guidelines_details"].map((x) => DailyAllowanceGuidelinesDetail.fromJson(x))),
//     eatbone: json["eatbone"],
//     idealWeight: json["ideal_weight"],
//     image: Image.fromJson(json["image"]),
//     imperialWeight: json["imperial_weight"].toDouble(),
//     name: json["name"],
//     nutrientGuidelineDetail: List<NutrientGuidelineDetail>.from(json["nutrient_guideline_detail"].map((x) => NutrientGuidelineDetail.fromJson(x))),
//     petLifeStageName: json["pet_life_stage_name"],
//     sex: json["sex"],
//     totalDailyCalories: json["total_daily_calories"],
//     weight: json["weight"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "activity_level_name": activityLevelName,
//     "age": age,
//     "birth_day": birthDay,
//     "birth_month": birthMonth,
//     "birth_year": birthYear,
//     "breed_name": breedName,
//     "daily_allowance_guidelines_details": List<dynamic>.from(dailyAllowanceGuidelinesDetails.map((x) => x.toJson())),
//     "eatbone": eatbone,
//     "ideal_weight": idealWeight,
//     "image": image.toJson(),
//     "imperial_weight": imperialWeight,
//     "name": name,
//     "nutrient_guideline_detail": List<dynamic>.from(nutrientGuidelineDetail.map((x) => x.toJson())),
//     "pet_life_stage_name": petLifeStageName,
//     "sex": sex,
//     "total_daily_calories": totalDailyCalories,
//     "weight": weight,
//   };
// }
//
// class DailyAllowanceGuidelinesDetail {
//   DailyAllowanceGuidelinesDetail({
//     this.name,
//     this.bones,
//     this.percentage,
//   });
//
//   String name;
//   bool bones;
//   double percentage;
//
//   factory DailyAllowanceGuidelinesDetail.fromJson(Map<String, dynamic> json) => DailyAllowanceGuidelinesDetail(
//     name: json["name"],
//     bones: json["bones"],
//     percentage: json["percentage"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "name": name,
//     "bones": bones,
//     "percentage": percentage,
//   };
// }
//
// class Image {
//   Image({
//     this.url,
//     this.thumb,
//   });
//
//   dynamic url;
//   Thumb thumb;
//
//   factory Image.fromJson(Map<String, dynamic> json) => Image(
//     url: json["url"],
//     thumb: Thumb.fromJson(json["thumb"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "url": url,
//     "thumb": thumb.toJson(),
//   };
// }
//
// class Thumb {
//   Thumb({
//     this.url,
//   });
//
//   dynamic url;
//
//   factory Thumb.fromJson(Map<String, dynamic> json) => Thumb(
//     url: json["url"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "url": url,
//   };
// }
//
// class NutrientGuidelineDetail {
//   NutrientGuidelineDetail({
//     this.name,
//     this.amount,
//     this.unit,
//     this.imperialAmount,
//   });
//
//   String name;
//   double amount;
//   Unit unit;
//   String imperialAmount;
//
//   factory NutrientGuidelineDetail.fromJson(Map<String, dynamic> json) => NutrientGuidelineDetail(
//     name: json["name"],
//     amount: json["amount"].toDouble(),
//     unit: unitValues.map[json["unit"]],
//     imperialAmount: json["imperial_amount"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "name": name,
//     "amount": amount,
//     "unit": unitValues.reverse[unit],
//     "imperial_amount": imperialAmount,
//   };
// }
//
// enum Unit { G, RATIO, MG, MCG }
//
// final unitValues = EnumValues({
//   "g": Unit.G,
//   "mcg": Unit.MCG,
//   "mg": Unit.MG,
//   "ratio": Unit.RATIO
// });
//
// class EnumValues<T> {
//   Map<String, T> map;
//   Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     if (reverseMap == null) {
//       reverseMap = map.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap;
//   }
// }


/////////// old pet model /////////////

// class Pet {
//   String petImage;
//   String eatbone;
//   String name;
//   // String petAge;
//   // String petBreed;
//   String weight;
//   String ideal_weight;
//   String activity_level_id;
//   String guideline_id;
//   String breed_id;
//   String user_id;
//   // String petSex;
//   // String petBirthDate;
//
//   Pet({
//     this.petImage,
//     this.eatbone,
//     this.name,
//     // this.petAge,
//     this.weight,
//     this.ideal_weight,
//     this.activity_level_id,
//     this.guideline_id,
//     this.breed_id,
//     // this.petActivityLevel,
//     // this.petSex,
//     this.user_id,
//     // this.petBirthDate,
//   });
//
//   factory Pet.fromJson(Map<String, dynamic> parsedJson) {
//     return new Pet(
//       petImage: parsedJson['petImage'] ?? "",
//       eatbone: parsedJson['eatbone'] ?? "",
//       name: parsedJson['name'] ?? "",
//       // petAge: parsedJson['petAge'] ?? "",
//       // petBreed: parsedJson['petBreed'] ?? "",
//       weight: parsedJson['weight'] ?? "",
//       ideal_weight: parsedJson['ideal_weight'] ?? "",
//       activity_level_id: parsedJson['activity_level_id'] ?? "",
//       guideline_id: parsedJson['guideline_id'] ?? "",
//       breed_id: parsedJson['breed_id'] ?? "",
//       // petSex: parsedJson['petSex'] ?? "",
//       user_id: parsedJson['user_id'] ?? "",
//       // petBirthDate: parsedJson['petBirthDate'] ?? "",
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['petImage'] = this.petImage;
//     data['eatbone'] = this.eatbone;
//     data['name'] = this.name;
//     // data['petAge'] = this.petAge;
//     data['weight'] = this.weight;
//     data['ideal_weight'] = this.ideal_weight;
//     data['activity_level_id'] = this.activity_level_id;
//     data['guideline_id'] = this.guideline_id;
//     data['breed_id'] = this.breed_id;
//     // data['petSex'] = this.petSex;
//     data['user_id'] = this.user_id;
//     // data['petBirthDate'] = this.petBirthDate;
//     return data;
//   }
// }
