import 'package:cyoap_core/design_setting.dart';
import 'package:cyoap_flutter/i18n.dart';
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
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => ref.read(changeTabProvider.notifier).home(context),
          ),
          title: TabBar(
            labelColor: Theme.of(context).colorScheme.secondary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            tabs: [
              Tab(text: 'general'.i18n),
              Tab(text: 'background'.i18n),
              Tab(text: 'preset'.i18n),
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
                    const ViewGeneralSettingTab(),
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

class ViewGeneralSettingTab extends ConsumerWidget {
  const ViewGeneralSettingTab({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ConstList.isSmallDisplay(context)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ViewFontSelector(
            label: 'font_score'.i18n,
            provider: variableFontProvider,
          ),
          const ViewPositionSetting(),
          ColorPicker(
            heading: Center(
              child: Text('background_color'.i18n),
            ),
            color: ref.watch(backgroundColorProvider),
            onColorChanged: (Color color) {
              ref.read(backgroundColorProvider.notifier).state = color;
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
          )
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              ViewFontSelector(
                label: 'font_score'.i18n,
                provider: variableFontProvider,
              ),
              const ViewPositionSetting(),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: ColorPicker(
            heading: Center(
              child: Text('background_color'.i18n),
            ),
            color: ref.watch(backgroundColorProvider),
            onColorChanged: (Color color) {
              ref.read(backgroundColorProvider.notifier).state = color;
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
        )
      ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text('margin_vertical'.i18n,
              style: Theme.of(context).textTheme.labelLarge),
        ),
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
            decoration: InputDecoration(
              label: Text('${"margin_default".i18n} 12.0'),
            ),
          ),
        ),
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
            decoration: InputDecoration(labelText: 'background_image'.i18n),
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
