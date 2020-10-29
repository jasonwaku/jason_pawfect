// To parse this JSON data, do
//
//     final userFetch = userFetchFromJson(jsonString);

import 'dart:convert';

UserFetch userFetchFromJson(String str) => UserFetch.fromJson(json.decode(str));

String userFetchToJson(UserFetch data) => json.encode(data.toJson());

class UserFetch {
  UserFetch({
    this.success,
    this.user,
  });

  bool success;
  User user;

  factory UserFetch.fromJson(Map<String, dynamic> json) => UserFetch(
    success: json["success"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
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


// // To parse this JSON data, do
// //
// //     final userFetch = userFetchFromJson(jsonString);
//
// import 'dart:convert';
//
// UserFetch userFetchFromJson(String str) => UserFetch.fromJson(json.decode(str));
//
// String userFetchToJson(UserFetch data) => json.encode(data.toJson());
//
// class UserFetch {
//   UserFetch({
//     this.success,
//     this.user,
//   });
//
//   bool success;
//   User user;
//
//   factory UserFetch.fromJson(Map<String, dynamic> json) => UserFetch(
//     success: json["success"],
//     user: User.fromJson(json["user"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "user": user.toJson(),
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
//   List<PetsInfo> petsInfo;
//   String role;
//   bool subscribed;
//   String username;
//   dynamic country;
//
//   factory User.fromJson(Map<String, dynamic> json) => User(
//     id: json["id"],
//     email: json["email"],
//     address: json["address"],
//     imperial: json["imperial"],
//     mobile: json["mobile"],
//     petsInfo: List<PetsInfo>.from(json["pets_info"].map((x) => PetsInfo.fromJson(x))),
//     role: json["role"],
//     subscribed: json["subscribed"],
//     username: json["username"],
//     country: json["country"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id":id,
//     "email": email,
//     "address": address,
//     "imperial": imperial,
//     "mobile": mobile,
//     "pets_info": List<dynamic>.from(petsInfo.map((x) => x.toJson())),
//     "role": role,
//     "subscribed": subscribed,
//     "username": username,
//     "country": country,
//   };
// }
//
// class PetsInfo {
//   PetsInfo({
//     this.id,
//     this.name,
//   });
//
//   int id;
//   String name;
//
//   factory PetsInfo.fromJson(Map<String, dynamic> json) => PetsInfo(
//     id: json["id"],
//     name: json["name"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//   };
// }