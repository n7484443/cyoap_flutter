import 'dart:async';
import 'dart:convert';

import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      'imageMap': getPlatformFileSystem().imageMap,
      'imageSource': getPlatformFileSystem().imageSource,
      'platform': utf8.encode(jsonEncode(getPlatform().toJson())),
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
      stopwatch.update((val){});
    });
    output.then((value){
      stopwatch.update((val) => val?.stop());
      timer.cancel();
      Get.back();
    });

    Get.find<VMDraggableNestedMap>().isChanged = false;
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