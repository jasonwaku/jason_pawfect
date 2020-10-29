// To parse this JSON data, do
//
//     final petFetch = petFetchFromJson(jsonString);

import 'dart:convert';

PetFetch petFetchFromJson(String str) => PetFetch.fromJson(json.decode(str));

String petFetchToJson(PetFetch data) => json.encode(data.toJson());

class PetFetch {
  PetFetch({
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

  factory PetFetch.fromJson(Map<String, dynamic> json) => PetFetch(
    id: json["id"],
    activityLevelName: json["activity_level_name"],
    age: json["age"],
    birthDate: DateTime.parse(json["birth_date"]),
    breedName: json["breed_name"],
    dailyAllowanceGuidelinesDetails: List<DailyAllowanceGuidelinesDetail>.from(json["daily_allowance_guidelines_details"].map((x) => DailyAllowanceGuidelinesDetail.fromJson(x))),
    eatbone: json["eatbone"],
    idealWeight: json["ideal_weight"].toDouble(),
    image: Image.fromJson(json["image"]),
    imperialIdealWeight: json["imperial_ideal_weight"].toDouble(),
    imperialWeight: json["imperial_weight"].toDouble(),
    name: json["name"],
    nutrientGuidelineDetail: List<NutrientGuidelineDetail>.from(json["nutrient_guideline_detail"].map((x) => NutrientGuidelineDetail.fromJson(x))),
    petLifeStageName: json["pet_life_stage_name"],
    sex: json["sex"],
    totalDailyCalories: json["total_daily_calories"],
    weight: json["weight"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "activity_level_name": activityLevelName,
    "age": age,
    "birth_date": "${birthDate.year.toString().padLeft(4, '0')}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}",
    "breed_name": breedName,
    "daily_allowance_guidelines_details": List<dynamic>.from(dailyAllowanceGuidelinesDetails.map((x) => x.toJson())),
    "eatbone": eatbone,
    "imperial_ideal_weight": imperialIdealWeight,
    "ideal_weight": idealWeight,
    "image": image.toJson(),
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
    percentage: json["percentage"].toDouble(),
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
// //     final petFetch = petFetchFromJson(jsonString);
//
// import 'dart:convert';
//
// PetFetch petFetchFromJson(String str) => PetFetch.fromJson(json.decode(str));
//
// String petFetchToJson(PetFetch data) => json.encode(data.toJson());
//
// class PetFetch {
//   PetFetch({
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
//   factory PetFetch.fromJson(Map<String, dynamic> json) => PetFetch(
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

// class Breed {
//   Breed({
//     this.id,
//     this.giant,
//     this.name,
//   });
//
//   int id;
//   dynamic giant;
//   String name;
//
//   factory Breed.fromJson(Map<String, dynamic> json) => Breed(
//     id: json["id"],
//     giant: json["giant"],
//     name: json["name"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "giant": giant,
//     "name": name,
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
//   int percentage;
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
//   });
//
//   String name;
//   double amount;
//   Unit unit;
//
//   factory NutrientGuidelineDetail.fromJson(Map<String, dynamic> json) => NutrientGuidelineDetail(
//     name: json["name"],
//     amount: json["amount"].toDouble(),
//     unit: unitValues.map[json["unit"]],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "name": name,
//     "amount": amount,
//     "unit": unitValues.reverse[unit],
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
