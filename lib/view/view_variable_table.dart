import 'package:cyoap_flutter/viewModel/vm_variable_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class ViewVariable extends StatelessWidget {
  const ViewVariable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(VMVariableTable());
    return GetBuilder<VMVariableTable>(
      builder: (_) => Drawer(
        child: ListView(
          controller: ScrollController(),
          children: [
            ExpansionTile(
              title: const Text('변수'),
              children: List<Widget>.generate(_.getVariableList().length, (index) {
                return ListTile(title: Text(_.getVariableList()[index]));
              }),
            ),
            ExpansionTile(
              title: const Text('노드'),
              children:
                  List<Widget>.generate(_.getNodeNameList().length, (index) {
                return ListTile(
                  title: Row(
                    children: [
                      Text(_.getNodeNameList()[index].data1),
                      Visibility(
                        child: Icon(_.getNodeNameList()[index].data2
                            ? Icons.check_box
                            : Icons.check_box_outline_blank),
                        visible: !_.isEditable(),
                      )
                    ],
                  ),
                );
              }),
            ),
            InkWell(
              child: Visibility(
                child: const ListTile(
                  title: Text('CYOA 설정'),
                ),
                visible: _.isEditable(),
              ),
              onTap: (){
                Get.toNamed('/viewGlobalSetting');
              },
            ),
          ],
        ),
      ),
    );
  }
}
