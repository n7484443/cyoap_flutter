import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class DevicePreference {
  static final DevicePreference _projectPath = DevicePreference._init();
  factory DevicePreference() {
    return _projectPath;
  }

  DevicePreference._init();

  Future<int> get androidVersion async {
    var deviceInfoPlugin = DeviceInfoPlugin();
    var androidInfo = await deviceInfoPlugin.androidInfo;
    return androidInfo.version.sdkInt;
  }

  static Future<String> getProjectFolder(String? name) async {
    if (ConstList.isMobile()) {
      var dir = (await getExternalStorageDirectory())!;
      if (name == null) {
        return "${dir.path}/project";
      }
      return "${dir.path}/project/$name";
    }
    return name!;
  }

  static Future<String> getDownloadFolder() async {
    if (ConstList.isDesktop()) {
      return (await getDownloadsDirectory())!.path;
    }
    return "/storage/emulated/0/Download";
  }

  void removeFolder(String path) async {
    var directory = Directory(path);
    await directory.delete(recursive: true);
  }

  Future<List<String>> get frequentPathFromData async {
    if (ConstList.isMobile()) {
      var dir = await getProjectFolder(null);
      var directory = Directory(dir);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      return directory.listSync().map((e) => e.path).toList();
    } else {
      var prefs = await SharedPreferences.getInstance();
      return prefs.getStringList('cyoap_frequent_path') ?? [];
    }
  }

  Future<bool> setFrequentPathFromData(List<String> pathList) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setStringList('cyoap_frequent_path', pathList);
  }

  Future<bool> getSaveAsWebp() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool('saveAsWebp') ?? true;
  }

  Future<void> setSaveAsWebp(bool data) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool('saveAsWebp', data);
  }

  static Future<String?> getLocaleName() async{
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('cyoap_language');
  }
  static void setLocaleName(String str) async{
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('cyoap_language', str);
  }
}
