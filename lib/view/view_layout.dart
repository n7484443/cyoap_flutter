import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:cyoap_flutter/view/view_choice_node.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/choiceNode/choice_node.dart';
import '../viewModel/vm_layout_setting.dart';

class ViewLayoutSetting extends GetView<VMLayoutSetting> {
  const ViewLayoutSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Obx(
            () => Row(
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
    );
  }
}
