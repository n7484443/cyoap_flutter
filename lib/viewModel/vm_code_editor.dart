import 'package:cyoap_flutter/model/editor.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class VMCodeEditor extends GetxController {
  final TextEditingController controllerClickable = TextEditingController();
  final TextEditingController controllerVisible = TextEditingController();
  final TextEditingController controllerExecute = TextEditingController();
  final FocusNode focusClickable = FocusNode();
  final FocusNode focusVisible = FocusNode();
  final FocusNode focusExecute = FocusNode();
  TextEditingController? lastFocus;

  var conditionClickable = ''.obs;
  var conditionVisible = ''.obs;
  var executeCode = ''.obs;

  var isOccupySpace = true.obs;

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
    focusExecute.onKey = (FocusNode node, RawKeyEvent event) {
      if (!event.isKeyPressed(LogicalKeyboardKey.tab)) {
        return KeyEventResult.ignored;
      }
      insertText(controllerExecute, "    ");
      return KeyEventResult.handled;
    };
    focusClickable.addListener(() {
      lastFocus = controllerClickable;
    });
    focusVisible.addListener(() {
      lastFocus = controllerVisible;
    });
    focusExecute.addListener(() {
      lastFocus = controllerExecute;
    });

    controllerClickable.text =
        NodeEditor().target.recursiveStatus.conditionClickableString;
    controllerVisible.text =
        NodeEditor().target.recursiveStatus.conditionVisibleString;
    controllerExecute.text =
        NodeEditor().target.recursiveStatus.executeCodeString;
    conditionClickable.value = controllerClickable.text;
    conditionVisible.value = controllerVisible.text;
    executeCode.value = controllerExecute.text;
    isOccupySpace.value = NodeEditor().target.isOccupySpace;

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
