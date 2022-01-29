import 'package:archive/archive.dart';
import 'package:cyoap_flutter/model/platform_file_system.dart';
import 'package:js/js.dart';
import 'dart:typed_data';

void saveRaw(String name, PlatformFileSystem platformFileSystem) async{
  var archive = await platformFileSystem.saveToTar();
  var encodedTar = TarEncoder().encode(archive) as Uint8List;
  _exportRaw(name, encodedTar);
}

@JS()
external void _exportRaw(String name, Uint8List data);