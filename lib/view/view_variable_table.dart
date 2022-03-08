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
    var vmVariableTable = Get.put(VMVariableTable());

    Widget widget;
    if (vmVariableTable.isEditable()) {
      widget = Column(
        children: [
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('이미지 출처 설정'),
            onTap: () => Get.toNamed("/viewSource", id: 1),
          ),
          ListTile(
            onTap: () {
              Get.toNamed('/viewGlobalSetting', id: 1);
            },
            leading: const Icon(Icons.settings),
            title: const Text('전역 설정'),
          ),
        ],
      );
    } else {
      widget = ListTile(
        leading: const Text('출처 보기'),
        trailing: GetBuilder<VMVariableTable>(
          builder: (_) => Switch(
            value: _.getSourceVisible(),
            onChanged: (value) => _.setSourceVisible(value),
          ),
        ),
      );
    }

    return GetBuilder<VMVariableTable>(
      builder: (_) => Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: ListView(
                controller: ScrollController(),
                shrinkWrap: true,
                children: [
                  ExpansionTile(
                    title: const Text('변수'),
                    children: List<Widget>.generate(_.getVariableList().length,
                        (index) {
                      return ListTile(title: Text(_.getVariableList()[index]));
                    }),
                  ),
                  ExpansionTile(
                    title: const Text('노드'),
                    children: List<Widget>.generate(_.getNodeNameList().length,
                        (index) {
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
                ],
              ),
            ),
            widget,
          ],
        ),
      ),
    );
  }
}
