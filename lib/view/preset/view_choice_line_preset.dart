import 'package:cyoap_core/preset/node_preset.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/util/color_helper.dart';
import 'package:cyoap_flutter/view/preset/view_preset.dart';
import 'package:cyoap_flutter/view/util/view_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../../model/image_db.dart';
import '../../viewModel/preset/vm_choice_line_preset.dart';
import '../../viewModel/preset/vm_preset.dart';
import '../util/controller_adjustable_scroll.dart';
import '../util/view_color_picker.dart';

class ChoiceLineSample extends ConsumerWidget {
  const ChoiceLineSample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var colorOption =
        ref.watch(choiceLinePresetCurrentEditProvider).backgroundColorOption!;
    return Container(
      decoration: BoxDecoration(
        image: ImageDB().checkers,
      ),
      child: Padding(
        padding: const EdgeInsets.all(ConstList.padding),
        child: Container(
          decoration: BoxDecoration(
            color: colorOption.getColor(),
            gradient: colorOption.getGradient(),
          ),
          constraints: const BoxConstraints.expand(
            height: 300,
          ),
        ),
      ),
    );
  }
}

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
                title: Text(preset.name!),
                trailing: preset.name == "default"
                    ? null
                    : IconButton(
                        icon: Icon(Icons.delete,
                            size: (IconTheme.of(context).size ?? 18) * 0.8),
                        onPressed: () {
                          ref
                              .read(choiceLinePresetListProvider.notifier)
                              .deleteIndex(index);
                        },
                      ),
                leading: preset.name == "default"
                    ? null
                    : IconButton(
                        icon: Icon(Icons.drive_file_rename_outline,
                            size: (IconTheme.of(context).size ?? 18) * 0.8),
                        onPressed: () async {
                          var text = await showDialog(
                              context: context,
                              builder: (context) {
                                return PresetRenameDialog(preset.name!);
                              },
                              barrierDismissible: false);
                          if (text != null && text.trim().isNotEmpty) {
                            ref
                                .read(choiceLinePresetListProvider.notifier)
                                .rename(index, text.trim());
                          }
                        },
                      ),
                onTap: () {
                  ref
                      .read(currentPresetIndexProvider.notifier)
                      .update((state) => index);
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
    var colorOption = preset.backgroundColorOption;
    return Padding(
      padding: const EdgeInsets.all(ConstList.padding),
      child: CustomScrollView(
        controller: AdjustableScrollController(),
        shrinkWrap: true,
        slivers: [
          SliverGrid(
            delegate: SliverChildListDelegate([
              CustomSwitch(
                  updateState: () => ref
                      .read(choiceLinePresetListProvider.notifier)
                      .updateIndex(
                          index,
                          preset.copyWith(
                              alwaysVisibleLine: !preset.alwaysVisibleLine!)),
                  label: 'black_line'.i18n,
                  state: preset.alwaysVisibleLine!),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(ConstList.padding),
                  child: Row(
                    children: [
                      Text('lineSetting_maxChildrenPerRow'.i18n),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () => ref
                            .read(choiceLinePresetListProvider.notifier)
                            .updateIndex(
                                index,
                                preset.copyWith(
                                    maxChildrenPerRow:
                                        preset.maxChildrenPerRow! >= 0
                                            ? preset.maxChildrenPerRow! - 1
                                            : preset.maxChildrenPerRow!)),
                      ),
                      Text(preset.maxChildrenPerRow.toString()),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () => ref
                            .read(choiceLinePresetListProvider.notifier)
                            .updateIndex(
                                index,
                                preset.copyWith(
                                    maxChildrenPerRow:
                                        preset.maxChildrenPerRow! + 1)),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ConstList.isSmallDisplay(context) ? 1 : 2,
              crossAxisSpacing: 2,
              mainAxisExtent: 80,
              mainAxisSpacing: 2,
            ),
          ),
          const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: ConstList.paddingHuge)),
          SliverToBoxAdapter(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(ConstList.padding),
                child: ViewColorOptionEditor(
                  colorOption: colorOption!,
                  changeFunction: (ColorOption after) {
                    ref.read(choiceLinePresetListProvider.notifier).updateIndex(
                        index, preset.copyWith(backgroundColorOption: after));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
