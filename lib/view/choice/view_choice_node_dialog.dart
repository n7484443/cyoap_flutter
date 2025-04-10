import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/viewModel/choice/vm_choice.dart';
import 'package:cyoap_flutter/viewModel/choice/vm_choice_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewModel/choice/vm_choice_node.dart';
import '../../viewModel/edit/preset/vm_choice_node_preset.dart';

class PresetDialog extends ConsumerWidget {
  final Pos pos;

  const PresetDialog(this.pos, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var design = ref.watch(choiceNodeDesignSettingProvider(pos: pos));
    return AlertDialog(
      scrollable: true,
      alignment: Alignment.center,
      title: Text('modify_preset'.i18n, textAlign: TextAlign.center),
      content: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: 'preset_setting'.i18n),
        items: ref.watch(choiceNodePresetListProvider).keys.map<DropdownMenuItem<String>>((name) => DropdownMenuItem(value: name, child: Text(name))).toList(),
        onChanged: (String? t) {
          if (t != null) {
            ref.read(choiceStatusProvider(pos).notifier).asChoiceNode()?.choiceNodeOption = design.copyWith(
              presetName: t,
            );
            ref.read(choiceStatusProvider(pos).notifier).refreshSelf();
          }
        },
        value: design.presetName,
      ),
    );
  }
}

class SizeDialog extends ConsumerWidget {
  final Pos pos;

  const SizeDialog(this.pos, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var width = ref.watch(choiceNodeSizeProvider(pos));
    var str = width == 0 ? 'max' : width.toString();
    var linePos = Pos(data: pos.data.getRange(0, 2).toList());
    var preset = ref.watch(lineDesignPresetProvider(pos: linePos));
    return AlertDialog(
      scrollable: true,
      alignment: Alignment.center,
      title: Text('modify_size'.i18n, textAlign: TextAlign.center),
      content: SizedBox(
        width: 400,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${'length'.i18n} : $str', style: Theme.of(context).textTheme.titleMedium),
            Slider(
              onChanged: (double value) {
                ref.read(choiceNodeSizeProvider(pos).notifier).sizeChange(value.toInt());
              },
              value: width.toDouble(),
              divisions: preset.maxChildrenPerRow,
              max: preset.maxChildrenPerRow!.toDouble(),
              min: 0,
              label: str,
            ),
          ],
        ),
      ),
    );
  }
}
