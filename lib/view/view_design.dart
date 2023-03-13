import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/view/preset/view_preset.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../viewModel/vm_design_setting.dart';
import '../viewModel/vm_make_platform.dart';

class ViewDesignSetting extends ConsumerWidget {
  const ViewDesignSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
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
