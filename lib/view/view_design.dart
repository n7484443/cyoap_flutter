import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/design_setting.dart';
import 'package:cyoap_flutter/view/util/controller_adjustable_scroll.dart';
import 'package:cyoap_flutter/view/util/view_image_loading.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:cyoap_flutter/view/view_choice_node.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../model/image_db.dart';
import '../model/platform.dart';
import '../model/platform_system.dart';
import '../viewModel/vm_choice_node.dart' show choiceNodeProvider;
import '../viewModel/vm_design_setting.dart';
import '../viewModel/vm_draggable_nested_map.dart';
import '../viewModel/vm_editor.dart';
import '../viewModel/vm_make_platform.dart';

class ViewDesignSetting extends ConsumerWidget {
  const ViewDesignSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(variableFontProvider, (String? previous, String next) {
      getPlatform.designSetting =
          getPlatform.designSetting.copyWith(variableFont: next);
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });
    ref.listen(colorBackgroundProvider, (previous, Color next) {
      getPlatform.designSetting =
          getPlatform.designSetting.copyWith(colorBackground: next.value);
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

    ref.listen(marginVerticalProvider, (previous, double next) {
      getPlatform.designSetting =
          getPlatform.designSetting.copyWith(marginVertical: next);
      ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    });

    return DefaultTabController(
      length: 5,
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
              const Tab(text: '프리셋'),
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
                    const ViewPositionSetting(),
                    ViewFontSelector(
                      label: '점수 폰트',
                      provider: variableFontProvider,
                    ),
                    const ViewBackgroundSetting(),
                    const ViewPresetTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ViewPositionSetting extends ConsumerStatefulWidget {
  const ViewPositionSetting({
    super.key,
  });

  @override
  ConsumerState createState() => _ViewPositionSettingState();
}

class _ViewPositionSettingState extends ConsumerState<ViewPositionSetting> {
  TextEditingController? _controller;

  @override
  void initState() {
    _controller = TextEditingController(
      text: ref.read(marginVerticalProvider).toString(),
    );
    _controller?.addListener(() {
      EasyDebounce.debounce(
          'marginController', const Duration(milliseconds: 500), () {
        ref.read(marginVerticalProvider.notifier).state =
            double.tryParse(_controller?.text ?? '') ?? 12.0;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    EasyDebounce.cancel('marginController');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('선택지 간 세로 여백', style: Theme.of(context).textTheme.labelLarge),
            SizedBox(
              width: 100,
              child: TextField(
                textAlign: TextAlign.end,
                maxLength: 4,
                minLines: 1,
                maxLines: 1,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: false),
                controller: _controller,
                decoration: const InputDecoration(
                  label: Text('기본 값 12.0'),
                ),
              ),
            ),
          ],
        )
      ],
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
  ];
  final providerList = [
    colorBackgroundProvider,
  ];
  final ScrollController _scrollController = AdjustableScrollController();

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
                  (index) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ChoiceChip(
                        label: Text(textList[index]),
                        selected: ref.watch(colorSelectProvider) == index,
                        onSelected: (value) => ref
                            .read(colorSelectProvider.notifier)
                            .state = index),
                  ),
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
  final ScrollController _scrollController = AdjustableScrollController();

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
      ],
    );
  }
}

class ViewPresetTab extends ConsumerWidget {
  const ViewPresetTab({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    if (ConstList.isSmallDisplay(context)) {
      return CustomScrollView(
        controller: AdjustableScrollController(),
        slivers: [
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            delegate: SliverChildListDelegate([
              const ListTile(
                title: Text('선택지'),
                selected: true,
              ),
              const PresetList(),
            ]),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: ref.watch(colorBackgroundProvider),
                image: background != null
                    ? DecorationImage(
                        image:
                            Image.memory(ImageDB().getImage(background)!).image,
                        fit: backgroundBoxFit,
                        repeat: backgroundRepeat,
                        filterQuality: FilterQuality.high,
                      )
                    : null,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: IgnorePointer(
                      child: ViewChoiceNode(
                        Pos(data: [designSamplePosition]),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        ref
                            .read(presetTestSelectProvider.notifier)
                            .update((state) => !state);
                        var pos = Pos(data: [designSamplePosition]);
                        ref.invalidate(choiceNodeProvider(pos));
                      },
                      icon: const Icon(Icons.border_style)),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: ViewNodeOptionEditor(),
          )
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(children: [
            Expanded(
              child: ListView(
                controller: AdjustableScrollController(),
                children: [
                  const ListTile(
                    title: Text('선택지'),
                    selected: true,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: ref.watch(colorBackgroundProvider),
                  image: background != null
                      ? DecorationImage(
                    image:
                    Image.memory(ImageDB().getImage(background)!).image,
                    fit: backgroundBoxFit,
                    repeat: backgroundRepeat,
                    filterQuality: FilterQuality.high,
                  )
                      : null,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: IgnorePointer(
                        child: ViewChoiceNode(
                          Pos(data: [designSamplePosition]),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          ref
                              .read(presetTestSelectProvider.notifier)
                              .update((state) => !state);
                          var pos = Pos(data: [designSamplePosition]);
                          ref.invalidate(choiceNodeProvider(pos));
                        },
                        icon: const Icon(Icons.border_style)),
                  ],
                ),
              ),
            )
          ]),
        ),
        const Expanded(
          child: PresetList(),
        ),
        const Expanded(flex: 4, child: ViewNodeOptionEditor()),
      ],
    );
  }
}

