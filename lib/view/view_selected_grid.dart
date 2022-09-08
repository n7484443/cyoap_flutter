import 'package:cyoap_flutter/view/view_choice_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewModel/vm_selected_grid.dart';

class ViewSelectedGrid extends ConsumerWidget {
  const ViewSelectedGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var posList = ref.watch(selectedChoiceNodeProvider);
    var numRow = 4;
    var listLength = (posList.length / numRow).ceil();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(numRow, (innerIndex) {
              var itemPos = index * numRow + innerIndex;
              if (itemPos >= posList.length) {
                return const Expanded(
                  child: SizedBox.shrink(),
                );
              }
              return Expanded(
                child: IgnorePointer(
                  child: ViewChoiceNode(posList[itemPos], ignoreOpacity: true),
                ),
              );
            }),
          );
        },
        itemCount: listLength,
      ),
    );
  }
}
