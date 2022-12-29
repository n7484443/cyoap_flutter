import 'package:cyoap_core/design_setting.dart';
import 'package:cyoap_flutter/view/preset/view_preset.dart';
import 'package:cyoap_flutter/view/util/controller_adjustable_scroll.dart';
import 'package:cyoap_flutter/view/util/view_image_loading.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../viewModel/vm_design_setting.dart';
import '../viewModel/vm_editor.dart';
import '../viewModel/vm_make_platform.dart';

class ViewDesignSetting extends ConsumerWidget {
  const ViewDesignSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    ViewPresetTab(),
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
