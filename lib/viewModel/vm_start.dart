import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/check_update.dart';
import '../model/opening_file_folder.dart';
import '../model/platform_system.dart';

class VMStartPlatform extends GetxController {
  FrequentlyUsedPath frequentlyUsedPath = FrequentlyUsedPath();
  List<String> pathList = List.empty(growable: true);
  int selected = -1;
  List<Future<void>> isAdded = List.empty(growable: true);

  bool needUpdate = false;

  @override
  void onInit() {
    CheckUpdate.needUpdateCheck().then((value) {
      needUpdate = value;
      update();
    });
    super.onInit();
  }

  Future<num> openDirectory() async {
    if (ConstList.isMobile()) {
      var status = await frequentlyUsedPath.getStatuses();
      if (!status) {
        return -1;
      }
    }
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      pathList = frequentlyUsedPath.addFrequentPath(selectedDirectory);
      update();
      return 0;
    }
    return -1;
  }

  Future<num> openFile() async {
    if (ConstList.isMobile()) {
      var status = await frequentlyUsedPath.getStatuses();
      if (!status) {
        return -1;
      }
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip', 'json'],
    );
    if (result != null) {
      if (ConstList.isOnlyFileAccept()) {
        isAdded.add(
            PlatformSystem.instance.openPlatformZipForWeb(result.files.single));
        pathList.add(result.files.single.name);
      } else {
        pathList =
            frequentlyUsedPath.addFrequentPath(result.files.single.path!);
      }
      update();
      return 0;
    }
    return -1;
  }

  Future<bool> setDirectory() async {
    if (selected >= 0) {
      if (ConstList.isMobile()) {
        frequentlyUsedPath.getStatuses().then((value) {
          if (!value) {
            return false;
          }
        });
      }

      await Future.wait(isAdded);

      isAdded.clear();
      var path = pathList.reversed.elementAt(selected);
      if (ConstList.isOnlyFileAccept()) {
        return true;
      } else if (path.isNotEmpty) {
        if (path.endsWith('.zip')) {
          var file = File(path);
          await PlatformSystem.instance.openPlatformZip(file);
        } else if (path.endsWith('.json')) {
          var file = File(path);
          await PlatformSystem.instance.openPlatformJson(file);
        } else {
          await PlatformSystem.instance.openPlatformFolder(path);
        }
        return true;
      }
    } else {
      if (ConstList.isOnlyFileAccept()) {
        await PlatformSystem.instance.openPlatformVoid();
        return true;
      }
    }
    return false;
  }

  void initFrequentPath() {
    frequentlyUsedPath.getFrequentPathFromData().then((value) {
      pathList = value;
      update();
    });
  }

  void selectFrequentPath(int index) {
    selected = index;
    update();
  }

  void removeFrequentPath(int index) {
    frequentlyUsedPath.removeFrequentPath(index).then((value) {
      pathList = value;
      update();
    });
  }

  Color getColor(int index) {
    if (selected == index) {
      return Colors.blue;
    } else {
      return Colors.black54;
    }
  }

  void setEditable(bool bool) {
    getPlatformFileSystem().isEditable = bool;
  }
}
