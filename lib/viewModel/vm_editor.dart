import 'package:cyoap_flutter/model/editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zefyrka/zefyrka.dart';

class VMEditor extends GetxController{
  final TextEditingController controllerTitle = TextEditingController();
  final ZefyrController controllerBody = ZefyrController();
  final FocusNode focusBody = FocusNode();

  var title = ''.obs;
  var contentsDocument = NotusDocument();
  var contents = ''.obs;

  @override
  void onInit(){
    controllerTitle.addListener(() {
      title.value = controllerTitle.text;
    });

    controllerBody.addListener(() {
      contentsDocument = controllerBody.document;
      contents.value = controllerBody.document.toPlainText();
    });

    super.onInit();
  }

  void save() {
    print('제목 : $title, 내용 : $contents');
  }
}