import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:cyoap_flutter/view/view_choice_node.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/choiceNode/choice_node.dart';
import '../viewModel/vm_design_setting.dart';

class ViewDesignSetting extends GetView<VMDesignSetting> {
  const ViewDesignSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(ConstList.padding),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(ConstList.padding),
              child: Obx(
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
                            decoration:
                                const InputDecoration(labelText: '제목 폰트'),
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
                            decoration:
                                const InputDecoration(labelText: '내용 폰트'),
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
            ),
            ColorPicker(
              color: controller.colorBackground.value,
              heading: const Text('배경색 설정'),
              subheading: const Text('색조 설정'),
              onColorChanged: (Color value) {
                controller.updateColor(value);
              },
              pickersEnabled: {
                ColorPickerType.wheel: true,
                ColorPickerType.accent: false
              },
              pickerTypeLabels: {
                ColorPickerType.primary: "배경색",
                ColorPickerType.wheel: "색상 선택"
              },
              width: 22,
              height: 22,
              borderRadius: 22,
            ),
            Obx(
              () => ColoredBox(
                color: controller.colorBackground.value,
                child: Padding(
                  padding: const EdgeInsets.all(ConstList.padding),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: IgnorePointer(
                          child: ViewChoiceNode.fromNode(
                            ChoiceNode(
                              1,
                              true,
                              "디자인",
                              "[{\"insert\":\"레이아웃과 폰트, 디자인, 크기 등을 조정하고 확인할 수 있습니다.\\n\"}]",
                              "noImage",
                            )..currentPos = 0,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        flex: 3,
                        child: IgnorePointer(
                          child: ViewChoiceNode.fromNode(
                            ChoiceNode(
                              1,
                              false,
                              "디자인(바깥 라운드 X, 카드 모드 X)",
                              "[{\"insert\":\"레이아웃과 폰트, 디자인, 크기 등을 조정하고 확인할 수 있습니다.\\n\"}]",
                              "noImage",
                            )
                              ..isRound = false
                              ..currentPos = 1,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
