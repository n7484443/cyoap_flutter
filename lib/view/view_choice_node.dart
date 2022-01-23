import 'package:flutter/material.dart';

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
    return Card(
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
    );
  }
}

class ViewChoiceNodeWithImage extends StatelessWidget {
  const ViewChoiceNodeWithImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
            image: ImageLoader.instance.getImage('img.jpg').image,
          ),
        ],
      ),
    );
  }
}
