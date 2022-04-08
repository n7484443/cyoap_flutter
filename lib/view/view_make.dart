import 'package:cyoap_flutter/view/view_choice_node.dart';
import 'package:cyoap_flutter/view/view_draggable_nested_map.dart';
import 'package:cyoap_flutter/viewModel/vm_platform.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../main.dart';
import '../model/platform_system.dart';
import '../viewModel/vm_choice_node.dart';
import '../viewModel/vm_draggable_nested_map.dart';

class ViewMake extends StatelessWidget {
  const ViewMake({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vmPlatform = Get.put(VMPlatform());

    var dialog = AlertDialog(
      title: const Text('뒤로가기'),
      content: const Text('저장되지 않은 내용이 있습니다. 저장하시겠습니까?'),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: const Text('아니오'),
        ),
        ElevatedButton(
          onPressed: () {
            vmPlatform.save(ConstList.isOnlyFileAccept());
            Get.back();
            Get.back();
          },
          child: const Text('예'),
        ),
      ],
    );
    var appbarWidget = PreferredSize(
      preferredSize: const Size.fromHeight(ConstList.appBarSize),
      child: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Get.find<VMDraggableNestedMap>().isChanged) {
              showDialog(
                context: context,
                builder: (_) => dialog,
              );
            } else {
              Get.back();
            }
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DragTarget<List<int>>(
              builder: (BuildContext context, List<dynamic> accepted,
                  List<dynamic> rejected) {
                return const Icon(Icons.delete);
              },
              onAccept: (List<int> data) {
                Get.find<VMDraggableNestedMap>().removeData(data);
              },
              onMove: (DragTargetDetails<List<int>> details) {},
            ),
            Draggable<List<int>>(
              data: [nonPositioned, nonPositioned],
              feedback: Transform.scale(
                scale: 0.9,
                child: Opacity(
                  child: ViewChoiceNode(nonPositioned, nonPositioned),
                  opacity: 0.6,
                ),
              ),
              onDragStarted: () {
                Get.find<VMDraggableNestedMap>().dragStart([nonPositioned, nonPositioned]);
              },
              onDragEnd: (DraggableDetails data) {
                Get.find<VMDraggableNestedMap>().dragEnd();
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {
              Get.find<VMPlatform>().loadVariable();
            },
          ),
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () {
              Get.defaultDialog(
                barrierDismissible: false,
                title: '이미지로 추출중...',
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    Obx(() => Text(Get.find<VMPlatform>()
                        .stopwatch
                        .value
                        .elapsed
                        .toString())),
                  ],
                ),
              );
              Get.find<VMPlatform>().exportAsImage();
            },
          ),
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: () {
              Get.defaultDialog(
                barrierDismissible: false,
                title: '압축중...',
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    Obx(() => Text(Get.find<VMPlatform>()
                        .stopwatch
                        .value
                        .elapsed
                        .toString())),
                  ],
                ),
              );
              Get.find<VMPlatform>().save(true);
            },
          ),
          Visibility(
            child: IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Get.defaultDialog(
                  barrierDismissible: false,
                  title: '저장중...',
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      Obx(() => Text(Get.find<VMPlatform>()
                          .stopwatch
                          .value
                          .elapsed
                          .toString())),
                    ],
                  ),
                );
                Get.find<VMPlatform>().save(false);
              },
            ),
            visible: !PlatformSystem().platformFileSystem.openAsFile,
          )
        ],
      ),
    );

    return WillPopScope(
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (_) => dialog,
        ) as Future<bool>;
      },
      child: Scaffold(
        appBar: appbarWidget,
        body: const NestedMap(),
      ),
    );
  }
}
