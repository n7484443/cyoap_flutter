import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/AbstractPlatform.dart';

class ViewModelLoadPlatform {
  Future<bool> _getStatuses() async {
    Map<Permission, PermissionStatus> statuses =
    await [Permission.storage, Permission.camera].request();

    if (await Permission.storage.isGranted) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  Future<num> openDirectory() async {
    if(Platform.isAndroid || Platform.isIOS){
      var status = await _getStatuses();
      if(!status) {
        return -1;
      }
    }
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      AbstractPlatform.createPlatform(selectedDirectory);
      return 0;
    }
    return -1;
  }
}
