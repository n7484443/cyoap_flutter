import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/playable_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewModel/vm_choice.dart';
import '../viewModel/vm_draggable_nested_map.dart';

class NodeDragTarget extends ConsumerWidget {
  final Pos pos;
  final Color baseColor = Colors.black12;
  final bool isHorizontal;

  const NodeDragTarget(this.pos, {this.isHorizontal = false, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Visibility(
      visible: ref.watch(dragChoiceNodeStatusProvider) != null,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: DragTarget<Pos>(
        builder: (BuildContext context, List<dynamic> accepted,
            List<dynamic> rejected) {
          return Container(
            color: baseColor,
            height: isHorizontal ? 200 : null,
          );
        },
        onWillAccept: (Pos? drag) {
          return drag != null && !drag.contain(pos);
        },
        onAccept: (Pos drag) {
          if (drag.last == nonPositioned) {
            ref.read(choiceStatusProvider(drag).notifier).swapChoice(pos);
          } else if (drag.last == removedPositioned) {
            ref.read(choiceStatusProvider(pos.removeLast()).notifier).addChoice(
                ref.read(removedChoiceNodeStatusProvider).choiceNode!.clone(),
                index: pos.last);
          } else if (drag.last == copiedPositioned) {
            ref.read(choiceStatusProvider(pos.removeLast()).notifier).addChoice(
                ref.read(copiedChoiceNodeStatusProvider).choiceNode!.clone(),
                index: pos.last);
          } else if (pos.equalExceptLast(drag) &&
              (pos.data.last - 1) >= drag.last) {
            ref
                .read(choiceStatusProvider(drag).notifier)
                .swapChoice(Pos(data: List.from(pos.data)..last -= 1));
          } else {
            ref.read(choiceStatusProvider(drag).notifier).swapChoice(pos);
          }
          ref.read(dragChoiceNodeStatusProvider.notifier).dragEnd();
        },
      ),
    );
  }
}
