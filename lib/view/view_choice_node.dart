import 'package:auto_size_text/auto_size_text.dart';
import 'package:cyoap_flutter/viewModel/vm_platform.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/image_loader.dart';
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
    return SizedBox(
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
            const Text.rich(
              TextSpan(
                text: 'title',
              ),
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const AutoSizeText.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'asdf\n'),
                  TextSpan(text: 'bdef\n'),
                  TextSpan(text: 'asdf\n'),
                ],
              ),
            ),
          ],
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
    return Card(
      elevation:5.0,
      child: InkWell(
        onTap: () {},
        onHover: (val) {},
        onDoubleTap: () {
          Get.find<VMPlatform>().setEdit(posX, posY);
          Get.toNamed('/viewEditor');
        },
        child: SizedBox(
          width: nodeBaseWidth * size.data1,
          height: nodeBaseHeight * size.data2,
          child: Column(
            children: [
              const Text.rich(
                TextSpan(
                  text: 'title',
                ),
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              const AutoSizeText.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'asdf\n'),
                    TextSpan(text: 'bdef\n'),
                    TextSpan(text: 'asdf\n'),
                  ],
                ),
              ),
            ],
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
    return Card(
      elevation:5.0,
      child: InkWell(
        onTap: () {},
        onHover: (val) {},
        onDoubleTap: () {
          Get.find<VMPlatform>().setEdit(posX, posY);
          Get.toNamed('/viewEditor');
        },
        child: SizedBox(
          width: nodeBaseWidth * size.data1,
          height: nodeBaseHeight * size.data2,
          child: Column(
            children: [
              const Text.rich(
                TextSpan(
                  text: 'title',
                ),
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              Image(
                image: ImageLoader.instance.getImage('imgt.jpg').image,
                width: 200,
              ),
            ],
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
    return Card(
      elevation:5.0,
      child: InkWell(
        onTap: () {},
        onHover: (val) {},
        onDoubleTap: () {
          Get.find<VMPlatform>().setEdit(posX, posY);
          Get.toNamed('/viewEditor');
        },
        child: SizedBox(
          width: nodeBaseWidth * size.data1,
          height: nodeBaseHeight * size.data2,
          child: Column(
            children: [
              Image(
                image: ImageLoader.instance.getImage('img.jpg').image,
                width: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
