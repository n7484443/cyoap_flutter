import 'dart:convert';
import 'dart:typed_data';

import 'package:cyoap_flutter/model/editor.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/viewModel/vm_platform.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart';
import 'package:zefyr/zefyr.dart';

class VMEditor extends GetxController{
  final TextEditingController controllerTitle = TextEditingController();
  late final ZefyrController zefyrController;
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
      zefyrController = ZefyrController();
    } else {
      var document = NotusDocument.fromJson(jsonDecode(NodeEditor.instance.target.contentsString));
      zefyrController = ZefyrController(document);
    }
    isCard = NodeEditor.instance.target.isCard;
    isSelectable = NodeEditor.instance.target.isSelectable;
    controllerTitle.text = NodeEditor.instance.target.title;
    title.value = controllerTitle.text;

    contents.value = zefyrController.document.toPlainText();

    controllerTitle.addListener(() {
      title.value = controllerTitle.text;
      isChanged = true;
    });

    zefyrController.addListener(() {
      contents.value = zefyrController.document.toPlainText();
      isChanged = true;
    });
    super.onInit();
  }

  void save() {
    NodeEditor.instance.target.title = title.value;
    NodeEditor.instance.target.contentsString =
        jsonEncode(zefyrController.document.toJson());
    Get.find<VMPlatform>().updateWidgetList();
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

  void setSelectable(bool value) {
    isSelectable = value;
    NodeEditor.instance.target.isSelectable = value;
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
      var names = file.name;
      var bytes = file.bytes!;
      /*if(file.name.endsWith('.gif')){
        names = names.replaceAll('.gif', '.apng');
        bytes = encodePngAnimation(decodeGifAnimation(bytes)!, level: 0) as Uint8List;
      }*/
      PlatformSystem.addImage(names, bytes);
      NodeEditor.instance.target.imageString = file.name;
      index = PlatformSystem.getImageIndex(file.name);
      Get.find<VMPlatform>().isChanged = true;
      isChanged = true;
      update();
    }
  }
}