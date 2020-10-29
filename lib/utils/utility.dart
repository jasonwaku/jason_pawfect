import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class Utility {
  //
  static const String KEY = "IMAGE_KEY";

  static Future<String> getImageFromPreferences() async {
    final SharedPreferences imagePrefs = await SharedPreferences.getInstance();
    return imagePrefs.getString(KEY) ?? null;
  }

  static Future<bool> saveImageToPreferences(String value) async {
    final SharedPreferences imagePrefs = await SharedPreferences.getInstance();
    return imagePrefs.setString(KEY, value);
  }

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }


}

const MaterialColor appColor = const MaterialColor(
    0xff03b898,
    const<int, Color>{
      50: const Color(0xff03b898),
      100: const Color(0xff03b898),
      200: const Color(0xff03b898),
      300: const Color(0xff03b898),
      400: const Color(0xff03b898),
      500: const Color(0xff03b898),
      600: const Color(0xff03b898),
      700: const Color(0xff03b898),
      800: const Color(0xff03b898),
      900: const Color(0xff03b898),
    }
);