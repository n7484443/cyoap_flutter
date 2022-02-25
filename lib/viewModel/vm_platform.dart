import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/platform_system.dart';
import '../view/view_choice_node.dart';

class VMPlatform extends GetxController{
  Stopwatch stopwatch = Stopwatch();

  void save(bool saveAsFile){
    PlatformSystem.getPlatform().compress();
    PlatformSystem.getPlatform().generateRecursiveParser();
    if(saveAsFile){
      PlatformSystem.instance.saveFile().then((value)=>saveEnd());
    }else{
      PlatformSystem.instance.saveFolder().then((value)=>saveEnd());
    }
    Get.find<VMDraggableNestedMap>().isChanged = false;
  }

  void saveEnd(){
    Get.back();
  }

  void loadVariable() {
    PlatformSystem.getPlatform().generateRecursiveParser();
    PlatformSystem.getPlatform().updateSelectable();
  }

  String getMaxSelect(int y){
    var max = PlatformSystem.getPlatform().getLineSetting(y)?.maxSelect;
    return max == -1 ? '무한' : '$max';
  }
}

Widget getWidgetFromType(int type, bool isCard, int x, int y) {
  Widget widget = ViewChoiceNodeTextWithImage(posX: x, posY: y);
  if (isCard) {
    return Card(
      elevation: 5.0,
      child: widget,
    );
  } else {
    return Material(
      color: Colors.white,
      child: widget,
    );
  }
}