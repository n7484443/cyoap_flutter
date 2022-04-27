import 'package:cyoap_flutter/view/util/view_wrap_custom.dart';
import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/choiceNode/choice_node.dart';
import '../model/editor.dart';
import '../model/image_db.dart';
import '../model/platform_system.dart';
import '../view/view_choice_node.dart';
import '../view/view_draggable_nested_map.dart';

const int maxWidthSize = 12;

class VMDraggableNestedMap extends GetxController {
  List<int>? drag;

  GlobalKey captureKey = GlobalKey();

  ScrollController scroller = ScrollController();

  bool isChanged = false;

  var mainFont = getPlatform.mainFont.obs;
  var titleFont = getPlatform.titleFont.obs;

  bool isCapture = false;

  BoxConstraints? constrain;

  @override
  void onClose() {
    ImageDB().clearImageCache();
    super.onClose();
  }

  bool isVisibleOnlyEdit() {
    return !isCapture && isEditable;
  }

  bool isVisibleDragTarget(int x, int y) {
    if (drag == null) return false;
    return drag![drag!.length - 1] != x - 1 || drag![drag!.length - 2] != y;
  }

  int getLength() {
    return getPlatform.lineSettings.length * 2 + (isEditable ? 2 : 0);
  }

  @override
  void update([List<Object>? ids, bool condition = true]) {
    super.update();
    isChanged = true;
  }

  List<Widget> widgetList() {
    var choiceNodeList = getPlatform.lineSettings;
    List<Widget> widgetList;
    if (isEditable) {
      widgetList = List<Widget>.generate(getLength(), (y) {
        var j = y ~/ 2;
        if (y < choiceNodeList.length * 2) {
          if (y.isOdd) {
            var xList = choiceNodeList[j].children;
            return Padding(
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 12,
              ),
              child: GetBuilder<VMDraggableNestedMap>(builder: (_) {
                if (xList.isEmpty) {
                  return Row(
                    children: [
                      Expanded(
                        child: NodeDragTarget(
                          [j, 0],
                          isHorizontal: true,
                        ),
                      )
                    ],
                  );
                }
                return ViewWrapCustom(
                  xList,
                  (child) => _.isVisibleOnlyEdit()
                      ? NodeDraggable(child)
                      : ViewChoiceNode(child.currentPos, j),
                  builderDraggable: _.isVisibleOnlyEdit()
                      ? (i) => NodeDragTarget([j, i])
                      : null,
                  isAllVisible: true,
                );
              }),
            );
          } else {
            return NodeDivider(j);
          }
        } else if (y.isOdd) {
          return Row(
            children: [
              Expanded(
                child: NodeDragTarget(
                  [choiceNodeList.length, 0],
                  isHorizontal: true,
                ),
              )
            ],
          );
        } else {
          return GetBuilder<VMDraggableNestedMap>(
            builder: (_) => Visibility(
              child: NodeDivider(j),
              visible: drag != null,
            ),
          );
        }
      });
    } else {
      widgetList = List<Widget>.generate(getLength(), (y) {
        var j = y ~/ 2;
        if (y.isOdd) {
          var xList = choiceNodeList[j].children;
          return Padding(
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 12,
            ),
            child: GetBuilder<VMDraggableNestedMap>(
              builder: (_) {
                return ViewWrapCustom(
                    xList, (child) => ViewChoiceNode(child.currentPos, j));
              },
            ),
          );
        } else {
          return NodeDivider(j);
        }
      });
    }
    return widgetList;
  }

  void removeData(List<int> data) {
    getPlatform.removeData(data);
    updateVMChoiceNode(data);
    update();
  }

  void updateVMChoiceNode(List<int> tag) {
    var node = VMChoiceNode.getNode(tag);
    if (node == null) return;
    var parentNode = (node as ChoiceNode).getParentLast();
    var y = parentNode!.parent!.currentPos;

    var lineSetting = getPlatform.lineSettings;
    if (y >= lineSetting.length) return;
    for (var node in lineSetting[y].children) {
      VMChoiceNode.getVMChoiceNodeFromTag(node.tag)?.updateFromNode();
    }
  }

  static ChoiceNode createNodeForTemp() {
    return ChoiceNode.noTitle(3, true, '', '');
  }

  void changeData(List<int> data, List<int> pos) {
    if (data.last == nonPositioned) {
      getPlatform.addData(pos, createNodeForTemp());
    } else {
      getPlatform.changeData(data, pos);
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
    if (drag != null) {
      VMChoiceNode.getVMChoiceNodeFromList(drag!)?.isDrag.value = false;
      drag = null;
      update();
    }
  }

  double get maxWidth => captureKey.currentContext!.width;

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

  Color get backgroundColor => getPlatform.colorBackground;

  double scale(BuildContext context) {
    var sizeMultiply = ConstList.isSmallDisplay(context) ? 0.85 : 1.0;
    return sizeMultiply;
  }

  void addMaxSelect(int y, int max) {
    if ((getPlatform.getLineSetting(y)!.maxSelect + max) >= -1) {
      getPlatform.getLineSetting(y)?.maxSelect += max;
    }
    update();
    isChanged = true;
  }

  set editNode(ChoiceNode node) => NodeEditor().target = node;

  String getMaxSelect(int y) {
    var line = getPlatform.getLineSetting(y);
    var max = line == null ? -1 : line.maxSelect;
    return max == -1 ? '무한' : '$max';
  }
}
