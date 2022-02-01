import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/util/tuple.dart';
import 'package:cyoap_flutter/view/view_choice_node.dart';
import 'package:cyoap_flutter/viewModel/vm_platform.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class NestedMap extends StatelessWidget {
  const NestedMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VMPlatform>(
      builder: (_) => SingleChildScrollView(
        child: RepaintBoundary(
          key: _.captureKey,
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _.widgetList.length * 2 + 1,
              itemBuilder: (BuildContext context, int x) {
                if (x < _.widgetList.length * 2 - 1) {
                  if (x % 2 == 1) {
                    return const Divider(
                      thickness: 4,
                    );
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
                      _.widgetList[i].length * 2 + 1,
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
                                visible: _.isDrag,
                              );
                            },
                            onAccept: (Tuple<int, int> data) {
                              _.changeData(data, Tuple(j ~/ 2, i));
                            },
                          );
                        } else {
                          int num = j ~/ 2;
                          if (_.isEditable()) {
                            if (ConstList.actualPlatformType ==
                                platformType.mobile) {
                              return LongPressDraggable<Tuple<int, int>>(
                                data: Tuple(num, i),
                                feedback: Transform.scale(
                                  scale: 0.9,
                                  child: _.widgetList[i][num],
                                ),
                                onDragStarted: () {
                                  _.dragStart();
                                },
                                child: _.widgetList[i][num],
                                onDragEnd: (DraggableDetails data) {
                                  _.dragEnd();
                                },
                              );
                            } else {
                              return Draggable<Tuple<int, int>>(
                                data: Tuple(num, i),
                                feedback: Transform.scale(
                                  scale: 0.9,
                                  child: _.widgetList[i][num],
                                ),
                                onDragStarted: () {
                                  _.dragStart();
                                },
                                child: _.widgetList[i][num],
                                onDragEnd: (DraggableDetails data) {
                                  _.dragEnd();
                                },
                              );
                            }
                          }
                          return _.widgetList[i][num];
                        }
                      },
                    ),
                  ),
                );
              } else if (x == _.widgetList.length * 2 - 1) {
                return Visibility(
                  child: const Divider(
                    thickness: 4,
                  ),
                  visible: _.isDrag,
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
                        visible: _.isDrag,
                      );
                    },
                    onAccept: (Tuple<int, int> data) {
                      _.changeData(data, Tuple(0, _.widgetList.length));
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
