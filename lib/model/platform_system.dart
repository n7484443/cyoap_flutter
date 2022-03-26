import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:cyoap_flutter/model/image_db.dart';
import 'package:cyoap_flutter/model/platform_file_system.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';

import '../main.dart';
import '../util/platform_specified_util/platform_specified.dart';
import 'abstract_platform.dart';

class PlatformSystem {
  static PlatformSystem instance = PlatformSystem();
  PlatformFileSystem platformFileSystem = PlatformFileSystem();
  String? path;

  Future<void> openPlatformZipForWeb(PlatformFile file) async {
    var bytes = file.bytes;
    if (bytes == null) return;

    var archiveBytes = ZipDecoder().decodeBytes(bytes);

    await platformFileSystem.createFromZip(archiveBytes);
  }

  Future<void> openPlatformZip(File file) async {
    var bytes = await file.readAsBytes();
    path = file.parent.path;

    var archiveBytes = ZipDecoder().decodeBytes(bytes);
    await platformFileSystem.createFromZip(archiveBytes);
  }

  Future<void> openPlatformJson(File file) async {
    path = file.parent.path;

    await platformFileSystem.createFromJson(file.readAsStringSync(), path!);
  }

  Future<void> openPlatformFolder(String path) async {
    this.path = path;
    await platformFileSystem.createFromFolder(path);
  }

  Future<void> openPlatformList(Map<String, String> choiceNodes,
      String imageSource,
      String platform) async {
    await platformFileSystem.createPlatformList(choiceNodes, imageSource, platform);
  }

  Future<void> openPlatformVoid() async {
    platformFileSystem.createFromVoid();
  }

  Future<void> saveFolder(PlatformFileSystem platformFileSystem) async {
    await saveProject!.saveRaw(path!, platformFileSystem);
  }

  static String getImageName(int index) =>
    instance.platformFileSystem.getImageName(index);

  static FutureBuilder getImage(String image) => instance.platformFileSystem.getImage(image);

  static void addImage(String name, Uint8List data) {
    ImageDB.instance.uploadImages(name, data);
  }

  static int getImageIndex(String name) {
    return instance.platformFileSystem.getImageIndex(name);
  }
}

AbstractPlatform getPlatform() {
  if(getPlatformFileSystem().platform == null) {
    getPlatformFileSystem().platform = AbstractPlatform.none();
  }
  return getPlatformFileSystem().platform!;
}

bool isEditable() {
  return getPlatformFileSystem().isEditable;
}

PlatformFileSystem getPlatformFileSystem() {
  return PlatformSystem.instance.platformFileSystem;
}

TextStyle get titleFont {
  return ConstList.getFont(getPlatform().titleFont);
}

TextStyle get mainFont {
  return ConstList.getFont(getPlatform().mainFont);
}
