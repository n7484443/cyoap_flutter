import 'dart:convert';
import 'dart:typed_data';
import 'package:cyoap_flutter/model/platform_file_system.dart';
import 'package:isolated_worker/js_isolated_worker.dart';
import 'package:js/js.dart';

Future<void> saveRaw(String name, PlatformFileSystem platformFileSystem) async {
}
Future<void> saveZip(String name, Map<String, dynamic> dataInput) async {
  Map<String, dynamic> map = {
    'platform.json': utf8.encode(dataInput['platform']),
    'imageSource.json': utf8.encode(jsonEncode(dataInput['imageSource']))
  };

  var image = dataInput['imageMap'] as Map<String, String>;
  for(var name in image.keys){
    map['images/$name'] = image[name]!;
  }

  var choiceNodes = dataInput['choiceNodes'] as Map<String, String>;
  for(var nodeName in choiceNodes.keys){
    map['nodes/$nodeName'] = choiceNodes[nodeName];
  }

  var lineSetting = dataInput['lineSetting'] as Map<String, String>;
  for(var nodeName in lineSetting.keys){
    map['nodes/$nodeName'] = lineSetting[nodeName];
  }

  await JsIsolatedWorker().importScripts(['save_web.js', 'jszip.js']);
  Uint8List output = await JsIsolatedWorker().run(functionName: '_compressToZip', arguments: jsonEncode(map));
  downloadCapture(name, output);
}
Future<void> downloadCapture(String name, Uint8List data) async{
  _exportRaw(name, data);
}

@JS()
external void _exportRaw(String name, Uint8List data);