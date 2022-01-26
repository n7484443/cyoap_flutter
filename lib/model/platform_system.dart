import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cyoap_flutter/model/platform_file_system.dart';
import 'package:flutter/widgets.dart';

import 'abstract_platform.dart';

class PlatformSystem{
  static PlatformSystem instance = PlatformSystem();
  PlatformFileSystem platformFileSystem = PlatformFileSystem();

  void openPlatformZip(Uint8List? fileData){
    if(fileData == null)return;
    var archive = ZipDecoder().decodeBytes(fileData);
    platformFileSystem.createFromZip(archive);
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
}