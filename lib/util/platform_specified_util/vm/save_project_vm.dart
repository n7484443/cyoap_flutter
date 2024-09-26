import 'dart:io';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart';
import 'package:file_picker/file_picker.dart';
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
  Future<void> saveZip(String? path, Map<String, Uint8List> dataInput) async {
    var uint8data = await compute(mapToArchive, dataInput);

    if (ConstList.isMobile()) {
      var grantedUri = (await openDocumentTree());
      if (grantedUri == null) return;
      await createFile(grantedUri,
          mimeType: 'application/zip',
          displayName: 'extract.zip',
          bytes: uint8data);
      return;
    }
    path ??= await FilePicker.platform.getDirectoryPath();
    if (path == null) return;
    var file = File('$path/extract.zip');
    int i = 0;
    while (file.existsSync()) {
      file = File('$path/extract_$i.zip');
      i++;
    }
    await file.create();
    await file.writeAsBytes(uint8data);
  }

  Future<bool> checkZipSameFile(Uint8List a, Uint8List b) async {
    var zip = ZipDecoder();
    var archiveA = zip.decodeBytes(a);
    var archiveB = zip.decodeBytes(b);
    if (archiveA.length != archiveB.length) return false;
    for (int i = 0; i < archiveA.length; i++) {
      if (archiveA[i].name != archiveB[i].name) return false;
      var hashA =
          await calculateFileHash(data: archiveA[i].rawContent!.toUint8List());
      var hashB =
          await calculateFileHash(data: archiveB[i].rawContent!.toUint8List());
      if (hashA != hashB) return false;
    }
    return true;
  }

  @override
  Future<void> saveBackup(String path, Map<String, Uint8List> dataInput) async {
    var uint8data = await compute(mapToArchive, dataInput);

    var latest = await findMostRecentlyModifiedFile('$path/backup');
    if (latest != null &&
        await checkZipSameFile(uint8data, await latest.readAsBytes())) {
      print("same backup file. skip this backup");
      return;
    }

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

  Future<File?> findMostRecentlyModifiedFile(String directoryPath) async {
    final directory = Directory(directoryPath);

    if (!await directory.exists()) {
      print('Directory does not exist: $directoryPath');
      return null;
    }

    File? mostRecentFile;
    DateTime mostRecentModification = DateTime.fromMillisecondsSinceEpoch(0);

    await for (final entity
        in directory.list(recursive: false, followLinks: false)) {
      if (entity is File) {
        final lastModified = await entity.lastModified();
        if (lastModified.isAfter(mostRecentModification)) {
          mostRecentModification = lastModified;
          mostRecentFile = entity;
        }
      }
    }

    return mostRecentFile;
  }

  Future<String> calculateFileHash({File? file, Uint8List? data}) async {
    assert(file != null || data != null);
    try {
      final fileContents = data ?? await file!.readAsBytes();
      final hash = sha256.convert(fileContents);
      return hash.toString();
    } catch (e) {
      print('Error calculating hash: $e');
      return '';
    }
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
