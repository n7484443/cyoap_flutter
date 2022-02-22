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

double nodeBaseWidth = 200;
double nodeBaseHeight = 360;

class ViewChoiceNodeTextWithImage extends StatelessWidget {
  final int posX;
  final int posY;

  const ViewChoiceNodeTextWithImage(
      {Key? key, required this.posX, required this.posY})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vmPlatform = Get.find<VMPlatform>();
    var size = vmPlatform.getSize(Tuple(posX, posY));
    var node = vmPlatform.getNode(posX, posY)!;

    var mainNode = GetBuilder<VMPlatform>(
      builder: (_) => Container(
        color: vmPlatform.isSelect(posX, posY)
            ? Colors.lightBlueAccent
            : Colors.white,
        width: nodeBaseWidth * size.data1 * _.getScale().data1,
        height: nodeBaseHeight * size.data2 * _.getScale().data2,
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
                      child: Stack(
                        children: [
                          Text(
                            node.title,
                            style: ConstList.getFont(PlatformSystem.getPlatform().titleFont).copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18 * _.getScale().data2,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 4
                                ..color = Colors.white,
                            ),
                          ),
                          Text(
                            node.title,
                            style: ConstList.getFont(PlatformSystem.getPlatform().titleFont).copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18 * _.getScale().data2,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
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
                            vmPlatform.sizeSet.data1 = size.data1;
                            vmPlatform.sizeSet.data2 = (size.data2 - 0.5).abs() <= 1e-5 ? 0 : size.data2.toInt();
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
                                              vmPlatform.sizeChange(-1, 0);
                                            },
                                          ),
                                          Text('${vmPlatform.sizeSet.data1}'),
                                          IconButton(
                                            icon:
                                                const Icon(Icons.chevron_right),
                                            onPressed: () {
                                              vmPlatform.sizeChange(1, 0);
                                            },
                                          ),
                                        ],
                                      ),
                                      const Text('높이'),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          IconButton(
                                            icon:
                                                const Icon(Icons.chevron_left),
                                            onPressed: () {
                                              vmPlatform.sizeChange(0, -1);
                                            },
                                          ),
                                          Text('${vmPlatform.sizeSet.data2 < 1 ? 0.5 : vmPlatform.sizeSet.data2}'),
                                          IconButton(
                                            icon:
                                                const Icon(Icons.chevron_right),
                                            onPressed: () {
                                              vmPlatform.sizeChange(0, 1);
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
                                        vmPlatform.setSize(Tuple(posX, posY),
                                            vmPlatform.sizeSet);
                                        vmPlatform.updateWidgetList();
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
                      visible: vmPlatform.mouseHover == Tuple(posX, posY) &&
                          vmPlatform.isEditable(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Visibility(
                child: IgnorePointer(
                  child: quill.QuillEditor(
                    controller: vmPlatform.getNodeController(posX, posY)!,
                    focusNode: FocusNode(),
                    readOnly: true,
                    autoFocus: false,
                    expands: true,
                    padding: const EdgeInsets.all(0),
                    scrollController: ScrollController(),
                    scrollable: false,
                    customStyles: ConstList.getDefaultThemeData(
                        context, _.getScale().data2,
                        fontStyle: ConstList.getFont(PlatformSystem.getPlatform().mainFont)),
                  ),
                ),
                visible: node.contentsString.isNotEmpty,
              ),
            ),
          ],
        ),
      ),
    );

    if (vmPlatform.isEditable()) {
      return GetBuilder<VMPlatform>(
        builder: (_) => InkWell(
          onTap: () {
            if (ConstList.isMobile()) {
              if (vmPlatform.isEditable()) {
                vmPlatform.setHover(posX, posY);
              }
            }
          },
          onHover: (val) {
            if (!ConstList.isMobile()) {
              if (val) {
                vmPlatform.setHover(posX, posY);
              }
            }
          },
          onDoubleTap: () {
            if (vmPlatform.isEditable()) {
              vmPlatform.setEdit(posX, posY);
              Get.toNamed('/viewEditor');
            }
          },
          child: mainNode,
        ),
      );
    } else {
      return GetBuilder<VMPlatform>(
        builder: (_) => IgnorePointer(
          ignoring: !vmPlatform.isSelectable(posX, posY),
          child: InkWell(
            onTap: () {
              vmPlatform.select(posX, posY);
            },
            child: Opacity(
                opacity: vmPlatform.isSelectablePreCheck(posX, posY) ? 1.0 : 0.5, child: mainNode),
          ),
        ),
      );
    }
  }
}