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
      if (controller.image.value == null) {
        return SizedBox.fromSize(
          size: controller.size ?? const Size(100, 50),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      return controller.image.value!;
    });
  }
}

class VMImageLoading extends GetxController {
  Rx<Image?> image = Rx(null);
  String name;
  Size? size;

  VMImageLoading(this.name);

  @override
  void onInit() {
    image = Rx(null);
    ImageDB().getImage(name).then((value) {
      image.value = value;
    });
    super.onInit();
  }
}
