import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cyoap_flutter/model/platform_file_system.dart';
import 'package:js/js.dart';

import '../../model/abstract_platform.dart';
import '../../model/choiceNode/choice_node.dart';
import '../../model/choiceNode/line_setting.dart';

Future<void> saveRaw(String name, PlatformFileSystem platformFileSystem) async {
}
Future<void> saveZip(String name, Map<String, dynamic> dataInput) async {
  Map<String, Uint8List> mapImage = PlatformFileSystem.fromImageMap(dataInput['imageMap']);
  Map<String, String> mapSource = dataInput['imageSource'];
  AbstractPlatform platform = AbstractPlatform.fromJson(jsonDecode(utf8.decode(dataInput['platform'])));
  List<String> nodes = dataInput['choiceNodes'];
  List<String> lineSetting = dataInput['lineSetting'];
  List<ChoiceNodeBase> nodeIn = nodes.map((e) => ChoiceNodeBase.fromJson(jsonDecode(e))).toList();
  List<LineSetting> lineIn = lineSetting.map((e) => LineSetting.fromJson(jsonDecode(e))).toList();
  var archive = await platform.toArchive(mapImage, mapSource, nodeIn, lineIn);
  var encodedTar = ZipEncoder().encode(archive, level: Deflate.NO_COMPRESSION) as Uint8List;
  _exportRaw(name, encodedTar);
}
Future<void> downloadCapture(String name, Uint8List data) async{
  _exportRaw(name, data);
}

@JS()
external void _exportRaw(String name, Uint8List data);