import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cyoap_flutter/model/choiceNode/choice_node.dart';
import 'package:cyoap_flutter/model/choiceNode/line_setting.dart';
import 'package:cyoap_flutter/model/image_db.dart';
import 'package:cyoap_flutter/model/platform_file_system.dart';

import '../../model/abstract_platform.dart';

Future<void> saveRaw(String name, PlatformFileSystem platformFileSystem) async{
  await platformFileSystem.saveToFolder(name);
}
Future<void> downloadCapture(String name, Uint8List data) async{
  var file = File(name);
  if(await file.exists()){
    await file.delete();
  }
  await file.create();
  await file.writeAsBytes(data);
}

Future<void> saveZip(String name, Map<String, dynamic> dataInput) async{
  Map<String, Uint8List> mapImage =
      ImageDB.fromImageMap(dataInput['imageMap']);
  Map<String, String> mapSource = dataInput['imageSource'];
  AbstractPlatform platform = AbstractPlatform.fromJson(jsonDecode(dataInput['platform']));
  Map<String, String> nodes = dataInput['choiceNodes'];
  Map<String, String> lineSetting = dataInput['lineSetting'];
  List<ChoiceNodeBase> nodeIn = List.empty(growable: true);
  List<LineSetting> lineIn = List.empty(growable: true);
  for(var nodeName in nodes.keys){
    nodeIn.add(ChoiceNodeBase.fromJson(jsonDecode(nodes[nodeName]!)));
  }
  for(var nodeName in lineSetting.keys){
    lineIn.add(LineSetting.fromJson(jsonDecode(lineSetting[nodeName]!)));
  }

  var archive = await platform.toArchive(nodeIn, lineIn,
      mapImage: mapImage, mapSource: mapSource);
  var encodedZip =
      ZipEncoder().encode(archive, level: Deflate.BEST_SPEED) as Uint8List;
  var file = File('$name/extract.zip');
  int i = 0;
  while (file.existsSync()) {
    file = File('$name/extract_$i.zip');
    i++;
  }
  await file.create();
  await file.writeAsBytes(encodedZip);

  archive.clear();
}