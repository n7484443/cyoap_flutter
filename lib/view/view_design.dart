import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/design_setting.dart';
import 'package:cyoap_core/playable_platform.dart';
import 'package:cyoap_flutter/view/util/view_image_loading.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:cyoap_flutter/view/view_choice_node.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../model/image_db.dart';
import '../model/platform_system.dart';
import '../viewModel/vm_design_setting.dart';
import '../viewModel/vm_draggable_nested_map.dart';
import '../viewModel/vm_editor.dart';
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
    ref.listen(titleOutlineProvider, (bool? previous, bool next) {
      getPlatform.designSetting =
          getPlatform.designSetting.copyWith(titleOutline: next);
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    ref.listen(colorBackgroundProvider, (previous, Color next) {
      getPlatform.designSetting =
          getPlatform.designSetting.copyWith(colorBackground: next.value);
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    ref.listen(colorNodeProvider, (previous, Color next) {
      getPlatform.designSetting =
          getPlatform.designSetting.copyWith(colorNode: next.value);
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    ref.listen(colorOutlineProvider, (previous, Color next) {
      getPlatform.designSetting =
          getPlatform.designSetting.copyWith(colorOutline: next.value);
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    ref.listen(colorTitleProvider, (previous, Color next) {
      getPlatform.designSetting =
          getPlatform.designSetting.copyWith(colorTitle: next.value);
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });

    ref.listen<String?>(backgroundProvider, (previous, String? next) {
      getPlatform.designSetting =
          getPlatform.designSetting.copyWith(backgroundImage: next);
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    ref.listen(backgroundAttributeProvider, (previous, ImageAttribute next) {
      getPlatform.designSetting =
          getPlatform.designSetting.copyWith(backgroundAttribute: next);
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });

    var background = ref.watch(backgroundProvider);
    var backgroundAttribute = ref.watch(backgroundAttributeProvider);

    BoxFit backgroundBoxFit = BoxFit.contain;
    ImageRepeat backgroundRepeat = ImageRepeat.noRepeat;
    switch (backgroundAttribute) {
      case ImageAttribute.fill:
        backgroundBoxFit = BoxFit.cover;
        break;
      case ImageAttribute.fit:
        backgroundBoxFit = BoxFit.contain;
        break;
      case ImageAttribute.pattern:
        backgroundBoxFit = BoxFit.contain;
        backgroundRepeat = ImageRepeat.repeat;
        break;
      case ImageAttribute.stretch:
        backgroundBoxFit = BoxFit.fill;
        break;
    }

    return DefaultTabController(
      length: 4,
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
              const Tab(text: '배경'),
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
                    const ViewColorSelect(),
                    Column(
                      children: [
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
                    const ViewBackgroundSetting(),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: ref.watch(colorBackgroundProvider),
                  image: background != null
                      ? DecorationImage(
                          image: Image.memory(ImageDB().getImage(background)!)
                              .image,
                          fit: backgroundBoxFit,
                          repeat: backgroundRepeat,
                        )
                      : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: ConstList.padding, vertical: 50),
                  child: IgnorePointer(
                    child: Row(
                      children: [
                        Expanded(
                          child: ViewChoiceNode(
                            Pos(data: [designSamplePosition0]),
                          ),
                        ),
                        Expanded(
                          child: ViewChoiceNode(
                            Pos(data: [designSamplePosition1]),
                          ),
                        )
                      ],
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

class ViewColorSelect extends ConsumerStatefulWidget {
  const ViewColorSelect({
    super.key,
  });

  @override
  ConsumerState createState() => _ViewColorSelectState();
}

class _ViewColorSelectState extends ConsumerState<ViewColorSelect> {
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
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var check = ref.watch(colorSelectProvider);
    return SingleChildScrollView(
      controller: _scrollController,
      child: Row(
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
      ),
    );
  }
}

class ViewBackgroundSetting extends ConsumerStatefulWidget {
  const ViewBackgroundSetting({
    super.key,
  });

  @override
  ConsumerState createState() => _ViewBackgroundSettingState();
}

class _ViewBackgroundSettingState extends ConsumerState<ViewBackgroundSetting> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var widget = ImageAttribute.values
        .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
        .toList();
    var background = ref.watch(backgroundProvider);
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: DropdownButtonFormField<ImageAttribute>(
            decoration: const InputDecoration(labelText: '배경 이미지'),
            items: widget,
            onChanged: (ImageAttribute? t) {
              if (t != null) {
                ref
                    .read(backgroundAttributeProvider.notifier)
                    .update((state) => t);
              }
            },
            value: ref.watch(backgroundAttributeProvider),
          ),
        ),
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 3,
                    color: index == ref.watch(backgroundCurrentStateProvider)
                        ? Colors.redAccent
                        : Colors.white,
                  ),
                ),
                child: GestureDetector(
                  child: ViewImageLoading(
                      ref.watch(imageListStateProvider)[index]),
                  onDoubleTap: () {
                    if (ref
                            .read(backgroundCurrentStateProvider.notifier)
                            .state ==
                        index) {
                      ref.read(backgroundCurrentStateProvider.notifier).state =
                          -1;
                      ref.read(backgroundProvider.notifier).state = null;
                    } else {
                      ref.read(backgroundCurrentStateProvider.notifier).state =
                          index;
                      ref.read(backgroundProvider.notifier).state =
                          ref.read(imageListStateProvider)[index];
                    }
                    ref.read(editorChangeProvider.notifier).needUpdate();
                  },
                ),
              );
            },
            childCount: ref.watch(imageListStateProvider).length,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ConstList.isSmallDisplay(context) ? 2 : 4,
            crossAxisSpacing: 3.0,
            mainAxisSpacing: 3.0,
          ),
        ),
        if (background != null)
          SliverToBoxAdapter(child: ViewImageLoading(background)),
      ],
    );
  }
}
