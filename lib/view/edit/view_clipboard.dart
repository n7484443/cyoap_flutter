import 'package:cyoap_flutter/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewModel/edit/vm_draggable_nested_map.dart';
import '../choice/view_choice_node.dart';

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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: NodeDraggable(
                  pos,
                  ignoreOption: ChoiceNodeChildRender.noOptionWithViewOnly,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  ref.read(choiceNodeClipboardStatusProvider.notifier).remove(index);
                },
                tooltip: 'delete'.i18n,
              ),
            ],
          ),
        );
      },
      itemCount: list.length,
    );
  }
}
