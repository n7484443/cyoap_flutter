
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

  @override
  void onInit(){
    controllerClickable.addListener(() {
      conditionClickable.value = controllerClickable.text;
    });
    controllerVisible.addListener(() {
      conditionVisible.value = controllerVisible.text;
    });

    controllerExecute.addListener(() {
      executeCode.value = controllerExecute.text;
    });

    super.onInit();
  }
}