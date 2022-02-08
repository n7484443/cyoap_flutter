
import 'package:cyoap_flutter/model/editor.dart';
import 'package:cyoap_flutter/model/grammar/analyser.dart';
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
    controllerClickable.text = NodeEditor.instance.target.conditionClickableString;
    controllerVisible.text = NodeEditor.instance.target.conditionVisibleString;
    controllerExecute.text = NodeEditor.instance.target.executeCodeString;

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
    var conditionClickableRecursive = Analyser.analyseCodes(conditionClickable.value);
    var conditionVisibleRecursive = Analyser.analyseCodes(conditionVisible.value);
    var executeCodeRecursive = Analyser.analyseCodes(executeCode.value);

    NodeEditor.instance.target.conditionClickableRecursive = conditionClickableRecursive.isNotEmpty ? conditionClickableRecursive[0] : null;
    NodeEditor.instance.target.conditionVisibleRecursive = conditionVisibleRecursive.isNotEmpty ? conditionVisibleRecursive[0] : null;
    NodeEditor.instance.target.executeCodeRecursive = executeCodeRecursive;

    NodeEditor.instance.target.conditionClickableString = conditionClickable.value;
    NodeEditor.instance.target.conditionVisibleString = conditionVisible.value;
    NodeEditor.instance.target.executeCodeString = executeCode.value;

    isChanged = false;
  }
}