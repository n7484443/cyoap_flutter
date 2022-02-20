import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cyoap_flutter/model/platform_file_system.dart';

void saveRaw(String name, PlatformFileSystem platformFileSystem) async{
  await platformFileSystem.saveToFolder(name);
  print('save Done!');
}
void downloadCapture(String name, Uint8List data){
  var file = File('$name/extract.jpg');
  if(file.existsSync()){
    file.delete();
  }
  file.createSync();
  file.writeAsBytesSync(data);
}

void saveZip(String name, PlatformFileSystem platformFileSystem) async{
  var archive = await platformFileSystem.saveToZip();
  var encodedZip = ZipEncoder().encode(archive, level: Deflate.NO_COMPRESSION) as Uint8List;
  var file = File('$name/extract.zip');
  if(file.existsSync()){
    file.delete();
  }
  file.createSync();
  file.writeAsBytes(encodedZip);
}