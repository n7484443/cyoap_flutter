import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cyoap_flutter/model/platform_file_system.dart';
import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart';
import 'package:cyoap_flutter/util/platform_specified_util/webp_converter.dart';

import '../tuple.dart';

class SaveProjectImp extends SaveProject {
  @override
  Future<Tuple<String, Uint8List>> convertImage(
      String name, Uint8List data) async {
    return await getWebpConverterInstance().convert(data, name);
  }

  @override
  Future<void> saveZip(String name, Map<String, dynamic> dataInput) async {
    var map = await getMap(dataInput);

    var archive = Archive();
    for (var name in map.keys) {
      var data = map[name]!;
      archive.addFile(ArchiveFile(name, data.length, data));
    }

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

  @override
  Future<void> downloadCapture(String name, Uint8List data) async {
    var file = File(name);
    if (await file.exists()) {
      await file.delete();
    }
    await file.create();
    await file.writeAsBytes(data);
  }

  @override
  Future<void> saveRaw(
      String name, PlatformFileSystem platformFileSystem) async {
    await platformFileSystem.saveToFolder(name);
  }
}
