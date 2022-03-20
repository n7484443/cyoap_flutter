import 'package:cyoap_flutter/model/editor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VMCodeEditor extends GetxController {
  final TextEditingController controllerClickable = TextEditingController();
  final TextEditingController controllerVisible = TextEditingController();
  final TextEditingController controllerExecute = TextEditingController();
  final FocusNode focusBody = FocusNode();

  var conditionClickable = ''.obs;
  var conditionVisible = ''.obs;
  var executeCode = ''.obs;
  bool isChanged = false;

  @override
  void onInit() {
    controllerClickable.text =
        NodeEditor.instance.target.recursiveStatus.conditionClickableString;
    controllerVisible.text = NodeEditor.instance.target.recursiveStatus.conditionVisibleString;
    controllerExecute.text = NodeEditor.instance.target.recursiveStatus.executeCodeString;
    conditionClickable.value = controllerClickable.text;
    conditionVisible.value = controllerVisible.text;
    executeCode.value = controllerExecute.text;

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

    super.onInit();
  }

  void save() {
    NodeEditor.instance.target.recursiveStatus.conditionClickableString =
        conditionClickable.value;
    NodeEditor.instance.target.recursiveStatus.conditionVisibleString = conditionVisible.value;
    NodeEditor.instance.target.recursiveStatus.executeCodeString = executeCode.value;

    isChanged = false;
  }
}
