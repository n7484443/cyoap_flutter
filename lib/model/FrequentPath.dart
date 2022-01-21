import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';

class FrequentlyUsedPath{
  var pathQueue = Queue<String>();

  Future<Queue<String>> getFrequentPathFromData() async {
    var prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList('cyoap_frequent_path') ?? [];
    return Queue.from(list);
  }

  Future<bool> setFrequentPathFromData(List<String> list) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setStringList('cyoap_frequent_path', list);
  }

  Queue<String> addFrequentPath(String path) {
    if(pathQueue.contains(path)){
      pathQueue.remove(path);
    }
    pathQueue.add(path);

    while(pathQueue.length > 10){
      pathQueue.removeLast();
    }
    setFrequentPathFromData(pathQueue.toList());
    return pathQueue;
  }

  Future<Queue<String>> removeFrequentPath(int index) async{
    var before = await getFrequentPathFromData();
    pathQueue = Queue.from(before);
    pathQueue.remove(pathQueue.toList().reversed.elementAt(index));
    setFrequentPathFromData(pathQueue.toList());
    return pathQueue;
  }
}