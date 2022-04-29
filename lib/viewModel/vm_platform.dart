import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cyoap_flutter/model/image_db.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

import '../main.dart';
import '../model/platform_system.dart';
import '../util/platform_specified_util/platform_specified.dart';

class VMPlatform extends GetxController {
  @override
  void onInit() {
    if (ConstList.isDistributed) {
      doDistributeMode();
    }
    super.onInit();
  }

  var stopwatch = Stopwatch().obs;

  void save(bool toFile) async {
    stopwatch.update((val) => val?.reset());
    stopwatch.update((val) => val?.start());

    var timer = Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {
      stopwatch.update((val) {});
    });

    getPlatform.compress();
    getPlatform.generateRecursiveParser();

    Future output;
    if (toFile) {
      output = getPlatformFileSystem.saveAsFile();
    } else {
      output = getPlatformFileSystem.saveAsFolder();
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
    var vmDraggable = Get.find<VMDraggableNestedMap>();
    vmDraggable.isCapture = true;
    vmDraggable.update();

    var timer = Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {
      stopwatch.update((val) {});
    });

    Timer(const Duration(seconds: 1), () async {
      var boundary = vmDraggable.captureKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary;
      var imageOutput = await boundary.toImage(pixelRatio: 1);
      var width = imageOutput.width;
      var height = imageOutput.height;
      var maxed = max<int>(width, height) + 1;
      var ratio = 16383 / maxed;
      var isWebp = true;
      if (ratio < 1.2) {
        ratio = 1.2;
        isWebp = false;
      }

      imageOutput = await boundary.toImage(pixelRatio: ratio);
      var byteData =
          (await imageOutput.toByteData(format: ImageByteFormat.png))!
              .buffer
              .asUint8List();

      if (isWebp) {
        Future<Tuple2<String, Uint8List>> output =
            compute(getPlatformFileSystem.saveCapture, byteData);
        output.then((value) {
          if (ConstList.isOnlyFileAccept()) {
            PlatformSpecified()
                .saveProject!
                .downloadCapture(value.item1, value.item2);
          } else {
            PlatformSpecified().saveProject!.downloadCapture(
                '${getPlatformFileSystem.path}/${value.item1}', value.item2);
          }

          stopwatch.update((val) => val?.stop());
          timer.cancel();
          Get.back();
        });
      } else {
        if (ConstList.isOnlyFileAccept()) {
          PlatformSpecified()
              .saveProject!
              .downloadCapture('exported.png', byteData);
        } else {
          PlatformSpecified().saveProject!.downloadCapture(
              '${getPlatformFileSystem.path}/exported.png', byteData);
        }

        stopwatch.update((val) => val?.stop());
        timer.cancel();
        Get.back();
      }
      vmDraggable.isCapture = false;
    });
  }

  void loadVariable() {
    getPlatform.generateRecursiveParser();
    getPlatform.updateStatusAll();
  }

  var loadString = '';
  var loaded = false;
  var stopwatchLoad = Stopwatch();

  Future<void> doDistributeMode() async {
    stopwatchLoad.start();
    var timer = Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {
      update();
    });

    print('web is Distribute mode');

    loadString = '[ 로드 시작 ]';
    var nodeList = await PlatformSpecified().distribute!.getNodeList();
    print('load start');
    loadString = '[ 선택지 로드중 ]';
    List<Future> futureMap = List.empty(growable: true);
    Map<String, String> nodeMap = {};
    for (var name in nodeList) {
      var future = PlatformSpecified().distribute!.getFileAsJson('nodes/$name');
      future.then((value) => nodeMap[name] = value);
      futureMap.add(future);
    }
    await Future.wait(futureMap);

    loadString = '[ 구조 생성중 ]';
    print('node loaded');

    String imageSource =
        await PlatformSpecified().distribute!.getFileAsJson('imageSource.json');
    String platformData =
        await PlatformSpecified().distribute!.getFileAsJson('platform.json');
    loadString = '[ 로드 완료 ]';
    print('load end');
    stopwatchLoad.stop();
    timer.cancel();

    await PlatformSystem().openPlatformList(nodeMap, imageSource, platformData);
    getPlatformFileSystem.isEditable = false;
    loaded = true;
    update();
  }
}
