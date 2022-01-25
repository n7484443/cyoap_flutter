import 'package:cyoap_flutter/model/abstract_platform.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/view_choice_node.dart';

class VMPlatform extends GetxController{
  List<List<Widget>> widgetList = List.empty(growable: true);

  void updateWidgetList(){
    widgetList.clear();
    for(var node in AbstractPlatform.instance.choiceNodes) {
      while(widgetList.length <= node.y){
        widgetList.add(List.empty(growable: true));
      }
      widgetList[node.y].insert(node.x, getWidgetFromType(node.type));
    }
    update();
  }

  Widget getWidgetFromType(int type){
    switch(type){
      case 0:
        return const ViewTextWithoutCardNode();
      case 1:
        return const ViewChoiceTextNode();
      case 2:
        return const ViewChoiceNodeImage();
      default:
        return const ViewChoiceNodeTextWithImage();
    }
  }
}