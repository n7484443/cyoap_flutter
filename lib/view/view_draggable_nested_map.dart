import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/view/view_text_outline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../viewModel/vm_draggable_nested_map.dart';

class NodeDivider extends StatelessWidget {
  final int y;

  const NodeDivider(this.y, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vmDraggableNestedMap = Get.find<VMDraggableNestedMap>();
    var maxSelectText = Visibility(
      child: TextOutline(
          '최대 ${vmDraggableNestedMap.getMaxSelect(y)}개만큼 선택 가능', 18.0, vmDraggableNestedMap.getTitleFont(), strokeWidth: 5.0),
      visible: vmDraggableNestedMap.getMaxSelect(y) != '무한',
    );
    if (vmDraggableNestedMap.isEditable()) {
      return Stack(
        children: [
          Divider(
            thickness: 4,
            color: getPlatform().colorBackground.computeLuminance() > 0.5 ? Colors.black : Colors.white,
          ),
          maxSelectText,
          Align(
            alignment: Alignment.centerRight,
            child: PopupMenuButton<int>(
              icon: const Icon(Icons.more_vert),
              onSelected: (result) {
                if (result == 0) {
                  showDialog(
                    context: context,
                    builder: (builder) => GetBuilder<VMDraggableNestedMap>(
                      builder: (_) => AlertDialog(
                        scrollable: true,
                        title: const Text('최대 선택지 개수 설정'),
                        content: Column(
                          children: [
                            Row(
                              children: [
                                const Text('선택 가능'),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.chevron_left),
                                  onPressed: () {
                                    _.addMaxSelect(y, -1);
                                  },
                                ),
                                Text(_.getMaxSelect(y)),
                                IconButton(
                                  icon: const Icon(Icons.chevron_right),
                                  onPressed: () {
                                    _.addMaxSelect(y, 1);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 0,
                    child: Text('최대 선택 설정'),
                  ),
                ];
              },
            ),
          ),
        ],
        alignment: Alignment.center,
      );
    } else {
      return Stack(
        children: [
          Divider(
            thickness: 4,
            color: getPlatform().colorBackground.computeLuminance() > 0.5 ? Colors.black : Colors.white,
          ),
          maxSelectText,
        ],
        alignment: Alignment.center,
      );
    }
  }
}

class NestedMap extends StatelessWidget {
  const NestedMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(VMDraggableNestedMap());
    return GetBuilder<VMDraggableNestedMap>(
      builder: (_) => LayoutBuilder(builder: (context, constrains) {
        _.updateWidgetList(context, constrains);
        return SingleChildScrollView(
          controller: _.scroller,
          child: RepaintBoundary(
            key: _.captureKey,
            child: Container(
              decoration: BoxDecoration(color: _.getBackgroundColor()),
              child: Column(
                key: _.keyListView,
                children: _.widgetList,
              ),
            ),
          ),
        );
      }),
    );
  }
}
