import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/preset/node_preset.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/util/color_helper.dart';
import 'package:cyoap_flutter/view/preset/view_preset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../../model/image_db.dart';
import '../../model/platform.dart';
import '../../viewModel/preset/vm_choice_node_preset.dart';
import '../../viewModel/preset/vm_preset.dart';
import '../../viewModel/choice/vm_choice.dart';
import '../util/controller_adjustable_scroll.dart';
import '../util/view_color_picker.dart';
import '../util/view_options.dart';
import '../choice/view_choice_node.dart';

class ChoiceNodeSample extends ConsumerWidget {
  const ChoiceNodeSample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            image: ImageDB().checkers,
          ),
          child: const SizedBox(
            width: 250,
            child: IgnorePointer(
              child: ViewChoiceNode(
                Pos(data: [designSamplePosition]),
                ignoreOption: true,
              ),
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              ref
                  .read(choiceNodePresetTestSelectProvider.notifier)
                  .update((state) => !state);
              var pos = const Pos(data: [designSamplePosition]);
              ref.read(choiceStatusProvider(pos)).refreshSelf();
            },
            icon: ref.watch(choiceNodePresetTestSelectProvider)
                ? const Icon(Icons.check_box_outlined)
                : const Icon(Icons.check_box_outline_blank)),
      ],
    );
  }
}

