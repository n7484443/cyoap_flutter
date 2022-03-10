import 'package:cyoap_flutter/view/view_draggable_nested_map.dart';
import 'package:cyoap_flutter/view/view_variable_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../viewModel/vm_platform.dart';

class ViewPlay extends StatelessWidget {
  const ViewPlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(VMPlatform());
    if (ConstList.isSmallDisplay(context)) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(ConstList.appBarSize),
          child: AppBar(),
        ),
        drawer: const ViewVariable(),
        body: const NestedMap(),
      );
    } else {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(ConstList.appBarSize),
          child: AppBar(),
        ),
        body: Row(
          children: [
            const LimitedBox(
              maxWidth: 250,
              child: ViewVariable(),
            ),
            const Expanded(
              child: NestedMap(),
            ),
          ],
        ),
      );
    }
  }
}
