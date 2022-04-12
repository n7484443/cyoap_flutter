import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/check_update.dart';
import '../model/opening_file_folder.dart';
import '../model/platform_system.dart';

class VMStartPlatform extends GetxController {
  FrequentlyUsedPath frequentlyUsedPath = FrequentlyUsedPath();
  List<Future<void>> isAdded = List.empty(growable: true);

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
      if (ConstList.isOnlyFileAccept()) {
        isAdded.add(PlatformSystem().openPlatformZipForWeb(result.files.single));
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
      if (ConstList.isOnlyFileAccept()) {
        return true;
      } else if (path.isNotEmpty) {
        if (path.endsWith('.zip')) {
          var file = File(path);
          await PlatformSystem().openPlatformZip(file);
        } else if (path.endsWith('.json')) {
          var file = File(path);
          await PlatformSystem().openPlatformJson(file);
        } else {
          await PlatformSystem().openPlatformFolder(path);
        }
        return true;
      }
    } else if (ConstList.isOnlyFileAccept()) {
      await PlatformSystem().openPlatformVoid();
      return true;
    }
    return false;
  }

  set select(int index){
    if(index == selected.value){
      selected.value = -1;
    }else{
      selected.value = index;
    }
  }

  void removeFrequentPath(int index) async {
    await frequentlyUsedPath.removeFrequentPath(index);
    pathList.clear();
    pathList.addAll(frequentlyUsedPath.pathList);
  }

  set editable(bool b) => getPlatformFileSystem.isEditable = b;
}
