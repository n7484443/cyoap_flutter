import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class ProjectPath {
  static final ProjectPath _projectPath = ProjectPath._init();
  factory ProjectPath() {
    return _projectPath;
  }

  ProjectPath._init();

  List<String> pathList = List.empty(growable: true);

  Future<bool> get androidVersion async {
    var deviceInfoPlugin = DeviceInfoPlugin();
    var androidInfo = await deviceInfoPlugin.androidInfo;
    return androidInfo.version.sdkInt! >= 30;
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
    return "/storage/emulated/0/Download";
  }

  Future<List<String>> get frequentPathFromData async {
    if (ConstList.isMobile()) {
      var dir = await getProjectFolder(null);
      var directory = Directory(dir);
      if (!await directory.exists()) {
        await directory.create();
      }
      pathList.clear();
      for (var sub in directory.listSync()) {
        pathList.add(sub.path);
      }
    } else {
      var prefs = await SharedPreferences.getInstance();
      pathList = prefs.getStringList('cyoap_frequent_path') ?? [];
    }
    return pathList;
  }

  Future<bool> setFrequentPathFromData(List<String> list) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setStringList('cyoap_frequent_path', list);
  }

  Future<void> addFrequentPath(String path) async {
    pathList.add(path);
    await setFrequentPathFromData(pathList.toList());
  }

  Future<void> removeFrequentPath(int index) async {
    if (ConstList.isMobile()) {
      var dir = Directory(pathList[index]);
      await dir.delete(recursive: true);
      pathList = await frequentPathFromData;
    } else {
      pathList = await frequentPathFromData;
      pathList.removeAt(index);
      await setFrequentPathFromData(pathList.toList());
    }
  }

  Future<bool> getSaveAsWebp() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool('saveAsWebp') ?? true;
  }

  Future<void> setSaveAsWebp(bool data) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('saveAsWebp', data);
  }
}
