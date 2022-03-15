import 'dart:convert';
import 'dart:typed_data';

import '../../model/platform_file_system.dart';
import '../tuple.dart';
import 'save_project_vm.dart' if (dart.library.html) 'save_project_web.dart';

abstract class SaveProject {
  Future<Tuple<String, Uint8List>> convertImage(
      String name, Uint8List data) async {
    return Tuple(name, data);
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
      map['images/${output.data1}'] = output.data2;
      imageList.add(output.data1);
    }

    var fileList = List.empty(growable: true);
    var choiceNodes = dataInput['choiceNodes'] as Map<String, String>;
    for (var nodeName in choiceNodes.keys) {
      map['nodes/$nodeName'] = utf8.encode(choiceNodes[nodeName]!) as Uint8List;
      fileList.add(nodeName);
    }

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

SaveProjectImp getSaveProject() => SaveProjectImp();
