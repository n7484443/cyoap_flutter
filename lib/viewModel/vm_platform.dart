import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

import '../model/choiceNode/choice_node.dart';
import '../model/editor.dart';
import '../model/platform_system.dart';
import '../util/tuple.dart';
import '../view/view_choice_node.dart';

class VMPlatform extends GetxController{
  List<List<Widget>> widgetList = List.empty(growable: true);
  bool isDrag = false;

  void updateWidgetList(){
    widgetList.clear();

    var list = PlatformSystem.getPlatform().choiceNodes;
    for(int y = 0; y < list.length; y++) {
      widgetList.add(List.empty(growable: true));
      var xList = list[y];
      for(int x = 0; x < xList.length; x++){
        widgetList[y].insert(x, getWidgetFromType(xList[x].type, x, y));
      }
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
    var node = PlatformSystem.getPlatform().choiceNodes[position.data2][position.data1];
    return Tuple(node.width, node.height);
  }

  ChoiceNodeBase? getNode(int x, int y) {
    return PlatformSystem.getPlatform().choiceNodes[y][x];
  }

  void setEdit(int posX, int posY) {
    var node = PlatformSystem.getPlatform().getChoiceNode(posX, posY);

    if(node == null){
      return;
    }
    ChoiceNodeBase nodeNonnull = node;
    NodeEditor.instance.setTarget(nodeNonnull);
  }

  QuillController? getNodeController(int x, int y){
    var node = getNode(x, y);
    if(node == null)return null;
    if(node.contents.isEmpty){
      return QuillController.basic();
    }else{
      var json = jsonDecode(node.contents);
      return QuillController(
        document: Document.fromJson(json),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
  }

  void dragStart() {
    isDrag = true;
    update();
  }
  void dragEnd() {
    isDrag = false;
    update();
  }

  void changeData(Tuple<int, int> data, Tuple<int, int> pos) {
    PlatformSystem.getPlatform().changeData(data, pos);
    updateWidgetList();
  }

  bool isEditable(){
    return PlatformSystem.getPlatform().isEditable;
  }
}