import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cyoap_flutter/model/image_db.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

import '../model/choiceNode/choice_node.dart';
import '../model/choiceNode/generable_parser.dart';
import '../model/platform_system.dart';
import '../view/view_choice_node.dart';

const double nodeBaseHeight = 200;
const int nonPositioned = -1;
const int removedPositioned = -2;

class VMChoiceNode extends GetxController {
  late QuillController quillController;
  ChoiceNode node;
  final List<int> pos;
  var size = 0.obs;
  var imageString = ''.obs;
  var titleString = ''.obs;
  var isDrag = false.obs;
  var isCard = false.obs;
  var isRound = true.obs;
  var hideTitle = false.obs;
  var imagePosition = 0.obs;
  var status = SelectableStatus.open.obs;
  var nodeMode = ChoiceNodeMode.defaultMode.obs;

  var maximizingImage = false.obs;
  var randomValue = (-1).obs;
  var randomProcess = false.obs;
  var selectedMultiple = 0.obs;

  VMChoiceNode({int x = nonPositioned, int y = nonPositioned})
      : pos = [y, x],
        node = getNode([y, x])! as ChoiceNode;

  VMChoiceNode.fromNode(this.node) : pos = node.pos();

  @override
  void onInit() {
    super.onInit();
    quillController = initQuillController();
    size.value = node.width;
    size.listen((value) => Get.find<VMDraggableNestedMap>().update());
    randomValue.value = -1;
    status.value = node.status;
    updateFromEditor();
  }

  void updateFromEditor() {
    titleString.value = node.title;
    imageString.value = node.imageString;
    isCard.value = node.isCard;
    imagePosition.value = node.imagePosition;
    isRound.value = node.isRound;
    hideTitle.value = node.hideTitle;
    maximizingImage.value = node.maximizingImage;
    nodeMode.value = node.choiceNodeMode;
  }

  void updateImage() {
    if (!ImageDB().contains(imageString.value) && node.imageString.isNotEmpty) {
      print(node.imageString);
      node.imageString = "";
      imageString.value = node.imageString;
    }
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

  static GenerableParserAndPosition? getNode(List<int> pos) {
    if (pos.last == nonPositioned) {
      return VMDraggableNestedMap.createNodeForTemp();
    }
    if (pos.length == 1) return getPlatform.getLineSetting(pos.first);
    return getPlatform.getChoiceNode(pos);
  }

  void sizeChange(int width) {
    size.value = width.clamp(0, node.getMaxSize(false));
    node.width = size.value;
    for (var child in node.children) {
      getVMChoiceNodeFromTag(child.tag)!.sizeChange(0);
    }
  }

  void updateFromNode() {
    node = getNode(pos)! as ChoiceNode;
    onInit();
    for (var child in node.children) {
      getVMChoiceNodeFromList(child.pos())?.updateFromNode();
    }
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

  static VMChoiceNode? getVMChoiceNodeFromNode(ChoiceNode node) {
    return getVMChoiceNodeFromTag(node.tag);
  }

  static String getTagFromList(List<int> tag) {
    var tagOut = tag[0].toString();
    for (int i = 1; i < tag.length; i++) {
      tagOut += ':${tag[i]}';
    }
    return tagOut;
  }

  bool get isIgnorePointer =>
      status.value.isPointerInteractive(node.isSelectable);

  Future<void> select(int n, context) async {
    if (node.isSelected() && nodeMode.value != ChoiceNodeMode.multiSelect) {
      node.selectNode(n);
      VMChoiceNode.updateStatusAll();
      return;
    }
    if (!isIgnorePointer) {
      return;
    }

    if (nodeMode.value == ChoiceNodeMode.randomMode) {
      node.selectNode(n);
      startRandom();
      await showDialog(
        context: context,
        builder: (builder) => RandomDialog(node),
        barrierDismissible: false,
      );
    } else if (nodeMode.value == ChoiceNodeMode.multiSelect) {
      selectedMultiple.value += n;
      selectedMultiple.value =
          selectedMultiple.value.clamp(0, node.maximumStatus);
      node.selectNode(selectedMultiple.value);
    } else {
      node.selectNode(n);
    }

    VMChoiceNode.updateStatusAll();
  }

  static void updateStatusAll() {
    getPlatform.updateStatusAll();
    VMChoiceNode.doAllVMChoiceNode((vm) {
      vm.status.value = vm.node.status;
    });
  }

  double get opacity {
    if (isEditable) return 1;

    if (node.isSelectable) {
      if (isIgnorePointer) {
        return 1;
      } else if (status.value == SelectableStatus.hide) {
        return 0;
      } else {
        return 0.4;
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
    randomValue.value = node.maximumStatus * 10;
    var timer =
        Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      randomValue.value = randomValue.value ~/ 2;
    });
    Timer(const Duration(milliseconds: 2000), () {
      timer.cancel();
      randomValue.value = Random().nextInt(node.maximumStatus);
      node.random = randomValue.value;
      randomProcess.value = false;
    });
  }

  static void doAllVMChoiceNode(void Function(VMChoiceNode vm) action) {
    getPlatform.doAllChoiceNode((node) {
      var vm = getVMChoiceNodeFromList(node.pos());
      if (vm != null) {
        action(vm);
      }
    });
  }
}
