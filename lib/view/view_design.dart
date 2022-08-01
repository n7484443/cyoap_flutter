import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:cyoap_flutter/view/view_choice_node.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/choiceNode/choice_node.dart';
import '../viewModel/vm_design_setting.dart';
import '../viewModel/vm_make_platform.dart';

class ViewDesignSetting extends GetView<VMDesignSetting> {
  const ViewDesignSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => makePlatform.back(),
          ),
          title: const TabBar(
            indicatorColor: Colors.blueAccent,
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: '색상'),
              Tab(text: '위치'),
              Tab(text: '폰트'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(ConstList.padding),
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    ListView(
                      controller: ScrollController(),
                      children: [
                        Obx(
                          () => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ColorPicker(
                                  color: controller.colorBackground.value,
                                  heading: const Text('배경색 설정'),
                                  onColorChanged: (Color value) {
                                    controller.colorBackground.value = value;
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
                              ),
                              Expanded(
                                child: ColorPicker(
                                  color: controller.colorNode.value,
                                  heading: const Text('선택지 색 설정'),
                                  onColorChanged: (Color value) {
                                    controller.colorNode.value = value;
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
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Obx(
                      () => Column(
                        children: [
                          ViewSwitchLabel(
                            label: "제목을 이미지 위에 겹치기",
                            () {
                              controller.titleOverlap.toggle();
                            },
                            controller.titleOverlap.value,
                          ),
                          ViewSwitchLabel(
                            label: "제목을 위로",
                            () {
                              controller.titlePosition.toggle();
                            },
                            controller.titlePosition.value,
                          ),
                          ViewSwitchLabel(
                            label: "제목 테두리",
                            () {
                              controller.titleOutline.toggle();
                            },
                            controller.titleOutline.value,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(labelText: '제목 폰트'),
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
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(labelText: '내용 폰트'),
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
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Obx(
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
                                  )..currentPos = -1,
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
                                    ..currentPos = -2,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