class ChoiceNodePresetList extends ConsumerWidget {
  const ChoiceNodePresetList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var list = ref.watch(choiceNodePresetListProvider);
    return Column(
      children: [
        ListTile(
          title: Text('preset'.i18n),
          trailing: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ref.read(choiceNodePresetListProvider.notifier).create();
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
                trailing: preset.name == "default"
                    ? null
                    : IconButton(
                        icon: Icon(Icons.delete,
                            size: (IconTheme.of(context).size ?? 18) * 0.8),
                        onPressed: () {
                          ref
                              .read(choiceNodePresetListProvider.notifier)
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
                                return PresetRenameDialog(preset.name);
                              },
                              barrierDismissible: false);
                          if (text != null && text.trim().isNotEmpty) {
                            ref
                                .read(choiceNodePresetListProvider.notifier)
                                .rename(index, text.trim());
                            var pos = const Pos(data: [designSamplePosition]);

                            ref.read(choiceStatusProvider(pos)).refreshSelf();
                          }
                        },
                      ),
                onTap: () {
                  ref
                      .read(currentPresetIndexProvider.notifier)
                      .update((state) => index);
                  var pos = const Pos(data: [designSamplePosition]);
                  ref.read(choiceStatusProvider(pos)).refreshSelf();
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

class ViewNodeOptionEditor extends ConsumerStatefulWidget {
  const ViewNodeOptionEditor({
    super.key,
  });

  @override
  ConsumerState createState() => _ViewNodeOptionEditorState();
}

class _ViewNodeOptionEditorState extends ConsumerState<ViewNodeOptionEditor> {
  AdjustableScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = AdjustableScrollController();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget currentChild;
    switch (ref.watch(choiceNodePresetCurrentTabProvider)) {
      case 0:
        currentChild = const ViewNodeGeneralOptionEditor();
      case 1:
        currentChild = const ViewNodeOutlineOptionEditor();
      default:
        currentChild = const ViewNodeColorOptionEditor();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NavigationRail(
          destinations: [
            NavigationRailDestination(
              icon: const Icon(Icons.settings),
              label: Text('general'.i18n),
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
            NavigationRailDestination(
              icon: const Icon(Icons.check_box_outline_blank),
              label: Text('outline'.i18n),
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
            NavigationRailDestination(
              icon: const Icon(Icons.square_rounded),
              label: Text('inner'.i18n),
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ],
          selectedIndex: ref.watch(choiceNodePresetCurrentTabProvider),
          onDestinationSelected: (int index) {
            ref.read(choiceNodePresetCurrentTabProvider.notifier).state = index;
          },
          labelType: NavigationRailLabelType.all,
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(ConstList.padding),
            child: currentChild,
          ),
        ),
      ],
    );
  }
}

class ViewNodeGeneralOptionEditor extends ConsumerStatefulWidget {
  const ViewNodeGeneralOptionEditor({super.key});

  @override
  ConsumerState createState() => _ViewNodeGeneralOptionEditorState();
}

class _ViewNodeGeneralOptionEditorState
    extends ConsumerState<ViewNodeGeneralOptionEditor> {
  final AdjustableScrollController _scrollController =
      AdjustableScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var preset = ref.watch(choiceNodePresetCurrentEditProvider);
    var presetIndex = ref.watch(currentPresetIndexProvider);
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: CustomScrollView(
        shrinkWrap: true,
        controller: _scrollController,
        slivers: [
          SliverGrid(
            delegate: SliverChildListDelegate([
              CustomTextField(
                controller:
                    ref.watch(choiceNodePresetCurrentEditElevationProvider),
                label: 'height'.i18n,
              ),
              CustomTextField(
                controller: ref.watch(choiceNodePresetCurrentEditRoundProvider),
                label: 'round'.i18n,
              ),
              CustomTextField(
                controller:
                    ref.watch(choiceNodePresetCurrentEditPaddingProvider),
                label: 'padding'.i18n,
              ),
            ]),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisExtent: 80,
              mainAxisSpacing: 2,
            ),
          ),
          const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: ConstList.paddingHuge)),
          SliverGrid(
            delegate: SliverChildListDelegate([
              CustomSwitch(
                updateState: () {
                  ref.read(choiceNodePresetListProvider.notifier).updateIndex(
                      presetIndex,
                      preset.copyWith(
                          maximizingImage: !preset.maximizingImage));
                },
                label: 'maximize_image'.i18n,
                state: preset.maximizingImage,
              ),
              CustomSwitch(
                updateState: () {
                  ref.read(choiceNodePresetListProvider.notifier).updateIndex(
                      presetIndex,
                      preset.copyWith(hideTitle: !preset.hideTitle));
                },
                label: 'hide_title'.i18n,
                state: preset.hideTitle,
              ),
              CustomSwitch(
                updateState: () {
                  ref.read(choiceNodePresetListProvider.notifier).updateIndex(
                      presetIndex,
                      preset.copyWith(titlePosition: !preset.titlePosition));
                },
                label: 'title_up'.i18n,
                state: preset.titlePosition,
              ),
              CustomSwitch(
                updateState: () {
                  ref.read(choiceNodePresetListProvider.notifier).updateIndex(
                      presetIndex,
                      preset.copyWith(
                          imagePosition: preset.imagePosition == 0 ? 1 : 0));
                },
                label: 'horizontal_mode'.i18n,
                state: preset.imagePosition != 0,
              ),
              CustomSwitch(
                updateState: () {
                  if (preset.imagePosition == 1) {
                    ref.read(choiceNodePresetListProvider.notifier).updateIndex(
                        presetIndex, preset.copyWith(imagePosition: 2));
                  } else if (preset.imagePosition == 2) {
                    ref.read(choiceNodePresetListProvider.notifier).updateIndex(
                        presetIndex, preset.copyWith(imagePosition: 1));
                  }
                },
                label: 'image_left'.i18n,
                disable: preset.imagePosition == 0,
                state: preset.imagePosition == 2,
              ),
            ]),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisExtent: 80,
              mainAxisSpacing: 2,
            ),
          ),
          const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: ConstList.paddingHuge)),
          SliverGrid(
            delegate: SliverChildListDelegate([
              CustomDropdownButton<String>(
                label: 'font_title'.i18n,
                onChanged: (String? t) {
                  if (t != null) {
                    var index = ref.read(currentPresetIndexProvider);
                    ref
                        .read(choiceNodePresetListProvider.notifier)
                        .updateIndex(index, preset.copyWith(titleFont: t));
                  }
                },
                value: preset.titleFont,
                items: ConstList.textFontList.keys
                    .map<DropdownMenuItem<String>>((name) => DropdownMenuItem(
                        value: name,
                        child: Text(name, style: ConstList.getFont(name))))
                    .toList(),
              ),
              CustomDropdownButton<String>(
                label: 'font_content'.i18n,
                onChanged: (String? t) {
                  if (t != null) {
                    var index = ref.read(currentPresetIndexProvider);
                    ref
                        .read(choiceNodePresetListProvider.notifier)
                        .updateIndex(index, preset.copyWith(mainFont: t));
                  }
                },
                value: preset.mainFont,
                items: ConstList.textFontList.keys
                    .map<DropdownMenuItem<String>>((name) => DropdownMenuItem(
                        value: name,
                        child: Text(name, style: ConstList.getFont(name))))
                    .toList(),
              ),
            ]),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisExtent: 80,
              mainAxisSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class ViewNodeOutlineOptionEditor extends ConsumerStatefulWidget {
  const ViewNodeOutlineOptionEditor({super.key});

  @override
  ConsumerState createState() => _ViewNodeOutlineOptionEditorState();
}

class _ViewNodeOutlineOptionEditorState
    extends ConsumerState<ViewNodeOutlineOptionEditor> {
  final AdjustableScrollController _scrollController =
      AdjustableScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var preset = ref.watch(choiceNodePresetCurrentEditProvider);
    var presetIndex = ref.watch(currentPresetIndexProvider);
    var opacity = preset.selectOutlineEnable ? 1.0 : 0.3;
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: CustomScrollView(
        shrinkWrap: true,
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(ConstList.padding),
                child: ViewColorPicker(
                  text: 'node_outline_color'.i18n,
                  color: preset.defaultOutlineOption.outlineColor.getColor()!,
                  onColorChanged: (Color value) {
                    ref.read(choiceNodePresetListProvider.notifier).updateIndex(
                        presetIndex,
                        preset.copyWith.defaultOutlineOption
                            .outlineColor(color: value.value));
                  },
                  hasAlpha: true,
                ),
              ),
            ),
          ),
          const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: ConstList.paddingHuge)),
          SliverGrid(
            delegate: SliverChildListDelegate([
              CustomDropdownButton<OutlineType>(
                label: 'outline_shape'.i18n,
                onChanged: (OutlineType? t) {
                  if (t != null) {
                    ref.read(choiceNodePresetListProvider.notifier).updateIndex(
                        presetIndex,
                        preset.copyWith.defaultOutlineOption(outlineType: t));
                  }
                },
                value: preset.defaultOutlineOption.outlineType,
                items: OutlineType.values
                    .map<DropdownMenuItem<OutlineType>>((type) =>
                        DropdownMenuItem(value: type, child: Text(type.name)))
                    .toList(),
              ),
              CustomTextField(
                label: 'outline_padding'.i18n,
                keyboardType: TextInputType.number,
                controller: ref
                    .watch(choiceNodePresetCurrentEditOutlinePaddingProvider),
              ),
              CustomTextField(
                label: 'outline_width'.i18n,
                keyboardType: TextInputType.number,
                controller:
                    ref.watch(choiceNodePresetCurrentEditOutlineWidthProvider),
              ),
            ]),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisExtent: 80,
              mainAxisSpacing: 2,
            ),
          ),
          const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: ConstList.paddingHuge)),
          const SliverToBoxAdapter(child: Divider()),
          const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: ConstList.paddingHuge)),
          SliverToBoxAdapter(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(ConstList.padding),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('node_select_color_enable'.i18n),
                        Checkbox(
                          value: preset.selectOutlineEnable,
                          onChanged: (bool? value) {
                            if (value != null) {
                              ref
                                  .read(choiceNodePresetListProvider.notifier)
                                  .updateIndex(
                                      presetIndex,
                                      preset.copyWith(
                                          selectOutlineEnable: value));
                            }
                          },
                        ),
                      ],
                    ),
                    Opacity(
                      opacity: opacity,
                      child: ViewColorPicker(
                        text: 'node_outline_color'.i18n,
                        color:
                            preset.selectOutlineOption.outlineColor.getColor()!,
                        onColorChanged: (Color value) {
                          ref
                              .read(choiceNodePresetListProvider.notifier)
                              .updateIndex(
                                  presetIndex,
                                  preset.copyWith.selectOutlineOption
                                      .outlineColor(color: value.value));
                        },
                        hasAlpha: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: ConstList.paddingHuge)),
          SliverOpacity(
            opacity: opacity,
            sliver: SliverGrid(
              delegate: SliverChildListDelegate([
                CustomDropdownButton<OutlineType>(
                  label: 'outline_shape'.i18n,
                  value: preset.selectOutlineOption.outlineType,
                  items: OutlineType.values
                      .map<DropdownMenuItem<OutlineType>>((type) =>
                          DropdownMenuItem(value: type, child: Text(type.name)))
                      .toList(),
                  onChanged: (OutlineType? t) {
                    if (t != null) {
                      ref
                          .read(choiceNodePresetListProvider.notifier)
                          .updateIndex(
                              presetIndex,
                              preset.copyWith
                                  .selectOutlineOption(outlineType: t));
                    }
                  },
                ),
                CustomTextField(
                    controller: ref.watch(
                        choiceNodePresetSelectedEditOutlinePaddingProvider),
                    label: 'outline_padding'.i18n),
                CustomTextField(
                    controller: ref.watch(
                        choiceNodePresetSelectedEditOutlineWidthProvider),
                    label: 'outline_width'.i18n),
              ]),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisExtent: 80,
                mainAxisSpacing: 2,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ViewNodeColorOptionEditor extends ConsumerStatefulWidget {
  const ViewNodeColorOptionEditor({super.key});

  @override
  ConsumerState createState() => _ViewNodeColorOptionEditorState();
}

class _ViewNodeColorOptionEditorState
    extends ConsumerState<ViewNodeColorOptionEditor> {
  final AdjustableScrollController _scrollController =
      AdjustableScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var preset = ref.watch(choiceNodePresetCurrentEditProvider);
    var presetIndex = ref.watch(currentPresetIndexProvider);
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: CustomScrollView(
        shrinkWrap: true,
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(ConstList.padding),
                child: ViewColorOptionEditor(
                  colorOption: preset.defaultColorOption,
                  changeFunction: (ColorOption after) {
                    ref.read(choiceNodePresetListProvider.notifier).updateIndex(
                        presetIndex,
                        preset.copyWith(defaultColorOption: after));
                  },
                ),
              ),
            ),
          ),
          const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: ConstList.paddingHuge)),
          SliverToBoxAdapter(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(ConstList.padding),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('node_select_color_enable'.i18n),
                        Checkbox(
                          value: preset.selectColorEnable,
                          onChanged: (bool? value) {
                            if (value != null) {
                              ref
                                  .read(choiceNodePresetListProvider.notifier)
                                  .updateIndex(
                                      presetIndex,
                                      preset.copyWith(
                                          selectColorEnable: value));
                            }
                          },
                        ),
                      ],
                    ),
                    Opacity(
                      opacity: preset.selectColorEnable ? 1.0 : 0.3,
                      child: ViewColorOptionEditor(
                        colorOption: preset.selectColorOption,
                        changeFunction: (ColorOption after) {
                          ref
                              .read(choiceNodePresetListProvider.notifier)
                              .updateIndex(presetIndex,
                                  preset.copyWith(selectColorOption: after));
                        },
                      ),
                    ),
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
