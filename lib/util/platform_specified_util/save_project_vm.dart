import 'dart:io';

import 'package:archive/archive.dart';
import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:shared_storage/shared_storage.dart';

class SaveProjectImp extends SaveProject {
  Future<Uint8List> mapToArchive(Map<String, Uint8List> dataInput) async {
    var archive = Archive();
    for (var name in dataInput.keys) {
      var data = dataInput[name]!;
      archive.addFile(ArchiveFile(name, data.length, data));
    }

    return ZipEncoder().encode(archive, level: Deflate.BEST_SPEED) as Uint8List;
  }

  @override
  Future<void> saveZip(String name, Map<String, Uint8List> dataInput) async {
    var uint8data = await compute(mapToArchive, dataInput);

    if (ConstList.isMobile()) {
      var grantedUri = (await openDocumentTree())!;
      await createFile(grantedUri,
          mimeType: 'application/zip',
          displayName: 'extract.zip',
          bytes: uint8data);
      return;
    }
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
  Future<void> saveBackup(String path, Map<String, Uint8List> dataInput) async {
    var uint8data = await compute(mapToArchive, dataInput);
    var currentTime = DateTime.now();
    var formatDate =
        "${currentTime.year}-${currentTime.month}-${currentTime.day}_${currentTime.hour}-${currentTime.minute}";
    var name = '$path/backup/$formatDate.zip';
    if (!await Directory('$path/backup').exists()) {
      await Directory('$path/backup').create();
    }
    var file = File(name);
    await file.writeAsBytes(uint8data);
  }

  @override
  Future<void> saveRaw(String path, Map<String, Uint8List> dataInput) async {
    var existMap = List<String>.empty(growable: true);
    Directory dirNode = Directory('$path/nodes');
    if (!await dirNode.exists()) {
      await dirNode.create();
    }
    var nameList = dirNode
        .listSync(recursive: true)
        .map((e) => ('nodes/${basename(e.path)}'))
        .toList();
    existMap.addAll(nameList);

    Directory dirImages = Directory('$path/images');
    if (!await dirImages.exists()) {
      await dirImages.create();
    }
    nameList = dirImages
        .listSync(recursive: true)
        .map((e) => ('images/${basename(e.path)}'))
        .toList();
    existMap.addAll(nameList);

    var needRemove = existMap.toSet().difference(dataInput.keys.toSet());

    for (var name in needRemove) {
      File f = File('$path/$name');
      await f.delete(recursive: true);
    }

    for (var name in dataInput.keys) {
      var data = dataInput[name]!;
      File f = File('$path/$name');
      await f.writeAsBytes(data);
    }
  }

  @override
  Future<void> downloadCapture(String path, String name, Uint8List data) async {
    var fileName = name.split(".")[0];
    var ext = name.split(".")[1];
    var editName = "$fileName.$ext";
    int addNum = 0;
    while (await File("$path/$editName").exists()) {
      editName = '$fileName (${addNum++}).$ext';
    }
    var file = File("$path/$editName");
    print("$path/$editName");
    await file.create();
    await file.writeAsBytes(data);
  }
}
