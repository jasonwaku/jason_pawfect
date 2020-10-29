import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pawfect/models/error_model.dart';
import 'package:pawfect/models/meal_plan_detail_model/meal_plan_detail.dart';
import 'package:pawfect/models/meal_plan_model/meal_plan_model.dart';
import 'package:pawfect/models/pets/activity_level.dart';
import 'package:pawfect/models/api_response.dart';
import 'package:pawfect/models/pets/dog_breed.dart';
import 'package:pawfect/models/pets/pet_fetch_model.dart';
import 'package:pawfect/models/response_api.dart';
import 'package:pawfect/models/pets/pet_model.dart';
import 'package:pawfect/models/users/user_fetch_model.dart';
import 'package:pawfect/models/users/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  final String _baseUrl = '';

  _setHeaders() => {
    'Content-type': 'application/json',
    'Accept': '*/*',
  };

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '?token=$token';
  }

  Future<dynamic> loginUser(data, apiUrl) async{
    var fullUrl = _baseUrl + apiUrl;
    final response = await http.post(fullUrl, body: jsonEncode(data), headers: _setHeaders());

    if(response.statusCode == 200){
      final String responseString = response.body;
      print(responseString);
      var res =json.decode(responseString);
      print(res.toString());
      if(res['success']){
        print("user create response------------ "+ responseString);
        return userCreateFromJson(responseString);
      }else{
        print("user failed response------------ "+ responseString);
        return errorModelFromJson(responseString);
      }
    }else{
      // throw Exception();
      return null;
    }
  }

  Future<dynamic> createTheUser(data, apiUrl) async{
    var fullUrl = _baseUrl + apiUrl;
    final response = await http.post(fullUrl, body: jsonEncode(data), headers: _setHeaders());

    if(response.statusCode == 200){
      final String responseString = response.body;
      var res =json.decode(responseString);
      print(res.toString());
      if(res['success']){
        print("user create response------------ "+ responseString);
        return userCreateFromJson(responseString);
      }else{
        print("user failed response------------ "+ responseString);
        return errorModelFromJson(responseString);
      }
    }else{
      // throw Exception("An Error Occurred");
      return null;
    }
  }

  Future<dynamic> updateTheUser(data, apiUrl) async{
    var fullUrl = _baseUrl + apiUrl;  // + await _getToken();
    final response = await http.put(fullUrl, body: jsonEncode(data), headers: _setHeaders());

    if(response.statusCode == 200){
      final String responseString = response.body;
      print(responseString);
      var res =json.decode(responseString);
      print(res.toString());
      if(res['success']){
        print("user create response------------ "+ responseString);
        return userCreateFromJson(responseString);
      }else{
        print("user failed response------------ "+ responseString);
        return errorModelFromJson(responseString);
      }

    }else{
      // throw Exception();
      return null;
    }
  }

  Future<UserFetch> fetchTheUser(apiUrl) async{
    var fullUrl = _baseUrl + apiUrl; // + await _getToken();
    final response = await http.get(fullUrl, headers: _setHeaders());

    if(response.statusCode == 200){
      final String res = response.body;
      print(res);
      return userFetchFromJson(res);
      // return userCreateFromJson(responseString);
    }else{
      // throw Exception();
      return null;
    }
  }

  Future<UserFetch> fetchUser(apiUrl) async {
    var fullUrl = _baseUrl + apiUrl;
    final response = await http.get(fullUrl, headers: _setHeaders());

    if (response.statusCode == 200) {
      // If the call to the server was successful (returns OK), parse the JSON.
      return UserFetch.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful (response was unexpected), it throw an error.
      throw Exception('Failed to load User');
    }
  }

  Future<dynamic> createThePet(data, apiUrl) async{
    var fullUrl = _baseUrl + apiUrl; // + await _getToken();
    final response = await http.post(fullUrl, body: jsonEncode(data), headers: _setHeaders());

    if(response.statusCode == 200){
      String responseString = response.body;
      print(responseString);
      var res =json.decode(responseString);
      print(res.toString());
      if(res['success']){
        print("success response------------ "+ responseString);
        return petCreateFromJson(responseString);
      }else{
        print("failed response------------ "+ responseString);
        return errorModelFromJson(responseString);
      }
    }else{
      // throw Exception();
      return null;
    }
  }

  Future<Pet> retrieveThePet(apiUrl) async{
    var fullUrl = _baseUrl + apiUrl; // + await _getToken();
    final response = await http.get(fullUrl, headers: _setHeaders());

    if(response.statusCode == 200){
      final jsonPet = jsonDecode(response.body);
      print(jsonPet);
      return Pet.fromJson(jsonPet);
      // return userCreateFromJson(responseString);
    }else{
      // throw Exception();
      return null;
    }
  }

  Future<PetFetch> getPetData(apiUrl) async {
    var fullUrl = _baseUrl + apiUrl; // + await _getToken();
    final response = await http.get(fullUrl);
    //
    if (response.statusCode == 200) {
      var res = response.body;
      return PetFetch.fromJson(json.decode(res));
    } else {
      throw Exception('Failed to load pet data');
    }
  }

  Future<dynamic> updateThePet(data, apiUrl) async{
    var fullUrl = _baseUrl + apiUrl; // + await _getToken();
    final response = await http.put(fullUrl, body: jsonEncode(data), headers: _setHeaders());

    if(response.statusCode == 200){
      final String responseString = response.body;
      print(responseString);
      var res =json.decode(responseString);
      if(res['success']){
        print("success response------------ "+ responseString);
        return petCreateFromJson(responseString);
      }else{
        print("failed response------------ "+ responseString);
        return errorModelFromJson(responseString);
      }
      // return petCreateFromJson(responseString);
    }else{
      return null;
    }
  }

  Future<DogBreed> getBreeds(apiUrl) async{
    var fullUrl = _baseUrl + apiUrl; // + await _getToken();
    final response = await http.get(fullUrl, headers: _setHeaders());

    if(response.statusCode == 200){
      final jsonBreed = jsonDecode(response.body);
      print(jsonBreed);
      return DogBreed.fromJson(jsonBreed);
      // return userCreateFromJson(responseString);
    }else{
      // throw Exception();
      return null;
    }
  }

  Future<ActivityLevel> getActivityLevels(apiUrl) async{
    var fullUrl = _baseUrl + apiUrl; // + await _getToken();
    final response = await http.get(fullUrl, headers: _setHeaders());

    if(response.statusCode == 200){
      final jsonActivityLevel = jsonDecode(response.body);
      print(jsonActivityLevel);
      return ActivityLevel.fromJson(jsonActivityLevel);
      // return userCreateFromJson(responseString);
    }else{
      // throw Exception();
      return null;
    }
  }

  Future<dynamic> createMealPlan(data, apiUrl) async{
    var fullUrl = _baseUrl + apiUrl; // + await _getToken();
    final response = await http.post(fullUrl, body: jsonEncode(data), headers: _setHeaders());

    if(response.statusCode == 200){
      String responseString = response.body;
      print(responseString);
      var res =json.decode(responseString);
      print(res.toString());
      if(res['success']){
        print("success response------------ "+ responseString);
        return mealPlanModelFromJson(responseString);
      }else{
        print("failed response------------ "+ responseString);
        return errorModelFromJson(responseString);
      }
    }else{
      // throw Exception();
      return null;
    }
  }

  Future<dynamic> createMealPlanDetail(data, apiUrl) async{
    var fullUrl = _baseUrl + apiUrl; // + await _getToken();
    final response = await http.post(fullUrl, body: jsonEncode(data), headers: _setHeaders());

    if(response.statusCode == 200){
      String responseString = response.body;
      print(responseString);
      var res =json.decode(responseString);
      print(res.toString());
      if(res['success']){
        print("success response------------ "+ responseString);
        return mealPlanDetailModelFromJson(responseString);
      }else{
        print("failed response------------ "+ responseString);
        return errorModelFromJson(responseString);
      }
    }else{
      // throw Exception();
      return null;
    }
  }

  registerData(data, apiUrl) async {
    var fullUrl = _baseUrl + apiUrl;
    var res =
        http.post(fullUrl, body: jsonEncode(data), headers: _setHeaders());
    return await res;
  }

  postData(data, apiUrl) async {
    var fullUrl = _baseUrl + apiUrl + await _getToken();
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = _baseUrl + apiUrl; // + await _getToken();
    return await http.get(fullUrl, headers: _setHeaders());
  }

  putData(data, apiUrl) async {
    var fullUrl = _baseUrl + apiUrl + await _getToken();
    return await http.put(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

}
