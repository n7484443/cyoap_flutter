
import 'package:cyoap_flutter/view/preset/view_choice_node_preset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewModel/preset/vm_choice_line_preset.dart';
import '../../viewModel/preset/vm_preset.dart';
import '../util/controller_adjustable_scroll.dart';

class ChoiceLinePresetList extends ConsumerWidget {
  const ChoiceLinePresetList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var list = ref.watch(choiceLinePresetListProvider);
    return Column(
      children: [
        ListTile(
          title: const Text('프리셋'),
          trailing: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ref.read(choiceLinePresetListProvider.notifier).create();
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: AdjustableScrollController(),
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              var preset = list[index];
              return ListTile(
                key: Key('$index'),
                title: Text(preset.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete,
                      size: (IconTheme.of(context).size ?? 18) * 0.8),
                  onPressed: () {
                    ref.read(choiceLinePresetListProvider.notifier).deleteIndex(index);
                  },
                ),
                onTap: () {
                  ref
                      .read(currentPresetIndexProvider.notifier)
                      .update((state) => index);
                },
                onLongPress: () async {
                  var text = await showDialog(
                      context: context,
                      builder: (context) {
                        return PresetRenameDialog(preset.name);
                      },
                      barrierDismissible: false);
                  if (text != null && text.trim().isNotEmpty) {
                    ref
                        .read(choiceLinePresetListProvider.notifier)
                        .rename(index, text.trim());
                  }
                },
                selected: index == ref.watch(currentPresetIndexProvider),
              );
            },
          ),
        ),
      ],
    );
  }
}