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
    for (int y = 0; y < list.length; y++) {
      widgetList.add(List.empty(growable: true));
      var xList = list[y];
      for (int x = 0; x < xList.length; x++) {
        widgetList[y].insert(
            x, getWidgetFromType(xList[x].getType(), xList[x].isCard, x, y));
      }
    }
    update();
  }

  Widget getWidgetFromType(int type, bool isCard, int x, int y) {
    Widget widget;
    switch (type) {
      case 0:
        widget = ViewChoiceTextNode(posX: x, posY: y);
        break;
      case 1:
        widget = ViewChoiceNodeImage(posX: x, posY: y);
        break;
      default:
        widget = ViewChoiceNodeTextWithImage(posX: x, posY: y);
        break;
    }
    if (isCard) {
      return Card(
        elevation: 5.0,
        child: widget,
      );
    } else {
      return widget;
    }
  }

  Tuple<int, int> getSize(Tuple<int, int> position) {
    var node = getNode(position.data1, position.data2)!;
    return Tuple(node.width, node.height);
  }

  ChoiceNodeBase createNodeForTemp(){
    return ChoiceNodeBase.noTitle(1, 1, false, '', '');
  }

  ChoiceNodeBase? getNode(int x, int y) {
    if(x == -1 && y == -1){
      return createNodeForTemp();
    }
    return PlatformSystem.getPlatform().getChoiceNode(x, y);
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
    if(node.contentsString.isEmpty){
      return QuillController.basic();
    }else{
      var json = jsonDecode(node.contentsString);
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
    if(data == Tuple(-1, -1)){
      PlatformSystem.getPlatform().addData(pos.data1, pos.data2, createNodeForTemp());
      updateWidgetList();
    }else{
      PlatformSystem.getPlatform().changeData(data, pos);
      updateWidgetList();
    }
  }

  void removeData(Tuple<int, int> data) {
    PlatformSystem.getPlatform().removeData(data.data1, data.data2);
    updateWidgetList();
  }

  bool isEditable(){
    return PlatformSystem.getPlatform().isEditable;
  }

  void save(bool saveAsFile){
    if(saveAsFile){
      PlatformSystem.instance.saveFile();
    }else{
      PlatformSystem.instance.saveFolder();
    }
  }

  void addNode() {
    PlatformSystem.getPlatform().addData(0, 0, ChoiceNodeBase.noTitle(1, 1, true, '', ''));
    PlatformSystem.getPlatform().checkDataCollect();
    updateWidgetList();
  }
}