import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:cyoap_flutter/model/image_db.dart';
import 'package:cyoap_flutter/model/platform_file_system.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';

import '../util/platform_specified_util/save_project.dart';
import 'abstract_platform.dart';

class PlatformSystem {
  static PlatformSystem instance = PlatformSystem();
  PlatformFileSystem platformFileSystem = PlatformFileSystem();
  String? path;

  Future<void> platformInit() async{
    await ImageDB.instance.init();
  }

  Future<void> openPlatformZipForWeb(PlatformFile file) async {
    await platformInit();
    var bytes = file.bytes;
    if (bytes == null) return;

    var archiveBytes = ZipDecoder().decodeBytes(bytes);

    await platformFileSystem.createFromZip(archiveBytes);
  }

  Future<void> openPlatformZip(File file) async {
    await platformInit();
    var bytes = await file.readAsBytes();
    path = file.parent.path;

    var archiveBytes = ZipDecoder().decodeBytes(bytes);
    await platformFileSystem.createFromZip(archiveBytes);
  }

  Future<void> openPlatformJson(File file) async {
    await platformInit();
    path = file.parent.path;

    await platformFileSystem.createFromJson(file.readAsStringSync(), path!);
  }

  Future<void> openPlatformFolder(String path) async {
    await platformInit();
    this.path = path;
    await platformFileSystem.createFromFolder(path);
  }

  Future<void> openPlatformVoid() async {
    await platformInit();
    platformFileSystem.createFromVoid();
  }

  Future<void> saveFile(Map<String, dynamic> input) async{
    if(input['bool'] as bool){
      await getSaveProject().saveZip('exported.zip', input);
    }else{
      await getSaveProject().saveZip(path!, input);
    }
  }
  Future<void> saveFolder(PlatformFileSystem platformFileSystem) async{
    await getSaveProject().saveRaw(path!, platformFileSystem);
  }

  static String getImageName(int index) {
    return instance.platformFileSystem.getImageName(index);
  }

  static FutureBuilder getImage(String image){
    return instance.platformFileSystem.getImage(image);
  }

  static void addImage(String name, Uint8List data){
    ImageDB.instance.uploadImages(name, data);
  }

  static int getImageIndex(String name) {
    return instance.platformFileSystem.getImageIndex(name);
  }
}

AbstractPlatform getPlatform(){
  return getPlatformFileSystem().platform;
}

PlatformFileSystem getPlatformFileSystem(){
  return PlatformSystem.instance.platformFileSystem;
}
