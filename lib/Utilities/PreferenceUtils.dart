import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static final String prefAuthToken = "apiToken";
  static final String prefUserDetails = "userDetails";
  static final String prefIsLoggedIn = "isUserLoggedIn";
  static final String prefResendTags = "resendTags";

  static setStringToSF(String key, String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, val);
  }

  static setIntToSF(String key, int val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, val);
  }

  static setDoubleToSF(String key, double val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, val);
  }

  static setBoolToSF(String key, bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, val);
  }

  static getStringValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString(key);
    return stringValue;
  }

  static getBoolValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool(key);
    return boolValue;
  }

  static getIntValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int intValue = prefs.getInt(key);
    return intValue;
  }

  static getDoubleValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return double
    double doubleValue = prefs.getDouble(key);
    return doubleValue;
  }

  static checkKeyExist(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool CheckValue = prefs.containsKey(key);
    return CheckValue;
  }

  static setObjectToSF(String key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  static getObject(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(key);
    if (data != null) {
      return json.decode(data);
    }
    return null;
  }
}
