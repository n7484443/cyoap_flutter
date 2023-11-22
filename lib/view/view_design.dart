import 'package:cyoap_core/preset/node_preset.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/view/preset/view_preset.dart';
import 'package:cyoap_flutter/view/util/controller_adjustable_scroll.dart';
import 'package:cyoap_flutter/view/util/view_color_picker.dart';
import 'package:easy_debounce/easy_debounce.dart';
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
          title: SizedBox(
            height: ConstList.appBarSize,
            child: TabBar(
              labelColor: Theme.of(context).colorScheme.secondary,
              unselectedLabelColor: Theme.of(context).colorScheme.primary,
              tabs: [
                Tab(text: 'general'.i18n),
                Tab(text: 'preset'.i18n),
              ],
            ),
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

class ViewGeneralSettingTab extends ConsumerStatefulWidget {
  const ViewGeneralSettingTab({super.key});

  @override
  ConsumerState createState() => _ViewGeneralSettingTabState();
}

class _ViewGeneralSettingTabState extends ConsumerState<ViewGeneralSettingTab> {
  AdjustableScrollController scrollController = AdjustableScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var designSetting = ref.watch(platformDesignSettingProvider);
    var fontEditor = ViewFontSelector(
      label: 'font_score'.i18n,
      value: designSetting.variableFont,
      onChange: (String? value) {
        ref.read(platformDesignSettingProvider.notifier).state =
            designSetting.copyWith(variableFont: value!);
      },
    );
    var colorEditor = ViewColorOptionEditor(
      colorOption: designSetting.backgroundColorOption,
      changeFunction: (ColorOption color) {
        ref.read(platformDesignSettingProvider.notifier).state =
            designSetting.copyWith(
          backgroundColorOption: color,
        );
      },
      hasAlpha: false,
    );
    if (ConstList.isSmallDisplay(context)) {
      return ListView(
        controller: scrollController,
        children: [fontEditor, const ViewPositionSetting(), colorEditor],
      );
    }
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverGrid(
          delegate: SliverChildListDelegate([
            fontEditor,
            const ViewPositionSetting(),
          ]),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 60,
            crossAxisSpacing: 40,
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.only(top: 40),
        ),
        SliverToBoxAdapter(
          child: colorEditor,
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
      text: ref.read(platformDesignSettingProvider).marginVertical.toString(),
    );
    _controller?.addListener(() {
      EasyDebounce.debounce('marginController', ConstList.debounceDuration, () {
        ref.read(platformDesignSettingProvider.notifier).state = ref
            .read(platformDesignSettingProvider)
            .copyWith(
                marginVertical:
                    double.tryParse(_controller?.text ?? '') ?? 12.0);
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
  final Function(String?)? onChange;
  final String value;

  const ViewFontSelector({
    required this.label,
    required this.onChange,
    required this.value,
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
      onChanged: onChange,
      value: value,
    );
  }
}
