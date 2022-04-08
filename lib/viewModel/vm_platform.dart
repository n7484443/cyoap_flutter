import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cyoap_flutter/model/image_db.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/platform_system.dart';
import '../util/platform_specified_util/platform_specified.dart';
import '../util/tuple.dart';

class VMPlatform extends GetxController {
  @override
  void onInit() {
    if (ConstList.isDistributed) {
      doDistributeMode();
    }
    super.onInit();
  }

  var stopwatch = Stopwatch().obs;

  Future saveAsFile() async {
    Map<String, String> lineSetting = {};
    for (int i = 0; i < getPlatform().lineSettings.length; i++) {
      var line = getPlatform().lineSettings[i];
      lineSetting['lineSetting_${line.currentPos}.json'] =
          jsonEncode(line.toJson());
    }

    var input = {
      'imageMap': await ImageDB().imageMap,
      'imageSource': getPlatformFileSystem().imageSource,
      'platform': jsonEncode(getPlatform().toJson()),
      'lineSetting': lineSetting,
    };

    if (ConstList.isOnlyFileAccept()) {
      return await PlatformSpecified().saveProject!.saveZip('exported.zip', input);
    } else {
      return await PlatformSpecified().saveProject!.saveZip(PlatformSystem().path!, input);
    }
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
      output = PlatformSystem().saveFolder(getPlatformFileSystem());
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
    var ratio = 16383 / maxed;
    var isWebp = true;
    if(ratio < 1.2){
      ratio = 1.2;
      isWebp = false;
    }

    imageOutput = await boundary.toImage(pixelRatio: ratio);
    var byteData = (await imageOutput.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();

    if(isWebp){
      Future<Tuple<String, Uint8List>> output = compute(getPlatformFileSystem().saveCapture, byteData);
      output.then((value) {
        if (ConstList.isOnlyFileAccept()) {
          PlatformSpecified().saveProject!.downloadCapture(value.data1, value.data2);
        } else {
          PlatformSpecified().saveProject!.downloadCapture('${PlatformSystem().path}/${value.data1}', value.data2);
        }

        stopwatch.update((val) => val?.stop());
        timer.cancel();
        Get.back();
      });
    }else{
      if (ConstList.isOnlyFileAccept()) {
        PlatformSpecified().saveProject!.downloadCapture('exported.png', byteData);
      } else {
        PlatformSpecified().saveProject!.downloadCapture('${PlatformSystem().path}/exported.png', byteData);
      }

      stopwatch.update((val) => val?.stop());
      timer.cancel();
      Get.back();
    }
    VMDraggableNestedMap.isCapture = false;
  }

  void loadVariable() {
    getPlatform().generateRecursiveParser();
    getPlatform().updateSelectable();
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
    var value = await PlatformSpecified().distribute!.getImageNodeList();
    print('load start');
    loadString = '[ 로드 시작 ]';
    var imageList = value.data1;
    var nodeList = value.data2;
    for (var name in imageList) {
      ImageDB()
          .uploadImagesFuture(name, PlatformSpecified().distribute!.getFile('images/$name'));
    }
    loadString = '[ 이미지 로드 완료 ]';

    List<Future> futureMap = List.empty(growable: true);
    Map<String, String> nodeMap = {};
    for (var name in nodeList) {
      var future = PlatformSpecified().distribute!.getFileWithJson('nodes/$name');
      future.then((value) => nodeMap[name] = value);
      futureMap.add(future);
    }
    await Future.wait(futureMap);

    loadString = '[ 선택지 로드 완료 ]';
    print('node loaded');

    String imageSource = await PlatformSpecified().distribute!.getFileWithJson('imageSource.json');
    String platformData = await PlatformSpecified().distribute!.getFileWithJson('platform.json');
    loadString = '[ 로드 완료 ]';
    print('load end');
    stopwatchLoad.stop();
    timer.cancel();

    await PlatformSystem()
        .openPlatformList(nodeMap, imageSource, platformData);
    getPlatformFileSystem().isEditable = false;
    loaded = true;
    update();
  }
}
