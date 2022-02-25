import 'package:cyoap_flutter/view/view_text_outline.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:cyoap_flutter/viewModel/vm_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:get/get.dart';

import '../main.dart';
import '../model/platform_system.dart';
import '../util/tuple.dart';

/*
  Card──Container─children─┬──title
                           ├──image
                           ├──area
                           └──Card──subChoiceSet
  */


class ViewChoiceNodeTextWithImage extends StatelessWidget {
  final int posX;
  final int posY;

  const ViewChoiceNodeTextWithImage(
      {Key? key, required this.posX, required this.posY})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vmDraggableNestedMap = Get.find<VMDraggableNestedMap>();
    var size = vmDraggableNestedMap.getSize(Tuple(posX, posY));
    var realSize = vmDraggableNestedMap.getRealSize(Tuple(posX, posY));
    var node = vmDraggableNestedMap.getNode(posX, posY)!;

    var mainNode = GetBuilder<VMDraggableNestedMap>(
      builder: (_) => Container(
        color: vmDraggableNestedMap.isSelect(posX, posY)
            ? Colors.lightBlueAccent
            : Colors.white,
        width: realSize.data1 * _.getScale().data1,
        height: realSize.data2 * _.getScale().data2,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Visibility(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 8.0),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          child: Image(
                            image:
                                PlatformSystem.getImage(node.imageString).image,
                            filterQuality: FilterQuality.high,
                            isAntiAlias: true,
                          ),
                        ),
                      ),
                      visible: node.imageString.isNotEmpty,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Visibility(
                      child: TextOutline(node.title,18 * _.getScale().data2),
                      visible: node.title.isNotEmpty,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Visibility(
                      child: PopupMenuButton<int>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (result) {
                          if (result == 0) {
                            vmDraggableNestedMap.sizeSet.data1 = size.data1;
                            vmDraggableNestedMap.sizeSet.data2 = size.data2;
                            showDialog(
                              context: context,
                              builder: (builder) => GetBuilder<VMPlatform>(
                                builder: (_) => AlertDialog(
                                  scrollable: true,
                                  alignment: Alignment.center,
                                  title: const Text('크기 수정'),
                                  content: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('길이'),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          IconButton(
                                            icon:
                                                const Icon(Icons.chevron_left),
                                            onPressed: () {
                                              vmDraggableNestedMap.sizeChange(-1, 0);
                                            },
                                          ),
                                          Text('${vmDraggableNestedMap.sizeSet.data1 == 0 ? 'max': vmDraggableNestedMap.sizeSet.data1}'),
                                          IconButton(
                                            icon:
                                                const Icon(Icons.chevron_right),
                                            onPressed: () {
                                              vmDraggableNestedMap.sizeChange(1, 0);
                                            },
                                          ),
                                        ],
                                      ),
                                      const Text('높이'),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          RotatedBox(
                                            quarterTurns: 2,
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.double_arrow,
                                              ),
                                              onPressed: () {
                                                vmDraggableNestedMap.sizeChange(0, -5);
                                              },
                                            ),
                                          ),
                                          IconButton(
                                            icon:
                                                const Icon(Icons.chevron_left),
                                            onPressed: () {
                                              vmDraggableNestedMap.sizeChange(0, -1);
                                            },
                                          ),
                                          Text(
                                              '${vmDraggableNestedMap.sizeSet.data2/10}'),
                                          IconButton(
                                            icon:
                                                const Icon(Icons.chevron_right),
                                            onPressed: () {
                                              vmDraggableNestedMap.sizeChange(0, 1);
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.double_arrow,
                                            ),
                                            onPressed: () {
                                              vmDraggableNestedMap.sizeChange(0, 5);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('변경'),
                                      onPressed: () {
                                        vmDraggableNestedMap.setSize(Tuple(posX, posY),
                                            vmDraggableNestedMap.sizeSet);
                                        vmDraggableNestedMap.updateWidgetList();
                                        Get.back();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              value: 0,
                              child: Text('크기 수정'),
                            ),
                          ];
                        },
                      ),
                      visible: vmDraggableNestedMap.mouseHover == Tuple(posX, posY) &&
                          vmDraggableNestedMap.isEditable(),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              child: IgnorePointer(
                child: quill.QuillEditor(
                  controller: vmDraggableNestedMap.getNodeController(posX, posY)!,
                  focusNode: FocusNode(),
                  readOnly: true,
                  autoFocus: false,
                  expands: false,
                  padding: const EdgeInsets.only(top:4),
                  scrollController: ScrollController(),
                  scrollable: false,
                  customStyles: ConstList.getDefaultThemeData(
                      context, _.getScale().data2,
                      fontStyle: ConstList.getFont(
                          PlatformSystem.getPlatform().mainFont)),
                ),
              ),
              visible: node.contentsString.isNotEmpty,
            ),
          ],
        ),
      ),
    );

    if (vmDraggableNestedMap.isEditable()) {
      return GetBuilder<VMPlatform>(
        builder: (_) => InkWell(
          onTap: () {
            if (ConstList.isMobile()) {
              if (vmDraggableNestedMap.isEditable()) {
                vmDraggableNestedMap.setHover(posX, posY);
              }
            }
          },
          onHover: (val) {
            if (!ConstList.isMobile()) {
              if (val) {
                vmDraggableNestedMap.setHover(posX, posY);
              }
            }
          },
          onDoubleTap: () {
            if (vmDraggableNestedMap.isEditable()) {
              vmDraggableNestedMap.setEdit(posX, posY);
              Get.toNamed('/viewEditor');
            }
          },
          child: mainNode,
        ),
      );
    } else {
      return GetBuilder<VMPlatform>(
        builder: (_) => IgnorePointer(
          ignoring: !vmDraggableNestedMap.isSelectable(posX, posY),
          child: InkWell(
            onTap: () {
              vmDraggableNestedMap.select(posX, posY);
            },
            child: Opacity(
                opacity: vmDraggableNestedMap.isSelectablePreCheck(posX, posY) ? 1.0 : 0.5, child: mainNode),
          ),
        ),
      );
    }
  }
}