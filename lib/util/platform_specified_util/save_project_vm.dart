import 'dart:io';

import 'package:archive/archive.dart';
import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart';
import 'package:cyoap_flutter/util/platform_specified_util/webp_converter.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:tuple/tuple.dart';

class SaveProjectImp extends SaveProject {
  @override
  String convertImageName(String name) {
    return name.replaceAll(RegExp('[.](png|jpg|jpeg)'), '.webp');
  }

  @override
  Future<Tuple2<String, Uint8List>> convertImage(
      String name, Uint8List data) async {
    return await getWebpConverterInstance().convert(data, name);
  }

  Future<Uint8List> mapToArchive(Map<String, dynamic> dataInput) async {
    var map = await getMap(dataInput);

    var archive = Archive();
    for (var name in map.keys) {
      var data = map[name]!;
      archive.addFile(ArchiveFile(name, data.length, data));
    }

    return ZipEncoder().encode(archive, level: Deflate.BEST_SPEED) as Uint8List;
  }

  @override
  Future<void> saveZip(String name, Map<String, dynamic> dataInput) async {
    var uint8data = await compute(mapToArchive, dataInput);

    var file = File('$name/extract.zip');
    int i = 0;
    while (file.existsSync()) {
      file = File('$name/extract_$i.zip');
      i++;
    }
    await file.create();
    await file.writeAsBytes(uint8data);
  }

  @override
  Future<void> saveRaw(String path, Map<String, dynamic> dataInput) async {
    var map = await getMap(dataInput);

    var existMap = List<String>.empty(growable: true);
    Directory dirNode = Directory('$path/nodes');
    if (await dirNode.exists()) {
      var nameList = dirNode
          .listSync(recursive: true)
          .map((e) => ('nodes/${basename(e.path)}'))
          .toList();
      existMap.addAll(nameList);
    }
    Directory dirImages = Directory('$path/images');
    if (await dirImages.exists()) {
      var nameList = dirImages
          .listSync(recursive: true)
          .map((e) => ('images/${basename(e.path)}'))
          .toList();
      existMap.addAll(nameList);
    }

    var needRemove = existMap.toSet().difference(map.keys.toSet());

    for (var name in needRemove) {
      File f = File('$path/$name');
      await f.delete(recursive: true);
    }

    for (var name in map.keys) {
      var data = map[name]!;
      File f = File('$path/$name');
      if (await f.exists()) {
        await f.delete();
      }
      await f.create(recursive: true);
      await f.writeAsBytes(data);
    }
  }

  @override
  Future<void> downloadCapture(String name, Uint8List data) async {
    var file = File(name);
    if (await file.exists()) {
      await file.delete();
    }
    await file.create();
    await file.writeAsBytes(data);
  }
}
