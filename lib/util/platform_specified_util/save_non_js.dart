import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cyoap_flutter/model/choiceNode/choice_node.dart';
import 'package:cyoap_flutter/model/choiceNode/line_setting.dart';
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
      PlatformFileSystem.fromImageMap(dataInput['imageMap']);
  Map<String, String> mapSource = dataInput['imageSource'];
  AbstractPlatform platform = AbstractPlatform.fromJson(jsonDecode(jsonEncode(dataInput['platform'])));
  List<String> nodes = dataInput['choiceNodes'];
  List<String> lineSetting = dataInput['lineSetting'];
  List<ChoiceNodeBase> nodeIn =
      nodes.map((e) => ChoiceNodeBase.fromJson(jsonDecode(e))).toList();
  List<LineSetting> lineIn =
      lineSetting.map((e) => LineSetting.fromJson(jsonDecode(e))).toList();

  var archive = await platform.toArchive(nodeIn, lineIn,
      mapImage: mapImage, mapSource: mapSource);
  var encodedZip =
      ZipEncoder().encode(archive, level: Deflate.NO_COMPRESSION) as Uint8List;
  var file = File('$name/extract.zip');
  int i = 0;
  while (file.existsSync()) {
    file = File('$name/extract_$i.zip');
    i++;
  }
  await file.create();
  await file.writeAsBytes(encodedZip);
}