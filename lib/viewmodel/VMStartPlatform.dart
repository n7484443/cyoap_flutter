import 'dart:collection';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/AbstractPlatform.dart';
import '../model/FrequentPath.dart';

class VMStartPlatform extends ChangeNotifier {
  FrequentlyUsedPath frequentlyUsedPath = FrequentlyUsedPath();
  var pathQueue = Queue<String>();
  int selected = -1;

  Future<bool> _getStatuses() async {
    await [Permission.storage, Permission.camera].request();

    return Future.value(Permission.storage.isGranted);
  }

  Future<num> openDirectory() async {
    if (Platform.isAndroid || Platform.isIOS) {
      var status = await _getStatuses();
      if (!status) {
        return -1;
      }
    }
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      pathQueue = frequentlyUsedPath.addFrequentPath(selectedDirectory);
      notifyListeners();
      return 0;
    }
    return -1;
  }

  void setDirectory(){
    if(selected >= -1){
      AbstractPlatform.createPlatform(pathQueue.toList().reversed.elementAt(selected));
    }
  }

  void initFrequentPath() {
    frequentlyUsedPath.getFrequentPathFromData().then((value) {
      pathQueue = value;
      notifyListeners();
    });
  }

  void selectFrequentPath(int index) {
    selected = index;
    notifyListeners();
  }

  void removeFrequentPath(int index){
    frequentlyUsedPath.removeFrequentPath(index).then((value) {
      pathQueue = value;
      notifyListeners();
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
