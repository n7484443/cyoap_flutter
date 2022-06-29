import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/image_db.dart';

class ViewImageLoading extends StatelessWidget {
  final String name;

  const ViewImageLoading(this.name, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(VMImageLoading(name), tag: name);
    return GetBuilder<VMImageLoading>(builder: (_) {
      switch (controller.imageLoaded) {
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
  var imageLoaded = 0; // 0 = unloaded 1 = loaded 2 = no data
  String name;

  VMImageLoading(this.name);

  @override
  void onInit() {
    ImageDB().getImage(name).then((value) {
      imageLoaded = 1;
      update();
    });
    super.onInit();
  }

  Image getData() {
    return ImageDB().getImageFromCache(name);
  }

  void checkNeedRemove() {
    if (!ImageDB().isInCache(name) && !ImageDB().isInData(name)) {
      imageLoaded = 2;
      update();
    }
  }
}