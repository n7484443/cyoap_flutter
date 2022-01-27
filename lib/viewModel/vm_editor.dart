import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

class VMEditor extends GetxController{
  final TextEditingController controllerTitle = TextEditingController();
  final QuillController controllerBody = QuillController.basic();
  final FocusNode focusBody = FocusNode();

  var title = ''.obs;
  var contents = ''.obs;

  @override
  void onInit(){
    controllerTitle.addListener(() {
      title.value = controllerTitle.text;
    });

    controllerBody.addListener(() {
      contents.value = controllerBody.document.toPlainText();
    });

    super.onInit();
  }

  void save() {
    print('제목 : $title, 내용 : $contents ${controllerBody.document.toDelta()}');

  }
}