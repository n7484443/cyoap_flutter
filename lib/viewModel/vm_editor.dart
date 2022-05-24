import 'dart:convert';
import 'dart:typed_data';

import 'package:cyoap_flutter/model/editor.dart';
import 'package:cyoap_flutter/model/image_db.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

class VMEditor extends GetxController {
  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerSource = TextEditingController();
  final TextEditingController controllerRandom = TextEditingController();
  late final QuillController quillController;
  final FocusNode focusBody = FocusNode();

  var title = NodeEditor().target.title.obs;
  var contents = ''.obs;
  var index = -1;
  var isCard = NodeEditor().target.isCard.obs;
  var isRound = NodeEditor().target.isRound.obs;
  var isSelectable = NodeEditor().target.isSelectable.obs;
  var isRandom = NodeEditor().target.isRandom.obs;
  var maximizingImage = NodeEditor().target.maximizingImage.obs;

  bool isChanged = false;

  @override
  void onInit() {
    quillController = NodeEditor().getVMChoiceNode()!.quillController;
    isCard.listen((value) {
      isChanged = true;
    });

    isRound.listen((value) {
      isChanged = true;
    });

    isSelectable.listen((value) {
      isChanged = true;
    });

    isRandom.listen((value) {
      isChanged = true;
    });

    maximizingImage.listen((value) {
      isChanged = true;
    });

    controllerRandom.addListener(() {
      isChanged = true;
    });

    controllerRandom.text = NodeEditor().target.maxRandom.toString();

    controllerTitle.text = title.value;
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
    NodeEditor().target.title = title.value;
    NodeEditor().target.contentsString =
        jsonEncode(quillController.document.toDelta().toJson());
    if (index != -1){
      NodeEditor().target.imageString = ImageDB().getImageName(index);
    }
    NodeEditor().target.maxRandom = int.parse(controllerRandom.text);
    NodeEditor().target.maximizingImage = maximizingImage.value;
    NodeEditor().target.maxRandom = isRandom.value ? 2 : 0;
    NodeEditor().target.isSelectable = isSelectable.value;
    NodeEditor().target.isRound = isRound.value;
    NodeEditor().target.isCard = isCard.value;

    quillController.updateSelection(
        const TextSelection.collapsed(offset: 0), ChangeSource.REMOTE);
    VMChoiceNode.getVMChoiceNodeFromNode(NodeEditor().target)
        ?.updateFromEditor();
    Get.find<VMDraggableNestedMap>().update();
    Get.find<VMDraggableNestedMap>().isChanged = true;
    isChanged = false;
  }

  void setIndex(int index) {
    this.index = index;
    isChanged = true;
    update();
  }

  int getImageLength() {
    return ImageDB().imageList.length;
  }

  Uint8List? imageLast;
  String? name;

  Future<String> addImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.image,
    );
    String name = '';
    if (result != null) {
      name = result.files.single.name;
      imageLast = result.files.single.bytes!;
      isChanged = true;
    }
    return name;
  }

  Future<void> addImageCrop(Uint8List data) async {
    ImageDB().uploadImages(name!, data);
    NodeEditor().target.imageString = name!;
    index = ImageDB().getImageIndex(name!);
    Get.find<VMDraggableNestedMap>().isChanged = true;
    isChanged = true;
    name = null;
    imageLast = null;
    update();
  }

  void addImageSource(String name) {
    getPlatformFileSystem.addSource(name, controllerSource.text);
  }
}
