import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:get/get.dart';

class VMDesignSetting extends GetxController {
  var titleOverlap = getPlatform.designSetting.titleOverlap.obs;
  var titlePosition = getPlatform.designSetting.titlePosition.obs;
  var titleFont = getPlatform.designSetting.titleFont.obs;
  var mainFont = getPlatform.designSetting.mainFont.obs;
  var colorBackground = getPlatform.designSetting.colorBackground.obs;
  var colorNode = getPlatform.designSetting.colorNode.obs;

  @override
  void onInit() {
    titleOverlap.listen((value) {
      getPlatform.designSetting.titleOverlap = value;
      Get.find<VMDraggableNestedMap>().isChanged = true;
    });
    titlePosition.listen((value) {
      getPlatform.designSetting.titlePosition = value;
      Get.find<VMDraggableNestedMap>().isChanged = true;
    });
    titleFont.listen((value) {
      getPlatform.designSetting.titleFont = value;
      Get.find<VMDraggableNestedMap>().isChanged = true;
    });
    mainFont.listen((value) {
      getPlatform.designSetting.mainFont = value;
      Get.find<VMDraggableNestedMap>().isChanged = true;
    });
    colorBackground.listen((value) {
      getPlatform.designSetting.colorBackground = value;
      Get.find<VMDraggableNestedMap>().isChanged = true;
      Get.find<VMDraggableNestedMap>().update();
    });
    colorNode.listen((value) {
      getPlatform.designSetting.colorNode = value;
      Get.find<VMDraggableNestedMap>().isChanged = true;
    });
    super.onInit();
  }

  void setTitleFont(String font) {
    titleFont.value = font;
  }

  void setMainFont(String font) {
    mainFont.value = font;
  }
}
