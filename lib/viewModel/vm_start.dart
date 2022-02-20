import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';
import '../model/check_update.dart';
import '../model/opening_file_folder.dart';
import '../model/platform_system.dart';

class VMStartPlatform extends GetxController {
  FrequentlyUsedPath frequentlyUsedPath = FrequentlyUsedPath();
  List<String> pathList = [];
  int selected = -1;
  List<Future<void>> isAdded = List.empty(growable: true);

  bool needUpdate = false;

  @override
  void onInit() {
    isNeedUpdate();
    super.onInit();
  }

  Future<bool> _getStatuses() async {
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
    if (await Permission.manageExternalStorage.isDenied) {
      await Permission.manageExternalStorage.request();
    }

    return await Permission.storage.isGranted &&
        await Permission.manageExternalStorage.isGranted;
  }

  Future<num> openDirectory() async {
    if (ConstList.actualPlatformType == platformType.mobile) {
      var status = await _getStatuses();
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
    if (ConstList.actualPlatformType == platformType.mobile) {
      var status = await _getStatuses();
      if (!status) {
        return -1;
      }
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    if (result != null) {
      if (ConstList.isOnlyFileAccept()) {
        isAdded.add(PlatformSystem.instance.openPlatformZip(result.files.single));
        pathList.add(result.files.single.name);
      } else {
        pathList = frequentlyUsedPath.addFrequentPath(result.files.single.path!);
      }
      update();
      return 0;
    }
    return -1;
  }

  Future<bool> setDirectory() async {
    if (selected >= 0) {
      if (ConstList.isMobile()) {
        _getStatuses().then((value) {
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
      } else if(path.isNotEmpty){
        if(path.endsWith('.zip')){
          var file = File(path);
          await PlatformSystem.instance.openPlatformZipFromFile(file);
        }else{
          await PlatformSystem.instance.openPlatformFolder(path);
        }
        return true;
      }
    }else{
      if(ConstList.isOnlyFileAccept()){
        PlatformSystem.instance.openPlatformVoid();
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

  void removeFrequentPath(int index){
    frequentlyUsedPath.removeFrequentPath(index).then((value) {
      pathList = value;
      update();
    });
  }

  Color getColor(int index) {
    if (selected == index) {
      return Colors.blue;
    } else {
      return Colors.red;
    }
  }

  void setEditable(bool bool) {
    PlatformSystem.getPlatform().isEditable = bool;
  }

  void isNeedUpdate(){
    CheckUpdate.needUpdateCheck().then((value) {
      needUpdate = value;
      update();
    });
  }
}
