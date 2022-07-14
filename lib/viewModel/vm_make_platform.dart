import 'package:cyoap_flutter/viewModel/vm_code_editor.dart';
import 'package:cyoap_flutter/viewModel/vm_editor.dart';
import 'package:cyoap_flutter/viewModel/vm_global_setting.dart';
import 'package:cyoap_flutter/viewModel/vm_image_editor.dart';
import 'package:cyoap_flutter/viewModel/vm_source.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/util/view_back_dialog.dart';
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

  Future<bool> removeFunction(int index) async {
    switch (index) {
      case 1:
        var controller = Get.find<VMEditor>();
        if (Get.find<VMEditor>().isChanged) {
          var out = await showDialog(
            context: Get.context!,
            builder: (_) => ViewBackDialog(
              () => controller.save(),
              () => {},
              cancelFunction: () => controller.isChanged = false,
            ),
          );
          if (!out) {
            return false;
          }
        }
        Get.delete<VMEditor>();
        break;
      case 2:
        var controller = Get.find<VMCodeEditor>();
        if (controller.isChanged) {
          var out = await showDialog(
            context: Get.context!,
            builder: (_) => ViewBackDialog(
              () => controller.save(),
              () => {},
              cancelFunction: () => controller.isChanged = false,
            ),
          );
          if (!out) {
            return false;
          }
        }
        Get.delete<VMCodeEditor>();
        break;
      case 3:
        var controller = Get.find<VMGlobalSetting>();
        if (controller.isChanged) {
          var out = await showDialog(
            context: Get.context!,
            builder: (_) => ViewBackDialog(
              () => controller.save(),
              () => {},
              cancelFunction: () => controller.isChanged = false,
            ),
          );
          if (!out) {
            return false;
          }
        }
        Get.delete<VMGlobalSetting>();
        break;
      case 4:
        Get.delete<VMSource>();
        break;
      case 6:
        Get.delete<VMImageEditor>();
        break;
    }
    return true;
  }

  List<Widget Function()> pages = [
    () => const ViewMake(),
    () => const ViewEditor(),
    () => const ViewCodeEditor(),
    () => const ViewGlobalSetting(),
    () => const ViewSource(),
    () => const ViewFontSource(),
    () => const ViewImageEditor(),
    () => const ViewDesignSetting(),
  ];

  Widget get currentPage => pages[currentIndex.value]();

  void changePage(int index) {
    removeFunction(currentIndex.value).then((value) {
      if (value) {
        currentIndex.value = index;
        if (stack.isEmpty || stack.last != index) {
          stack.add(index);
        }
      }
    });
  }

  void back() {
    if (stack.length <= 1) {
      changePage(0);
      stack.clear();
    } else {
      removeFunction(currentIndex.value).then((value) {
        if (value) {
          stack.removeLast();
          currentIndex.value = stack.last;
        }
      });
    }
  }

  void changePageString(String index) {
    switch (index) {
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
