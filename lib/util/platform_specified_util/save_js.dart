import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cyoap_flutter/model/platform_file_system.dart';
import 'package:js/js.dart';

Future<void> saveRaw(String name, PlatformFileSystem platformFileSystem) async {
  var archive = await platformFileSystem.saveToZip();
  var encodedTar = ZipEncoder().encode(archive, level: Deflate.NO_COMPRESSION) as Uint8List;
  _exportRaw(name, encodedTar);
}
Future<void> saveZip(String name, PlatformFileSystem platformFileSystem) async {
}
void downloadCapture(String name, Uint8List data){
  _exportRaw(name, data);
}

@JS()
external void _exportRaw(String name, Uint8List data);