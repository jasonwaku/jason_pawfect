import 'package:dio/dio.dart';
import 'package:pawfect/models/users/country_model.dart';
import 'package:pawfect/utils/provider/db_provider.dart';

class ApiProvider{
  //
  final String _baseUrl = 'https://api.pawfect-balance.oz.to/';
  //
  //get all countries
  Future<List<CountryModel>> getAllCountries(url) async {
    final String fullUrl = _baseUrl+url;
    Response response = await Dio().get(fullUrl);

    return (response.data as List).map((country) {
      print('Inserting $country');
      DBProvider.db.createCountry(CountryModel.fromJson(country));
    }).toList();
  }

}