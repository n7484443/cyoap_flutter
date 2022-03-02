import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/platform_system.dart';
import '../view/view_choice_node.dart';

class VMPlatform extends GetxController{
  Stopwatch stopwatch = Stopwatch();

  void save(bool saveAsFile){
    getPlatform().compress();
    getPlatform().generateRecursiveParser();
    if(saveAsFile){
      PlatformSystem.instance.saveFile().then((value)=>Get.back());
    }else{
      PlatformSystem.instance.saveFolder().then((value)=>Get.back());
    }
    Get.find<VMDraggableNestedMap>().isChanged = false;
  }

  void loadVariable() {
    getPlatform().generateRecursiveParser();
    getPlatform().updateSelectable();
  }
}

Widget getWidgetFromType(bool isCard, int x, int y) {
  var widget = ViewChoiceNodeTextWithImage(posX: x, posY: y);
  if (isCard) {
    return GetBuilder<VMDraggableNestedMap>(
      builder: (_) => Opacity(
        opacity: !_.isEditable() && !_.isSelectablePreCheck(x, y) ? 0.5 : 1.0,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: _.isSelect(x, y) ? Colors.lightBlueAccent : Colors.white,
              width: 4,
            ),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 20.0,
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
                width: 4),
            color: Colors.white,
          ),
          child: widget,
        ),
      ),
    );
  }
}