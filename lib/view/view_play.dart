import 'package:flutter/material.dart';

import 'view_choice_node.dart';

class ViewPlay extends StatelessWidget {
  const ViewPlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          Container(
            margin: EdgeInsets.all(20),
            child: Icon(Icons.menu),
          )
        ]),
        body: Container(
            child: ViewChoiceNode(),
        ));
  }
}
