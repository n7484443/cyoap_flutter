import 'dart:convert';
import 'dart:typed_data';

import 'package:cyoap_flutter/model/editor.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/viewModel/vm_platform.dart';
import 'package:cyoap_flutter/viewModel/vm_variable_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

class VMEditor extends GetxController{
  final TextEditingController controllerTitle = TextEditingController();
  late final QuillController controllerBody;
  final FocusNode focusBody = FocusNode();

  var title = ''.obs;
  var contents = ''.obs;

  @override
  void onInit(){
    if(NodeEditor.instance.target.contentsString.isEmpty){
      controllerBody = QuillController.basic();
    }else{
      controllerBody = QuillController(
        document: Document.fromJson(jsonDecode(NodeEditor.instance.target.contentsString)),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
    controllerTitle.text = NodeEditor.instance.target.title;

    controllerTitle.addListener(() {
      title.value = controllerTitle.text;
    });

    controllerBody.addListener(() {
      contents.value = controllerBody.document.toPlainText();
    });
    super.onInit();
  }

  void save() {
    NodeEditor.instance.target.contentsString = jsonEncode(controllerBody.document.toDelta().toJson());
    NodeEditor.instance.target.title = title.value;
    Get.find<VMPlatform>().update();
    Get.find<VMVariableTable>().update();
  }

  Uint8List getImage(int i){
    return PlatformSystem.getImageList()[i];
  }

  void setImage(int index) {
    NodeEditor.instance.target.imageString = PlatformSystem.getImageName(index);
    Get.find<VMPlatform>().update();
  }

  int getImageLength(){
    return PlatformSystem.getImageList().length;
  }
}