import 'package:cyoap_flutter/model/grammar/value_type.dart';
import 'package:cyoap_flutter/view/util/view_back_dialog.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:cyoap_flutter/viewModel/vm_global_setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class ViewGlobalSetting extends StatelessWidget {
  const ViewGlobalSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vmGlobalSetting = Get.put(VMGlobalSetting());

    var appbarWidget = AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (vmGlobalSetting.isChanged) {
            showDialog(
              context: context,
              builder: (_) => ViewBackDialog(
                    () => vmGlobalSetting.save(),
                    () => Get.back(id: 1),
                cancelFunction: () => vmGlobalSetting.isChanged = false,
              ),
            );
          } else {
            Get.back(id: 1);
          }
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Get.toNamed('/viewFontSource', id: 1);
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
                child: ListView.separated(
                  itemCount: vmGlobalSetting.initialValueList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              vmGlobalSetting.loadInitialValue(index);
                              editDialog(index);
                            },
                            child: Text(
                              '${vmGlobalSetting.getKey(index)}  |  ${vmGlobalSetting.getValue(index)?.valueType.data}',
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              vmGlobalSetting.deleteInitialValue(index);
                            },
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                child: const Text('초기값 추가'),
                onPressed: () {
                  vmGlobalSetting.addInitialValue(
                      'point', ValueTypeWrapper(ValueType(0), true));
                },
              ),
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
