import 'dart:convert';
import 'dart:typed_data';

import 'package:cyoap_flutter/model/editor.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

class VMEditor extends GetxController{
  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerSource = TextEditingController();
  late final QuillController quillController;
  final FocusNode focusBody = FocusNode();

  var title = ''.obs;
  var contents = ''.obs;
  var index = -1;
  var isCard = false;
  var isSelectable = true;

  bool isChanged = false;

  @override
  void onInit() {
    if (NodeEditor.instance.target.contentsString.isEmpty) {
      quillController = QuillController.basic();
    } else {
      var document = Document.fromJson(
          jsonDecode(NodeEditor.instance.target.contentsString));
      quillController = QuillController(
          document: document,
          selection: const TextSelection.collapsed(offset: 0));
    }
    isCard = NodeEditor.instance.target.isCard;
    isSelectable = NodeEditor.instance.target.isSelectable;
    controllerTitle.text = NodeEditor.instance.target.title;
    title.value = controllerTitle.text;

    contents.value = quillController.document.toPlainText();

    controllerTitle.addListener(() {
      title.value = controllerTitle.text;
      isChanged = true;
    });

    quillController.addListener(() {
      contents.value = quillController.document.toPlainText();
      isChanged = true;
    });
    super.onInit();
  }

  void save() {
    NodeEditor.instance.target.title = title.value;
    NodeEditor.instance.target.contentsString =
        jsonEncode(quillController.document.toDelta().toJson());
    Get.find<VMDraggableNestedMap>().update();
    isChanged = false;
  }

  Image getImage(int i){
    return PlatformSystem.getImage(PlatformSystem.getImageName(i));
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

  void setSelectable(bool value) {
    isSelectable = value;
    NodeEditor.instance.target.isSelectable = value;
    isChanged = true;
    update();
  }

  Uint8List? imageLast;

  Future<String> addImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.image,
    );
    String name = '';
    if (result != null) {
      name = result.files.single.name;
      imageLast = result.files.single.bytes!;
    }
    isChanged = true;
    return name;
  }

  Future<void> addImageCrop(String name, Uint8List data) async {
    PlatformSystem.addImage(name, data);
    NodeEditor.instance.target.imageString = name;
    index = PlatformSystem.getImageIndex(name);
    Get.find<VMDraggableNestedMap>().isChanged = true;
    imageLast = null;

    isChanged = true;
    update();
  }

  void addImageSource(String name) {
    getPlatformFileSystem().addSource(name, controllerSource.text);
  }
}