import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/view/choice/view_choice_node.dart';
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
    var posList = ref.watch(selectedchoiceNodeStatusProvider);
    var numRow = ConstList.isSmallDisplay(context) ? 4 : 6;
    var listLength = (posList.length / numRow).ceil();
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 10.0),
      scrollable: true,
      content: RepaintBoundary(
        key: globalKey,
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
                        posList[itemPos].$1,
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
      actions: [
        TextButton(
          onPressed: () {
            saveAsImage(globalKey);
          },
          child: Text('save_as_image'.i18n),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('confirm'.i18n),
        ),
      ],
    );
  }
}
