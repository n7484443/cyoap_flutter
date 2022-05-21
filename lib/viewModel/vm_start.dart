import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../util/check_update.dart';
import '../model/opening_file_folder.dart';
import '../model/platform_system.dart';

class VMStartPlatform extends GetxController {
  FrequentlyUsedPath frequentlyUsedPath = FrequentlyUsedPath();
  List<Future<void>> isAdded = List.empty(growable: true);
  TextEditingController textInputController = TextEditingController();

  var needUpdate = false.obs;
  var version = ''.obs;
  var pathList = <String>[].obs;
  var selected = (-1).obs;

  @override
  void onInit() {
    CheckUpdate.needUpdateCheck().then((value) {
      needUpdate.value = value;
      version.value = ConstList.version;
    });
    frequentlyUsedPath.frequentPathFromData.then((value) {
      pathList.clear();
      pathList.addAll(value);
    });
    super.onInit();
  }

  Future<int> addDirectory() async {
    if (ConstList.isMobile()) {
      var status = await frequentlyUsedPath.getStatuses();
      if (!status) {
        return -1;
      }
      textInputController.text = "";
      Get.dialog(
        AlertDialog(
          title: const Text("프로젝트명"),
          content: TextField(
            controller: textInputController,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () async {
                var path = await FrequentlyUsedPath.getProjectFolder(textInputController.text);
                await Directory(path).create(recursive: true);
                await frequentlyUsedPath.addFrequentPath(path);
                Get.back();
              },
              child: const Text('생성'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
      return 0;
    }
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      frequentlyUsedPath.addFrequentPath(selectedDirectory);
      pathList.clear();
      pathList.addAll(frequentlyUsedPath.pathList);
      return 0;
    }
    return -1;
  }

  Future<int> addFile() async {
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
      if (ConstList.isWeb()) {
        isAdded
            .add(PlatformSystem().openPlatformZipForWeb(result.files.single));
        pathList.add(result.files.single.name);
      } else {
        frequentlyUsedPath.addFrequentPath(result.files.single.path!);
        pathList.clear();
        pathList.addAll(frequentlyUsedPath.pathList);
      }
      return 0;
    }
    return -1;
  }

  Future<bool> openProject() async {
    if (selected.value >= 0) {
      if (ConstList.isMobile()) {
        if (!await frequentlyUsedPath.getStatuses()) {
          return false;
        }
      }

      await Future.wait(isAdded);

      isAdded.clear();
      var path = pathList[pathList.length - 1 - selected.value];
      if (ConstList.isWeb()) {
        return true;
      } else if (path.isNotEmpty) {
        if (path.endsWith('.zip')) {
          var file = File(path);
          if (!await file.exists()) {
            await removeFrequentPath(selected.value);
            return false;
          }
          await PlatformSystem().openPlatformZip(file);
        } else if (path.endsWith('.json')) {
          var file = File(path);
          if (!await file.exists()) {
            await removeFrequentPath(selected.value);
            return false;
          }
          await PlatformSystem().openPlatformJson(file);
        } else {
          var dir = Directory(path);
          if (!await dir.exists()) {
            await removeFrequentPath(selected.value);
            return false;
          }
          await PlatformSystem().openPlatformFolder(path);
        }
        return true;
      }
    } else if (ConstList.isWeb()) {
      await PlatformSystem().openPlatformVoid();
      return true;
    }
    return false;
  }

  set select(int index) {
    if (index == selected.value) {
      selected.value = -1;
    } else {
      selected.value = index;
    }
  }

  int get select => selected.value;

  Future<void> removeFrequentPath(int index) async {
    await frequentlyUsedPath.removeFrequentPath(index);
    pathList.clear();
    pathList.addAll(frequentlyUsedPath.pathList);
  }

  set editable(bool b) => getPlatformFileSystem.isEditable = b;
}
