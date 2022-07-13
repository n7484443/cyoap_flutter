import 'package:cyoap_flutter/view/view_variable_table.dart';
import 'package:cyoap_flutter/viewModel/vm_make_platform.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';

class ViewMakePlatform extends GetView<VMMakePlatform> {
  const ViewMakePlatform({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ConstList.isSmallDisplay(context)) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          drawer: const Drawer(
            child: ViewVariable(),
          ),
          body: Obx(() => controller.currentPage),
        ),
      );
    }
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Row(
          children: [
            const LimitedBox(
              maxWidth: 250,
              child: ViewVariable(),
            ),
            Flexible(
              child: Obx(() => controller.currentPage),
            ),
          ],
        ),
      ),
    );
  }
}
