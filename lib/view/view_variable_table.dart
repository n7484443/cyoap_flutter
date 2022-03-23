import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/viewModel/vm_variable_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:qlevar_router/qlevar_router.dart';

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
            title: const Text('출처 설정'),
            onTap: () => QR.to('/viewMakePlatform/viewSource'),
          ),
          ListTile(
            onTap: () {
              QR.to('/viewMakePlatform/viewGlobalSetting');
            },
            leading: const Icon(Icons.settings),
            title: const Text('전역 설정'),
          ),
        ],
      );
    } else {
      widget = Column(
        children: [
          ListTile(
            leading: const Text('버전'),
            title: Text(ConstList.version),
          ),
          ListTile(
            leading: const Text('출처 보기'),
            trailing: GetBuilder<VMVariableTable>(
              builder: (_) => Switch(
                value: _.getSourceVisible(),
                onChanged: (value) => _.setSourceVisible(value),
              ),
            ),
          ),
        ],
      );
    }

    return GetBuilder<VMVariableTable>(
      builder: (_) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: ListView(
              controller: ScrollController(),
              shrinkWrap: true,
              children: [
                ExpansionTile(
                  title: const Text('변수'),
                  children: _.variableList,
                ),
                ExpansionTile(
                  title: const Text('노드'),
                  children: _.nodeList,
                ),
              ],
            ),
          ),
          widget,
        ],
      ),
    );
  }
}
