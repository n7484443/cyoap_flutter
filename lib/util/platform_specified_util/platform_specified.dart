import 'dart:convert';
import 'dart:typed_data';

import 'package:tuple/tuple.dart';

import 'platform_specified_vm.dart'
    if (dart.library.html) 'platform_specified_web.dart';

abstract class PlatformSpecified {
  static final PlatformSpecified _instance = PlatformSpecifiedImp();
  factory PlatformSpecified() {
    return _instance;
  }
  late final SaveProject? saveProject;
  void init() {}
  void preInit() {}
}

abstract class Distribute {
  Future<List<String>> getNodeList() async {
    throw UnimplementedError();
  }

  Future<Uint8List> getFileAsUint8(String f) async {
    throw UnimplementedError();
  }

  Future<String> getFileAsJson(String f) async {
    throw UnimplementedError();
  }
}

abstract class SaveProject {
  Future<Tuple2<String, Uint8List>> convertImage(
      String name, Uint8List data) async {
    return Tuple2(name, data);
  }

  void init();

  Future<Map<String, dynamic>> getMap(Map<String, dynamic> dataInput) async {
    Map<String, dynamic> map = {
      'platform.json': utf8.encode(dataInput['platform']),
      'imageSource.json': utf8.encode(jsonEncode(dataInput['imageSource']))
    };

    var image = dataInput['imageMap'] as Map<String, String>;
    for (var name in image.keys) {
      var data = Uint8List.fromList(image[name]!.codeUnits);
      var output = await convertImage(name, data);
      map['images/${output.item1}'] = output.item2;
    }

    var fileList = List.empty(growable: true);

    var lineSetting = dataInput['lineSetting'] as Map<String, String>;
    for (var nodeName in lineSetting.keys) {
      map['nodes/$nodeName'] = utf8.encode(lineSetting[nodeName]!) as Uint8List;
      fileList.add(nodeName);
    }
    map['nodes/list.json'] = utf8.encode(jsonEncode(fileList));

    return map;
  }

  Future<void> downloadCapture(String path, String name, Uint8List data) async {
    throw UnimplementedError();
  }

  Future<void> saveZip(String name, Map<String, dynamic> dataInput) async {
    throw UnimplementedError();
  }

  Future<void> saveRaw(String path, Map<String, dynamic> dataInput) async {}
}
