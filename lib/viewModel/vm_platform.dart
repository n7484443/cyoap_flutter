import 'dart:async';

import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

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

  void save(bool asZip) async {
    stopwatch.update((val) => val?.reset());
    stopwatch.update((val) => val?.start());

    var timer = Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {
      stopwatch.update((val) {});
    });

    getPlatform.compress();
    getPlatform.generateRecursiveParser();

    Future output = getPlatformFileSystem.save(asZip);

    output.then((value) {
      stopwatch.update((val) => val?.stop());
      timer.cancel();
      Get.back();
    });

    Get.find<VMDraggableNestedMap>().isChanged = false;
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

    if (kDebugMode) {
      print('web is Distribute mode');
    }

    loadString = '[ 로드 시작 ]';
    var nodeList = await PlatformSpecified().distribute!.getNodeList();
    if (kDebugMode) {
      print('load start');
    }
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
    if (kDebugMode) {
      print('node loaded');
    }

    String imageSource =
        await PlatformSpecified().distribute!.getFileAsJson('imageSource.json');
    String platformData =
        await PlatformSpecified().distribute!.getFileAsJson('platform.json');
    loadString = '[ 로드 완료 ]';
    if (kDebugMode) {
      print('load end');
    }
    stopwatchLoad.stop();
    timer.cancel();

    await PlatformSystem().openPlatformList(nodeMap, imageSource, platformData);
    getPlatformFileSystem.isEditable = false;
    loaded = true;
    update();
  }
}
