import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cyoap_flutter/model/platform_file_system.dart';

Future<void> saveRaw(String name, PlatformFileSystem platformFileSystem) async{
  await platformFileSystem.saveToFolder(name);
}
void downloadCapture(String name, Uint8List data){
  var file = File(name);
  if(file.existsSync()){
    file.delete();
  }
  file.createSync();
  file.writeAsBytesSync(data);
}

Future<void> saveZip(String name, PlatformFileSystem platformFileSystem) async{
  var archive = await platformFileSystem.saveToZip();
  var encodedZip = ZipEncoder().encode(archive, level: Deflate.NO_COMPRESSION) as Uint8List;
  var file = File('$name/extract.zip');
  int i = 0;
  while(file.existsSync()){
    file = File('$name/extract_$i.zip');
    i++;
  }
  file.createSync();
  file.writeAsBytes(encodedZip);
}