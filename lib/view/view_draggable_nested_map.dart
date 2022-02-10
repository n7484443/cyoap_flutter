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
                            return Visibility(
                              child: DragTarget<Tuple<int, int>>(
                                builder: (BuildContext context,
                                    List<dynamic> accepted,
                                    List<dynamic> rejected) {
                                  return Container(
                                    color: Colors.black12,
                                    width: nodeBaseWidth / 6,
                                    height: nodeBaseHeight,
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
                              if (ConstList.actualPlatformType ==
                                  platformType.mobile) {
                                return LongPressDraggable<Tuple<int, int>>(
                                  data: Tuple(num, i),
                                  feedback: Transform.scale(
                                    scale: 0.9,
                                    child: _.widgetList[i][num],
                                  ),
                                  onDragStarted: () {
                                    _.dragStart(num, i);
                                  },
                                  child: _.widgetList[i][num],
                                  onDragEnd: (DraggableDetails data) {
                                    _.dragEnd();
                                  },
                                );
                              } else {
                                return GestureDetector(
                                  child: Draggable<Tuple<int, int>>(
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
                                  ),
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
                          width: nodeBaseWidth / 6,
                          height: nodeBaseHeight,
                        ),
                        visible: _.drag != null,
                      );
                    },
                    onAccept: (Tuple<int, int> data) {
                      _.changeData(data, Tuple(0, _.widgetList.length));
                    },
                  );
                }
              }),
              )
              /*child: ListView.builder(
                key: _.keyListView,
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
                              return Visibility(
                                child: DragTarget<Tuple<int, int>>(
                                  builder: (BuildContext context,
                                      List<dynamic> accepted,
                                      List<dynamic> rejected) {
                                    return Container(
                                      color: Colors.black12,
                                      width: nodeBaseWidth / 6,
                                      height: nodeBaseHeight,
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
                                if (ConstList.actualPlatformType ==
                                    platformType.mobile) {
                                  return LongPressDraggable<Tuple<int, int>>(
                                    data: Tuple(num, i),
                                    feedback: Transform.scale(
                                      scale: 0.9,
                                      child: _.widgetList[i][num],
                                    ),
                                    onDragStarted: () {
                                      _.dragStart(num, i);
                                    },
                                    child: _.widgetList[i][num],
                                    onDragEnd: (DraggableDetails data) {
                                      _.dragEnd();
                                    },
                                  );
                                } else {
                                  return GestureDetector(
                                    child: Draggable<Tuple<int, int>>(
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
                                    ),
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
                            width: nodeBaseWidth / 6,
                            height: nodeBaseHeight,
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
              ),*/
            ),
          ),
        ),
      ),
    );
  }
}
