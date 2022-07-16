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
  final TextEditingController controllerTitle =
      TextEditingController(text: NodeEditor().target.title);
  final TextEditingController controllerSource = TextEditingController();
  final TextEditingController controllerMaximum =
      TextEditingController(text: NodeEditor().target.maximumStatus.toString());
  late final QuillController quillController;
  final FocusNode focusBody = FocusNode();

  var contents = ''.obs;
  var index = -1;
  var isCard = NodeEditor().target.isCard.obs;
  var isRound = NodeEditor().target.isRound.obs;
  var isSelectable = NodeEditor().target.isSelectable.obs;
  var nodeMode = NodeEditor().target.choiceNodeMode.obs;
  var imagePosition = NodeEditor().target.imagePosition.obs;
  var maximizingImage = NodeEditor().target.maximizingImage.obs;
  var hideTitle = NodeEditor().target.hideTitle.obs;

  bool isChanged = false;

  @override
  void onInit() {
    quillController = NodeEditor().getVMChoiceNode()!.quillController;
    isCard.listen((value) => isChanged = true);
    isRound.listen((value) => isChanged = true);
    isSelectable.listen((value) => isChanged = true);
    nodeMode.listen((value) => isChanged = true);
    imagePosition.listen((value) => isChanged = true);
    maximizingImage.listen((value) => isChanged = true);
    hideTitle.listen((value) => isChanged = true);
    controllerMaximum.addListener(() => isChanged = true);
    contents.listen((value) => isChanged = true);

    controllerTitle.addListener(() {
      isChanged = true;
    });
    quillController.addListener(
        () => contents.value = quillController.document.toPlainText());
    index = ImageDB().getImageIndex(NodeEditor().target.imageString);

    super.onInit();
  }

  void save() {
    NodeEditor().target.title = controllerTitle.text;
    NodeEditor().target.contentsString =
        jsonEncode(quillController.document.toDelta().toJson());
    NodeEditor().target.imageString = ImageDB().getImageName(index);
    try {
      NodeEditor().target.maximumStatus = int.parse(controllerMaximum.text);
    } catch (e) {
      NodeEditor().target.maximumStatus = 0;
    }
    NodeEditor().target.maximizingImage = maximizingImage.value;
    NodeEditor().target.isSelectable = isSelectable.value;
    NodeEditor().target.isRound = isRound.value;
    NodeEditor().target.isCard = isCard.value;
    NodeEditor().target.imagePosition = imagePosition.value;
    NodeEditor().target.hideTitle = hideTitle.value;
    NodeEditor().target.choiceNodeMode = nodeMode.value;

    quillController.updateSelection(
        const TextSelection.collapsed(offset: 0), ChangeSource.REMOTE);
    VMChoiceNode.getVMChoiceNodeFromNode(NodeEditor().target)
        ?.updateFromEditor();
    Get.find<VMDraggableNestedMap>().update();
    Get.find<VMDraggableNestedMap>().isChanged = true;
    isChanged = false;
  }

  void setIndex(int index) {
    if (this.index == index) {
      this.index = -1;
    } else {
      this.index = index;
    }
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
      allowedExtensions: ['png', 'jpg', 'jpeg', 'gif', 'webp', 'bmp'],
      type: FileType.custom,
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
