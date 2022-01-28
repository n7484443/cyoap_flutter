import 'package:cyoap_flutter/util/tuple.dart';
import 'package:cyoap_flutter/view/view_choice_node.dart';
import 'package:cyoap_flutter/viewModel/vm_platform.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class NestedMap extends StatelessWidget {
  const NestedMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vmPlatform = Get.put(VMPlatform());
    vmPlatform.updateWidgetList();
    return GetBuilder<VMPlatform>(
      builder: (_) => ListView.builder(
        shrinkWrap: true,
        itemCount: vmPlatform.widgetList.length * 2 + 1,
        itemBuilder: (BuildContext context, int x) {
          if (x < vmPlatform.widgetList.length * 2 - 1) {
            if (x % 2 == 1) {
              return const Divider();
            }
            int i = x ~/ 2;
            return Padding(
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 12,
              ),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: List<Widget>.generate(
                  vmPlatform.widgetList[i].length * 2 + 1,
                  (int j) {
                    if (j % 2 == 0) {
                      return DragTarget<Tuple<int, int>>(
                        builder: (BuildContext context, List<dynamic> accepted,
                            List<dynamic> rejected) {
                          return Visibility(
                            child: Container(
                              color: Colors.black12,
                              width: nodeBaseWidth / 6,
                              height: nodeBaseHeight,
                            ),
                            visible: vmPlatform.isDrag,
                          );
                        },
                        onAccept: (Tuple<int, int> data) {
                          vmPlatform.changeData(data, Tuple(j ~/ 2, i));
                        },
                      );
                    } else {
                      int num = j ~/ 2;
                      if (vmPlatform.isEditable()) {
                        return Draggable<Tuple<int, int>>(
                          data: Tuple(num, i),
                          feedback: Transform.scale(
                            scale: 0.9,
                            child: vmPlatform.widgetList[i][num],
                          ),
                          onDragStarted: () {
                            vmPlatform.dragStart();
                          },
                          child: vmPlatform.widgetList[i][num],
                          onDragEnd: (DraggableDetails data) {
                            vmPlatform.dragEnd();
                          },
                        );
                      }
                      return vmPlatform.widgetList[i][num];
                    }
                  },
                ),
              ),
            );
          } else if (x == vmPlatform.widgetList.length * 2 - 1) {
            return Visibility(
              child: const Divider(),
              visible: vmPlatform.isDrag,
            );
          } else {
            return DragTarget<Tuple<int, int>>(
              builder: (BuildContext context, List<dynamic> accepted,
                  List<dynamic> rejected) {
                return Visibility(
                  child: Container(
                    color: Colors.black12,
                    width: nodeBaseWidth / 6,
                    height: nodeBaseHeight,
                  ),
                  visible: vmPlatform.isDrag,
                );
              },
              onAccept: (Tuple<int, int> data) {
                vmPlatform.changeData(
                    data, Tuple(0, vmPlatform.widgetList.length));
              },
            );
          }
        },
      ),
    );
  }
}
