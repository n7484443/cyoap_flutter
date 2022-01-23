import 'package:flutter/material.dart';

import 'view_choice_node.dart';

class ViewMake extends StatelessWidget {
  const ViewMake({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [Icon(Icons.menu)]),
        body: Container(
          child: GridView.count(
            crossAxisCount: 3,
            children: [
              ViewChoiceNode(),
              ViewChoiceNodeWithImage(),
              ViewChoiceNode(),
              ViewChoiceNodeWithImage(),
            ],
          ),
        ));
  }
}
