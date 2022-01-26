import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';
import '../model/abstract_platform.dart';
import '../model/opening_file_folder.dart';
import '../model/image_loader.dart';

class VMStartPlatform extends GetxController {
  FrequentlyUsedPath frequentlyUsedPath = FrequentlyUsedPath();
  List<String> pathList = [];
  int selected = -1;

  Future<bool> _getStatuses() async {
    await [Permission.storage, Permission.camera].request();

    return Future.value(Permission.storage.isGranted);
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
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if(result != null){
        openZipInWeb(result.files.single.bytes);
      }else{

      }
    }else{
      selectedDirectory = await FilePicker.platform.getDirectoryPath();
    }

    if (selectedDirectory != null) {
      pathList = frequentlyUsedPath.addFrequentPath(selectedDirectory);
      update();
      return 0;
    }
    return -1;
  }

  Future<bool> setDirectory() async{
    if(selected >= -1){
      var path = pathList.reversed.elementAt(selected);
      await ImageLoader.instance.loadImages(path);
      await AbstractPlatform.createPlatform(path);
      return true;
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
}
