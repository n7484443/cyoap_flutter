import 'dart:math';

import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/choiceNode/choice_node.dart';
import '../model/editor.dart';
import '../model/image_db.dart';
import '../model/platform_system.dart';

const int maxWidthSize = 12;

class VMDraggableNestedMap extends GetxController {
  List<int>? drag;

  ScrollController scroller = ScrollController();
  GlobalKey captureKey = GlobalKey();

  bool isChanged = false;

  BoxConstraints? constrain;

  Rx<ChoiceNode?> removedData = Rx(null);

  @override
  void onClose() {
    ImageDB().clearImageCache();
    super.onClose();
  }

  bool isVisibleDragTarget(int x, int y) {
    if (drag == null) return false;
    return drag![drag!.length - 1] != x - 1 || drag![drag!.length - 2] != y;
  }

  @override
  void update([List<Object>? ids, bool condition = true]) {
    super.update();
    isChanged = true;
  }


  void removeData(List<int> data) {
    var choiceNode = getPlatform.removeData(data);
    removedData.value = choiceNode;
    removedData.refresh();
    updateVMChoiceNode(data);
    update();
  }

  void addData(List<int> data, ChoiceNode choiceNode) {
    getPlatform.addData(data, choiceNode);
    updateVMChoiceNode(data);
    update();
  }

  void updateVMChoiceNode(List<int> tag) {
    var node = VMChoiceNode.getNode(tag);
    if (node == null) return;
    var parentNode = (node as ChoiceNode).getParentLast()!;
    var y = parentNode.parent!.currentPos;

    var lineSetting = getPlatform.lineSettings;
    if (y >= lineSetting.length) return;
    for (var node in lineSetting[y].children) {
      VMChoiceNode.getVMChoiceNodeFromTag(node.tag)?.updateFromNode();
    }
  }

  static ChoiceNode createNodeForTemp() {
    return ChoiceNode.noTitle(3, true, '', '');
  }

  void changeData(List<int> input, List<int> target) {
    if (input.last == nonPositioned) {
      getPlatform.addData(target, createNodeForTemp());
    } else {
      var inputNode = getPlatform.getChoiceNode(input)!;
      var targetNode = getPlatform.getChoiceNode(target);
      if (targetNode == null) {
        var generableParser = getPlatform
            .getGenerableParserAndPosition(List.from(target)..removeLast());
        if (generableParser == null) {
          getPlatform.removeData(input);
          getPlatform.addData(target, inputNode);
        } else {
          getPlatform.insertDataWithParent(inputNode, generableParser);
        }
        updateVMChoiceNode(input);
      } else {
        getPlatform.insertData(inputNode, targetNode);
        updateVMChoiceNode(input);
      }
    }
    updateVMChoiceNode(target);
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

  double get maxWidth => constrain!.maxWidth;

  void dragUpdate(DragUpdateDetails details, BuildContext context) {
    double topY = 0;
    double bottomY = topY + constrain!.maxHeight;

    var detectedRange = constrain!.maxHeight * 0.06;
    var moveDistance = ConstList.isSmallDisplay(context) ? 0.8 : 1;
    if (details.localPosition.dy < topY + detectedRange) {
      scroller.jumpTo(max(scroller.offset - moveDistance, 0));
    }
    if (details.localPosition.dy > bottomY - detectedRange) {
      scroller.jumpTo(scroller.offset + moveDistance);
    }
  }

  Color get backgroundColor => getPlatform.designSetting.colorBackground;

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
