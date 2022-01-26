import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cyoap_flutter/model/platform_file_system.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FrequentlyUsedPath{
  List<String> pathList = [];

  Future<List<String>> getFrequentPathFromData() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('cyoap_frequent_path') ?? [];
  }

  Future<bool> setFrequentPathFromData(List<String> list) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setStringList('cyoap_frequent_path', list);
  }

  List<String> addFrequentPath(String path) {
    if(pathList.contains(path)){
      pathList.remove(path);
    }
    pathList.add(path);

    while(pathList.length > 10){
      pathList.removeLast();
    }
    setFrequentPathFromData(pathList.toList());
    return pathList;
  }

  Future<List<String>> removeFrequentPath(int index) async{
    print('asdf' + (pathList.length - 1 - index).toString());
    pathList = await getFrequentPathFromData();
    pathList.removeAt(pathList.length - 1 - index);
    setFrequentPathFromData(pathList.toList());
    print(pathList.length);
    return pathList;
  }
}
String openZipInWeb(Uint8List? fileData){
  if(fileData == null)return '';
  var archive = ZipDecoder().decodeBytes(fileData);
  PlatformFileSystem(archive);
  return '';
}