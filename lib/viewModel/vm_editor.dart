import 'dart:convert';
import 'dart:typed_data';

import 'package:cyoap_flutter/model/editor.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/viewModel/vm_platform.dart';
import 'package:cyoap_flutter/viewModel/vm_variable_table.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

class VMEditor extends GetxController{
  final TextEditingController controllerTitle = TextEditingController();
  late final QuillController controllerBody;
  final FocusNode focusBody = FocusNode();

  var title = ''.obs;
  var contents = ''.obs;
  var index = -1;
  var isCard = false;

  bool isChanged = false;

  @override
  void onInit() {
    if (NodeEditor.instance.target.contentsString.isEmpty) {
      controllerBody = QuillController.basic();
    } else {
      controllerBody = QuillController(
        document: Document.fromJson(
            jsonDecode(NodeEditor.instance.target.contentsString)),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
    isCard = NodeEditor.instance.target.isCard;
    controllerTitle.text = NodeEditor.instance.target.title;

    controllerTitle.addListener(() {
      title.value = controllerTitle.text;
      isChanged = true;
    });

    controllerBody.addListener(() {
      contents.value = controllerBody.document.toPlainText();
      isChanged = true;
    });
    super.onInit();
  }

  void save() {
    NodeEditor.instance.target.contentsString =
        jsonEncode(controllerBody.document.toDelta().toJson());
    NodeEditor.instance.target.title = title.value;
    Get.find<VMPlatform>().updateWidgetList();
    Get.find<VMPlatform>().update();
    Get.find<VMVariableTable>().update();
    isChanged = false;
  }

  Uint8List getImage(int i){
    return PlatformSystem.getImageList()[i];
  }

  void setImage(int index) {
    this.index = index;
    NodeEditor.instance.target.imageString = PlatformSystem.getImageName(index);
    isChanged = true;
    update();
  }

  int getImageLength() {
    return PlatformSystem.getImageList().length;
  }

  void setCard(bool value) {
    isCard = value;
    NodeEditor.instance.target.isCard = value;
    isChanged = true;
    update();
  }

  Future<void> addImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.image,
    );
    if(result != null){
      var file = result.files.single;

      if(file.bytes == null)return;
      PlatformSystem.addImage(file.name, file.bytes!);
      Get.find<VMPlatform>().isChanged = true;
      update();
    }
  }
}