import 'package:flutter/material.dart';

class ViewChoiceNode extends StatefulWidget {
  const ViewChoiceNode({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChoiceState();
}

class _ChoiceState extends State<ViewChoiceNode>{
  int width = 100;
  int height = 100;

  /*
  Card──Container─children─┬──title
                           ├──image
                           ├──area
                           └──Card──subChoiceSet
  */
  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: width.toDouble(),
        height: height.toDouble(),
        child: Column(
          children: [
            const Text.rich(
              TextSpan(
                text: 'title',
              ),
              style: TextStyle(
                fontSize: 18,
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
