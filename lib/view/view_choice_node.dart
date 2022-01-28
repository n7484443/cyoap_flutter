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

abstract class NodeBase extends StatelessWidget {
  final int posX;
  final int posY;

  const NodeBase({Key? key, required this.posX, required this.posY})
      : super(key: key);
}


class ViewTextWithoutCardNode extends NodeBase {
  const ViewTextWithoutCardNode(
      {Key? key, required int posX, required int posY})
      : super(key: key, posX: posX, posY: posY);

  @override
  Widget build(BuildContext context) {
    var size = Get.find<VMPlatform>().getSize(Tuple(posX, posY));
    var node = Get.find<VMPlatform>().getNode(posX, posY)!;
    return Card(
      elevation:0.0,
      child: GetBuilder<VMPlatform>(
        builder: (_) => SizedBox(
          width: nodeBaseWidth * size.data1,
          height: nodeBaseHeight * size.data2,
          child: InkWell(
            onTap: () {},
            onHover: (val) {},
            onDoubleTap: () {
              Get.find<VMPlatform>().setEdit(posX, posY);
              Get.toNamed('/viewEditor');
            },
            child: Column(
              children: [
                Text.rich(
                  TextSpan(
                    text: node.title,
                  ),
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
                IgnorePointer(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ViewChoiceTextNode extends NodeBase {
  const ViewChoiceTextNode({Key? key, required int posX, required int posY})
      : super(key: key, posX: posX, posY: posY);

  @override
  Widget build(BuildContext context) {
    var size = Get.find<VMPlatform>().getSize(Tuple(posX, posY));
    var node = Get.find<VMPlatform>().getNode(posX, posY)!;
    return Card(
      elevation:5.0,
      child: InkWell(
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
                Text.rich(
                  TextSpan(
                    text: node.title,
                  ),
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
                IgnorePointer(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ViewChoiceNodeTextWithImage extends NodeBase {
  const ViewChoiceNodeTextWithImage(
      {Key? key, required int posX, required int posY})
      : super(key: key, posX: posX, posY: posY);

  @override
  Widget build(BuildContext context) {
    var size = Get.find<VMPlatform>().getSize(Tuple(posX, posY));
    var node = Get.find<VMPlatform>().getNode(posX, posY)!;
    return Card(
      elevation:5.0,
      child: InkWell(
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
                Text.rich(
                  TextSpan(
                    text: node.title,
                  ),
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
                Image(
                  image: PlatformSystem.getImage(node.imageString).image,
                  width: 200,
                ),
                IgnorePointer(
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
              ],
                ),
              ),
        ),
      ),
    );
  }
}

class ViewChoiceNodeImage extends NodeBase {
  const ViewChoiceNodeImage({Key? key, required int posX, required int posY})
      : super(key: key, posX: posX, posY: posY);

  @override
  Widget build(BuildContext context) {
    var size = Get.find<VMPlatform>().getSize(Tuple(posX, posY));
    var node = Get.find<VMPlatform>().getNode(posX, posY)!;
    return Card(
      elevation:5.0,
      child: InkWell(
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
                Image(
                  image: PlatformSystem.getImage(node.imageString).image,
                  width: 200,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
