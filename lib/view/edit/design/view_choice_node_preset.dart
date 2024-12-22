import 'package:context_menus/context_menus.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/preset/node_preset.dart';
import 'package:cyoap_core/preset/preset.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/util/color_helper.dart';
import 'package:cyoap_flutter/view/edit/design/view_preset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main.dart';
import '../../../model/image_db.dart';
import '../../../model/platform.dart';
import '../../../viewModel/choice/vm_choice.dart';
import '../../../viewModel/edit/preset/vm_choice_node_preset.dart';
import '../../../viewModel/edit/preset/vm_preset.dart';
import '../../choice/view_choice_node.dart';
import '../../util/view_color_picker.dart';
import '../../util/view_options.dart';

class ChoiceNodeSample extends ConsumerWidget {
  const ChoiceNodeSample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ConstList.isSmallDisplay(context)) {
      return SizedBox(
        height: 300,
        child: Row(
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
                    ignoreOption: ChoiceNodeChildRender.onlySelf,
                  ),
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  ref.read(choiceNodePresetTestSelectProvider.notifier).update((state) => !state);
                  var pos = const Pos(data: [designSamplePosition]);
                  ref.read(choiceStatusProvider(pos)).refreshSelf();
                },
                icon: ref.watch(choiceNodePresetTestSelectProvider) ? const Icon(Icons.check_box_outlined) : const Icon(Icons.check_box_outline_blank)),
          ],
        ),
      );
    }
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
                ignoreOption: ChoiceNodeChildRender.onlySelf,
              ),
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              ref.read(choiceNodePresetTestSelectProvider.notifier).update((state) => !state);
              var pos = const Pos(data: [designSamplePosition]);
              ref.read(choiceStatusProvider(pos)).refreshSelf();
            },
            icon: ref.watch(choiceNodePresetTestSelectProvider) ? const Icon(Icons.check_box_outlined) : const Icon(Icons.check_box_outline_blank)),
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
    List<(String, void Function(String name, ChoiceNodeDesignPreset preset))> popupDefaultPreset = [
      (
        'clone'.i18n,
        (name, preset) async {
          ref.read(choiceNodePresetListProvider.notifier).clone(name);
        }
      ),
    ];
    List<(String, void Function(String name, ChoiceNodeDesignPreset preset))> popupNonDefaultPreset = [
      (
        'rename'.i18n,
        (name, preset) async {
          var text = await showDialog(
              context: context,
              builder: (context) {
                return PresetRenameDialog(name);
              },
              barrierDismissible: false);
          if (text != null && text.trim().isNotEmpty) {
            ref.read(choiceNodePresetListProvider.notifier).rename(name, text.trim());
            var pos = const Pos(data: [designSamplePosition]);

            ref.read(choiceStatusProvider(pos)).refreshSelf();
          }
        }
      ),
      ...popupDefaultPreset,
      (
        'delete'.i18n,
        (name, preset) async {
          ref.read(choiceNodePresetListProvider.notifier).delete(name);
        }
      ),
    ];
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: ScrollController(),
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              var name = list.keys.toList()[index];
              var preset = list[name]!;
              var popupList = name == "default" ? popupDefaultPreset : popupNonDefaultPreset;
              return ContextMenuRegion(
                contextMenu: GenericContextMenu(
                  buttonConfigs: List.generate(
                    popupList.length,
                    (popupIndex) => ContextMenuButtonConfig(
                      popupList[popupIndex].$1,
                      onPressed: () {
                        popupList[popupIndex].$2(name, preset);
                      },
                    ),
                  ),
                ),
                child: ListTile(
                  key: Key('$index'),
                  title: Text(name),
                  onTap: () {
                    ref.read(currentPresetNameProvider.notifier).update((state) => name);
                    var pos = const Pos(data: [designSamplePosition]);
                    ref.read(choiceStatusProvider(pos)).refreshSelf();
                  },
                  selected: name == ref.watch(currentPresetNameProvider),
                ),
              );
            },
          ),
        ),
        ListTile(
          title: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ref.read(choiceNodePresetListProvider.notifier).create();
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
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
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
      case 2:
        currentChild = const ViewNodeColorOptionEditor();
      default:
        currentChild = const ViewNodeComponentOptionEditor();
    }
    List<(Widget, String)> destinations = [
      (const Icon(Icons.settings), 'general'.i18n),
      (const Icon(Icons.check_box_outline_blank), 'outline'.i18n),
      (const Icon(Icons.square_rounded), 'inner'.i18n),
      (
        Stack(
          children: [
            const Icon(Icons.horizontal_rule),
            Positioned.fill(
              child: Center(
                child: ColoredBox(
                  color: Theme.of(context).colorScheme.error,
                  child: const SizedBox(width: 2, height: 10),
                ),
              ),
            ),
          ],
        ),
        'component'.i18n
      ),
    ];
    if (ConstList.isSmallDisplay(context)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavigationBar(
            destinations: List.generate(destinations.length, (int index) {
              return NavigationDestination(
                icon: destinations[index].$1,
                label: destinations[index].$2,
              );
            }),
            selectedIndex: ref.watch(choiceNodePresetCurrentTabProvider),
            onDestinationSelected: (int index) {
              ref.read(choiceNodePresetCurrentTabProvider.notifier).state = index;
            },
            surfaceTintColor: Colors.transparent,
          ),
          const SizedBox(
            width: 8,
          ),
          currentChild,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: ConstList.padding),
            child: currentChild,
          ),
        ),
        NavigationRail(
          destinations: List.generate(destinations.length, (int index) {
            return NavigationRailDestination(
              icon: destinations[index].$1,
              label: Text(destinations[index].$2),
              padding: const EdgeInsets.symmetric(vertical: 8),
            );
          }),
          selectedIndex: ref.watch(choiceNodePresetCurrentTabProvider),
          onDestinationSelected: (int index) {
            ref.read(choiceNodePresetCurrentTabProvider.notifier).state = index;
          },
          labelType: NavigationRailLabelType.all,
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

class _ViewNodeGeneralOptionEditorState extends ConsumerState<ViewNodeGeneralOptionEditor> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var preset = ref.watch(choiceNodePresetCurrentEditProvider)!;
    var presetName = ref.watch(currentPresetNameProvider);
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      trackVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Wrap(
          spacing: 15,
          runSpacing: 15,
          children: [
            SizedBox(
              width: unitWidth * 2,
              child: ViewVertexEdgeEditor(
                label: 'padding_round'.i18n,
                edgeProvider: (String str) => ref.watch(ChoiceNodePresetDistanceProvider(position: str)),
                vertexProvider: (String str) => ref.watch(ChoiceNodePresetRoundProvider(position: str)),
                edgeFillLabel: 'distance'.i18n,
                vertexFillLabel: 'round'.i18n,
              ),
            ),
            SizedBox(
              width: largeUnitWidth,
              child: Wrap(
                children: [
                  CustomTextField(
                    forceWidth: unitWidth,
                    controller: ref.watch(choiceNodePresetCurrentEditElevationProvider),
                    label: 'elevation'.i18n,
                  ),
                  CustomTextField(
                    forceWidth: unitWidth,
                    controller: ref.watch(choiceNodePresetImageMaxHeightRatioProvider),
                    label: 'image_maxHeight_ratio'.i18n,
                    tooltip: 'image_maxHeight_ratio_tooltip'.i18n,
                  ),
                  CustomSwitch(
                    forceWidth: unitWidth,
                    updateState: () {
                      ref.read(choiceNodePresetListProvider.notifier).update(presetName, preset.copyWith(hideTitle: !preset.hideTitle!));
                    },
                    label: 'hide_title'.i18n,
                    state: preset.hideTitle!,
                  ),
                  CustomSwitch(
                    forceWidth: unitWidth,
                    updateState: () {
                      ref.read(choiceNodePresetListProvider.notifier).update(presetName, preset.copyWith(titlePosition: !preset.titlePosition!));
                    },
                    label: 'title_up'.i18n,
                    state: preset.titlePosition!,
                  ),
                  CustomSwitch(
                    forceWidth: unitWidth,
                    updateState: () {
                      ref.read(choiceNodePresetListProvider.notifier).update(presetName, preset.copyWith(imagePosition: preset.imagePosition == 0 ? 1 : 0));
                    },
                    label: 'horizontal_mode'.i18n,
                    state: preset.imagePosition != 0,
                  ),
                  CustomSwitch(
                    forceWidth: unitWidth,
                    updateState: () {
                      if (preset.imagePosition == 1) {
                        ref.read(choiceNodePresetListProvider.notifier).update(presetName, preset.copyWith(imagePosition: 2));
                      } else if (preset.imagePosition == 2) {
                        ref.read(choiceNodePresetListProvider.notifier).update(presetName, preset.copyWith(imagePosition: 1));
                      }
                    },
                    label: 'image_left'.i18n,
                    disable: preset.imagePosition == 0,
                    state: preset.imagePosition == 2,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: largeUnitWidth,
              child: Wrap(
                children: [
                  CustomDropdownButton<String>(
                    forceWidth: unitWidth,
                    label: 'font_title'.i18n,
                    onChanged: (String? t) {
                      if (t != null) {
                        ref.read(choiceNodePresetListProvider.notifier).update(presetName, preset.copyWith(titleFont: t));
                      }
                    },
                    value: preset.titleFont!,
                    items: ConstList.textFontList.keys.map<DropdownMenuItem<String>>((name) => DropdownMenuItem(value: name, child: Text(name, style: ConstList.getFont(name)))).toList(),
                  ),
                  CustomDropdownButton<String>(
                    forceWidth: unitWidth,
                    label: 'font_content'.i18n,
                    onChanged: (String? t) {
                      if (t != null) {
                        ref.read(choiceNodePresetListProvider.notifier).update(presetName, preset.copyWith(mainFont: t));
                      }
                    },
                    value: preset.mainFont!,
                    items: ConstList.textFontList.keys.map<DropdownMenuItem<String>>((name) => DropdownMenuItem(value: name, child: Text(name, style: ConstList.getFont(name)))).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewNodeOutlineOptionEditor extends ConsumerStatefulWidget {
  const ViewNodeOutlineOptionEditor({super.key});

  @override
  ConsumerState createState() => _ViewNodeOutlineOptionEditorState();
}

class _ViewNodeOutlineOptionEditorState extends ConsumerState<ViewNodeOutlineOptionEditor> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var preset = ref.watch(choiceNodePresetCurrentEditProvider)!;
    var presetName = ref.watch(currentPresetNameProvider);
    var opacity = preset.selectOutlineEnable! ? 1.0 : 0.3;
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      trackVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                SizedBox(
                  width: unitWidth,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(ConstList.padding),
                      child: ViewColorPicker(
                        text: 'node_outline_color'.i18n,
                        color: preset.defaultOutlineOption!.outlineColor.getColor()!,
                        onColorChanged: (Color value) {
                          ref.read(choiceNodePresetListProvider.notifier).update(presetName, preset.copyWith.defaultOutlineOption!.outlineColor(color: value.value));
                        },
                        hasAlpha: true,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    CustomDropdownButton<OutlineType>(
                      forceWidth: unitWidth,
                      label: 'outline_shape'.i18n,
                      onChanged: (OutlineType? t) {
                        if (t != null) {
                          ref.read(choiceNodePresetListProvider.notifier).update(presetName, preset.copyWith.defaultOutlineOption!(outlineType: t));
                        }
                      },
                      value: preset.defaultOutlineOption!.outlineType,
                      items: OutlineType.values.map<DropdownMenuItem<OutlineType>>((type) => DropdownMenuItem(value: type, child: Text(type.name))).toList(),
                    ),
                    CustomTextField(
                      forceWidth: unitWidth,
                      label: 'outline_width'.i18n,
                      keyboardType: TextInputType.number,
                      controller: ref.watch(choiceNodePresetCurrentEditOutlineWidthProvider),
                    ),
                  ],
                ),
                SizedBox(
                  width: largeUnitWidth,
                  child: ViewVertexEdgeEditor(
                    label: 'outline_distance_round_nonactive'.i18n,
                    subLabel: 'outline_distance_round_sub'.i18n,
                    edgeProvider: (String str) => ref.watch(ChoiceNodePresetOutlineDistanceProvider(position: str, isSelected: false)),
                    vertexProvider: (String str) => ref.watch(ChoiceNodePresetOutlineRoundProvider(position: str, isSelected: false)),
                    edgeFillLabel: 'distance'.i18n,
                    vertexFillLabel: 'round'.i18n,
                  ),
                )
              ],
            ),
            const SizedBox(height: ConstList.paddingHuge),
            const Divider(),
            const SizedBox(height: ConstList.paddingHuge),
            Row(
              children: [
                Text('node_select_color_enable'.i18n),
                Checkbox(
                  value: preset.selectOutlineEnable,
                  onChanged: (bool? value) {
                    if (value != null) {
                      ref.read(choiceNodePresetListProvider.notifier).update(presetName, preset.copyWith(selectOutlineEnable: value));
                    }
                  },
                ),
              ],
            ),
            Wrap(
              children: [
                SizedBox(
                  width: unitWidth,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(ConstList.padding),
                      child: Column(
                        children: [
                          Opacity(
                            opacity: opacity,
                            child: ViewColorPicker(
                              text: 'node_outline_color_selected'.i18n,
                              color: preset.selectOutlineOption!.outlineColor.getColor()!,
                              onColorChanged: (Color value) {
                                ref.read(choiceNodePresetListProvider.notifier).update(presetName, preset.copyWith.selectOutlineOption!.outlineColor(color: value.value));
                              },
                              hasAlpha: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: unitWidth,
                  child: Opacity(
                    opacity: opacity,
                    child: Column(
                      children: [
                        CustomDropdownButton<OutlineType>(
                          label: 'outline_shape'.i18n,
                          value: preset.selectOutlineOption!.outlineType,
                          items: OutlineType.values.map<DropdownMenuItem<OutlineType>>((type) => DropdownMenuItem(value: type, child: Text(type.name))).toList(),
                          onChanged: (OutlineType? t) {
                            if (t != null) {
                              ref.read(choiceNodePresetListProvider.notifier).update(presetName, preset.copyWith.selectOutlineOption!(outlineType: t));
                            }
                          },
                        ),
                        CustomTextField(controller: ref.watch(choiceNodePresetSelectedEditOutlineWidthProvider), label: 'outline_width'.i18n),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: largeUnitWidth,
                  child: Opacity(
                    opacity: opacity,
                    child: ViewVertexEdgeEditor(
                      label: 'outline_distance_round_active'.i18n,
                      subLabel: 'outline_distance_round_sub'.i18n,
                      edgeProvider: (String str) => ref.watch(ChoiceNodePresetOutlineDistanceProvider(position: str, isSelected: true)),
                      vertexProvider: (String str) => ref.watch(ChoiceNodePresetOutlineRoundProvider(position: str, isSelected: true)),
                      edgeFillLabel: 'distance'.i18n,
                      vertexFillLabel: 'round'.i18n,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ViewNodeComponentOptionEditor extends ConsumerStatefulWidget {
  const ViewNodeComponentOptionEditor({super.key});

  @override
  ConsumerState createState() => _ViewNodeComponentOptionEditorState();
}

class _ViewNodeComponentOptionEditorState extends ConsumerState<ViewNodeComponentOptionEditor> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var preset = ref.watch(choiceNodePresetCurrentEditProvider)!;
    var presetName = ref.watch(currentPresetNameProvider);
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      trackVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Wrap(
          spacing: 15,
          runSpacing: 15,
          children: [
            CustomDropdownButton<SliderThumbShape>(
              forceWidth: unitWidth,
              label: 'slider_thumb_shape'.i18n,
              onChanged: (SliderThumbShape? t) {
                if (t != null) {
                  ref.read(choiceNodePresetListProvider.notifier).update(presetName, preset.copyWith.sliderOption!(sliderThumbShape: t));
                }
              },
              value: SliderThumbShape.circle,
              items: SliderThumbShape.values.map<DropdownMenuItem<SliderThumbShape>>((shape) => DropdownMenuItem(value: shape, child: Text(shape.toString()))).toList(),
            ),
            SizedBox(
              width: unitWidth,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(ConstList.padding),
                  child: ViewColorPicker(
                    text: 'slider_thumb_color'.i18n,
                    color: preset.sliderOption!.sliderThumbColor.getColor()!,
                    onColorChanged: (Color value) {
                      ref.read(choiceNodePresetListProvider.notifier).update(presetName, preset.copyWith.sliderOption!.sliderThumbColor(color: value.value));
                    },
                    hasAlpha: true,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: unitWidth,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(ConstList.padding),
                  child: ViewColorPicker(
                    text: 'slider_track_active_color'.i18n,
                    color: preset.sliderOption!.sliderTrackActiveColor.getColor()!,
                    onColorChanged: (Color value) {
                      ref.read(choiceNodePresetListProvider.notifier).update(presetName, preset.copyWith.sliderOption!.sliderTrackActiveColor(color: value.value));
                    },
                    hasAlpha: true,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: unitWidth,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(ConstList.padding),
                  child: ViewColorPicker(
                    text: 'slider_track_inactive_color'.i18n,
                    color: preset.sliderOption!.sliderTrackInactiveColor.getColor()!,
                    onColorChanged: (Color value) {
                      ref.read(choiceNodePresetListProvider.notifier).update(presetName, preset.copyWith.sliderOption!.sliderTrackInactiveColor(color: value.value));
                    },
                    hasAlpha: true,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ViewNodeColorOptionEditor extends ConsumerStatefulWidget {
  const ViewNodeColorOptionEditor({super.key});

  @override
  ConsumerState createState() => _ViewNodeColorOptionEditorState();
}

class _ViewNodeColorOptionEditorState extends ConsumerState<ViewNodeColorOptionEditor> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var preset = ref.watch(choiceNodePresetCurrentEditProvider)!;
    var presetName = ref.watch(currentPresetNameProvider);
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      trackVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Wrap(
          spacing: 15,
          runSpacing: 15,
          children: [
            SizedBox(
              width: unitWidth,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(ConstList.padding),
                  child: ViewColorOptionEditor(
                    colorOption: preset.defaultColorOption!,
                    changeFunction: (ColorOption after) {
                      ref.read(choiceNodePresetListProvider.notifier).update(presetName, preset.copyWith(defaultColorOption: after));
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              width: unitWidth,
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
                                ref.read(choiceNodePresetListProvider.notifier).update(presetName, preset.copyWith(selectColorEnable: value));
                              }
                            },
                          ),
                        ],
                      ),
                      Opacity(
                        opacity: preset.selectColorEnable! ? 1.0 : 0.3,
                        child: ViewColorOptionEditor(
                          colorOption: preset.selectColorOption!,
                          changeFunction: (ColorOption after) {
                            ref.read(choiceNodePresetListProvider.notifier).update(presetName, preset.copyWith(selectColorOption: after));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ViewVertexEdgeEditor extends ConsumerWidget {
  final String label;
  final String? subLabel;
  final TextEditingController Function(String str) edgeProvider;
  final TextEditingController Function(String str) vertexProvider;
  final String edgeFillLabel;
  final String vertexFillLabel;

  const ViewVertexEdgeEditor({required this.label, this.subLabel, required this.edgeProvider, required this.vertexProvider, required this.edgeFillLabel, required this.vertexFillLabel, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 2.0),
              child: Text(label),
            ),
            if (subLabel != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(subLabel!, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: const Color(0xFF666666))),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'topLeft'.i18n,
                    subLabel: vertexFillLabel,
                    keyboardType: TextInputType.number,
                    controller: vertexProvider('topLeft'),
                    outPadding: 2.0,
                  ),
                ),
                Expanded(
                  child: CustomTextField(
                    label: 'top'.i18n,
                    subLabel: edgeFillLabel,
                    keyboardType: TextInputType.number,
                    controller: edgeProvider('top'),
                    outPadding: 2.0,
                  ),
                ),
                Expanded(
                  child: CustomTextField(
                    label: 'topRight'.i18n,
                    subLabel: vertexFillLabel,
                    keyboardType: TextInputType.number,
                    controller: vertexProvider('topRight'),
                    outPadding: 2.0,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'left'.i18n,
                    subLabel: edgeFillLabel,
                    keyboardType: TextInputType.number,
                    controller: edgeProvider('left'),
                    outPadding: 2.0,
                  ),
                ),
                const Spacer(),
                Expanded(
                  child: CustomTextField(
                    label: 'right'.i18n,
                    subLabel: edgeFillLabel,
                    keyboardType: TextInputType.number,
                    controller: edgeProvider('right'),
                    outPadding: 2.0,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'bottomLeft'.i18n,
                    subLabel: vertexFillLabel,
                    keyboardType: TextInputType.number,
                    controller: vertexProvider('bottomLeft'),
                    outPadding: 2.0,
                  ),
                ),
                Expanded(
                  child: CustomTextField(
                    label: 'bottom'.i18n,
                    subLabel: edgeFillLabel,
                    keyboardType: TextInputType.number,
                    controller: edgeProvider('bottom'),
                    outPadding: 2.0,
                  ),
                ),
                Expanded(
                  child: CustomTextField(
                    label: 'bottomRight'.i18n,
                    subLabel: vertexFillLabel,
                    keyboardType: TextInputType.number,
                    controller: vertexProvider('bottomRight'),
                    outPadding: 2.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
