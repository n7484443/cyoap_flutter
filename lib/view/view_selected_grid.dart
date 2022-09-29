import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/view/view_choice_node.dart';
import 'package:cyoap_flutter/viewModel/vm_design_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewModel/vm_selected_grid.dart';

class ViewSelectedGrid extends ConsumerWidget {
  const ViewSelectedGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var globalKey = GlobalKey();
    var posList = ref.watch(selectedChoiceNodeProvider);
    var numRow = ConstList.isSmallDisplay(context) ? 4 : 6;
    var listLength = (posList.length / numRow).ceil();
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 10.0),
      scrollable: true,
      content: RepaintBoundary(
        key: globalKey,
        child: ColoredBox(
          color: ref.watch(colorBackgroundProvider),
          child: Column(
            children: List.generate(listLength * 2 - 1, (index) {
              if (index.isEven) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(numRow, (innerIndex) {
                    var itemPos = index ~/ 2 * numRow + innerIndex;
                    if (itemPos >= posList.length) {
                      return const Expanded(
                        child: SizedBox.shrink(),
                      );
                    }
                    return Expanded(
                      child: IgnorePointer(
                        child: ViewChoiceNode(
                          posList[itemPos],
                          ignoreOpacity: true,
                          ignoreChild: true,
                        ),
                      ),
                    );
                  }),
                );
              }
              return const Divider();
            }),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            saveAsImage(globalKey);
          },
          child: const Text('이미지로 저장'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('확인'),
        ),
      ],
    );
  }
}