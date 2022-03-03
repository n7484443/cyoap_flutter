import 'dart:convert';

import 'package:cyoap_flutter/viewModel/vm_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/choiceNode/choice_node.dart';
import '../model/editor.dart';
import '../model/platform_system.dart';
import '../util/tuple.dart';

class VMDraggableNestedMap extends GetxController {
  List<List<Widget>> widgetList = List.empty(growable: true);
  Tuple<int, int>? drag;
  Tuple<int, int> mouseHover = Tuple(-1, -1);
  Tuple<int, int> sizeSet = Tuple(1, 1);

  GlobalKey captureKey = GlobalKey();
  GlobalKey keyListView = GlobalKey();

  ScrollController scroller = ScrollController();

  bool isChanged = false;

  void updateWidgetList() {
    widgetList.clear();

    var list = getPlatform().choiceNodes;
    for (int y = 0; y < list.length; y++) {
      widgetList.add(List.empty(growable: true));
      var xList = list[y];
      for (int x = 0; x < xList.data1.length; x++) {
        widgetList[y].insert(
            x,
            getWidgetFromType(xList.data1[x].isCard, x, y));
      }
    }
    update();
    isChanged = true;
  }

  void setHover(int x, int y) {
    mouseHover = Tuple(x, y);
    update();
  }

  Tuple<int, int> getSize(Tuple<int, int> position) {
    var node = getNode(position.data1, position.data2)!;
    return Tuple(node.width, node.height);
  }

  double nodeBaseWidth = 180;
  double nodeBaseHeight = 20;

  Tuple<int, int> getRealSize(Tuple<int, int> position) {
    var node = getSize(position);
    var width = node.data1 == 0 ? findMaxWidth() : node.data1 * nodeBaseWidth;
    var height = node.data2 * nodeBaseHeight;
    return Tuple(width.toInt(), height.toInt());
  }

  void removeData(Tuple<int, int> data) {
    getPlatform().removeData(data.data1, data.data2);
    updateWidgetList();
  }

  void changeData(Tuple<int, int> data, Tuple<int, int> pos) {
    if (data == Tuple(-1, -1)) {
      getPlatform()
          .addData(pos.data1, pos.data2, createNodeForTemp());
    } else {
      getPlatform().changeData(data, pos);
    }
    updateWidgetList();
  }

  void dragStart(int posX, int posY) {
    drag = Tuple(posX, posY);
    update();
  }

  void dragEnd() {
    drag = null;
    update();
  }

  int findMaxWidth() {
    return (captureKey.currentContext!.width * 0.9).toInt();
  }

  void setSize(Tuple<int, int> position, Tuple<int, int> size) {
    var node = getNode(position.data1, position.data2)!;
    node.width = size.data1;
    node.height = size.data2;
  }

  void dragUpdate(BoxConstraints constrains, DragUpdateDetails details,
      BuildContext context) {
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

  Color getBackgroundColor() {
    return getPlatform().colorBackground;
  }

  Tuple<double, double> getScale() {
    var context = captureKey.currentContext;
    if (context == null) return Tuple(drag == null ? 1 : 0.9, 1);
    var sizeMultiply = ConstList.isSmallDisplay(context) ? 0.75 : 1;
    return Tuple<double, double>(drag == null ? 1 : 0.9, 1).mul(sizeMultiply);
  }

  bool isEditable() {
    return getPlatform().isEditable;
  }

  ChoiceNodeBase? getNode(int x, int y) {
    if (x == -1 && y == -1) {
      return createNodeForTemp();
    }
    return getPlatform().getChoiceNode(x, y);
  }

  ChoiceNodeBase createNodeForTemp() {
    return ChoiceNodeBase.noTitle(1, 10, false, '', '');
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

  void addNode() {
    getPlatform()
        .addData(0, 0, ChoiceNodeBase.noTitle(1, 1, true, '', ''));
    getPlatform().checkDataCollect();
    updateWidgetList();
  }

  Future<void> exportAsImage() async {
    var boundary =
        captureKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    PlatformSystem.instance.saveCapture(await boundary.toImage());
  }

  void select(int posX, int posY) {
    if (getNode(posX, posY)!.isSelectableWithCheck()) {
      getPlatform().setSelect(posX, posY);
      update();
    }
  }

  void sizeChange(int x, int y) {
    sizeSet.data1 += x;
    sizeSet.data2 += y;
    if (sizeSet.data1 < 0) {
      sizeSet.data1 = 0;
    }
    if (sizeSet.data2 < 5) {
      sizeSet.data2 = 5;
    }
    update();
  }

  bool isSelectable(int posX, int posY) {
    return getNode(posX, posY)?.isSelectableWithCheck() ?? false;
  }

  bool isSelectablePreCheck(int posX, int posY) {
    return getNode(posX, posY)!.isSelectableCheck;
  }

  void addMaxSelect(int y, int max) {
    if ((getPlatform().getLineSetting(y)!.maxSelect + max) >=
        -1) {
      getPlatform().getLineSetting(y)?.maxSelect += max;
    }
    update();
    isChanged = true;
  }

  bool isSelect(int posX, int posY) {
    if (posX == -1 && posY == -1) return false;
    return getPlatform().isSelect(posX, posY);
  }

  void setEdit(int posX, int posY) {
    var node = getPlatform().getChoiceNode(posX, posY);

    if(node == null){
      return;
    }
    ChoiceNodeBase nodeNonnull = node;
    NodeEditor.instance.setTarget(nodeNonnull);
  }

  String getMaxSelect(int y){
    var max = getPlatform().getLineSetting(y)?.maxSelect;
    return max == -1 ? '무한' : '$max';
  }

  TextStyle getTitleFont() {
    return ConstList.getFont(getPlatform().titleFont);
  }
}
