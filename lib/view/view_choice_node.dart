import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../model/image_loader.dart';

class ViewChoiceNode extends StatelessWidget {
  const ViewChoiceNode({Key? key}) : super(key: key);

  /*
  Card──Container─children─┬──title
                           ├──image
                           ├──area
                           └──Card──subChoiceSet
  */
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      onHover: (val) {},
      onDoubleTap: () {
        Get.toNamed('/viewEditor');
      },
      child: Card(
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
            const Text.rich(
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

class ViewChoiceNodeTextWithImage extends StatelessWidget {
  const ViewChoiceNodeTextWithImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      onHover: (val) {},
      onDoubleTap: () {
        Get.toNamed('/viewEditor');
      },
      child: Card(
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
    );
  }
}

class ViewChoiceNodeImage extends StatelessWidget {
  const ViewChoiceNodeImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      onHover: (val) {},
      onDoubleTap: () {
        Get.toNamed('/viewEditor');
      },
      child: Card(
        child: Column(
          children: [
            Image(
              image: ImageLoader.instance.getImage('img.jpg').image,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }
}
