import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';
import '../model/abstract_platform.dart';
import '../model/frequently_used_path.dart';
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
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      pathList = frequentlyUsedPath.addFrequentPath(selectedDirectory);
      update();
      return 0;
    }
    return -1;
  }

  void setDirectory(){
    if(selected >= -1){
      var path = pathList.reversed.elementAt(selected);
      ImageLoader.instance.loadImages(path).then((value) {
        AbstractPlatform.createPlatform(path);
      });
    }
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
