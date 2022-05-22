import 'package:cyoap_flutter/view/util/view_back_dialog.dart';
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

    var appbarWidget = PreferredSize(
      preferredSize: const Size.fromHeight(ConstList.appBarSize),
      child: AppBar(
        leading: IconButton(
          tooltip: '뒤로가기',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Get.find<VMDraggableNestedMap>().isChanged) {
              showDialog(
                context: context,
                builder: (_) => ViewBackDialog(
                  () => vmPlatform.save(ConstList.isWeb()),
                  () => Get.back(),
                ),
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
                return const Tooltip(
                    message: '드래그&드랍으로 선택지 삭제', child: Icon(Icons.delete));
              },
              onAccept: (List<int> data) {
                Get.find<VMDraggableNestedMap>().removeData(data);
              },
            ),
            Draggable<List<int>>(
              data: [nonPositioned, nonPositioned],
              feedback: Transform.scale(
                scale: 0.9,
                child: Opacity(
                  opacity: 0.6,
                  child: ViewChoiceNode(nonPositioned, nonPositioned),
                ),
              ),
              onDragStarted: () {
                Get.find<VMDraggableNestedMap>()
                    .dragStart([nonPositioned, nonPositioned]);
              },
              onDragEnd: (DraggableDetails data) {
                Get.find<VMDraggableNestedMap>().dragEnd();
              },
              onDragUpdate: (DragUpdateDetails details) {
                Get.find<VMDraggableNestedMap>().dragUpdate(details, context);
              },
              child: const Tooltip(
                message: '드래그로 선택지 생성',
                child: Icon(Icons.add),
              ),
            ),
            Obx(
              () => Visibility(
                visible:
                    Get.find<VMDraggableNestedMap>().removedData.value != null,
                child: Draggable<List<int>>(
                  data: [removedPositioned, removedPositioned],
                  feedback: Transform.scale(
                    scale: 0.9,
                    child: Opacity(
                      opacity: 0.6,
                      child:
                          ViewChoiceNode(removedPositioned, removedPositioned),
                    ),
                  ),
                  onDragStarted: () {
                    Get.find<VMDraggableNestedMap>()
                        .dragStart([removedPositioned, removedPositioned]);
                  },
                  onDragEnd: (DraggableDetails data) {
                    Get.find<VMDraggableNestedMap>().dragEnd();
                  },
                  onDragUpdate: (DragUpdateDetails details) {
                    Get.find<VMDraggableNestedMap>()
                        .dragUpdate(details, context);
                  },
                  child: const Tooltip(
                    message: '최근 삭제된 선택지 생성',
                    child: Icon(Icons.auto_delete),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            tooltip: '변수 목록 갱신',
            onPressed: () {
              vmPlatform.loadVariable();
            },
          ),
          PopupMenuButton(
            icon: const Icon(Icons.save),
            tooltip: '저장 관련 옵션',
            onSelected: (selected) {
              Get.defaultDialog(
                barrierDismissible: false,
                title: selected == 0
                    ? '저장중...'
                    : selected == 1
                        ? '압축중...'
                        : '이미지로 추출중...',
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    Obx(() =>
                        Text(vmPlatform.stopwatch.value.elapsed.toString())),
                  ],
                ),
              );
              switch (selected) {
                case 0:
                  vmPlatform.save(false);
                  break;
                case 1:
                  vmPlatform.save(true);
                  break;
                case 2:
                  vmPlatform.exportAsImage();
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                if (!getPlatformFileSystem.openAsFile)
                  const PopupMenuItem(
                    value: 0,
                    child: Text('저장'),
                  ),
                PopupMenuItem(
                  value: 1,
                  child: Text('${ConstList.isMobile() ? 'download 폴더에 ' : ''}zip 파일로 추출'),
                ),
                if (ConstList.isDesktop())
                  const PopupMenuItem(
                    value: 2,
                    child: Text('이미지로 추출'),
                  ),
              ];
            },
          )
        ],
      ),
    );

    return WillPopScope(
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (_) => ViewBackDialog(
            () => vmPlatform.save(ConstList.isWeb()),
            () => Get.back(),
          ),
        ) as Future<bool>;
      },
      child: Scaffold(
        appBar: appbarWidget,
        body: const NestedMap(),
      ),
    );
  }
}
