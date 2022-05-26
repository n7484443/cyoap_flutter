import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:cyoap_flutter/view/view_choice_node.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/choiceNode/choice_node.dart';
import '../viewModel/vm_design_setting.dart';

class ViewLayoutSetting extends GetView<VMDesignSetting> {
  const ViewLayoutSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(ConstList.padding),
        child: Column(
          children: [
            Obx(
              () => Wrap(
                children: [
                  Row(
                    children: [
                      ViewSwitchLabel(
                        label: "제목을 이미지 위에 겹치기",
                        () {
                          controller.titleOverlap.value =
                              !controller.titleOverlap.value;
                        },
                        controller.titleOverlap.value,
                      ),
                      ViewSwitchLabel(
                        label: "제목을 위로",
                        () {
                          controller.titlePosition.value =
                              !controller.titlePosition.value;
                        },
                        controller.titlePosition.value,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                              labelText: '제목 폰트'
                          ),
                          items: ConstList.textFontList.keys
                              .map<DropdownMenuItem<String>>((name) =>
                              DropdownMenuItem(
                                  value: name,
                                  child: Text(name,
                                      style: ConstList.getFont(name))))
                              .toList(),
                          onChanged: (String? t) {
                            if (t != null) controller.setTitleFont(t);
                          },
                          value: controller.titleFont.value,
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                              labelText: '내용 폰트'
                          ),
                          items: ConstList.textFontList.keys
                              .map<DropdownMenuItem<String>>((name) =>
                              DropdownMenuItem(
                                  value: name,
                                  child: Text(name,
                                      style: ConstList.getFont(name))))
                              .toList(),
                          onChanged: (String? t) {
                            if (t != null) controller.setMainFont(t);
                          },
                          value: controller.mainFont.value,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IgnorePointer(
              child: ViewChoiceNode.fromNode(
                ChoiceNode(
                  1,
                  true,
                  "레이아웃",
                  "[{\"insert\":\"레이아웃과 폰트, 크기 등을 조정하고 확인할 수 있습니다.\\n\"}]",
                  "noImage",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