class PresetList extends ConsumerWidget {
  const PresetList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var list = ref.watch(presetListProvider);
    return Column(
      children: [
        ListTile(
          title: const Text('프리셋'),
          trailing: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ref.read(presetListProvider.notifier).create();
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
                    ref.read(presetListProvider.notifier).deleteIndex(index);
                  },
                ),
                onTap: () {
                  ref
                      .read(presetCurrentEditIndexProvider.notifier)
                      .update((state) => index);
                  var pos = Pos(data: [designSamplePosition]);
                  ref.invalidate(choiceNodeProvider(pos));
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
                        .read(presetListProvider.notifier)
                        .rename(index, text.trim());
                    var pos = Pos(data: [designSamplePosition]);
                    ref.invalidate(choiceNodeProvider(pos));
                  }
                },
                selected: index == ref.watch(presetCurrentEditIndexProvider),
              );
            },
          ),
        ),
      ],
    );
  }
}

class PresetRenameDialog extends ConsumerStatefulWidget {
  final String name;

  const PresetRenameDialog(
    this.name, {
    super.key,
  });

  @override
  ConsumerState createState() => _PresetRenameDialogState();
}

class _PresetRenameDialogState extends ConsumerState<PresetRenameDialog> {
  TextEditingController? controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.name);
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        controller: controller,
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('취소')),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(controller?.text);
            },
            child: const Text('저장')),
      ],
    );
  }
}

class ViewTextFieldInput extends ConsumerStatefulWidget {
  final String text;
  final AutoDisposeProvider<double> provider;
  final void Function(String) inputFunction;

  const ViewTextFieldInput(
    this.text,
    this.provider,
    this.inputFunction, {
    super.key,
  });

  @override
  ConsumerState createState() => _ViewTextFieldInputState();
}

