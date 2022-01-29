import 'package:cyoap_flutter/view/view_draggable_nested_map.dart';
import 'package:cyoap_flutter/view/view_variable_table.dart';
import 'package:cyoap_flutter/viewModel/vm_platform.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

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
              Visibility(
                child: IconButton(
                  icon: const Icon(Icons.archive),
                  onPressed: () {
                    Get.find<VMPlatform>().save(true);
                  },
                ),
                visible: !ConstList.isFileSystem(),
              ),
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  Get.find<VMPlatform>().save(false);
                },
              )
            ],
          ),
        ),
        drawer: const ViewVariable(),
        body: const NestedMap(),
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
                    Visibility(
                      child: IconButton(
                        icon: const Icon(Icons.archive),
                        onPressed: () {
                          Get.find<VMPlatform>().save(true);
                        },
                      ),
                      visible: !ConstList.isFileSystem(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () {
                        Get.find<VMPlatform>().save(false);
                      },
                    )
                  ],
                ),
              ),
              body: const NestedMap(),
            ),
          ),
        ],
      );
    }
  }
}


