import 'package:cyoap_flutter/util/tuple.dart';
import 'package:cyoap_flutter/view/view_draggable_nested_map.dart';
import 'package:cyoap_flutter/view/view_variable_table.dart';
import 'package:cyoap_flutter/viewModel/vm_platform.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../main.dart';

class ViewMake extends StatelessWidget {
  const ViewMake({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vmPlatform = Get.put(VMPlatform());
    vmPlatform.updateWidgetList();
    if (ConstList.actualPlatformType == platformType.mobile) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(ConstList.appBarSize),
          child: AppBar(
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
                    child: Get.find<VMPlatform>().getWidgetFromType(1, -1, -1),
                  ),
                  onDragStarted: () {
                    Get.find<VMPlatform>().dragStart();
                  },
                  onDragEnd: (DraggableDetails data) {
                    Get.find<VMPlatform>().dragEnd();
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            actions: [
              Visibility(
                child: IconButton(
                  icon: const Icon(Icons.archive),
                  onPressed: () {
                    Get.find<VMPlatform>().save(true);
                  },
                ),
                visible: !ConstList.isFileSystem(),
              ),
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  Get.find<VMPlatform>().save(false);
                },
              )
            ],
          ),
        ),
        drawer: const ViewVariable(),
        body: const NestedMap(),
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
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(ConstList.appBarSize),
                child: AppBar(
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
                      ),
                      Draggable<Tuple<int, int>>(
                        data: Tuple(-1, -1),
                        feedback: Transform.scale(
                          scale: 0.9,
                          child: Get.find<VMPlatform>().getWidgetFromType(1, -1, -1),
                        ),
                        onDragStarted: () {
                          Get.find<VMPlatform>().dragStart();
                        },
                        onDragEnd: (DraggableDetails data) {
                          Get.find<VMPlatform>().dragEnd();
                        },
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  actions: [
                    Visibility(
                      child: IconButton(
                        icon: const Icon(Icons.archive),
                        onPressed: () {
                          Get.find<VMPlatform>().save(true);
                        },
                      ),
                      visible: !ConstList.isFileSystem(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () {
                        Get.find<VMPlatform>().save(false);
                      },
                    )
                  ],
                ),
              ),
              body: const NestedMap(),
            ),
          ),
        ],
      );
    }
  }
}


