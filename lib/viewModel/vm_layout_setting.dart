import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:get/get.dart';


class VMLayoutSetting extends GetxController{
  var titleOverlap = true.obs;
  var titlePosition = true.obs;

  @override
  void onInit(){
    titleOverlap.listen((value) {
      getPlatform.layoutSetting.titleOverlap = value;
    });
    titlePosition.listen((value) {
      getPlatform.layoutSetting.titlePosition = value;
    });
    super.onInit();
  }
}