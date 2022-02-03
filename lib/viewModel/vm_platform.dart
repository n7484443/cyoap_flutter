import 'dart:convert';

import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:cyoap_flutter/viewModel/vm_variable_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  GlobalKey captureKey = GlobalKey();
  bool isChanged = false;
  Tuple<int, int> mouseHover = Tuple(-1, -1);
  Tuple<int, int> sizeSet = Tuple(1, 1);

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
    isChanged = true;
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
          child: widget
      );
    }
  }

  void setHover(int x, int y){
    mouseHover = Tuple(x, y);
    update();
  }

  Tuple<int, int> getSize(Tuple<int, int> position) {
    var node = getNode(position.data1, position.data2)!;
    return Tuple(node.width, node.height);
  }

  void setSize(Tuple<int, int> position, Tuple<int, int> size) {
    var node = getNode(position.data1, position.data2)!;
    node.width = size.data1;
    node.height = size.data2;
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
    isChanged = false;
  }

  void addNode() {
    PlatformSystem.getPlatform().addData(0, 0, ChoiceNodeBase.noTitle(1, 1, true, '', ''));
    PlatformSystem.getPlatform().checkDataCollect();
    updateWidgetList();
  }

  Future<void> exportAsImage() async {
    var boundary = captureKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    PlatformSystem.instance.saveCapture(await boundary.toImage());
  }

  void sizeChange(int x, int y){
    sizeSet.data1 += x;
    sizeSet.data2 += y;
    if (sizeSet.data1 < 1) {
      sizeSet.data1 = 1;
    }
    if (sizeSet.data2 < 1) {
      sizeSet.data2 = 1;
    }
    update();
  }

  void loadVariable() {
    VariableDataBase.instance.clear();
    for (var ys in PlatformSystem.getPlatform().choiceNodes) {
      for (var node in ys) {
        if(node.executeCodeRecursive != null){
          for (var codes in node.executeCodeRecursive!) {
            codes.unzip();
          }
        }
      }
    }
    Get.find<VMVariableTable>().update();
  }

  void select(int posX, int posY) {
    PlatformSystem.getPlatform().setSelect(posX, posY);
    update();
  }

  bool isSelect(int posX, int posY) {
    if(posX == -1 && posY == -1)return false;
    return PlatformSystem.getPlatform().isSelect(posX, posY);
  }
}