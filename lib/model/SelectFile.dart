import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class SelectFile {
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
    var status = await _getStatuses();
    if(!status) {
      return -1;
    }
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      createPlatform(selectedDirectory);
      return 0;
    }
    return -1;
  }

  void createPlatform(String directory) {}
}
