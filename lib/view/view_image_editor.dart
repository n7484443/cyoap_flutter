import 'package:cyoap_flutter/viewModel/vm_image_editor.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../viewModel/vm_editor.dart';

class ViewImageEditor extends StatelessWidget {
  const ViewImageEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(VMImageEditor(), permanent: true);
    var controllerEditor = Get.find<VMEditor>();
    controller.data = controllerEditor.imageLast;
    return Column(
      children: [
        Flexible(
          child: ExtendedImage.memory(
            controller.data!,
            fit: BoxFit.contain,
            mode: ExtendedImageMode.editor,
            extendedImageEditorKey: controller.globalEditorKey,
            initEditorConfigHandler: (ExtendedImageState? state) {
              return EditorConfig(
                  maxScale: 4.0,
                  hitTestSize: 20.0,
                  cropRectPadding: const EdgeInsets.all(10.0),
                  initCropRectType: InitCropRectType.imageRect,
                  editActionDetailsIsChanged: (EditActionDetails? details) {});
            },
          ),
        ),
        FloatingActionButton(
          child: const Icon(Icons.crop),
          onPressed: () async {
            controllerEditor.imageLast = null;
            controllerEditor.addImageCrop(await controller.cropImage());
            Get.back(id: 1);
          },
        ),
      ],
    );
  }
}
