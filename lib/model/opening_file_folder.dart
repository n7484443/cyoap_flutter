import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FrequentlyUsedPath {
  List<String> pathList = List.empty(growable: true);

  Future<bool> getStatuses() async {
    var deviceInfoPlugin = DeviceInfoPlugin();
    var androidInfo = await deviceInfoPlugin.androidInfo;

    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
    if (androidInfo.version.sdkInt! >= 30) {
      if (await Permission.manageExternalStorage.isDenied) {
        await Permission.manageExternalStorage.request();
      }
      return await Permission.storage.isGranted &&
          await Permission.manageExternalStorage.isGranted;
    } else {
      return await Permission.storage.isGranted;
    }
  }

  Future<List<String>> get frequentPathFromData async {
    var prefs = await SharedPreferences.getInstance();
    pathList = prefs.getStringList('cyoap_frequent_path') ?? [];
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
