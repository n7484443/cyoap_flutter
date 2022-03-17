import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/choiceNode/choice_node.dart';
import '../model/editor.dart';
import '../model/platform_system.dart';
import '../util/tuple.dart';
import '../view/view_choice_node.dart';
import '../view/view_draggable_nested_map.dart';

class VMDraggableNestedMap extends GetxController {
  Tuple<int, int>? drag;
  Tuple<int, int> mouseHover = Tuple(-10, -10);

  GlobalKey captureKey = GlobalKey();

  ScrollController scroller = ScrollController();

  bool isChanged = false;
  static bool isCapture = false;

  bool isVisibleDragTarget(int x, int y){
    return drag != null && drag != Tuple(x - 1, y);
  }

  int getLength(){
    return isEditable() ? (getPlatform().choiceNodes.length * 2 + 2) : (getPlatform().choiceNodes.length * 2);
  }

  List<Widget> widgetList({BoxConstraints? constrains}) {
    var choiceNodeList = getPlatform().choiceNodes;
    var edit = isEditable();

    List<Widget> widgetList;
    if (edit) {
      widgetList = List<Widget>.generate(
          getLength(), (y) {
        if (y < choiceNodeList.length * 2) {
          if (y.isOdd) {
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
                    xList.length * 2 + 1,
                    (x) {
                      var i = x ~/ 2;
                      var j = y ~/ 2;
                      if (x.isOdd) {
                        if (constrains != null) {
                          return NodeDraggable(i, j, constrains);
                        } else {
                          return ViewChoiceNode(posX: i, posY: j,);
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
            return NodeDivider(y ~/ 2);
          }
        } else {
          if (y.isOdd) {
            return NodeDraggableTarget(0, choiceNodeList.length);
          } else {
            return GetBuilder<VMDraggableNestedMap>(
              builder: (_) => Visibility(
                child: NodeDivider(y ~/ 2 ),
                visible: drag != null,
              ),
            );
          }
        }
      });
    } else {
      widgetList = List<Widget>.generate(
          getLength(), (y) {
        if (y.isOdd) {
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
                  xList.length,
                  (x) {
                    var j = y ~/ 2;
                    return ViewChoiceNode(posX: x, posY: j,);
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

  void removeData(Tuple<int, int> data) {
    getPlatform().removeData(data.data1, data.data2);
    updateVMChoiceNode(data.data1, data.data2);
    update();
  }
  void updateVMChoiceNode(int x, int y){
    var nodes = getPlatform().choiceNodes;
    if(y >= nodes.length)return;
    for(var i = x; i < nodes[y].length; i++){
      if(!Get.isRegistered<VMChoiceNode>(tag: VMChoiceNode.getTag(i, y))){
        continue;
      }
      Get.find<VMChoiceNode>(tag: VMChoiceNode.getTag(i, y)).updateFromNode();
    }
  }

  static ChoiceNodeBase createNodeForTemp() {
    return ChoiceNodeBase.noTitle(1, 10, true, '', '');
  }

  void changeData(Tuple<int, int> data, Tuple<int, int> pos) {
    if (data == Tuple(-10, -10)) {
      getPlatform().addData(pos.data1, pos.data2, createNodeForTemp());
    } else {
      getPlatform().changeData(data, pos);
      updateVMChoiceNode(data.data1, data.data2);
    }
    updateVMChoiceNode(pos.data1, pos.data2);
    update();
  }

  void dragStart(Tuple<int, int> pos) {
    drag = pos.copy();
    VMChoiceNode.getVMChoiceNode(drag!.data1, drag!.data2)?.isDrag.value = true;
    update();
  }

  void dragEnd() {
    VMChoiceNode.getVMChoiceNode(drag!.data1, drag!.data2)?.isDrag.value = false;
    drag = null;
  }

  double getMaxWidth() {
    return captureKey.currentContext!.width;
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
    return Tuple<double, double>(drag == null ? 1 : 0.9, 1) * sizeMultiply;
  }

  void select(int posX, int posY) {
    if (VMChoiceNode.getNode(posX, posY)!.isSelectableWithCheck()) {
      getPlatform().setSelect(posX, posY);
      update();
    }
  }

  bool isSelectable(int posX, int posY) {
    return VMChoiceNode.getNode(posX, posY)?.isSelectableWithCheck() ?? false;
  }

  bool isSelectablePreCheck(int posX, int posY) {
    var node = VMChoiceNode.getNode(posX, posY)!;
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
