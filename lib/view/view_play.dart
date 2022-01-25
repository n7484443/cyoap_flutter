import 'package:cyoap_flutter/view/view_choice_grid.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ViewPlay extends StatelessWidget {
  const ViewPlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController _controllerDrawer = ScrollController();
    if (ConstList.actualPlatformType == platformType.mobile) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(ConstList.appBarSize),
          child: AppBar(
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 15),
                child: const Icon(Icons.menu),
              )
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            controller: _controllerDrawer,
            padding: EdgeInsets.zero,
          ),
        ),
        body: ChoiceSetGrid(),
      );
    } else {
      return Row(
        children: [
          Drawer(
            child: ListView(
              controller: _controllerDrawer,
              padding: EdgeInsets.zero,
            ),
          ),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(ConstList.appBarSize),
                child: AppBar(
                  actions: [
                    Container(
                      margin: const EdgeInsets.only(right: 15),
                      child: const Icon(Icons.menu),
                    )
                  ],
                ),
              ),
              body: ChoiceSetGrid(),
            ),
          ),
        ],
      );
    }
  }
}
