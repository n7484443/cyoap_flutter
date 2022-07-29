import 'package:cyoap_flutter/model/editor.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class VMCodeEditor extends GetxController {
  final TextEditingController controllerClickable = TextEditingController(
      text: NodeEditor().targetRecursive.conditionClickableString);
  final TextEditingController controllerVisible = TextEditingController(
      text: NodeEditor().targetRecursive.conditionVisibleString);
  final TextEditingController controllerExecute = TextEditingController(
      text: NodeEditor().targetRecursive.executeCodeString);
  final FocusNode focusClickable = FocusNode();
  final FocusNode focusVisible = FocusNode();
  final FocusNode focusExecute = FocusNode();
  TextEditingController? lastFocus;

  var conditionClickable =
      NodeEditor().targetRecursive.conditionClickableString.obs;
  var conditionVisible =
      NodeEditor().targetRecursive.conditionVisibleString.obs;
  var executeCode = NodeEditor().targetRecursive.executeCodeString.obs;

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
    focusClickable.addListener(() {
      lastFocus = controllerClickable;
    });
    focusVisible.addListener(() {
      lastFocus = controllerVisible;
    });
    focusExecute.addListener(() {
      lastFocus = controllerExecute;
    });

    controllerClickable.addListener(() {
      isChanged = true;
      conditionClickable.value = controllerClickable.text;
    });
    controllerVisible.addListener(() {
      isChanged = true;
      conditionVisible.value = controllerVisible.text;
    });
    controllerExecute.addListener(() {
      isChanged = true;
      executeCode.value = controllerExecute.text;
    });
    isOccupySpace.listen((value) {
      isChanged = true;
      NodeEditor().target.isOccupySpace = value;
    });

    super.onInit();
  }

  void save() {
    NodeEditor().target.recursiveStatus.conditionClickableString =
        conditionClickable.value;
    NodeEditor().target.recursiveStatus.conditionVisibleString =
        conditionVisible.value;
    NodeEditor().target.recursiveStatus.executeCodeString = executeCode.value;

    isChanged = false;
    Get.find<VMDraggableNestedMap>().isChanged = true;
  }
}
