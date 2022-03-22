import 'dart:async';
import 'dart:io';

import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/check_update.dart';
import '../model/image_db.dart';
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
    if (ConstList.isDistributed) {
      doDistributeMode();
    }
    super.onInit();
  }

  Future<num> openDirectory() async {
    if (ConstList.isMobile()) {
      var status = await frequentlyUsedPath.getStatuses();
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
        isAdded.add(
            PlatformSystem.instance.openPlatformZipForWeb(result.files.single));
        pathList.add(result.files.single.name);
      } else {
        pathList =
            frequentlyUsedPath.addFrequentPath(result.files.single.path!);
      }
      update();
      return 0;
    }
    return -1;
  }

  Future<bool> setDirectory() async {
    if (selected >= 0) {
      if (ConstList.isMobile()) {
        frequentlyUsedPath.getStatuses().then((value) {
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
      } else if (path.isNotEmpty) {
        if (path.endsWith('.zip')) {
          var file = File(path);
          await PlatformSystem.instance.openPlatformZip(file);
        } else if (path.endsWith('.json')) {
          var file = File(path);
          await PlatformSystem.instance.openPlatformJson(file);
        } else {
          await PlatformSystem.instance.openPlatformFolder(path);
        }
        return true;
      }
    } else {
      if (ConstList.isOnlyFileAccept()) {
        await PlatformSystem.instance.openPlatformVoid();
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

  void removeFrequentPath(int index) {
    frequentlyUsedPath.removeFrequentPath(index).then((value) {
      pathList = value;
      update();
    });
  }

  Color getColor(int index) {
    if (selected == index) {
      return Colors.blue;
    } else {
      return Colors.black54;
    }
  }

  void setEditable(bool bool) {
    getPlatform().isEditable = bool;
  }

  void isNeedUpdate() {
    CheckUpdate.needUpdateCheck().then((value) {
      needUpdate = value;
      update();
    });
  }

  var load = ''.obs;
  var stopwatch = Stopwatch().obs;
  void doDistributeMode() async {
    stopwatch.value.start();
    var timer = Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {
      stopwatch.update((val) {});
    });

    print('web is Distribute mode');
    var distribute = PlatformSpecified.instance.distribute;
    var value = await distribute.getImageNodeList();
    print('load start');
    load.value = '[ 로드 시작 ]';
    var imageList = value.data1;
    var nodeList = value.data2;
    for (var name in imageList) {
      ImageDB.instance.uploadImagesFuture(name, distribute.getFile('images/$name'));
    }
    load.value = '[ 이미지 로드 완료 ]';

    List<Future> futureMap = List.empty(growable: true);
    Map<String, String> nodeMap = {};
    for (var name in nodeList) {
      var future = distribute.getFileWithJson('nodes/$name');
      future.then((value) => nodeMap[name] = value);
      futureMap.add(future);
    }
    await Future.wait(futureMap);

    load.value = '[ 선택지 로드 완료 ]';
    print('node loaded');

    String imageSource = await distribute.getFileWithJson('imageSource.json');
    String platformData = await distribute.getFileWithJson('platform.json');
    load.value = '[ 로드 완료 ]';
    print('load end');
    stopwatch.value.stop();
    timer.cancel();

    await PlatformSystem.instance
        .openPlatformList(nodeMap, imageSource, platformData);
    Get.find<VMStartPlatform>().setEditable(false);
    Get.toNamed('/viewPlay');
  }
}
