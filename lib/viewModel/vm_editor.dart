import 'package:cyoap_flutter/model/editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zefyrka/zefyrka.dart';

class VMEditor extends GetxController{
  final TextEditingController controllerTitle = TextEditingController();
  final ZefyrController controllerBody = ZefyrController();

  var title = ''.obs;
  var contents = NotusDocument().obs;

  void updateString(String title, NotusDocument contents){
    this.title.value = title;
    this.contents.value = contents;
    update();
  }
  @override
  void onInit(){
    controllerTitle.addListener(() {
      title.value = controllerTitle.text;
    });

    controllerBody.addListener(() {
      contents.value = controllerBody.document;
    });

    super.onInit();
  }

  void save() {
    print('제목 : $title, 내용 : $contents');
  }
}