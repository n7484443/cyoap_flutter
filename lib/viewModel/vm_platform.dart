import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:cyoap_flutter/model/image_db.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/platform_system.dart';

class VMPlatform extends GetxController {
  var stopwatch = Stopwatch().obs;

  Future saveAsFile() async {
    Map<String, String> choiceNodes = {};
    Map<String, String> lineSetting = {};
    for (int i = 0; i < getPlatform().lineSettings.length; i++) {
      var line = getPlatform().lineSettings[i];
      lineSetting['lineSetting_${line.y}.json'] = jsonEncode(line.toJson());
    }

    var input = {
      'bool': ConstList.isOnlyFileAccept(),
      'imageMap': await ImageDB.instance.imageMap,
      'imageSource': getPlatformFileSystem().imageSource,
      'platform': jsonEncode(getPlatform().toJson()),
      'choiceNodes': choiceNodes,
      'lineSetting': lineSetting,
    };
    return compute(PlatformSystem.instance.saveFile, input);
  }

  void save(bool toFile) async {
    stopwatch.update((val) => val?.reset());
    stopwatch.update((val) => val?.start());

    var timer = Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {
      stopwatch.update((val) {});
    });

    getPlatform().compress();
    getPlatform().generateRecursiveParser();

    Future output;
    if (toFile) {
      output = saveAsFile();
    } else {
      output = PlatformSystem.instance.saveFolder(getPlatformFileSystem());
    }

    output.then((value) {
      stopwatch.update((val) => val?.stop());
      timer.cancel();
      Get.back();
    });

    Get.find<VMDraggableNestedMap>().isChanged = false;
  }

  void exportAsImage() async {
    stopwatch.update((val) => val?.reset());
    stopwatch.update((val) => val?.start());
    VMDraggableNestedMap.isCapture = true;
    Get.find<VMDraggableNestedMap>().update();

    var timer = Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {
      stopwatch.update((val) {});
    });

    var vmDraggable = Get.find<VMDraggableNestedMap>();
    var boundary = vmDraggable.captureKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary;
    var imageOutput = await boundary.toImage(pixelRatio: 1);
    var width = imageOutput.width;
    var height = imageOutput.height;
    var maxed = max<int>(width, height) + 1;

    imageOutput = await boundary.toImage(pixelRatio: 16383 / maxed);
    var byteData = (await imageOutput.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();

    Map<String, dynamic> map = {
      'uint8list': String.fromCharCodes(byteData),
      'isOnlyFileAccept': ConstList.isOnlyFileAccept(),
      'path': PlatformSystem.instance.path,
    };

    var output = compute(getPlatformFileSystem().saveCapture, map);

    output.then((value) {
      stopwatch.update((val) => val?.stop());
      timer.cancel();
      Get.back();
    });
    VMDraggableNestedMap.isCapture = false;
  }

  void loadVariable() {
    getPlatform().generateRecursiveParser();
    getPlatform().updateSelectable();
  }
}
