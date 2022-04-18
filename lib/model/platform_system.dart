import 'dart:io';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:cyoap_flutter/model/platform_file_system.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';

import 'abstract_platform.dart';

class PlatformSystem {
  factory PlatformSystem() {
    return _instance;
  }

  PlatformSystem._init();

  static final PlatformSystem _instance = PlatformSystem._init();
  static final PlatformFileSystem platformFileSystem = PlatformFileSystem();

  Future<void> openPlatformZipForWeb(PlatformFile file) async {
    var bytes = file.bytes;
    if (bytes == null) return;

    var archiveBytes = ZipDecoder().decodeBytes(bytes);

    await platformFileSystem.createFromZip(archiveBytes);
  }

  Future<void> openPlatformZip(File file) async {
    var bytes = await file.readAsBytes();
    platformFileSystem.path = file.parent.path;

    var archiveBytes = ZipDecoder().decodeBytes(bytes);
    await platformFileSystem.createFromZip(archiveBytes);
  }

  Future<void> openPlatformJson(File file) async {
    platformFileSystem.path = file.parent.path;
    await platformFileSystem.createFromJson(file.readAsStringSync());
  }

  Future<void> openPlatformFolder(String path) async {
    platformFileSystem.path = path;
    await platformFileSystem.createFromFolder(path);
  }

  Future<void> openPlatformList(Map<String, String> choiceNodes,
      String imageSource, String platform) async {
    await platformFileSystem.createPlatformList(
        choiceNodes, imageSource, platform);
  }

  Future<void> openPlatformVoid() async {
    platformFileSystem.createFromVoid();
  }

  static FutureBuilder getImage(String image) =>
      PlatformSystem.platformFileSystem.getImage(image);
}

AbstractPlatform get getPlatform {
  getPlatformFileSystem.platform ??= AbstractPlatform.none();
  return getPlatformFileSystem.platform!;
}

bool get isEditable => getPlatformFileSystem.isEditable;

PlatformFileSystem get getPlatformFileSystem => PlatformSystem.platformFileSystem;
