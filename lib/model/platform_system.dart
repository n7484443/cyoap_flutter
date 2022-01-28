@JS()
library _exportRaw;

import 'package:js/js.dart';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:cyoap_flutter/model/platform_file_system.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';

import '../main.dart';
import 'abstract_platform.dart';

class PlatformSystem{
  static PlatformSystem instance = PlatformSystem();
  PlatformFileSystem platformFileSystem = PlatformFileSystem();

  void openPlatformZip(PlatformFile file){
    var bytes = file.bytes;
    if(bytes == null)return;

    var archiveBytes = TarDecoder().decodeBytes(bytes);
    platformFileSystem.createFromTar(archiveBytes);
  }

  Future<void> openPlatformFolder(String path) async {
    await platformFileSystem.createFromFolder(path);
  }

  static Image getImage(String image){
    return instance.platformFileSystem.getImage(image);
  }

  static AbstractPlatform getPlatform(){
    return instance.platformFileSystem.platform;
  }


  void saveFile() async{
    if(ConstList.isFileSystem()){
      var archive = await platformFileSystem.saveToTar();
      var encodedTar = TarEncoder().encode(archive) as Uint8List;
      _exportRaw('exported.tar', encodedTar);
    }else{
    }
  }
}

@JS()
external void _exportRaw(String name, Uint8List data);
