import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cyoap_flutter/model/image_db.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/platform_system.dart';
import '../view/view_choice_node.dart';

class VMPlatform extends GetxController{
  var stopwatch = Stopwatch().obs;

  void save(bool saveAsFile) async {
    stopwatch.update((val) => val?.reset());
    stopwatch.update((val) => val?.start());
    getPlatform().compress();
    getPlatform().generateRecursiveParser();

    List<String> choiceNodes = List<String>.empty(growable: true);
    for (var nodeY in getPlatform().choiceNodes) {
      for (var node in nodeY.data1) {
        choiceNodes.add(jsonEncode(node.toJson()));
      }
    }

    List<String> lineSetting = getPlatform()
        .choiceNodes
        .map((e) => jsonEncode(e.data2.toJson()))
        .toList();
    var input = {
      'bool': ConstList.isOnlyFileAccept(),
      'imageMap': await ImageDB.instance.imageMap,
      'imageSource': getPlatformFileSystem().imageSource,
      'platform': getPlatform().toJson(),
      'choiceNodes': choiceNodes,
      'lineSetting': lineSetting,
    };
    Future output;
    if (saveAsFile) {
      output = compute(PlatformSystem.instance.saveFile, input);
    } else {
      output = PlatformSystem.instance.saveFolder(getPlatformFileSystem());
    }
    var timer = Timer.periodic(const Duration(milliseconds: 10), (Timer timer){
      stopwatch.update((val) {});
    });
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
    var boundary = vmDraggable.captureKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary;
    var imageOutput = await boundary.toImage(pixelRatio: 1);
    var width = imageOutput.width;
    var height = imageOutput.height;
    var maxed = max<int>(width, height) + 1;

    imageOutput = await boundary.toImage(pixelRatio: 16383/maxed);
    var byteData = (await imageOutput.toByteData())!.buffer.asUint8List();

    Map<String, dynamic> map = {
      'uint8list': String.fromCharCodes(byteData),
      'width': imageOutput.width,
      'height': imageOutput.height,
      'isOnlyFileAccept' : ConstList.isOnlyFileAccept(),
      'path': PlatformSystem.instance.path,
    };

    var output = compute(getPlatformFileSystem().saveCapture, map);

    var timer = Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {
      stopwatch.update((val) {});
    });
    output.then((value) {
      stopwatch.update((val) => val?.stop());
      timer.cancel();
      Get.back();
    });
  }

  void loadVariable() {
    getPlatform().generateRecursiveParser();
    getPlatform().updateSelectable();
  }
}

Widget getChoiceWidget(bool isCard, int x, int y) {
  var widget = ViewChoiceNode(posX: x, posY: y);
  if (isCard) {
    return GetBuilder<VMDraggableNestedMap>(
      builder: (_) => Opacity(
        opacity: !_.isEditable() && !_.isSelectablePreCheck(x, y) ? 0.5 : 1.0,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: _.isSelect(x, y) ? Colors.lightBlueAccent : Colors.white,
              width: 6,
            ),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: ConstList.elevation,
          child: widget,
        ),
      ),
    );
  } else {
    return GetBuilder<VMDraggableNestedMap>(
      builder: (_) => Opacity(
        opacity: !_.isEditable() && !_.isSelectablePreCheck(x, y) ? 0.5 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: _.isSelect(x, y) ? Colors.lightBlueAccent : Colors.white,
                width: 6),
            color: Colors.white,
          ),
          child: widget,
        ),
      ),
    );
  }
}