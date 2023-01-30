import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/view/preset/view_preset.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../../viewModel/preset/vm_choice_line_preset.dart';
import '../../viewModel/preset/vm_preset.dart';
import '../util/controller_adjustable_scroll.dart';
import '../util/view_switch_label.dart';

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
          title: Text('preset'.i18n),
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
                    ref
                        .read(choiceLinePresetListProvider.notifier)
                        .deleteIndex(index);
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

class ViewLineOptionEditor extends ConsumerWidget {
  const ViewLineOptionEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var preset = ref.watch(choiceLinePresetCurrentEditProvider);
    var index = ref.watch(currentPresetIndexProvider);
    return CustomScrollView(
      controller: AdjustableScrollController(),
      shrinkWrap: true,
      slivers: [
        SliverGrid(
          delegate: SliverChildListDelegate([
            ViewSwitchLabel(
              () => ref.read(choiceLinePresetListProvider.notifier).updateIndex(
                  index,
                  preset.copyWith(
                      alwaysVisibleLine: !preset.alwaysVisibleLine)),
              preset.alwaysVisibleLine,
              label: 'black_line'.i18n,
            ),
          ]),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ConstList.isSmallDisplay(context) ? 2 : 4,
            crossAxisSpacing: 2,
            mainAxisExtent: 80,
            mainAxisSpacing: 2,
          ),
        ),
        SliverToBoxAdapter(
          child: ColorPicker(
            heading: Center(
              child: Text('background_color'.i18n),
            ),
            color: Color(preset.backgroundColor ?? 0x000000),
            onColorChanged: (Color color) {
              ref.read(choiceLinePresetListProvider.notifier).updateIndex(
                  index, preset.copyWith(backgroundColor: color.value));
            },
            pickersEnabled: {
              ColorPickerType.wheel: true,
              ColorPickerType.accent: false
            },
            pickerTypeLabels: {
              ColorPickerType.primary: "color_select".i18n,
              ColorPickerType.wheel: "color_direct_select".i18n,
            },
            width: 22,
            height: 22,
            borderRadius: 22,
          ),
        ),
        SliverToBoxAdapter(
          child: IconButton(
            onPressed: () {
              ref
                  .read(choiceLinePresetListProvider.notifier)
                  .updateIndex(index, preset.copyWith(backgroundColor: null));
            },
            icon: const Icon(Icons.format_color_reset),
          ),
        )
      ],
    );
  }
}
