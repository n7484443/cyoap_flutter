import 'dart:io';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:cyoap_flutter/model/platform_file_system.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'platform.dart';

class PlatformSystem {
  factory PlatformSystem() {
    return _instance;
  }

  PlatformSystem._init();

  static final PlatformSystem _instance = PlatformSystem._init();
  static final PlatformFileSystem platformFileSystem = PlatformFileSystem();

  Future<LoadProjectState> openPlatformZipForWeb(PlatformFile? file) async {
    if (file == null) {
      await PlatformSystem().openPlatformVoid();
      return LoadProjectState(ProjectState.success);
    }
    var bytes = file.bytes;
    if (bytes == null) return LoadProjectState(ProjectState.nonExist);

    var archiveBytes = ZipDecoder().decodeBytes(bytes);

    return await platformFileSystem.createFromZip(archiveBytes);
  }

  Future<LoadProjectState> openPlatformZip(File file) async {
    platformFileSystem.path = file.parent.path;
    var bytes = await file.readAsBytes();

    var archiveBytes = ZipDecoder().decodeBytes(bytes);
    return await platformFileSystem.createFromZip(archiveBytes);
  }

  Future<LoadProjectState> openPlatformJson(File file, Ref ref) async {
    platformFileSystem.path = file.parent.path;
    return await platformFileSystem.createFromJson(file.readAsStringSync(), ref);
  }

  Future<LoadProjectState> openPlatformFolder(String path) async {
    platformFileSystem.path = path;
    return await platformFileSystem.createFromFolder(path);
  }

  Future<LoadProjectState> openPlatformList(Map<String, String> choiceNodes, String imageSource, String platform) async {
    return await platformFileSystem.createPlatformList(choiceNodes, imageSource, platform);
  }

  Future<void> openPlatformVoid() async {
    platformFileSystem.createFromVoid();
  }
}

EditablePlatform get getPlatform {
  if (getPlatformFileSystem.platform == null) {
    PlatformSystem().openPlatformVoid();
  }
  return getPlatformFileSystem.platform!;
}

bool get isPlatformEditable => getPlatformFileSystem.isEditable;

PlatformFileSystem get getPlatformFileSystem => PlatformSystem.platformFileSystem;
