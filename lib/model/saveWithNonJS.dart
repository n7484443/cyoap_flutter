import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cyoap_flutter/model/platform_file_system.dart';
import 'dart:io';

void saveRaw(String name, PlatformFileSystem platformFileSystem) async{
  await platformFileSystem.saveToFolder(name);
  print('save Done!');
}

void saveZip(String name, PlatformFileSystem platformFileSystem) async{
  var archive = await platformFileSystem.saveToTar();
  var encodedTar = TarEncoder().encode(archive) as Uint8List;
  var file = File('$name/extract.tar');
  if(file.existsSync()){
    file.delete();
  }
  file.createSync();
  file.writeAsBytes(encodedTar);
}