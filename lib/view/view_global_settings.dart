import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/model/grammar/value_type.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:cyoap_flutter/viewModel/vm_global_setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../viewModel/vm_make_platform.dart';

class ViewGlobalSetting extends StatelessWidget {
  const ViewGlobalSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vmGlobalSetting = Get.put(VMGlobalSetting());

    var appbarWidget = AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          makePlatform.back();
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            makePlatform.changePageString('viewFontSource');
          },
        ),
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: () {
            vmGlobalSetting.save();
          },
        )
      ],
    );

    editDialog(int index) {
      Get.defaultDialog(
        title: "데이터 변경",
        radius: 10,
        cancel: TextButton(
          child: const Text('취소'),
          onPressed: () {
            Get.back();
          },
        ),
        confirm: TextButton(
          child: const Text('저장'),
          onPressed: () {
            vmGlobalSetting.editInitialValue(index);
            Get.back();
          },
        ),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Flexible(
                flex: 4,
                child: TextField(
                  maxLines: 1,
                  maxLength: 50,
                  controller: vmGlobalSetting.controllerName,
                  decoration: const InputDecoration(
                    label: Text('변수명'),
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              const Spacer(),
              Flexible(
                flex: 4,
                child: TextField(
                  maxLines: 1,
                  maxLength: 50,
                  controller: vmGlobalSetting.controllerValue,
                  decoration: const InputDecoration(
                    label: Text('변수 초기값'),
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              const Spacer(),
              Flexible(
                flex: 4,
                child: TextField(
                  maxLines: 1,
                  maxLength: 50,
                  controller: vmGlobalSetting.controllerDisplayName,
                  decoration: const InputDecoration(
                    label: Text('변수 표기명'),
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              const Spacer(),
              Flexible(
                flex: 4,
                child: Column(
                  children: [
                    GetBuilder<VMGlobalSetting>(
                      builder: (_) => ViewSwitchLabel(
                        () => vmGlobalSetting.setVisible(
                            index, !vmGlobalSetting.isVisible(index)),
                        vmGlobalSetting.isVisible(index),
                        label: '플레이시 표시',
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    var initialValueList = GetBuilder<VMGlobalSetting>(
      builder: (_) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 18,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.lightBlueAccent),
                ),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ConstList.isSmallDisplay(context) ? 2 : 4,
                    crossAxisSpacing: 2,
                    mainAxisExtent: 60,
                    mainAxisSpacing: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        vmGlobalSetting.loadInitialValue(index);
                        editDialog(index);
                      },
                      title: Text(vmGlobalSetting.getKey(index)),
                      subtitle: Text(vmGlobalSetting
                          .getValue(index)!
                          .valueType
                          .data
                          .toString()),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          vmGlobalSetting.deleteInitialValue(index);
                        },
                      ),
                    );
                  },
                  itemCount: vmGlobalSetting.initialValueList.length,
                ),
              ),
            ),
            TextButton(
              child: const Text('초기값 추가'),
              onPressed: () {
                vmGlobalSetting.addInitialValue(
                    'point', ValueTypeWrapper(ValueType(0), true));
              },
            )
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: appbarWidget,
      body: initialValueList,
    );
  }
}
