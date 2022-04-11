import 'dart:convert';
import 'dart:typed_data';

import 'package:tuple/tuple.dart';

import '../../model/platform_file_system.dart';
import 'platform_specified_vm.dart'
if (dart.library.html) 'platform_specified_web.dart';

abstract class PlatformSpecified{
  static final PlatformSpecified _instance = PlatformSpecifiedImp();
  factory PlatformSpecified(){
    return _instance;
  }
  late final Distribute? distribute;
  late final SaveProject? saveProject;
  void init(){}
  void preInit(){}
}

abstract class Distribute {
  Future<Tuple2<List<String>, List<String>>> getImageNodeList() async {
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

  Future<Map<String, dynamic>> getMap(Map<String, dynamic> dataInput) async {
    Map<String, dynamic> map = {
      'platform.json': utf8.encode(dataInput['platform']),
      'imageSource.json': utf8.encode(jsonEncode(dataInput['imageSource']))
    };

    var image = dataInput['imageMap'] as Map<String, String>;
    var imageList = List.empty(growable: true);
    for (var name in image.keys) {
      var data = Uint8List.fromList(image[name]!.codeUnits);
      var output = await convertImage(name, data);
      map['images/${output.item1}'] = output.item2;
      imageList.add(output.item1);
    }

    var fileList = List.empty(growable: true);

    var lineSetting = dataInput['lineSetting'] as Map<String, String>;
    for (var nodeName in lineSetting.keys) {
      map['nodes/$nodeName'] = utf8.encode(lineSetting[nodeName]!) as Uint8List;
      fileList.add(nodeName);
    }
    map['images/list.json'] = utf8.encode(jsonEncode(imageList));
    map['nodes/list.json'] = utf8.encode(jsonEncode(fileList));

    return map;
  }

  Future<void> downloadCapture(String name, Uint8List data) async {
    throw UnimplementedError();
  }

  Future<void> saveZip(String name, Map<String, dynamic> dataInput) async {
    throw UnimplementedError();
  }

  Future<void> saveRaw(
      String name, PlatformFileSystem platformFileSystem) async {}
}

abstract class WebpConverter {
  Future<Tuple2<String, Uint8List>> convert(
      Uint8List input, String name) async =>
      throw "doesn't work in this platform";

  void init() {}
  bool canConvert() => false;
}