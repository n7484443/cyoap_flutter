import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/design_setting.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/view/preset/view_preset.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../../model/image_db.dart';
import '../../model/platform.dart';
import '../../viewModel/preset/vm_choice_node_preset.dart';
import '../../viewModel/preset/vm_preset.dart';
import '../../viewModel/vm_choice_node.dart';
import '../../viewModel/vm_design_setting.dart';
import '../util/controller_adjustable_scroll.dart';
import '../util/view_switch_label.dart';
import '../view_choice_node.dart';

class ChoiceNodeSample extends ConsumerWidget {
  const ChoiceNodeSample({super.key});

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
    return Container(
      decoration: BoxDecoration(
        image: background != null
            ? DecorationImage(
                image: Image.memory(ImageDB().getImage(background)!).image,
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
                    .read(choiceNodePresetTestSelectProvider.notifier)
                    .update((state) => !state);
                var pos = Pos(data: [designSamplePosition]);
                ref.invalidate(choiceNodeProvider(pos));
              },
              icon: const Icon(Icons.border_style)),
        ],
      ),
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
                trailing: IconButton(
                  icon: Icon(Icons.delete,
                      size: (IconTheme.of(context).size ?? 18) * 0.8),
                  onPressed: () {
                    ref
                        .read(choiceNodePresetListProvider.notifier)
                        .deleteIndex(index);
                  },
                ),
                onTap: () {
                  ref
                      .read(currentPresetIndexProvider.notifier)
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
                        .read(choiceNodePresetListProvider.notifier)
                        .rename(index, text.trim());
                    var pos = Pos(data: [designSamplePosition]);
                    ref.invalidate(choiceNodeProvider(pos));
                  }
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
    var presetIndex = ref.watch(currentPresetIndexProvider);
    var preset = ref.watch(choiceNodePresetCurrentEditProvider);

    return CustomScrollView(
      controller: AdjustableScrollController(),
      shrinkWrap: true,
      slivers: [
        SliverGrid(
          delegate: SliverChildListDelegate([
            TextFormField(
              textAlign: TextAlign.end,
              minLines: 1,
              maxLines: 1,
              keyboardType: TextInputType.number,
              controller:
                  ref.watch(choiceNodePresetCurrentEditElevationProvider),
              decoration: InputDecoration(labelText: 'height'.i18n),
            ),
            TextFormField(
              textAlign: TextAlign.end,
              minLines: 1,
              maxLines: 1,
              keyboardType: TextInputType.number,
              controller: ref.watch(choiceNodePresetCurrentEditRoundProvider),
              decoration: InputDecoration(labelText: 'round'.i18n),
            ),
            ViewSwitchLabel(
              () => ref.read(choiceNodePresetListProvider.notifier).updateIndex(
                  presetIndex,
                  preset.copyWith(maximizingImage: !preset.maximizingImage)),
              preset.maximizingImage,
              label: 'maximize_image'.i18n,
            ),
            ViewSwitchLabel(
              () => ref.read(choiceNodePresetListProvider.notifier).updateIndex(
                  presetIndex, preset.copyWith(hideTitle: !preset.hideTitle)),
              preset.hideTitle,
              label: 'hide_title'.i18n,
            ),
            ViewSwitchLabel(
              () => ref.read(choiceNodePresetListProvider.notifier).updateIndex(
                  presetIndex,
                  preset.copyWith(titlePosition: !preset.titlePosition)),
              preset.titlePosition,
              label: 'title_up'.i18n,
            ),
            ViewSwitchLabel(
              () => ref.read(choiceNodePresetListProvider.notifier).updateIndex(
                  presetIndex,
                  preset.copyWith(
                      imagePosition: preset.imagePosition == 0 ? 1 : 0)),
              preset.imagePosition != 0,
              label: 'horizontal_mode'.i18n,
            ),
            ViewSwitchLabel(
              () {
                if (preset.imagePosition == 1) {
                  ref.read(choiceNodePresetListProvider.notifier).updateIndex(
                      presetIndex, preset.copyWith(imagePosition: 2));
                } else if (preset.imagePosition == 2) {
                  ref.read(choiceNodePresetListProvider.notifier).updateIndex(
                      presetIndex, preset.copyWith(imagePosition: 1));
                }
              },
              preset.imagePosition == 2,
              disable: preset.imagePosition == 0,
              label: 'image_left'.i18n,
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
              heading: Center(
                child: Text('node_color'.i18n),
              ),
              color: Color(preset.colorNode),
              onColorChanged: (Color value) {
                ref.read(choiceNodePresetListProvider.notifier).updateIndex(
                    presetIndex, preset.copyWith(colorNode: value.value));
              },
              pickersEnabled: {
                ColorPickerType.wheel: true,
                ColorPickerType.accent: false
              },
              pickerTypeLabels: {
                ColorPickerType.primary: "color_select".i18n,
                ColorPickerType.wheel: "color_direct_select".i18n
              },
              width: 22,
              height: 22,
              borderRadius: 22,
            ),
            ColorPicker(
              heading: Center(
                child: Text('node_outline_color'.i18n),
              ),
              color: Color(preset.colorSelectNode),
              onColorChanged: (Color value) {
                ref.read(choiceNodePresetListProvider.notifier).updateIndex(
                    presetIndex, preset.copyWith(colorSelectNode: value.value));
              },
              pickersEnabled: {
                ColorPickerType.wheel: true,
                ColorPickerType.accent: false
              },
              pickerTypeLabels: {
                ColorPickerType.primary: "color_select".i18n,
                ColorPickerType.wheel: "color_direct_select".i18n
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
              decoration: InputDecoration(labelText: 'font_title'.i18n),
              items: ConstList.textFontList.keys
                  .map<DropdownMenuItem<String>>((name) => DropdownMenuItem(
                      value: name,
                      child: Text(name, style: ConstList.getFont(name))))
                  .toList(),
              onChanged: (String? t) {
                if (t != null) {
                  var index = ref.read(currentPresetIndexProvider);
                  ref
                      .read(choiceNodePresetListProvider.notifier)
                      .updateIndex(index, preset.copyWith(titleFont: t));
                }
              },
              value: preset.titleFont,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'font_content'.i18n),
              items: ConstList.textFontList.keys
                  .map<DropdownMenuItem<String>>((name) => DropdownMenuItem(
                      value: name,
                      child: Text(name, style: ConstList.getFont(name))))
                  .toList(),
              onChanged: (String? t) {
                if (t != null) {
                  var index = ref.read(currentPresetIndexProvider);
                  ref
                      .read(choiceNodePresetListProvider.notifier)
                      .updateIndex(index, preset.copyWith(mainFont: t));
                }
              },
              value: preset.mainFont,
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
            decoration: const InputDecoration(labelText: 'Outline Shape'),
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
