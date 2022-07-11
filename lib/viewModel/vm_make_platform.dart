import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/view_code_editor.dart';
import '../view/view_design.dart';
import '../view/view_editor.dart';
import '../view/view_font_source.dart';
import '../view/view_global_settings.dart';
import '../view/view_image_editor.dart';
import '../view/view_make.dart';
import '../view/view_source.dart';

VMMakePlatform get makePlatform => Get.find<VMMakePlatform>();

class VMMakePlatform extends GetxController {
  final currentIndex = 0.obs;
  List<int> stack = List.empty(growable: true);
  List<Widget> pages = [
    const ViewMake(),
    const ViewEditor(),
    const ViewCodeEditor(),
    const ViewGlobalSetting(),
    const ViewSource(),
    const ViewFontSource(),
    const ViewImageEditor(),
    const ViewDesignSetting(),
  ];

  Widget get currentPage => pages[currentIndex.value];

  void changePage(int index){
    currentIndex.value = index;
    if(stack.isEmpty || stack.last != index){
      stack.add(index);
    }
  }

  void back(){
    if(stack.length <= 1){
      changePage(0);
      stack.clear();
    }else{
      stack.removeLast();
      currentIndex.value = stack.last;
    }
  }

  void changePageString(String index){
    switch(index){
      case "viewMake":
        return changePage(0);
      case "viewEditor":
        return changePage(1);
      case "viewCodeEditor":
        return changePage(2);
      case "viewGlobalSetting":
        return changePage(3);
      case "viewSource":
        return changePage(4);
      case "viewFontSource":
        return changePage(5);
      case "viewImageEditor":
        return changePage(6);
      case "viewDesignSetting":
        return changePage(7);
    }
    return changePage(0);
  }
}
