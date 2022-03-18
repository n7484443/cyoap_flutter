import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../model/platform_system.dart';

class VMSource extends GetxController {
  TextEditingController getTextEditor(String name) {
    var textEditingController = TextEditingController();
    textEditingController.addListener(() {
      getPlatformFileSystem().addSource(name, textEditingController.text);
    });
    return textEditingController;
  }
}
