import 'dart:io';

import 'package:cyoap_flutter/main.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FrequentlyUsedPath {
  List<String> pathList = List.empty(growable: true);

  Future<bool> getStatuses() async {
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
    return await Permission.storage.isGranted;
  }

  Future<bool> get androidVersion async{
    var deviceInfoPlugin = DeviceInfoPlugin();
    var androidInfo = await deviceInfoPlugin.androidInfo;
    return androidInfo.version.sdkInt! >= 30;
  }

  static Future<String> getProjectFolder(String? name) async{
    if(ConstList.isMobile()){
      var dir = (await getExternalStorageDirectory())!;
      if(name == null){
        return "${dir.path}/project";
      }
      return "${dir.path}/project/$name";
    }
    return name!;
  }

  static Future<String> getDownloadFolder() async{
    return "/storage/emulated/0/Download";
  }

  Future<List<String>> get frequentPathFromData async {
    if(ConstList.isMobile()){
      var dir = await getProjectFolder(null);
      var directory = Directory(dir);
      if(!await directory.exists()){
        await directory.create();
      }
      pathList.clear();
      for (var sub in directory.listSync()){
        pathList.add(sub.path);
      }
    }else{
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
    if (pathList.contains(path)) {
      pathList.remove(path);
    }
    pathList.add(path);

    while (pathList.length > 10) {
      pathList.removeLast();
    }
    await setFrequentPathFromData(pathList.toList());
  }

  Future<void> removeFrequentPath(int index) async {
    pathList = await frequentPathFromData;
    pathList.removeAt(pathList.length - 1 - index);
    await setFrequentPathFromData(pathList.toList());
  }
}
