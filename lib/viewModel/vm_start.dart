import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';
import '../model/opening_file_folder.dart';
import '../model/platform_system.dart';

class VMStartPlatform extends GetxController {
  FrequentlyUsedPath frequentlyUsedPath = FrequentlyUsedPath();
  List<String> pathList = [];
  int selected = -1;

  Future<bool> _getStatuses() async {
    if(await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
    if(await Permission.manageExternalStorage.isDenied) {
      await Permission.manageExternalStorage.request();
    }

    return await Permission.storage.isGranted && await Permission.manageExternalStorage.isGranted;
  }

  Future<num> openDirectory() async {
    if(ConstList.actualPlatformType == platformType.mobile){
      var status = await _getStatuses();
      if (!status) {
        return -1;
      }
    }
    String? selectedDirectory;
    if(ConstList.actualPlatformType == platformType.web){
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['tar'],
      );
      if(result != null){
        PlatformSystem.instance.openPlatformZip(result.files.single);
        print(Uri.base);
        pathList.add(result.files.single.name);
        update();
        return 0;
      }
    }else{
      selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory != null) {
        pathList = frequentlyUsedPath.addFrequentPath(selectedDirectory);
        update();
        return 0;
      }
    }
    return -1;
  }

  Future<bool> setDirectory() async{
    if(selected >= 0){
      if(ConstList.actualPlatformType == platformType.mobile){
        var status = await _getStatuses();
        if (!status) {
          return false;
        }
      }

      var path = pathList.reversed.elementAt(selected);
      if(ConstList.actualPlatformType == platformType.web){
        return true;
      }else{
        await PlatformSystem.instance.openPlatformFolder(path).then((value) {
          return true;
        });
      }
    }else{
      if(ConstList.isFileSystem()){
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
}
