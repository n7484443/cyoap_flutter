import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/view/util/view_image_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/image_db.dart';
import '../viewModel/vm_make_platform.dart';
import '../viewModel/vm_source.dart';

class ViewSource extends StatelessWidget {
  const ViewSource({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(VMSource());
    var widget = GetBuilder<VMSource>(
      builder: (_) => ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          var name = ImageDB().getImageName(index);
          return Obx(
            () => Card(
              elevation: ConstList.elevation,
              color: controller.deleteList.contains(name)
                  ? Colors.redAccent
                  : Colors.white,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ViewImageLoading(name),
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(name),
                          TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: getPlatformFileSystem.getSource(name) ??
                                  '출처를 여기에 적어주세요!',
                              alignLabelWithHint: true,
                            ),
                            controller: controller.getTextEditor(name),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: controller.deleteMode.value,
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        controller.checkRemove(name);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: ImageDB().imageList.length,
      ),
    );

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              makePlatform.back();
            },
          ),
          title: Obx(() {
            if (!controller.deleteMode.value) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: '프로젝트에서 이미지 삭제',
                    onPressed: () {
                      controller.deleteMode.value = true;
                    },
                  ),
                ],
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: '이미지 삭제 취소',
                  onPressed: () {
                    controller.deleteList.clear();
                    controller.deleteMode.value = false;
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.check),
                  tooltip: '프로젝트에서 이미지 삭제',
                  onPressed: () {
                    controller.remove();
                    controller.deleteMode.value = false;
                  },
                ),
              ],
            );
          }),
        ),
        body: widget,
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
