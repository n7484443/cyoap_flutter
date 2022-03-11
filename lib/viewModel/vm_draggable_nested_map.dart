import 'dart:convert';

import 'package:cyoap_flutter/viewModel/vm_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/choiceNode/choice_node.dart';
import '../model/editor.dart';
import '../model/platform_system.dart';
import '../util/tuple.dart';
import '../view/view_draggable_nested_map.dart';

class VMDraggableNestedMap extends GetxController {
  Tuple<int, int>? drag;
  Tuple<int, int> mouseHover = Tuple(-10, -10);
  Tuple<int, int> sizeSet = Tuple(1, 1);

  GlobalKey captureKey = GlobalKey();

  ScrollController scroller = ScrollController();

  bool isChanged = false;

  double nodeBaseWidth = 176;
  double nodeBaseHeight = 24;

  int getLength(){
    return isEditable() ? (getPlatform().choiceNodes.length * 2 + 1) : (getPlatform().choiceNodes.length * 2 - 1);
  }

  List<Widget> updateWidgetList({BoxConstraints? constrains}) {
    var choiceNodeList = getPlatform().choiceNodes;
    var edit = isEditable();

    List<Widget> widgetList;
    if (edit) {
      widgetList = List<Widget>.generate(
          getLength(), (y) {
        if (y <= choiceNodeList.length * 2 - 2) {
          if (y.isEven) {
            var xList = choiceNodeList[y ~/ 2];
            return Padding(
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 12,
              ),
              child: GetBuilder<VMDraggableNestedMap>(
                builder: (_) => Wrap(
                  spacing: 2,
                  alignment: WrapAlignment.center,
                  children: List<Widget>.generate(
                    xList.data1.length * 2 + 1,
                    (x) {
                      var i = x ~/ 2;
                      var j = y ~/ 2;
                      if (x.isOdd) {
                        if (constrains != null) {
                          return NodeDraggable(i, j, constrains);
                        } else {
                          return getChoiceWidget(xList.data1[i].isCard, i, j);
                        }
                      } else {
                        return NodeDraggableTarget(i, j);
                      }
                    },
                  ),
                ),
              ),
            );
          } else {
            return NodeDivider(y ~/ 2 + 1);
          }
        } else {
          if (y.isEven) {
            return NodeDraggableTarget(0, choiceNodeList.length);
          } else {
            return GetBuilder<VMDraggableNestedMap>(
              builder: (_) => Visibility(
                child: NodeDivider(y ~/ 2 + 1),
                visible: drag != null,
              ),
            );
          }
        }
      });
    } else {
      widgetList = List<Widget>.generate(
          getLength(), (y) {
        if (y.isEven) {
          var xList = choiceNodeList[y ~/ 2];
          return Padding(
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 12,
            ),
            child: GetBuilder<VMDraggableNestedMap>(
              builder: (_) => Wrap(
                spacing: 2,
                alignment: WrapAlignment.center,
                children: List<Widget>.generate(
                  xList.data1.length,
                  (x) {
                    var j = y ~/ 2;
                    return getChoiceWidget(xList.data1[x].isCard, x, j);
                  },
                ),
              ),
            ),
          );
        } else {
          return NodeDivider(y ~/ 2 + 1);
        }
      });
    }

    isChanged = true;
    return widgetList;
  }

  void setHover(int x, int y) {
    mouseHover = Tuple(x, y);
    update();
  }

  Tuple<int, int> getSize(Tuple<int, int> position) {
    var node = getNode(position.data1, position.data2)!;
    return Tuple(node.width, node.height);
  }

  Tuple<double, double> getRealSize(Tuple<int, int> position) {
    var node = getSize(position);
    double width;
    if(node.data1 == 0){
      if(drag == null){
        width = double.infinity;
      }else{
        width = getMaxWidth();
      }
    }else{
      width = node.data1 * nodeBaseWidth;
    }
    var height = node.data2 * nodeBaseHeight;
    return Tuple(width, height);
  }

  void removeData(Tuple<int, int> data) {
    getPlatform().removeData(data.data1, data.data2);
    update();
  }

  void changeData(Tuple<int, int> data, Tuple<int, int> pos) {
    if (data == Tuple(-10, -10)) {
      getPlatform().addData(pos.data1, pos.data2, createNodeForTemp());
    } else {
      getPlatform().changeData(data, pos);
    }
    update();
  }

  void dragStart(Tuple<int, int> pos) {
    drag = pos;
    update();
  }

  void dragEnd() {
    drag = null;
    update();
  }

  double getMaxWidth() {
    return captureKey.currentContext!.width;
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
    if (x == -10 && y == -10) {
      return createNodeForTemp();
    }else if(y < 0 || y >= getPlatform().choiceNodes.length){
      return null;
    }else if(x < 0 || x >= getPlatform().choiceNodes[y].data1.length){
      return null;
    }
    return getPlatform().getChoiceNode(x, y);
  }

  ChoiceNodeBase createNodeForTemp() {
    return ChoiceNodeBase.noTitle(1, 10, true, '', '');
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
    var node = getNode(posX, posY)!;
    if(node.isSelectable){
      return node.isSelectableCheck;
    }
    return true;
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
    if (posX == -10 && posY == -10) return false;
    return getPlatform().isSelect(posX, posY);
  }

  void setEdit(int posX, int posY) {
    var node = getPlatform().getChoiceNode(posX, posY);

    if (node == null) {
      return;
    }
    ChoiceNodeBase nodeNonnull = node;
    NodeEditor.instance.setTarget(nodeNonnull);
  }

  String getMaxSelect(int y) {
    var line = getPlatform().getLineSetting(y);
    var max = line == null ? -1 : line.maxSelect;
    return max == -1 ? '무한' : '$max';
  }

  TextStyle getTitleFont() {
    return ConstList.getFont(getPlatform().titleFont);
  }
}
