import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cyoap_flutter/model/platform_file_system.dart';
import 'package:js/js.dart';

void saveRaw(String name, PlatformFileSystem platformFileSystem) async {
  var archive = await platformFileSystem.saveToTar();
  var encodedTar = TarEncoder().encode(archive) as Uint8List;
  _exportRaw(name, encodedTar);
}
void saveZip(String name, PlatformFileSystem platformFileSystem) async {
}
@JS()
external void _exportRaw(String name, Uint8List data);