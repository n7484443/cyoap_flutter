import 'package:cyoap_flutter/util/tuple.dart';
import 'package:cyoap_flutter/view/view_draggable_nested_map.dart';
import 'package:cyoap_flutter/view/view_variable_table.dart';
import 'package:cyoap_flutter/viewModel/vm_platform.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../main.dart';
import '../model/platform_system.dart';

class ViewMake extends StatelessWidget {
  const ViewMake({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vmPlatform = Get.put(VMPlatform());
    vmPlatform.updateWidgetList();

    var dialog = AlertDialog(
      title: const Text('뒤로가기'),
      content: const Text('저장되지 않은 내용이 있습니다. 저장하시겠습니까?'),
      actions: [
        ElevatedButton(
          onPressed: () {
            vmPlatform.isChanged = false;
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
      preferredSize: Size.fromHeight(ConstList.appBarSize),
      child: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if(vmPlatform.isChanged){
              showDialog(
                context: context,
                builder: (_) => dialog,
              );
            }else{
              Get.back();
            }
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DragTarget<Tuple<int, int>>(
              builder: (BuildContext context, List<dynamic> accepted,
                  List<dynamic> rejected) {
                return const Icon(Icons.delete);
              },
              onAccept: (Tuple<int, int> data) {
                Get.find<VMPlatform>().removeData(data);
              },
              onMove: (DragTargetDetails<Tuple<int, int>> details){
              },
            ),
            Draggable<Tuple<int, int>>(
              data: Tuple(-1, -1),
              feedback: Transform.scale(
                scale: 0.9,
                child: Get.find<VMPlatform>()
                    .getWidgetFromType(0, true, -1, -1),
              ),
              onDragStarted: () {
                Get.find<VMPlatform>().dragStart(-1, -1);
              },
              onDragEnd: (DraggableDetails data) {
                Get.find<VMPlatform>().dragEnd();
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
              Get.find<VMPlatform>().exportAsImage();
            },
          ),
          Visibility(
            child: IconButton(
              icon: const Icon(MdiIcons.zipBox),
              onPressed: () {
                Get.defaultDialog(
                  barrierDismissible: false,
                  title: '압축중...',
                  content: Obx(() => Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LinearProgressIndicator(
                            value: PlatformSystem.instance.platformFileSystem
                                .saveProgress.value.progressPercent,
                          ),
                          Text(
                              '${PlatformSystem.instance.platformFileSystem.saveProgress.value.progress} / ${PlatformSystem.instance.platformFileSystem.saveProgress.value.progressMax}'),
                        ],
                      )),
                );
                Get.find<VMPlatform>().save(true);
              },
            ),
            visible: !ConstList.isOnlyFileAccept(),
          ),
          Visibility(
            child: IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Get.defaultDialog(
                  barrierDismissible: false,
                  title: '저장중...',
                  content: Obx(() => Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LinearProgressIndicator(
                            value: PlatformSystem.instance.platformFileSystem
                                .saveProgress.value.progressPercent,
                          ),
                          Text(
                              '${PlatformSystem.instance.platformFileSystem.saveProgress.value.progress} / ${PlatformSystem.instance.platformFileSystem.saveProgress.value.progressMax}'),
                        ],
                      )),
                );
                Get.find<VMPlatform>().save(false);
              },
            ),
            visible: !PlatformSystem.instance.platformFileSystem.openAsFile,
          )
        ],
      ),
    );
    
    if (ConstList.isSmallDisplay(context)) {
      return WillPopScope(
        onWillPop: () {
          return showDialog(
            context: context,
            builder: (_) => dialog,
          ) as Future<bool>;
        },
        child: Scaffold(
          appBar: appbarWidget,
          drawer: const ViewVariable(),
          body: const NestedMap(),
        ),
      );
    } else {
      return Row(
        children: [
          const ViewVariable(),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child: Scaffold(
              appBar: appbarWidget,
              body: const NestedMap(),
            ),
          ),
        ],
      );
    }
  }
}


