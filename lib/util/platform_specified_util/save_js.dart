import 'dart:convert';
import 'dart:typed_data';
import 'package:cyoap_flutter/model/platform_file_system.dart';
import 'package:isolated_worker/js_isolated_worker.dart';
import 'package:js/js.dart';

Future<void> saveRaw(String name, PlatformFileSystem platformFileSystem) async {
}
Future<void> saveZip(String name, Map<String, dynamic> dataInput) async {
  Map<String, dynamic> map = {
    'platform.json': utf8.encode(jsonEncode(dataInput['platform'])),
    'imageSource.json': utf8.encode(jsonEncode(dataInput['imageSource']))
  };

  var image = dataInput['imageMap'] as Map<String, String>;
  for(var name in image.keys){
    map['images/$name'] = image[name]!;
  }

  for(var node in dataInput['choiceNodes'] as List<String>){
    var decoded = jsonDecode(node);
    int y = decoded['y'];
    int x = decoded['x'];
    map['nodes/node_${y}_$x.json'] = node;
  }

  for(var node in dataInput['lineSetting'] as List<String>){
    var decoded = jsonDecode(node);
    int y = decoded['y'];
    map['nodes/lineSetting_$y.json'] = node;
  }

  await JsIsolatedWorker().importScripts(['save_web.js', 'jszip.js', 'FileSaver.js']);
  Uint8List output = await JsIsolatedWorker().run(functionName: '_compressToZip', arguments: jsonEncode(map));
  downloadCapture(name, output);
}
Future<void> downloadCapture(String name, Uint8List data) async{
  _exportRaw(name, data);
}

@JS()
external void _exportRaw(String name, Uint8List data);