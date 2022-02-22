import 'dart:convert';

import 'package:cyoap_flutter/main.dart';
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
  Tuple<int, int>? drag;
  bool isChanged = false;
  Tuple<int, int> mouseHover = Tuple(-1, -1);
  Tuple<int, int> sizeSet = Tuple(1, 1);

  GlobalKey captureKey = GlobalKey();
  GlobalKey keyListView = GlobalKey();

  ScrollController scroller = ScrollController();

  void updateWidgetList(){
    widgetList.clear();

    var list = PlatformSystem.getPlatform().choiceNodes;
    for (int y = 0; y < list.length; y++) {
      widgetList.add(List.empty(growable: true));
      var xList = list[y];
      for (int x = 0; x < xList.data1.length; x++) {
        widgetList[y].insert(
            x, getWidgetFromType(xList.data1[x].getType(), xList.data1[x].isCard, x, y));
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
        child: widget,
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

  QuillController? getNodeController(int x, int y) {
    var node = getNode(x, y);
    if (node == null || node.contentsString.isEmpty) {
      return QuillController.basic();
    } else {
      var json = jsonDecode(node.contentsString);
      var document = Document.fromJson(json);
      return QuillController(
          document: document,
          selection: const TextSelection.collapsed(offset: 0));
    }
  }

  void dragStart(int posX, int posY) {
    drag = Tuple(posX, posY);
    update();
  }
  void dragEnd() {
    drag = null;
    update();
  }

  void changeData(Tuple<int, int> data, Tuple<int, int> pos) {
    if(data == Tuple(-1, -1)){
      PlatformSystem.getPlatform().addData(pos.data1, pos.data2, createNodeForTemp());
    }else{
      PlatformSystem.getPlatform().changeData(data, pos);
    }
    updateWidgetList();
  }

  void removeData(Tuple<int, int> data) {
    PlatformSystem.getPlatform().removeData(data.data1, data.data2);
    updateWidgetList();
  }

  bool isEditable(){
    return PlatformSystem.getPlatform().isEditable;
  }

  void save(bool saveAsFile){
    PlatformSystem.getPlatform().compress();
    PlatformSystem.getPlatform().generateRecursiveParser();
    if(saveAsFile){
      PlatformSystem.instance.saveFile().then((value)=>saveEnd());
    }else{
      PlatformSystem.instance.saveFolder().then((value)=>saveEnd());
    }
    isChanged = false;
  }

  void saveEnd(){
    Get.back();
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
    PlatformSystem.getPlatform().generateRecursiveParser();
    PlatformSystem.getPlatform().updateSelectable();
  }

  void select(int posX, int posY) {
    if(getNode(posX, posY)!.isSelectableWithCheck()){
      PlatformSystem.getPlatform().setSelect(posX, posY);
      update();
    }
  }

  bool isSelect(int posX, int posY) {
    if(posX == -1 && posY == -1)return false;
    return PlatformSystem.getPlatform().isSelect(posX, posY);
  }

  bool isSelectable(int posX, int posY) {
    return getNode(posX, posY)?.isSelectableWithCheck() ?? false;
  }

  bool isSelectablePreCheck(int posX, int posY) {
    return getNode(posX, posY)!.isSelectableCheck;
  }

  void dragUpdate(BoxConstraints constrains, DragUpdateDetails details, BuildContext context){
    double topY = 0;
    double bottomY = topY + constrains.maxHeight;

    var detectedRange = constrains.maxHeight * 0.1;
    var moveDistance = ConstList.isSmallDisplay(context) ? 1.5 : 3;
    if (details.localPosition.dy < topY + detectedRange) {
      scroller.jumpTo(scroller.offset - moveDistance);
    }
    if (details.localPosition.dy > bottomY - detectedRange) {
      scroller.jumpTo(scroller.offset + moveDistance);
    }
  }

  double getScale() {
    var context = captureKey.currentContext;
    if (context == null) return 1;
    return ConstList.isSmallDisplay(context) ? 0.75 : 1;
  }

  void addMaxSelect(int y, int max){
    if((PlatformSystem.getPlatform().getLineSetting(y)!.maxSelect + max) >= -1){
      PlatformSystem.getPlatform().getLineSetting(y)?.maxSelect += max;
    }
    update();
    isChanged = true;
  }

  String getMaxSelect(int y){
    var max = PlatformSystem.getPlatform().getLineSetting(y)?.maxSelect;
    return max == -1 ? '무한' : '$max';
  }
}