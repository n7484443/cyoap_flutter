import 'package:cyoap_flutter/viewModel/vm_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:get/get.dart';

import '../model/platform_system.dart';
import '../util/tuple.dart';

/*
  Card──Container─children─┬──title
                           ├──image
                           ├──area
                           └──Card──subChoiceSet
  */

double nodeBaseWidth = 240;
double nodeBaseHeight = 260;

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
      onTap: () {},
      onHover: (val) {},
      onDoubleTap: () {
        Get.find<VMPlatform>().setEdit(posX, posY);
        Get.toNamed('/viewEditor');
      },
      child: GetBuilder<VMPlatform>(
        builder: (_) => SizedBox(
          width: nodeBaseWidth * size.data1,
          height: nodeBaseHeight * size.data2,
          child: Column(
            children: [
              Visibility(
                child: Text.rich(
                  TextSpan(
                    text: node.title,
                  ),
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
                visible: node.title.isNotEmpty,
              ),
              Visibility(
                child: Expanded(
                  child: Image(
                    image: PlatformSystem.getImage(node.imageString).image,
                  ),
                ),
                visible: node.imageString.isNotEmpty,
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