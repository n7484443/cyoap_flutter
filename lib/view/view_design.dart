import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:cyoap_flutter/view/view_choice_node.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
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
      getPlatform.designSetting =
          getPlatform.designSetting.copyWith(titleFont: next);
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    ref.listen(mainFontProvider, (String? previous, String next) {
      getPlatform.designSetting =
          getPlatform.designSetting.copyWith(mainFont: next);
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    ref.listen(variableFontProvider, (String? previous, String next) {
      getPlatform.designSetting =
          getPlatform.designSetting.copyWith(variableFont: next);
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    ref.listen(titlePositionProvider, (bool? previous, bool next) {
      getPlatform.designSetting =
          getPlatform.designSetting.copyWith(titlePosition: next);
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    ref.listen(titleOverlapProvider, (bool? previous, bool next) {
      getPlatform.designSetting =
          getPlatform.designSetting.copyWith(titleOverlap: next);
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    ref.listen(titleOutlineProvider, (bool? previous, bool next) {
      getPlatform.designSetting =
          getPlatform.designSetting.copyWith(titleOutline: next);
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    ref.listen(colorBackgroundProvider, (previous, Color next) {
      getPlatform.designSetting =
          getPlatform.designSetting.copyWith(colorBackground: next);
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    ref.listen(colorNodeProvider, (previous, Color next) {
      getPlatform.designSetting =
          getPlatform.designSetting.copyWith(colorNode: next);
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    ref.listen(colorOutlineProvider, (previous, Color next) {
      getPlatform.designSetting =
          getPlatform.designSetting.copyWith(colorOutline: next);
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    ref.listen(colorTitleProvider, (previous, Color next) {
      getPlatform.designSetting =
          getPlatform.designSetting.copyWith(colorTitle: next);
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
                        ViewFontSelector(
                          label: '제목 폰트',
                          provider: titleFontProvider,
                        ),
                        ViewFontSelector(
                          label: '내용 폰트',
                          provider: mainFontProvider,
                        ),
                        ViewFontSelector(
                          label: '점수 폰트',
                          provider: variableFontProvider,
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

class ViewFontSelector extends ConsumerWidget {
  final String label;
  final AutoDisposeStateProvider<String> provider;

  const ViewFontSelector({
    required this.label,
    required this.provider,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      items: ConstList.textFontList.keys
          .map<DropdownMenuItem<String>>((name) => DropdownMenuItem(
              value: name, child: Text(name, style: ConstList.getFont(name))))
          .toList(),
      onChanged: (String? t) {
        if (t != null) {
          ref.read(provider.notifier).update((state) => t);
        }
      },
      value: ref.watch(provider),
    );
  }
}

class ViewColorSelect extends ConsumerWidget {
  final textList = const [
    "배경",
    "선택지",
    "외곽선",
    "제목",
  ];
  final providerList = [
    colorBackgroundProvider,
    colorNodeProvider,
    colorOutlineProvider,
    colorTitleProvider,
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
          child: SizedBox(
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List<Widget>.generate(
                textList.length,
                (index) => ChoiceChip(
                    label: Text(textList[index]),
                    selected: ref.watch(colorSelectProvider) == index,
                    onSelected: (value) =>
                        ref.read(colorSelectProvider.notifier).state = index),
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              ColorPicker(
                color: ref.watch(providerList[check]),
                onColorChanged: (Color value) => ref
                    .read(providerList[check].notifier)
                    .update((state) => value),
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
