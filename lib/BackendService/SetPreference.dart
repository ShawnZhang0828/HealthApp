import 'package:shared_preferences/shared_preferences.dart';

class PreferenceSetter {

  static writeInt (String key, int value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(key, value);
  }

  static writeBool (String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(key, value);
  }

  static writeDouble (String key, double value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble(key, value);
  }

  static writeString (String key, String value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(key, value);
  }

  static writeList (String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(key, value);
  }

  static readInt (String key) async {
    final prefs = await SharedPreferences.getInstance();

    final int? output = prefs.getInt(key);

    return output;
  }

  static readBool (String key) async {
    final prefs = await SharedPreferences.getInstance();

    final bool? output = prefs.getBool(key);

    return output;
  }

  static readDouble (String key) async {
    final prefs = await SharedPreferences.getInstance();

    final double? output = prefs.getDouble(key);

    return output;
  }

  static readString (String key) async {
    final prefs = await SharedPreferences.getInstance();

    final String? output = prefs.getString(key);

    return output;
  }

  static readStringList (String key) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String>? output = prefs.getStringList(key);

    return output;
  }

}