import 'package:cyoap_flutter/view/view_choice_grid.dart';
import 'package:cyoap_flutter/view/view_variable_table.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ViewMake extends StatelessWidget {
  const ViewMake({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        drawer: const ViewVariable(),
        body: const ChoiceSetGrid(),
      );
    } else {
      return Row(
        children: [
          const ViewVariable(),
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
              body: const ChoiceSetGrid(),
            ),
          ),
        ],
      );
    }
  }
}


