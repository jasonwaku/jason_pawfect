// To parse this JSON data, do
//
//     final userCreate = userCreateFromJson(jsonString);

import 'dart:convert';

UserCreate userCreateFromJson(String str) => UserCreate.fromJson(json.decode(str));

String userCreateToJson(UserCreate data) => json.encode(data.toJson());

class UserCreate {
  UserCreate({
    this.success,
    this.token,
    // this.message,
    this.user,
  });

  bool success;
  String token;
  // String message;
  User user;

  factory UserCreate.fromJson(Map<String, dynamic> json) => UserCreate(
    success: json["success"],
    token: json["token"],
    // message: json["message"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "token": token,
    // "message": message,
    "user": user.toJson(),
  };
}

class User {
  User({
    this.id,
    this.email,
    this.address,
    this.countryName,
    this.imperial,
    this.mobile,
    this.petsInfo,
    this.role,
    this.subscribed,
    this.username,
  });

  int id;
  String email;
  String address;
  String countryName;
  bool imperial;
  String mobile;
  List<PetsInfo> petsInfo;
  String role;
  bool subscribed;
  String username;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
    address: json["address"],
    countryName: json["country_name"],
    imperial: json["imperial"],
    mobile: json["mobile"],
    petsInfo: List<PetsInfo>.from(json["pets_info"].map((x) => PetsInfo.fromJson(x))),
    role: json["role"],
    subscribed: json["subscribed"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "address": address,
    "country_name": countryName,
    "imperial": imperial,
    "mobile": mobile,
    "pets_info": List<dynamic>.from(petsInfo.map((x) => x.toJson())),
    "role": role,
    "subscribed": subscribed,
    "username": username,
  };
}

class PetsInfo {
  PetsInfo({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory PetsInfo.fromJson(Map<String, dynamic> json) => PetsInfo(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

// import 'dart:convert';
//
// UserCreate userCreateFromJson(String str) => UserCreate.fromJson(json.decode(str));
//
// String userCreateToJson(UserCreate data) => json.encode(data.toJson());
//
// class UserCreate {
//   UserCreate({
//     this.success,
//     this.token,
//     this.user,
//     this.message,
//   });
//
//   bool success;
//   String token;
//   User user;
//   String message;
//
//   factory UserCreate.fromJson(Map<String, dynamic> json) => UserCreate(
//     success: json["success"],
//     token: json["token"],
//     user: User.fromJson(json["user"]),
//     message: json["message"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "token": token,
//     "user": user.toJson(),
//     "message": message,
//   };
// }
//
// class User {
//   User({
//     this.id,
//     this.email,
//     this.address,
//     this.imperial,
//     this.mobile,
//     this.petsInfo,
//     this.role,
//     this.subscribed,
//     this.username,
//     this.country,
//   });
//
//   int id;
//   String email;
//   String address;
//   bool imperial;
//   String mobile;
//   List<dynamic> petsInfo;
//   String role;
//   bool subscribed;
//   String username;
//   Country country;
//
//   factory User.fromJson(Map<String, dynamic> json) => User(
//     id: json["id"],
//     email: json["email"],
//     address: json["address"],
//     imperial: json["imperial"],
//     mobile: json["mobile"],
//     petsInfo: List<dynamic>.from(json["pets_info"].map((x) => x)),
//     role: json["role"],
//     subscribed: json["subscribed"],
//     username: json["username"],
//     country: Country.fromJson(json["country"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "email": email,
//     "address": address,
//     "imperial": imperial,
//     "mobile": mobile,
//     "pets_info": List<dynamic>.from(petsInfo.map((x) => x)),
//     "role": role,
//     "subscribed": subscribed,
//     "username": username,
//     "country": country.toJson(),
//   };
// }
//
// class Country {
//   Country({
//     this.id,
//     this.creatorId,
//     this.updaterId,
//     this.deleterId,
//     this.deletedAt,
//     this.code,
//     this.dialCode,
//     this.name,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   int id;
//   dynamic creatorId;
//   dynamic updaterId;
//   dynamic deleterId;
//   dynamic deletedAt;
//   String code;
//   String dialCode;
//   String name;
//   DateTime createdAt;
//   DateTime updatedAt;
//
//   factory Country.fromJson(Map<String, dynamic> json) => Country(
//     id: json["id"],
//     creatorId: json["creator_id"],
//     updaterId: json["updater_id"],
//     deleterId: json["deleter_id"],
//     deletedAt: json["deleted_at"],
//     code: json["code"],
//     dialCode: json["dial_code"],
//     name: json["name"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "creator_id": creatorId,
//     "updater_id": updaterId,
//     "deleter_id": deleterId,
//     "deleted_at": deletedAt,
//     "code": code,
//     "dial_code": dialCode,
//     "name": name,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//   };
// }
//
// ////////////////////// old model ///////////////////////
// // class User{
// //   // String user_token;
// //   String email;
// //   String username;
// //   String address;
// //   String imperial;
// //   String mobile;
// //   String password;
// //   String role;
// //   // String userCountry;
// //   String subscribed;
// //   String country_id;
// //
// //
// //   User({this.email, this.username, this.address, this.imperial,
// //     this.mobile, this.password, this.role, this.subscribed, this.country_id});
// //
// //   factory User.fromJson(Map<String, dynamic> parsedJson) {
// //     return new User(
// //       email: parsedJson['email'] ?? "",
// //       username: parsedJson['username'] ?? "",
// //       address: parsedJson['address'] ?? "",
// //       imperial: parsedJson['imperial'] ?? "",
// //       mobile: parsedJson['mobile'] ?? "",
// //       password: parsedJson['password'] ?? "",
// //       role: parsedJson['role'] ?? "",
// //       subscribed: parsedJson['subscribed'] ?? "",
// //       country_id: parsedJson['country_id'] ?? "",
// //     );
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['email'] = this.email;
// //     data['username'] = this.username;
// //     data['address'] = this.address;
// //     data['imperial'] = this.imperial;
// //     data['mobile'] = this.mobile;
// //     data['password'] = this.password;
// //     data['role'] = this.role;
// //     data['subscribed'] = this.subscribed;
// //     data['country_id'] = this.country_id;
// //     return data;
// //   }
// // }