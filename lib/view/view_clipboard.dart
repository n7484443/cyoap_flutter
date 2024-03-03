import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../viewModel/vm_draggable_nested_map.dart';
import '../viewModel/vm_make_platform.dart';
import 'choice/view_choice_node.dart';

class ViewClipboard extends ConsumerStatefulWidget {
  const ViewClipboard({super.key});

  @override
  ConsumerState createState() => _ViewClipboardState();
}

class _ViewClipboardState extends ConsumerState<ViewClipboard> {
  @override
  Widget build(BuildContext context) {
    var list = ref.watch(choiceNodeClipboardStatusProvider).posList;
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        var pos = list[index];
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Draggable<Pos>(
            data: pos,
            feedback: Transform.scale(
              scale: 0.9,
              child: Opacity(
                opacity: 0.6,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                  ),
                  child: ViewChoiceNode(
                    pos,
                    ignoreOption: true,
                  ),
                ),
              ),
            ),
            onDragStarted: () {
              if (ConstList.isMobile()) {
                Scaffold.of(context).closeDrawer();
                ref.read(sideTabProvider.notifier).state = 0;
              }
              ref.read(dragChoiceNodeStatusProvider.notifier).dragStart(pos);
            },
            onDragUpdate: (DragUpdateDetails details) {
              ref.read(dragPositionProvider.notifier).state =
                  details.localPosition.dy;
            },
            child: ViewChoiceNode(
              pos,
              ignoreOption: true,
            ),
          ),
        );
      },
      itemCount: list.length,
    );
  }
}
