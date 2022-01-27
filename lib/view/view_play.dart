import 'package:cyoap_flutter/view/view_choice_grid.dart';
import 'package:cyoap_flutter/view/view_variable_table.dart';
import 'package:cyoap_flutter/viewModel/vm_editor.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

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
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  Get.find<VMEditor>().save();
                },
              )
            ],
          ),
        ),
        drawer: const ViewVariable(),
        body: ChoiceSetGrid(),
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
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () {
                        Get.find<VMEditor>().save();
                      },
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
