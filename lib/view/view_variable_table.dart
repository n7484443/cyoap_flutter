import 'package:cyoap_flutter/viewModel/vm_variable_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class ViewVariable extends StatelessWidget {
  const ViewVariable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VMVariableTable>(
      init: Get.put(VMVariableTable()),
      builder: (_) => Drawer(
        child: Column(
          children: [
            const ExpansionTile(
              title: Text('변수'),
              children: [
                ListTile(title: Text('세부')),
                ListTile(title: Text('세부2')),
              ],
            ),
            ExpansionTile(
              title: const Text('노드'),
              children: List<Widget>.generate(_.getNodeNameList().length, (index) {
                return ListTile(title: Text(_.getNodeNameList()[index]));
              }),
            ),
          ],
        ),
      ),
    );
  }
}
