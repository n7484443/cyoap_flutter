import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/image_loader.dart';

/*
  Card──Container─children─┬──title
                           ├──image
                           ├──area
                           └──Card──subChoiceSet
  */

double nodeBaseWidth = 260;
double nodeBaseHeight = 300;

class ViewTextWithoutCardNode extends StatelessWidget {
  const ViewTextWithoutCardNode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: nodeBaseWidth,
      height: nodeBaseHeight,
      child: InkWell(
        onTap: () {},
        onHover: (val) {},
        onDoubleTap: () {
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

class ViewChoiceTextNode extends StatelessWidget {
  const ViewChoiceTextNode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        onHover: (val) {},
        onDoubleTap: () {
          Get.toNamed('/viewEditor');
        },
        child: SizedBox(
          width: nodeBaseWidth,
          height: nodeBaseHeight,
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

class ViewChoiceNodeTextWithImage extends StatelessWidget {
  const ViewChoiceNodeTextWithImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        onHover: (val) {},
        onDoubleTap: () {
          Get.toNamed('/viewEditor');
        },
        child: SizedBox(
          width: nodeBaseWidth,
          height: nodeBaseHeight,
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

class ViewChoiceNodeImage extends StatelessWidget {
  const ViewChoiceNodeImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        onHover: (val) {},
        onDoubleTap: () {
          Get.toNamed('/viewEditor');
        },
        child: SizedBox(
          width: nodeBaseWidth,
          height: nodeBaseHeight,
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
