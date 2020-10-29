import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pawfect/models/users/country_model.dart';
import 'package:pawfect/utils/network/call_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountryRepo {
  //
  String _countryApiUrl = 'countries/fetch_all';
  List<CountryModel> _countryList = new List<CountryModel>();

  //
  Future<List<CountryModel>> _fetchCountries() async {
//
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await CallApi().getData(_countryApiUrl);
    if (response.statusCode == 200) {
      List<dynamic> values = new List<dynamic>();
      values = json.decode(response.body);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            _countryList.add(CountryModel.fromJson(map));
            debugPrint('Id-------${map['id']}');
            debugPrint('code-------${map['code']}');
            debugPrint('dialCode-------${map['dial_code']}');
            debugPrint('name-------${map['name']}');
          }
        }
      }
      return _countryList;
    } else {
      return _countryList = [];
// If that call was not successful, throw an error.
//       throw Exception('Failed to load data');
    }
  }
}
