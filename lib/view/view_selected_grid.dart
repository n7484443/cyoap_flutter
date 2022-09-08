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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(4, (innerIndex) {
                var itemPos = index * 4 + innerIndex;
                if (itemPos >= posList.length) {
                  return const Flexible(
                    child: SizedBox.shrink(),
                  );
                }
                return Flexible(
                  child: IgnorePointer(
                    child: ViewChoiceNode(posList[itemPos], ignoreOpacity: true),
                  ),
                );
              }),
            ),
          );
        },
        itemCount: posList.length ~/ 4 + posList.length % 4 == 0 ? 0 : 1,
      ),
    );
  }
}
