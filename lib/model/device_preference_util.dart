import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DevicePreferenceUtil {
  Future<int> get androidVersion async {
    var deviceInfoPlugin = DeviceInfoPlugin();
    var androidInfo = await deviceInfoPlugin.androidInfo;
    return androidInfo.version.sdkInt;
  }

  void removeFolder(String path) async {
    var directory = Directory(path);
    await directory.delete(recursive: true);
  }

  Future<bool> getBoolVariable(String option, {defaultValue = true}) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool(option) ?? defaultValue;
  }

  Future<void> setBoolVariable(String option, bool data) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool(option, data);
  }

  Future<int> getIntVariable(String option, {defaultValue = 0}) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt(option) ?? defaultValue;
  }

  Future<void> setIntVariable(String option, int data) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt(option, data);
  }

  Future<List<String>> getStringListVariable(String option, {defaultValue}) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(option) ?? defaultValue;
  }

  Future<void> setStringListVariable(String option, List<String> data) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(option, data);
  }

  Future<String> getStringVariable(String option, {defaultValue}) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(option) ?? defaultValue;
  }

  Future<void> setStringVariable(String option, String data) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(option, data);
  }
}
