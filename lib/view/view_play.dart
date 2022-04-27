import 'package:cyoap_flutter/view/view_draggable_nested_map.dart';
import 'package:cyoap_flutter/view/view_variable_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../viewModel/vm_platform.dart';
import '../viewModel/vm_variable_table.dart';

class ViewPlay extends StatelessWidget {
  const ViewPlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VMPlatform>(
      init: VMPlatform(),
      builder: (_) {
        if (ConstList.isDistributed && !_.loaded) {
          return Scaffold(
            body: Center(
              child: Column(
                children: [
                  const CircularProgressIndicator(),
                  const Text('로딩중입니다. 잠시만 기다려주세요.'),
                  Text(_.loadString),
                  Text(_.stopwatchLoad.elapsed.toString()),
                ],
              ),
            ),
          );
        }

        Get.put(VMVariableTable());
        if (ConstList.isSmallDisplay(context)) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(ConstList.appBarSize),
              child: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
            ),
            drawer: const Drawer(
              child: ViewVariable(),
            ),
            body: const NestedMap(),
          );
        } else {
          return Scaffold(
            body: Row(
              children: [
                const LimitedBox(
                  maxWidth: 250,
                  child: ViewVariable(),
                ),
                Flexible(
                  child: Scaffold(
                    appBar: PreferredSize(
                      preferredSize:
                          const Size.fromHeight(ConstList.appBarSize),
                      child: AppBar(),
                    ),
                    body: const NestedMap(),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
