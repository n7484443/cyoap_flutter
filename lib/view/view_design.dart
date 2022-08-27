import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:cyoap_flutter/view/view_choice_node.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../model/choiceNode/pos.dart';
import '../model/platform_system.dart';
import '../viewModel/vm_choice_node.dart';
import '../viewModel/vm_design_setting.dart';
import '../viewModel/vm_draggable_nested_map.dart';
import '../viewModel/vm_make_platform.dart';

class ViewDesignSetting extends ConsumerWidget {
  const ViewDesignSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(titleFontProvider, (String? previous, String next) {
      getPlatform.designSetting.titleFont = next;
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    ref.listen(mainFontProvider, (String? previous, String next) {
      getPlatform.designSetting.mainFont = next;
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    ref.listen(titlePositionProvider, (bool? previous, bool next) {
      getPlatform.designSetting.titlePosition = next;
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    ref.listen(titleOverlapProvider, (bool? previous, bool next) {
      getPlatform.designSetting.titleOverlap = next;
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    ref.listen(titleOutlineProvider, (bool? previous, bool next) {
      getPlatform.designSetting.titleOutline = next;
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    ref.listen(colorBackgroundProvider, (previous, Color next) {
      getPlatform.designSetting.colorBackground = next;
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    ref.listen(colorNodeProvider, (previous, Color next) {
      getPlatform.designSetting.colorNode = next;
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    ref.listen(colorOutlineProvider, (previous, Color next) {
      getPlatform.designSetting.colorOutline = next;
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => ref.read(changeTabProvider.notifier).back(context),
          ),
          title: TabBar(
            labelColor: Theme.of(context).colorScheme.secondary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            tabs: [
              const Tab(text: '색상'),
              const Tab(text: '위치'),
              const Tab(text: '폰트'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(ConstList.padding),
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: ViewColorSelect(),
                    ),
                    Column(
                      children: [
                        ViewSwitchLabel(
                          label: "제목을 이미지 위에 겹치기",
                          () => ref
                              .read(titleOverlapProvider.notifier)
                              .update((state) => !state),
                          ref.watch(titleOverlapProvider),
                        ),
                        ViewSwitchLabel(
                          label: "제목을 위로",
                          () => ref
                              .read(titlePositionProvider.notifier)
                              .update((state) => !state),
                          ref.watch(titlePositionProvider),
                        ),
                        ViewSwitchLabel(
                          label: "제목 테두리",
                          () => ref
                              .read(titleOutlineProvider.notifier)
                              .update((state) => !state),
                          ref.watch(titleOutlineProvider),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(labelText: '제목 폰트'),
                          items: ConstList.textFontList.keys
                              .map<DropdownMenuItem<String>>((name) =>
                                  DropdownMenuItem(
                                      value: name,
                                      child: Text(name,
                                          style: ConstList.getFont(name))))
                              .toList(),
                          onChanged: (String? t) {
                            if (t != null) {
                              ref
                                  .read(titleFontProvider.notifier)
                                  .update((state) => t);
                            }
                          },
                          value: ref.watch(titleFontProvider),
                        ),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(labelText: '내용 폰트'),
                          items: ConstList.textFontList.keys
                              .map<DropdownMenuItem<String>>((name) =>
                                  DropdownMenuItem(
                                      value: name,
                                      child: Text(name,
                                          style: ConstList.getFont(name))))
                              .toList(),
                          onChanged: (String? t) {
                            if (t != null) {
                              ref
                                  .read(mainFontProvider.notifier)
                                  .update((state) => t);
                            }
                          },
                          value: ref.watch(mainFontProvider),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: ColoredBox(
                    color: ref.watch(colorBackgroundProvider),
                    child: Padding(
                      padding: const EdgeInsets.all(ConstList.padding),
                      child: IgnorePointer(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: ViewChoiceNode(
                                Pos(data: [designSamplePosition0]),
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 3,
                              child: ViewChoiceNode(
                                Pos(data: [designSamplePosition1]),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ViewColorSelect extends ConsumerWidget {
  final textList = const [
    "배경",
    "선택지",
    "외곽선",
  ];
  final providerList = [
    colorBackgroundProvider,
    colorNodeProvider,
    colorOutlineProvider,
  ];

  ViewColorSelect({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var check = ref.watch(colorSelectProvider);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ToggleButtons(
                direction: Axis.vertical,
                onPressed: (index) =>
                    ref.read(colorSelectProvider.notifier).state = index,
                isSelected: List.generate(textList.length,
                    (index) => ref.watch(colorSelectProvider) == index),
                children: List.generate(
                    textList.length, (index) => Text(textList[index])),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              ColorPicker(
                color: ref.watch(providerList[check]),
                onColorChanged: (Color value) =>
                    ref.read(providerList[check].notifier).update((state) => value),
                pickersEnabled: {
                  ColorPickerType.wheel: true,
                  ColorPickerType.accent: false
                },
                pickerTypeLabels: {
                  ColorPickerType.primary: "색상 선택",
                  ColorPickerType.wheel: "직접 선택"
                },
                width: 22,
                height: 22,
                borderRadius: 22,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
