import 'package:shared_preferences/shared_preferences.dart';

class PawfectSharedPrefs {
  PawfectSharedPrefs._privateConstructor();

  static final PawfectSharedPrefs instance = PawfectSharedPrefs._privateConstructor();

  setBooleanValue(String key, bool value) async {
    SharedPreferences pbPrefs = await SharedPreferences.getInstance();
    pbPrefs.setBool(key, value);
  }

  Future<bool> getBooleanValue(String key) async {
    SharedPreferences pbPrefs = await SharedPreferences.getInstance();
    return pbPrefs.getBool(key) ?? false;
  }
}