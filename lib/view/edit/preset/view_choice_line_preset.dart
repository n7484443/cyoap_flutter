import 'package:context_menus/context_menus.dart';
import 'package:cyoap_core/preset/line_preset.dart';
import 'package:cyoap_core/preset/node_preset.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/util/color_helper.dart';
import 'package:cyoap_flutter/view/edit/preset/view_preset.dart';
import 'package:cyoap_flutter/view/util/view_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main.dart';
import '../../../model/image_db.dart';
import '../../../viewModel/edit/preset/vm_choice_line_preset.dart';
import '../../../viewModel/edit/preset/vm_preset.dart';
import '../../util/view_color_picker.dart';

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
    var popupDefaultPreset = [
      (
        'clone'.i18n,
        (index, preset) async {
          ref.read(choiceLinePresetListProvider.notifier).cloneIndex(index);
        }
      ),
    ];
    var popupNonDefaultPreset = [
      (
        'rename'.i18n,
        (index, preset) async {
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
        }
      ),
      ...popupDefaultPreset,
      (
        'delete'.i18n,
        (index, preset) async {
          ref
              .read(choiceLinePresetListProvider.notifier)
              .deleteIndex(index);
        }
      ),
    ];
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
            controller: ScrollController(),
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              var preset = list[index];
              var popupList = preset.name == "default"
                  ? popupDefaultPreset
                  : popupNonDefaultPreset;
              return ContextMenuRegion(
                  contextMenu: GenericContextMenu(
                    buttonConfigs: List.generate(
                      popupList.length,
                      (popupIndex) => ContextMenuButtonConfig(
                        popupList[popupIndex].$1,
                        onPressed: () {
                          popupList[popupIndex].$2(index, preset);
                        },
                      ),
                    ),
                  ),
                  child: ListTile(
                    key: Key('$index'),
                    title: Text(preset.name!),
                    onTap: () {
                      ref
                          .read(currentPresetIndexProvider.notifier)
                          .update((state) => index);
                    },
                    selected: index == ref.watch(currentPresetIndexProvider),
                  ));
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
        controller: ScrollController(),
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
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('lineSetting_alignment'.i18n),
                      SizedBox(
                        width: 80,
                        child: DropdownButtonFormField<ChoiceLineAlignment>(
                          items: ChoiceLineAlignment.values
                              .map<DropdownMenuItem<ChoiceLineAlignment>>(
                                  (type) => DropdownMenuItem(
                                      value: type, child: Text(type.name)))
                              .toList(),
                          onChanged: (ChoiceLineAlignment? t) {
                            if (t != null) {
                              ref
                                  .read(choiceLinePresetListProvider.notifier)
                                  .updateIndex(
                                      index, preset.copyWith(alignment: t));
                            }
                          },
                          value: preset.alignment,
                        ),
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
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text("background_color".i18n,
                        style: Theme.of(context).textTheme.titleMedium),
                    Padding(
                      padding: const EdgeInsets.all(ConstList.padding),
                      child: ViewColorOptionEditor(
                        colorOption: colorOption!,
                        changeFunction: (ColorOption after) {
                          ref
                              .read(choiceLinePresetListProvider.notifier)
                              .updateIndex(
                                  index,
                                  preset.copyWith(
                                      backgroundColorOption: after));
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
