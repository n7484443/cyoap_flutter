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
  List<int>? drag;

  GlobalKey captureKey = GlobalKey();

  ScrollController scroller = ScrollController();

  bool isChanged = false;

  var mainFont = getPlatform().mainFont.obs;
  var titleFont = getPlatform().titleFont.obs;

  static bool isCapture = false;

  static bool isVisibleOnlyEdit() {
    return !isCapture && isEditable();
  }

  bool isVisibleDragTarget(int x, int y) {
    if(drag == null)return false;
    return drag![drag!.length - 1] != x - 1 || drag![drag!.length - 2] != y;
  }

  int getLength() {
    return isEditable()
        ? (getPlatform().lineSettings.length * 2 + 2)
        : (getPlatform().lineSettings.length * 2);
  }

  List<Widget> widgetList({BoxConstraints? constrains}) {
    var choiceNodeList = getPlatform().lineSettings;
    var edit = isEditable();
    List<Widget> widgetList;
    if (edit) {
      widgetList = List<Widget>.generate(getLength(), (y) {
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
                    xList.children.length * 2 + 1,
                    (x) {
                      var i = x ~/ 2;
                      var j = y ~/ 2;
                      if (x.isOdd) {
                        if (constrains != null) {
                          return NodeDraggable(i, j, constrains);
                        } else {
                          return ViewChoiceNode(i, j);
                        }
                      } else {
                        return NodeDragTarget(i, j);
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
            return NodeDragTarget(0, choiceNodeList.length);
          } else {
            return GetBuilder<VMDraggableNestedMap>(
              builder: (_) => Visibility(
                child: NodeDivider(y ~/ 2),
                visible: drag != null,
              ),
            );
          }
        }
      });
    } else {
      widgetList = List<Widget>.generate(getLength(), (y) {
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
                  xList.children.length,
                  (x) {
                    var j = y ~/ 2;
                    return ViewChoiceNode(x, j);
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

  void removeData(List<int> data) {
    getPlatform().removeData(data[1], data[0]);
    updateVMChoiceNode(data[1], data[0]);
    update();
  }

  void updateVMChoiceNode(int x, int y) {
    var lineSetting = getPlatform().lineSettings;
    if (y >= lineSetting.length) return;
    for (var node in lineSetting[y].children) {
      VMChoiceNode.getVMChoiceNodeFromTag(node.tag)?.updateFromNode();
    }
  }

  static ChoiceNodeBase createNodeForTemp() {
    return ChoiceNodeBase.noTitle(1, 10, true, '', '');
  }

  void changeData(List<int> data, List<int> pos) {
    if (data[data.length - 1] == nonPositioned) {
      getPlatform().addDataFromList(pos, createNodeForTemp());
    } else {
      getPlatform().changeDataFromList(data, pos);
      updateVMChoiceNode(data[1], data[0]);
    }
    updateVMChoiceNode(pos[1], pos[0]);
    update();
  }

  void dragStart(List<int> pos) {
    drag = List.from(pos);
    VMChoiceNode.getVMChoiceNodeFromList(drag!)?.isDrag.value = true;
    update();
  }

  void dragEnd() {
    if(drag != null){
      VMChoiceNode.getVMChoiceNodeFromList(drag!)?.isDrag.value =
      false;
      drag = null;
      update();
    }
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

  void addMaxSelect(int y, int max) {
    if ((getPlatform().getLineSetting(y)!.maxSelect + max) >= -1) {
      getPlatform().getLineSetting(y)?.maxSelect += max;
    }
    update();
    isChanged = true;
  }

  bool isSelect(int posX, int posY) {
    if (posX == nonPositioned && posY == nonPositioned) return false;
    return getPlatform().isSelect(posX, posY);
  }

  void setEdit(ChoiceNodeBase node) {
    ChoiceNodeBase nodeNonnull = node;
    NodeEditor.instance.setTarget(nodeNonnull);
  }

  String getMaxSelect(int y) {
    var line = getPlatform().getLineSetting(y);
    var max = line == null ? -1 : line.maxSelect;
    return max == -1 ? '무한' : '$max';
  }
}
