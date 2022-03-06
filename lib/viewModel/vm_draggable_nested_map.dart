import 'dart:convert';

import 'package:cyoap_flutter/viewModel/vm_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/choiceNode/choice_node.dart';
import '../model/editor.dart';
import '../model/platform_system.dart';
import '../util/tuple.dart';
import '../view/view_draggable_nested_map.dart';

class VMDraggableNestedMap extends GetxController {
  List<Widget> widgetList = List.empty(growable: true);
  Tuple<int, int>? drag;
  Tuple<int, int> mouseHover = Tuple(-1, -1);
  Tuple<int, int> sizeSet = Tuple(1, 1);

  GlobalKey captureKey = GlobalKey();
  GlobalKey keyListView = GlobalKey();

  ScrollController scroller = ScrollController();

  bool isChanged = false;

  void updateWidgetList(BuildContext context, BoxConstraints constrains) {
    var choiceNodeList = getPlatform().choiceNodes;

    widgetList = List<Widget>.generate(choiceNodeList.length * 2 + 1, (y) {
      if (y <= choiceNodeList.length * 2 - 2) {
        if (y.isEven) {
          var xList = choiceNodeList[y ~/ 2];
          return Padding(
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 12,
            ),
            child: GetBuilder<VMDraggableNestedMap>(
              builder: (_) => Wrap(
                spacing: 2,
                alignment: WrapAlignment.center,
                children: List<Widget>.generate(
                  xList.data1.length * 2 + 1,
                  (x) {
                    var i = x ~/ 2;
                    var j = y ~/ 2;
                    if (x.isOdd) {
                      var widget = getChoiceWidget(xList.data1[i].isCard, i, j);
                      if (_.isEditable()) {
                        var pos = Tuple(i, j);
                        if (ConstList.isSmallDisplay(context)) {
                          return LongPressDraggable<Tuple<int, int>>(
                            onDragUpdate: (details) =>
                                _.dragUpdate(constrains, details, context),
                            data: pos,
                            feedback: Transform.scale(
                              scale: 0.9,
                              child: widget,
                            ),
                            onDragStarted: () {
                              _.dragStart(pos);
                            },
                            child: Visibility(
                              child: widget,
                              visible: _.drag != pos,
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
                            onDragUpdate: (details) =>
                                _.dragUpdate(constrains, details, context),
                            data: pos,
                            feedback: Transform.scale(
                              scale: 0.9,
                              child: widget,
                            ),
                            onDragStarted: () {
                              _.dragStart(pos);
                            },
                            child: Visibility(
                              child: widget,
                              visible: _.drag != pos,
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
                      } else {
                        return widget;
                      }
                    } else {
                      return Visibility(
                        child: DragTarget<Tuple<int, int>>(
                          builder: (BuildContext context,
                              List<dynamic> accepted, List<dynamic> rejected) {
                            return Container(
                              color: Colors.black12,
                              width: nodeBaseWidth / 6 * getScale().data1,
                              height: nodeBaseHeight * 10 * getScale().data2,
                            );
                          },
                          onAccept: (Tuple<int, int> data) {
                            if (drag == Tuple(-1, -1)) {
                              changeData(data, Tuple(i, j));
                            } else {
                              if ((j - 2) > (drag!.data2 * 2)) {
                                changeData(data, Tuple(i, j - 1));
                              } else {
                                changeData(data, Tuple(i, j));
                              }
                            }
                          },
                        ),
                        visible: drag != null && drag != Tuple(i - 1, j),
                      );
                    }
                  },
                ),
              ),
            ),
          );
        } else {
          return NodeDivider(y ~/ 2 + 1);
        }
      } else {
        if (y.isEven) {
          return Visibility(
            child: DragTarget<Tuple<int, int>>(
              builder: (BuildContext context,
                  List<dynamic> accepted, List<dynamic> rejected) {
                return Container(
                  color: Colors.black12,
                  width: double.infinity,
                  height: nodeBaseHeight * 10 * getScale().data2,
                );
              },
              onAccept: (Tuple<int, int> data) {
                changeData(data, Tuple(0, choiceNodeList.length));
              },
            ),
            visible: drag != null,
          );
        } else {
          return GetBuilder<VMDraggableNestedMap>(
            builder: (_) => Visibility(
              child: NodeDivider(y ~/ 2 + 1),
              visible: drag != null,
            ),
          );
        }
      }
    });
  }

  void setHover(int x, int y) {
    mouseHover = Tuple(x, y);
    update();
  }

  Tuple<int, int> getSize(Tuple<int, int> position) {
    var node = getNode(position.data1, position.data2)!;
    return Tuple(node.width, node.height);
  }

  double nodeBaseWidth = 160;
  double nodeBaseHeight = 20;

  Tuple<double, double> getRealSize(Tuple<int, int> position) {
    var node = getSize(position);
    var width = node.data1 == 0 ? double.infinity : node.data1 * nodeBaseWidth;
    var height = node.data2 * nodeBaseHeight;
    return Tuple(width, height);
  }

  void removeData(Tuple<int, int> data) {
    getPlatform().removeData(data.data1, data.data2);
    update();
  }

  void changeData(Tuple<int, int> data, Tuple<int, int> pos) {
    if (data == Tuple(-1, -1)) {
      getPlatform().addData(pos.data1, pos.data2, createNodeForTemp());
    } else {
      getPlatform().changeData(data, pos);
    }
    update();
  }

  void dragStart(Tuple<int, int> pos) {
    drag = pos;
    update();
  }

  void dragEnd() {
    drag = null;
    update();
  }

  double findMaxWidth() {
    return captureKey.currentContext!.width;
  }

  void setSize(Tuple<int, int> position, Tuple<int, int> size) {
    var node = getNode(position.data1, position.data2)!;
    node.width = size.data1;
    node.height = size.data2;
  }

  void dragUpdate(BoxConstraints constrains, DragUpdateDetails details,
      BuildContext context) {
    double topY = 0;
    double bottomY = topY + constrains.maxHeight;

    var detectedRange = constrains.maxHeight * 0.1;
    var moveDistance = ConstList.isSmallDisplay(context) ? 1.5 : 3;
    if (details.localPosition.dy < topY + detectedRange) {
      scroller.jumpTo(scroller.offset - moveDistance);
    }
    if (details.localPosition.dy > bottomY - detectedRange) {
      scroller.jumpTo(scroller.offset + moveDistance);
    }
  }

  Color getBackgroundColor() {
    return getPlatform().colorBackground;
  }

  Tuple<double, double> getScale() {
    var context = captureKey.currentContext;
    if (context == null) return Tuple(drag == null ? 1 : 0.9, 1);
    var sizeMultiply = ConstList.isSmallDisplay(context) ? 0.75 : 1;
    return Tuple<double, double>(drag == null ? 1 : 0.9, 1).mul(sizeMultiply);
  }

  bool isEditable() {
    return getPlatform().isEditable;
  }

  ChoiceNodeBase? getNode(int x, int y) {
    if (x == -1 && y == -1) {
      return createNodeForTemp();
    }
    return getPlatform().getChoiceNode(x, y);
  }

  ChoiceNodeBase createNodeForTemp() {
    return ChoiceNodeBase.noTitle(1, 10, true, '', '');
  }

  QuillController? getNodeController(int x, int y) {
    var node = getNode(x, y);
    if (node == null || node.contentsString.isEmpty) {
      return QuillController.basic();
    } else {
      var json = jsonDecode(node.contentsString);
      var document = Document.fromJson(json);
      return QuillController(
          document: document,
          selection: const TextSelection.collapsed(offset: 0));
    }
  }

  Future<void> exportAsImage() async {
    var boundary =
        captureKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    PlatformSystem.instance.saveCapture(await boundary.toImage());
  }

  void select(int posX, int posY) {
    if (getNode(posX, posY)!.isSelectableWithCheck()) {
      getPlatform().setSelect(posX, posY);
      update();
    }
  }

  void sizeChange(int x, int y) {
    sizeSet.data1 += x;
    sizeSet.data2 += y;
    if (sizeSet.data1 < 0) {
      sizeSet.data1 = 0;
    }
    if (sizeSet.data2 < 5) {
      sizeSet.data2 = 5;
    }
    update();
  }

  bool isSelectable(int posX, int posY) {
    return getNode(posX, posY)?.isSelectableWithCheck() ?? false;
  }

  bool isSelectablePreCheck(int posX, int posY) {
    var node = getNode(posX, posY)!;
    if(node.isSelectable){
      return node.isSelectableCheck;
    }
    return true;
  }

  void addMaxSelect(int y, int max) {
    if ((getPlatform().getLineSetting(y)!.maxSelect + max) >=
        -1) {
      getPlatform().getLineSetting(y)?.maxSelect += max;
    }
    update();
    isChanged = true;
  }

  bool isSelect(int posX, int posY) {
    if (posX == -1 && posY == -1) return false;
    return getPlatform().isSelect(posX, posY);
  }

  void setEdit(int posX, int posY) {
    var node = getPlatform().getChoiceNode(posX, posY);

    if (node == null) {
      return;
    }
    ChoiceNodeBase nodeNonnull = node;
    NodeEditor.instance.setTarget(nodeNonnull);
  }

  String getMaxSelect(int y) {
    var line = getPlatform().getLineSetting(y);
    var max = line == null ? -1 : line.maxSelect;
    return max == -1 ? '무한' : '$max';
  }

  TextStyle getTitleFont() {
    return ConstList.getFont(getPlatform().titleFont);
  }
}
