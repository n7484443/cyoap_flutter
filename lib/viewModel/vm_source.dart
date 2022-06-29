import 'package:cyoap_flutter/model/image_db.dart';
import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/platform_system.dart';

class VMSource extends GetxController {
  var deleteMode = false.obs;
  var deleteList = List<String>.empty(growable: true).obs;

  TextEditingController getTextEditor(String name) {
    var textEditingController = TextEditingController();
    textEditingController.addListener(() {
      getPlatformFileSystem.addSource(name, textEditingController.text);
    });
    return textEditingController;
  }

  void checkRemove(String name) {
    deleteList.add(name);
  }

  void remove() {
    for (var name in deleteList) {
      ImageDB().removeImage(name);
    }
    update();
    VMChoiceNode.doAllVMChoiceNode((vm) => vm.updateImage());
    Get.find<VMDraggableNestedMap>().isChanged = true;
  }
}
