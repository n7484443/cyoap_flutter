import 'dart:ui';

import 'package:cyoap_flutter/viewModel/vm_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';
import '../model/platform_system.dart';
import '../util/tuple.dart';

/*
  Card──Container─children─┬──title
                           ├──image
                           ├──area
                           └──Card──subChoiceSet
  */

double nodeBaseWidth = 240;
double nodeBaseHeight = 360;

class ViewChoiceNodeTextWithImage extends StatelessWidget {
  final int posX;
  final int posY;

  const ViewChoiceNodeTextWithImage(
      {Key? key, required this.posX, required this.posY})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = Get.find<VMPlatform>().getSize(Tuple(posX, posY));
    var node = Get.find<VMPlatform>().getNode(posX, posY)!;
    return InkWell(
      onTap: () {
        if (ConstList.isMobile()) {
          if(Get.find<VMPlatform>().isEditable()){
            Get.find<VMPlatform>().setHover(posX, posY);
          }
        }
        if(!Get.find<VMPlatform>().isEditable()) {
          Get.find<VMPlatform>().select(posX, posY);
        }
      },
      onHover: (val) {
        if (!ConstList.isMobile()) {
          if (val) {
            Get.find<VMPlatform>().setHover(posX, posY);
          }
        }
      },
      onDoubleTap: () {
        if(Get.find<VMPlatform>().isEditable()) {
          Get.find<VMPlatform>().setEdit(posX, posY);
          Get.toNamed('/viewEditor');
        }
      },
      child: GetBuilder<VMPlatform>(
        builder: (_) => Container(
          color: Get.find<VMPlatform>().isSelect(posX, posY)
              ? Colors.lightBlueAccent
              : Colors.white,
          width: nodeBaseWidth * size.data1,
          height: nodeBaseHeight * size.data2,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Visibility(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                            child: Image(
                              image:
                                  PlatformSystem.getImage(node.imageString).image,
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
                              style: GoogleFonts.notoSans(
                                  textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 4
                                  ..color = Colors.white,
                              )),
                            ),
                            Text(
                              node.title,
                              style: GoogleFonts.notoSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.black87,
                                ),
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
                              Get.find<VMPlatform>().sizeSet.data1 = size.data1;
                              Get.find<VMPlatform>().sizeSet.data2 = size.data2;
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
                                              icon: const Icon(
                                                  Icons.chevron_left),
                                              onPressed: () {
                                                Get.find<VMPlatform>()
                                                    .sizeChange(-1, 0);
                                              },
                                            ),
                                            Text(
                                                '${Get.find<VMPlatform>().sizeSet.data1}'),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.chevron_right),
                                              onPressed: () {
                                                Get.find<VMPlatform>()
                                                    .sizeChange(1, 0);
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
                                              icon: const Icon(
                                                  Icons.chevron_left),
                                              onPressed: () {
                                                Get.find<VMPlatform>()
                                                    .sizeChange(0, -1);
                                              },
                                            ),
                                            Text(
                                                '${Get.find<VMPlatform>().sizeSet.data2}'),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.chevron_right),
                                              onPressed: () {
                                                Get.find<VMPlatform>()
                                                    .sizeChange(0, 1);
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
                                          Get.find<VMPlatform>().setSize(
                                              Tuple(posX, posY),
                                              Get.find<VMPlatform>().sizeSet);
                                          Get.find<VMPlatform>()
                                              .updateWidgetList();
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
                        visible: Get.find<VMPlatform>().mouseHover ==
                                Tuple(posX, posY) &&
                            Get.find<VMPlatform>().isEditable(),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                child: IgnorePointer(
                  child: quill.QuillEditor(
                    controller:
                        Get.find<VMPlatform>().getNodeController(posX, posY)!,
                    scrollController: ScrollController(),
                    readOnly: true,
                    showCursor: false,
                    scrollable: false,
                    focusNode: FocusNode(),
                    autoFocus: false,
                    expands: false,
                    enableInteractiveSelection: false,
                    padding: EdgeInsets.zero,
                  ),
                ),
                visible: node.contentsString.isNotEmpty,
              ),
            ],
          ),
        ),
      ),
    );
  }
}