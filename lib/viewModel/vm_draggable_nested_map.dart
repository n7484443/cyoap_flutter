import 'package:cyoap_flutter/view/util/view_wrap_custom.dart';
import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/choiceNode/choice_node.dart';
import '../model/editor.dart';
import '../model/platform_system.dart';
import '../view/view_choice_node.dart';
import '../view/view_draggable_nested_map.dart';

const int maxWidthSize = 12;

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

  @override
  void update([List<Object>? ids, bool condition = true]) {
    super.update();
    isChanged = true;
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
              child: GetBuilder<VMDraggableNestedMap>(builder: (_) {
                var j = y ~/ 2;
                return ViewWrapCustom(
                  xList.children,
                  (child) => constrains != null
                      ? NodeDraggable(child.currentPos, j, constrains)
                      : ViewChoiceNode(child.currentPos, j),
                  builderDraggable: (i) => NodeDragTarget(i, j),
                );
              }),
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
              builder: (_){
                var j = y ~/ 2;
                return ViewWrapCustom(xList.children, (child) => ViewChoiceNode(child.currentPos, j));
              },
            ),
          );
        } else {
          return NodeDivider(y ~/ 2);
        }
      });
    }
    return widgetList;
  }

  void removeData(List<int> data) {
    getPlatform().removeData(data);
    updateVMChoiceNode(data);
    update();
  }

  void updateVMChoiceNode(List<int> tag) {
    var node = VMChoiceNode.getNode(tag);
    if(node == null)return;
    var parentNode = node.getParentLast();
    var y = parentNode!.parent!.currentPos;

    var lineSetting = getPlatform().lineSettings;
    if (y >= lineSetting.length) return;
    for (var node in lineSetting[y].children) {
      VMChoiceNode.getVMChoiceNodeFromTag(node.tag)?.updateFromNode();
    }
  }

  static ChoiceNodeBase createNodeForTemp() {
    return ChoiceNodeBase.noTitle(3, true, '', '');
  }

  void changeData(List<int> data, List<int> pos) {
    if (data[data.length - 1] == nonPositioned) {
      getPlatform().addData(pos, createNodeForTemp());
    } else {
      getPlatform().changeData(data, pos);
      updateVMChoiceNode(data);
    }
    updateVMChoiceNode(pos);
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

  double getScale() {
    var context = captureKey.currentContext;
    if (context == null) return 1;
    var sizeMultiply = ConstList.isSmallDisplay(context) ? 0.75 : 1.0;
    return sizeMultiply;
  }

  void addMaxSelect(int y, int max) {
    if ((getPlatform().getLineSetting(y)!.maxSelect + max) >= -1) {
      getPlatform().getLineSetting(y)?.maxSelect += max;
    }
    update();
    isChanged = true;
  }

  void setEdit(ChoiceNodeBase node) {
    ChoiceNodeBase nodeNonnull = node;
    NodeEditor().setTarget(nodeNonnull);
  }

  String getMaxSelect(int y) {
    var line = getPlatform().getLineSetting(y);
    var max = line == null ? -1 : line.maxSelect;
    return max == -1 ? '무한' : '$max';
  }
}
