import 'package:flutter/material.dart';

import '../main.dart';
import 'view_choice_node.dart';

class ViewPlay extends StatelessWidget {
  const ViewPlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(ConstList.appBarSize),
          child: AppBar(actions: [
            Container(
              margin: const EdgeInsets.only(right:15),
              child: const Icon(Icons.menu),
            )
          ]),
        ),
        body: Container(
            child: ViewChoiceNode(),
        ));
  }
}
