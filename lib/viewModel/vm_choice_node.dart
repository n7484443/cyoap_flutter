import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

import '../model/choiceNode/choice_node.dart';
import '../model/choiceNode/generable_parser.dart';
import '../model/platform_system.dart';

const double nodeBaseWidth = 100;
const double nodeBaseHeight = 200;
const int nonPositioned = -10;

class VMChoiceNode extends GetxController {
  late QuillController quillController;
  ChoiceNodeBase node;
  final List<int> pos;
  var size = 0.obs;
  var imageString = ''.obs;
  var titleString = ''.obs;
  var isDrag = false.obs;
  var isCardMode = false.obs;
  var status = SelectableStatus.open.obs;

  var isRandom = false.obs;
  var randomValue = (-1).obs;
  var randomProcess = false.obs;

  VMChoiceNode({int x = nonPositioned, int y = nonPositioned})
      : pos = [y, x],
        node = getNode([y, x])!;

  VMChoiceNode.fromNode(this.node) : pos = node.pos();

  @override
  void onInit() {
    super.onInit();
    quillController = initQuillController();
    size.value = node.width;
    size.listen((p0) {
      Get.find<VMDraggableNestedMap>().update();
    });
    titleString.value = node.title;
    imageString.value = node.imageString;
    isCardMode.value = node.isCard;
    isRandom.value = node.isRandom;
    randomValue.value = -1;
    status.value = node.status;
  }

  QuillController initQuillController() {
    if (node.contentsString.isEmpty) {
      return QuillController.basic();
    } else {
      var json = jsonDecode(node.contentsString);
      var document = Document.fromJson(json);
      return QuillController(
          document: document,
          selection: const TextSelection.collapsed(offset: 0));
    }
  }

  static ChoiceNodeBase? getNode(List<int> pos) {
    if (pos[pos.length - 1] == nonPositioned) {
      return VMDraggableNestedMap.createNodeForTemp();
    }
    return getPlatform().getChoiceNode(pos);
  }

  static String getTagFromXY(int x, int y) {
    return getNode([y, x])!.tag;
  }

  void sizeChange(int width) {
    size.value += width;
    if(node.parent is ChoiceNodeBase){
      size.value = size.value.clamp(0, (node.parent as ChoiceNodeBase).width);
    }else{
      size.value = size.value.clamp(0, 12);
    }
    node.width = size.value;
    for(var child in node.children){
      getVMChoiceNodeFromTag(child.tag)!.sizeChange(0);
    }
  }

  void updateFromEditor() {
    titleString.value = node.title;
    imageString.value = node.imageString;
    isCardMode.value = node.isCard;
  }

  void updateFromNode() {
    node = getNode(pos)!;
    onInit();
    for(var child in node.children){
      getVMChoiceNodeFromList(child.pos())?.updateFromNode();
    }
  }

  static VMChoiceNode? getVMChoiceNode(int x, int y) {
    if (!Get.isRegistered<VMChoiceNode>(tag: VMChoiceNode.getTagFromXY(x, y))) {
      return null;
    }
    return Get.find<VMChoiceNode>(tag: VMChoiceNode.getTagFromXY(x, y));
  }

  static VMChoiceNode? getVMChoiceNodeFromTag(String tag) {
    if (!Get.isRegistered<VMChoiceNode>(tag: tag)) {
      return null;
    }
    return Get.find<VMChoiceNode>(tag: tag);
  }

  static VMChoiceNode? getVMChoiceNodeFromList(List<int> tag) {
    return getVMChoiceNodeFromTag(getTagFromList(tag));
  }

  static VMChoiceNode? getVMChoiceNodeFromNode(ChoiceNodeBase node) {
    return getVMChoiceNodeFromTag(node.tag);
  }

  static String getTagFromList(List<int> tag) {
    var tagOut = tag[0].toString();
    for (int i = 1; i < tag.length; i++) {
      tagOut += ':${tag[i]}';
    }
    return tagOut;
  }

  bool isSelect() {
    if (pos[pos.length - 1] == nonPositioned) return false;
    return getPlatform().isSelect(node.pos());
  }

  bool isIgnorePointer() {
    return status.value.isPointerInteractive(node.isSelectable);
  }

  void select() {
    getPlatform().setSelect(node.pos());
  }

  static void updateStatusAll(){
    getPlatform().updateStatusAll();
    VMChoiceNode.doAllVMChoiceNode((vm) {
      vm.status.value = vm.node.status;
    });
  }

  double get opacity{
    if (isEditable) return 1;

    if (node.isSelectable) {
      if (isIgnorePointer()) {
        return 1;
      } else if (status.value == SelectableStatus.hide) {
        return 0;
      } else {
        return 0.5;
      }
    } else {
      if (status.value == SelectableStatus.selected) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  void startRandom() {
    randomProcess.value = true;
    randomValue.value = node.maxRandom * 10;
    var timer = Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      randomValue.value = randomValue.value ~/ 2;
    });
    Timer(const Duration(milliseconds: 2000), () {
      timer.cancel();
      randomValue.value = Random().nextInt(node.maxRandom);
      node.random = randomValue.value;
      randomProcess.value = false;
    });
  }

  static void doAllVMChoiceNode(void Function(VMChoiceNode vm) action) {
    getPlatform().doAllChoiceNode((node) {
      var vm = getVMChoiceNodeFromList(node.pos());
      if (vm != null) {
        action(vm);
      }
    });
  }
}
