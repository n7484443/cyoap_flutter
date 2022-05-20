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

  Future<List<String>> get frequentPathFromData async {
    if(ConstList.isMobile() && await androidVersion){
      var dir = await getApplicationDocumentsDirectory();
      dir = Directory("${dir.path}/project");
      if(!await dir.exists()){
        await dir.create();
      }
      pathList.clear();
      for (var sub in dir.listSync()){
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