class _ViewTextFieldInputState extends ConsumerState<ViewTextFieldInput> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller?.addListener(() {
      EasyDebounce.debounce(widget.text, const Duration(milliseconds: 500), () {
        widget.inputFunction(_controller?.text ?? '');
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.end,
      maxLength: 3,
      minLines: 1,
      maxLines: 1,
      keyboardType: TextInputType.number,
      controller: _controller,
      decoration: InputDecoration(labelText: widget.text),
    );
  }
}

class ViewNodeOptionEditor extends ConsumerWidget {
  const ViewNodeOptionEditor({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var presetIndex = ref.watch(presetCurrentEditIndexProvider);
    var preset = ref.watch(presetCurrentEditProvider);

    return CustomScrollView(
      controller: ScrollController(),
      shrinkWrap: true,
      slivers: [
        SliverGrid(
          delegate: SliverChildListDelegate([
            TextFormField(
              textAlign: TextAlign.end,
              minLines: 1,
              maxLines: 1,
              keyboardType: TextInputType.number,
              controller: ref.watch(presetCurrentEditElevationProvider),
              decoration: const InputDecoration(labelText: '높이'),
            ),
            TextFormField(
              textAlign: TextAlign.end,
              minLines: 1,
              maxLines: 1,
              keyboardType: TextInputType.number,
              controller: ref.watch(presetCurrentEditRoundProvider),
              decoration: const InputDecoration(labelText: '모서리 라운드'),
            ),
            ViewSwitchLabel(
              () => ref.read(presetListProvider.notifier).updateIndex(
                  presetIndex,
                  preset.copyWith(maximizingImage: !preset.maximizingImage)),
              preset.maximizingImage,
              label: '이미지 최대화',
            ),
            ViewSwitchLabel(
              () => ref.read(presetListProvider.notifier).updateIndex(
                  presetIndex, preset.copyWith(hideTitle: !preset.hideTitle)),
              preset.hideTitle,
              label: '제목 숨기기',
            ),
            ViewSwitchLabel(
              () => ref.read(presetListProvider.notifier).updateIndex(
                  presetIndex,
                  preset.copyWith(titlePosition: !preset.titlePosition)),
              preset.titlePosition,
              label: '제목을 위로',
            ),
            ViewSwitchLabel(
              () => ref.read(presetListProvider.notifier).updateIndex(
                  presetIndex,
                  preset.copyWith(
                      imagePosition: preset.imagePosition == 0 ? 1 : 0)),
              preset.imagePosition != 0,
              label: '가로 모드',
            ),
            ViewSwitchLabel(
              () {
                if (preset.imagePosition == 1) {
                  ref.read(presetListProvider.notifier).updateIndex(
                      presetIndex, preset.copyWith(imagePosition: 2));
                } else if (preset.imagePosition == 2) {
                  ref.read(presetListProvider.notifier).updateIndex(
                      presetIndex, preset.copyWith(imagePosition: 1));
                }
              },
              preset.imagePosition == 2,
              disable: preset.imagePosition == 0,
              label: '이미지 왼쪽으로',
            ),
          ]),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ConstList.isSmallDisplay(context) ? 2 : 4,
            crossAxisSpacing: 2,
            mainAxisExtent: 80,
            mainAxisSpacing: 2,
          ),
        ),
        const SliverToBoxAdapter(
          child: Divider(),
        ),
        SliverGrid(
          delegate: SliverChildListDelegate([
            ColorPicker(
              heading: const Center(
                child: Text('선택지 색상'),
              ),
              color: Color(preset.colorNode),
              onColorChanged: (Color value) {
                ref.read(presetListProvider.notifier).updateIndex(
                    presetIndex, preset.copyWith(colorNode: value.value));
              },
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
            ColorPicker(
              heading: const Center(
                child: Text('외곽선 색상'),
              ),
              color: Color(preset.colorSelectNode),
              onColorChanged: (Color value) {
                ref.read(presetListProvider.notifier).updateIndex(
                    presetIndex, preset.copyWith(colorSelectNode: value.value));
              },
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
          ]),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ConstList.isSmallDisplay(context) ? 1 : 2,
            crossAxisSpacing: 2,
            mainAxisExtent: 380,
            mainAxisSpacing: 2,
          ),
        ),
        SliverGrid(
          delegate: SliverChildListDelegate([
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: '제목 폰트'),
              items: ConstList.textFontList.keys
                  .map<DropdownMenuItem<String>>((name) => DropdownMenuItem(
                      value: name,
                      child: Text(name, style: ConstList.getFont(name))))
                  .toList(),
              onChanged: (String? t) {
                if (t != null) {
                  var index = ref.read(presetCurrentEditIndexProvider);
                  ref
                      .read(presetListProvider.notifier)
                      .updateIndex(index, preset.copyWith(titleFont: t));
                }
              },
              value: preset.titleFont,
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: '내용 폰트'),
              items: ConstList.textFontList.keys
                  .map<DropdownMenuItem<String>>((name) => DropdownMenuItem(
                      value: name,
                      child: Text(name, style: ConstList.getFont(name))))
                  .toList(),
              onChanged: (String? t) {
                if (t != null) {
                  var index = ref.read(presetCurrentEditIndexProvider);
                  ref
                      .read(presetListProvider.notifier)
                      .updateIndex(index, preset.copyWith(mainFont: t));
                }
              },
              value: preset.titleFont,
            ),
          ]),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ConstList.isSmallDisplay(context) ? 1 : 2,
            crossAxisSpacing: 2,
            mainAxisExtent: 60,
            mainAxisSpacing: 2,
          ),
        ),
        /*SliverToBoxAdapter(
          child: DropdownButtonFormField<Outline>(
            decoration: const InputDecoration(labelText: '외곽선 형태'),
            items: Outline.values
                .map<DropdownMenuItem<Outline>>((type) =>
                    DropdownMenuItem(value: type, child: Text(type.name)))
                .toList(),
            onChanged: (Outline? t) {
              if (t != null) {
                var index = ref.read(presetCurrentEditIndexProvider);
                ref
                    .read(presetListProvider.notifier)
                    .updateIndex(index, preset.copyWith(outline: t));
              }
            },
            value: preset.outline,
          ),
        )*/
      ],
    );
  }
}
