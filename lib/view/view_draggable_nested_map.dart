import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/util/tuple.dart';
import 'package:cyoap_flutter/view/view_choice_node.dart';
import 'package:cyoap_flutter/viewModel/vm_platform.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NodeDivider extends StatelessWidget {
  final int y;

  const NodeDivider(this.y, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vmPlatform = Get.find<VMPlatform>();
    if (vmPlatform.isEditable()) {
      return Stack(
        children: [
          const Divider(
            thickness: 4,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: PopupMenuButton<int>(
              icon: const Icon(Icons.more_vert),
              onSelected: (result) {
                if (result == 0) {
                  showDialog(
                    context: context,
                    builder: (builder) => GetBuilder<VMPlatform>(
                      builder: (_) => AlertDialog(
                        scrollable: true,
                        title: const Text('최대 선택지 개수 설정'),
                        content: Column(
                          children: [
                            Row(
                              children: [
                                const Text('선택 가능'),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.chevron_left),
                                  onPressed: () {
                                    vmPlatform.addMaxSelect(y, -1);
                                  },
                                ),
                                Text(vmPlatform.getMaxSelect(y)),
                                IconButton(
                                  icon: const Icon(Icons.chevron_right),
                                  onPressed: () {
                                    vmPlatform.addMaxSelect(y, 1);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 0,
                    child: Text('최대 선택 설정'),
                  ),
                ];
              },
            ),
          ),
        ],
        alignment: Alignment.center,
      );
    } else {
      return const Divider(
        thickness: 4,
      );
    }
  }
}

class NestedMap extends StatelessWidget {
  const NestedMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VMPlatform>(
      builder: (_) => LayoutBuilder(
        builder: (context, constrains) => SingleChildScrollView(
          controller: _.scroller,
          child: RepaintBoundary(
            key: _.captureKey,
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child:Column(
                key: _.keyListView,
                children: List<Widget>.generate( _.widgetList.length * 2 + 1, (x){
                if (x < _.widgetList.length * 2 - 1) {
                  if (x % 2 == 1) {
                        return NodeDivider(x ~/ 2 + 1);
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
                                return Visibility(
                                  child: DragTarget<Tuple<int, int>>(
                                    builder: (BuildContext context,
                                        List<dynamic> accepted,
                                        List<dynamic> rejected) {
                                      return Container(
                                        color: Colors.black12,
                                        width: nodeBaseWidth / 6 * _.getScale(),
                                        height: nodeBaseHeight * _.getScale(),
                                      );
                                    },
                                onAccept: (Tuple<int, int> data) {
                                  if (_.drag == Tuple(-1, -1)) {
                                    _.changeData(data, Tuple(j ~/ 2, i));
                                  } else {
                                    if ((j - 2) > (_.drag!.data2 * 2)) {
                                      _.changeData(
                                          data, Tuple(j ~/ 2 - 1, i));
                                    } else {
                                      _.changeData(data, Tuple(j ~/ 2, i));
                                    }
                                  }
                                },
                              ),
                              visible: _.drag != null &&
                                  _.drag != Tuple(i, j ~/ 2 - 1),
                            );
                          } else {
                                int num = j ~/ 2;
                                if (_.isEditable()) {
                                  if (ConstList.isSmallDisplay(context)) {
                                    return LongPressDraggable<Tuple<int, int>>(
                                      onDragUpdate: (details) => _.dragUpdate(
                                          constrains, details, context),
                                      data: Tuple(num, i),
                                      feedback: Transform.scale(
                                        scale: 0.9,
                                        child: _.widgetList[i][num],
                                      ),
                                      onDragStarted: () {
                                        _.dragStart(i, num);
                                      },
                                      child: Visibility(
                                        child: _.widgetList[i][num],
                                        visible: _.drag != Tuple(i, num),
                                      ),
                                      onDragEnd: (DraggableDetails data) {
                                        _.dragEnd();
                                      },
                                      onDraggableCanceled:
                                          (Velocity velocity, Offset offset) {
                                        _.dragEnd();
                                      },
                                    );
                                  } else {
                                    return Draggable<Tuple<int, int>>(
                                      onDragUpdate: (details) => _.dragUpdate(
                                          constrains, details, context),
                                      data: Tuple(num, i),
                                      feedback: Transform.scale(
                                        scale: 0.9,
                                        child: _.widgetList[i][num],
                                      ),
                                      onDragStarted: () {
                                        _.dragStart(i, num);
                                      },
                                      child: Visibility(
                                        child: _.widgetList[i][num],
                                        visible: _.drag != Tuple(i, num),
                                      ),
                                      onDragEnd: (DraggableDetails data) {
                                        _.dragEnd();
                                      },
                                      onDraggableCanceled:
                                          (Velocity velocity, Offset offset) {
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
                        visible: _.drag != null,
                      );
                    } else {
                      return DragTarget<Tuple<int, int>>(
                        builder: (BuildContext context, List<dynamic> accepted,
                            List<dynamic> rejected) {
                          return Visibility(
                            child: Container(
                              color: Colors.black12,
                              width: nodeBaseWidth / 6 * _.getScale(),
                              height: nodeBaseHeight * _.getScale(),
                            ),
                            visible: _.drag != null,
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
        ),
      ),
    );
  }
}
