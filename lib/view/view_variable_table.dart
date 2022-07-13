import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:cyoap_flutter/viewModel/vm_variable_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../model/platform_system.dart';
import '../viewModel/vm_make_platform.dart';

class ViewVariable extends GetView<VMVariableTable> {
  const ViewVariable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList;
    if (!ConstList.isDistributed && isEditable) {
      widgetList = [
        ListTile(
          onTap: () {
            makePlatform.changePageString('viewDesignSetting');
          },
          leading: const Icon(Icons.settings),
          title: const Text('디자인 설정'),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('이미지 설정'),
          onTap: () => makePlatform.changePageString("viewSource"),
        ),
        ListTile(
          onTap: () {
            makePlatform.changePageString('viewGlobalSetting');
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
          title: Obx(
            () => ViewSwitchLabel(
              () => controller.isVisibleSource.toggle(),
              controller.isVisibleSource.value,
              label: '출처 보기',
            ),
          ),
        ),
        if (ConstList.isSmallDisplay(context))
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            IconButton(
              onPressed: () {
                if (MediaQuery.of(context).orientation ==
                    Orientation.portrait) {
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.landscapeLeft]);
                } else {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.landscapeRight,
                    DeviceOrientation.landscapeLeft
                  ]);
                }
              },
              icon: const Icon(Icons.rotate_right),
            ),
            IconButton(
              onPressed: () {
                if (MediaQuery.of(context).orientation ==
                    Orientation.portrait) {
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.landscapeRight]);
                } else {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.landscapeRight,
                    DeviceOrientation.landscapeLeft
                  ]);
                }
              },
              icon: const Icon(Icons.rotate_left),
            ),
          ]),
      ];
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: GetBuilder<VMVariableTable>(
            builder: (_) => ListView(
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
        ),
        Column(
          children: widgetList,
        ),
      ],
    );
  }
}
