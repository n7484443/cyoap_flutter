import 'package:cyoap_flutter/model/editor.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VMCodeEditor extends GetxController {
  final TextEditingController controllerClickable = TextEditingController(
      text: NodeEditor().targetRecursive.conditionClickableString);
  final TextEditingController controllerVisible = TextEditingController(
      text: NodeEditor().targetRecursive.conditionVisibleString);
  final TextEditingController controllerExecute = TextEditingController(
      text: NodeEditor().targetRecursive.executeCodeString);
  TextEditingController? lastFocus;

  var isOccupySpace = NodeEditor().target.isOccupySpace.obs;

  bool isChanged = false;

  void insertText(TextEditingController controller, String text) {
    var selection = controller.selection;
    controller.text =
        controller.text.replaceRange(selection.start, selection.end, text);
    controller.selection =
        TextSelection.collapsed(offset: selection.start + text.length);
  }

  @override
  void onInit() {
    controllerClickable.addListener(() {
      isChanged = true;
    });
    controllerVisible.addListener(() {
      isChanged = true;
    });
    controllerExecute.addListener(() {
      isChanged = true;
    });
    isOccupySpace.listen((value) {
      isChanged = true;
      NodeEditor().target.isOccupySpace = value;
    });

    super.onInit();
  }

  void save() {
    NodeEditor().target.recursiveStatus.conditionClickableString =
        controllerClickable.text;
    NodeEditor().target.recursiveStatus.conditionVisibleString =
        controllerVisible.text;
    NodeEditor().target.recursiveStatus.executeCodeString =
        controllerExecute.text;

    isChanged = false;
    Get.find<VMDraggableNestedMap>().isChanged = true;
  }
}
