import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeStore {
  final _key = 'brightness';

  ValueNotifier<bool> brightnessDark = ValueNotifier<bool>(false);

  Future<void> loadTheme() async {
    brightnessDark.value = await getBrightnessDark();
  }

  Future<void> changeTheme(bool isDark) async {
    await _setPreferences(isDark);
    brightnessDark.value = isDark;
  }

  Future<bool> _setPreferences(bool value) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(_key, value);
  }

  Future<bool> getBrightnessDark() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(_key) ?? false;
  }
}
