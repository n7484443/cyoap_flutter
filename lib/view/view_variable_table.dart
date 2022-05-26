import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:cyoap_flutter/viewModel/vm_variable_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/platform_system.dart';

class ViewVariable extends StatelessWidget {
  const ViewVariable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList;
    if (!ConstList.isDistributed && isEditable) {
      widgetList = [
        ListTile(
          onTap: () {
            Get.toNamed('/viewLayoutSetting', id: 1);
          },
          leading: const Icon(Icons.settings),
          title: const Text('레이아웃 설정'),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('이미지 설정'),
          onTap: () => Get.toNamed("/viewSource", id: 1),
        ),
        ListTile(
          onTap: () {
            Get.toNamed('/viewGlobalSetting', id: 1);
          },
          leading: const Icon(Icons.settings),
          title: const Text('전역 설정'),
        ),
      ];
    } else {
      widgetList = [
        ListTile(
          leading: const Text('버전'),
          title: Text(ConstList.version),
        ),
        ListTile(
          title: GetBuilder<VMVariableTable>(
            builder: (_) => ViewSwitchLabel(
              _.setSourceVisible,
              _.sourceVisible,
              label: '출처 보기',
            ),
          ),
        ),
      ];
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
                  initiallyExpanded: true,
                  children: _.variableList,
                ),
                ExpansionTile(
                  title: const Text('노드'),
                  children: _.nodeList,
                ),
              ],
            ),
          ),
          Column(
            children: widgetList,
          ),
        ],
      ),
    );
  }
}
