import 'dart:async';
import 'dart:io';

import 'package:cyoap_flutter/view/util/view_back_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/opening_file_folder.dart';
import '../model/platform_system.dart';
import '../util/check_update.dart';

class VMStartPlatform extends GetxController {
  ProjectPath frequentlyUsedPath = ProjectPath();
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
                var path = await ProjectPath.getProjectFolder(
                    textInputController.text);
                await Directory(path).create(recursive: true);
                await updatePathList();
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
      await Future.wait(isAdded);

      isAdded.clear();
      var path = pathList[selected.value];
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
    if (!ConstList.isMobile()) {
      await frequentlyUsedPath.removeFrequentPath(index);
      pathList.clear();
      pathList.addAll(frequentlyUsedPath.pathList);
      await updatePathList();
    } else {
      Get.dialog(ViewWarningDialog(
        acceptFunction: () async {
          await frequentlyUsedPath.removeFrequentPath(index);
          await updatePathList();
        },
      ));
    }
  }

  set editable(bool b) => getPlatformFileSystem.isEditable = b;

  Future<void> updatePathList() async {
    pathList.clear();
    pathList.addAll(await frequentlyUsedPath.frequentPathFromData);
  }
}
