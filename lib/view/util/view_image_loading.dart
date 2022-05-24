import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/image_db.dart';

class ViewImageLoading extends StatelessWidget {
  final String name;

  const ViewImageLoading(this.name, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(VMImageLoading(name), tag: name);
    return Obx(() {
      switch(controller.imageLoaded.value){
        case 0:
          return SizedBox.fromSize(
            size: const Size(100, 100),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        case 1:
          return controller.getData();
        default:
          return ImageDB().noImage;
      }
    });
  }
}

class VMImageLoading extends GetxController {
  var imageLoaded = 0.obs; // 0 = unloaded 1 = loaded 2 = no data
  String name;

  VMImageLoading(this.name);

  @override
  void onInit() {
    ImageDB().getImage(name).then((value) {
      imageLoaded.value = 1;
    });
    super.onInit();
  }

  Image getData(){
    return ImageDB().getImageFromCache(name);
  }

  void checkNeedRemove(){
    if(!ImageDB().isInCache(name) && !ImageDB().isInData(name)){
      imageLoaded.value = 2;
    }
  }
}
