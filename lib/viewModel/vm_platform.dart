import 'package:cyoap_flutter/model/abstract_platform.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/choiceNode/choice_node.dart';
import '../model/editor.dart';
import '../util/tuple.dart';
import '../view/view_choice_node.dart';

class VMPlatform extends GetxController{
  List<List<Widget>> widgetList = List.empty(growable: true);

  void updateWidgetList(){
    widgetList.clear();
    for(var node in AbstractPlatform.instance.choiceNodes) {
      while(widgetList.length <= node.y){
        widgetList.add(List.empty(growable: true));
      }
      widgetList[node.y].insert(node.x, getWidgetFromType(node.type, node.x, node.y));
    }
    update();
  }

  Widget getWidgetFromType(int type, int x, int y) {
    switch (type) {
      case 0:
        return ViewTextWithoutCardNode(posX: x, posY: y);
      case 1:
        return ViewChoiceTextNode(posX: x, posY: y);
      case 2:
        return ViewChoiceNodeImage(posX: x, posY: y);
      default:
        return ViewChoiceNodeTextWithImage(posX: x, posY: y);
    }
  }

  Tuple<int, int> getSize(Tuple<int, int> position) {
    for (var node in AbstractPlatform.instance.choiceNodes) {
      if (node.x == position.data1 && node.y == position.data2) {
        return Tuple(node.width, node.height);
      }
    }
    return Tuple(1, 1);
  }

  void setEdit(int posX, int posY) {
    var node = AbstractPlatform.instance.getChoiceNode(posX, posY);

    if(node == null){
      return;
    }
    ChoiceNodeBase nodeNonnull = node;
    NodeEditor.instance.setTarget(nodeNonnull);
  }
}