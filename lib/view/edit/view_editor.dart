import 'dart:convert';
import 'dart:ui';

import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/view/util/view_color_picker.dart';
import 'package:cyoap_flutter/view/util/view_image_loading.dart';
import 'package:cyoap_flutter/view/util/view_image_selector.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/src/common/utils/color.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../../viewModel/edit/preset/vm_choice_node_preset.dart';
import '../../viewModel/edit/vm_editor.dart';
import '../../viewModel/edit/vm_make_platform.dart';
import '../code/view_ide_node.dart';

class ViewEditor extends ConsumerStatefulWidget {
  const ViewEditor({
    super.key,
  });

  @override
  ConsumerState createState() => _ViewEditorState();
}

class _ViewEditorState extends ConsumerState<ViewEditor> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(nodeEditorTargetPosProvider) == null) {
      return const SizedBox.shrink();
    }
    var children = [
      const ViewContentsEditor(),
      ViewIdeNode(choice: ref.watch(nodeEditorTargetProvider)),
      const ViewNodeOptionEditor(),
      ViewImageDraggable(
        addImageFunction: (ref, name) {
          ref.read(nodeEditorTargetProvider.notifier).setState((node) => node..imageString = name);
        },
        widgetBuilder: (ref, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 3,
                color: index == ref.watch(imageStateProvider) ? Colors.redAccent : Colors.white,
              ),
            ),
            child: GestureDetector(
              child: ViewImageLoading(ref.watch(imageListStateProvider)[index]),
              onDoubleTap: () {
                if (ref
                    .read(imageStateProvider.notifier)
                    .state == index) {
                  ref
                      .read(imageStateProvider.notifier)
                      .state = -1;
                } else {
                  ref
                      .read(imageStateProvider.notifier)
                      .state = index;
                }
              },
            ),
          );
        },
        widgetLength: (ref) =>
        ref
            .watch(imageListStateProvider)
            .length,
        imageName: (ref, index) => ref.watch(imageListStateProvider)[index],
      ),
    ];
    var childrenText = const ["content", "code", "setting", "image"].map((e) => e.i18n);
    return PopScope(
      canPop: false,
      onPopInvoked: (onPopInvoked) {
        ref.read(changeTabProvider.notifier).home(context);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _tabController?.index = 0;
              if (ref
                  .watch(nodeTitleProvider)
                  .isNotEmpty) {
                ref.read(changeTabProvider.notifier).home(context);
              }
            },
          ),
          title: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            }),
            child: SizedBox(
              height: ConstList.appBarSize,
              child: TabBar(
                controller: _tabController,
                labelColor: Theme
                    .of(context)
                    .colorScheme
                    .secondary,
                unselectedLabelColor: Theme
                    .of(context)
                    .colorScheme
                    .primary,
                tabs: childrenText.map((String e) => Tab(text: e)).toList(),
                isScrollable: true,
                physics: const AlwaysScrollableScrollPhysics(),
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: children,
        ),
      ),
    );
  }
}

class ViewContentsEditor extends ConsumerWidget {
  const ViewContentsEditor({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const ViewTitleTextFieldInput(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Visibility(
              visible: ref.watch(nodeEditorTargetProvider).choiceNodeMode != ChoiceNodeMode.onlyCode,
              child: const ViewTextContentsEditor(),
            ),
          ),
        ),
      ],
    );
  }
}

class ViewTitleTextFieldInput extends ConsumerStatefulWidget {
  const ViewTitleTextFieldInput({
    super.key,
  });

  @override
  ConsumerState createState() => _ViewTitleTextFieldInputState();
}

class _ViewTitleTextFieldInputState extends ConsumerState<ViewTitleTextFieldInput> {
  TextEditingController? _controller;

  @override
  void initState() {
    var node = ref.read(nodeEditorTargetProvider);
    _controller = TextEditingController(text: node.title);
    _controller!.addListener(() {
      node.title = _controller!.text;
      ref
          .read(nodeTitleProvider.notifier)
          .state = node.title;
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var design = ref.watch(nodeEditorDesignProvider);
    var preset = ref.watch(choiceNodePresetProvider(design.presetName));
    return TextField(
      controller: _controller,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: 'title'.i18n,
        hintStyle: ConstList.getFont(preset.titleFont!).copyWith(fontSize: 24, color: Colors.red),
        filled: true,
      ),
      style: ConstList.getFont(preset.titleFont!).copyWith(
        fontSize: 24,
      ),
    );
  }
}

class ViewTextContentsEditor extends ConsumerStatefulWidget {
  const ViewTextContentsEditor({
    super.key,
  });

  @override
  ConsumerState createState() => _ViewTextContentsEditorState();
}

final RegExp textFinder = RegExp(r"\{\{.*?\}\}");

class _ViewTextContentsEditorState extends ConsumerState<ViewTextContentsEditor> {
  FocusNode? _focusNode;
  ScrollController? _scrollController;
  QuillController? _quillController;

  @override
  void initState() {
    _focusNode = FocusNode();
    var node = ref.read(nodeEditorTargetProvider);
    if (node.contentsOriginalString.isEmpty) {
      _quillController = QuillController.basic();
    } else {
      _quillController = QuillController(document: Document.fromJson(jsonDecode(node.contentsOriginalString)), selection: const TextSelection.collapsed(offset: 0));
    }
    _quillController?.addListener(() {
      EasyDebounce.debounce('content-editor', ConstList.debounceDuration, () {
        var pos = textFinder.allMatches(_quillController?.document.toPlainText() ?? '');
        if (pos.isNotEmpty) {
          for (var data in pos) {
            final styles = _quillController?.document.collectAllStyles(data.start, data.end - data.start);
            if (styles == null) {
              continue;
            }
            final attrs = <Attribute>{};
            for (final style in styles) {
              for (final attr in style.attributes.values) {
                attrs.add(attr);
              }
            }
            for (final attr in attrs) {
              _quillController?.formatText(data.start, data.end - data.start, Attribute.clone(attr, null));
            }
          }
        }

        ref.read(nodeEditorTargetProvider.notifier).setState((node) => node..contentsString = jsonEncode(_quillController?.document.toDelta().toJson()));
      });
    });
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    EasyDebounce.cancel('content-editor');
    _focusNode?.dispose();
    _scrollController?.dispose();
    _quillController?.dispose();
    super.dispose();
  }

  void changeColor(QuillController controller, Color color, bool background) {
    var hex = color.value.toRadixString(16);
    if (hex.startsWith('ff')) {
      hex = hex.substring(2);
    }
    hex = '#$hex';
    controller.formatSelection(background ? BackgroundAttribute(hex) : ColorAttribute(hex));
    getPlatform.addLastColor(color);
  }

  Style get _selectionStyle => _quillController!.getSelectionStyle();

  Color getColor() {
    if (_selectionStyle.attributes['color'] == null) {
      return Colors.white;
    }
    return stringToColor(_selectionStyle.attributes['color']?.value);
  }

  Color getColorBackground() {
    if (_selectionStyle.attributes['background'] == null) {
      return Colors.white;
    }
    return stringToColor(_selectionStyle.attributes['background']?.value);
  }

  @override
  Widget build(BuildContext context) {
    void colorIconDialog(Color color, bool background) {
      ref
          .read(textColorProvider.notifier)
          .state = color;
      showDialog(
        context: context,
        builder: (context) =>
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? _) =>
                  AlertDialog(
                    backgroundColor: Theme
                        .of(context)
                        .canvasColor,
                    content: SizedBox(
                      width: ConstList.isSmallDisplay(context) ? 400 : 370,
                      child: SingleChildScrollView(
                        child: ViewColorPicker(
                          text: 'Select Color',
                          color: ref.watch(textColorProvider),
                          onColorChanged: (color) {
                            ref
                                .read(textColorProvider.notifier)
                                .state = color;
                          },
                          hasAlpha: true,
                        ),
                      ),
                    ),
                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          changeColor(_quillController!, ref.read(textColorProvider), background);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
            ),
      );
    }

    var design = ref.watch(nodeEditorDesignProvider);
    var preset = ref.watch(choiceNodePresetProvider(design.presetName));

    var fontSize = [10, 11, 12, 14, 16, 18, 21, 24, 36, 48, 60, 72].map((e) => e.toString()).toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: QuillSimpleToolbar(
            controller: _quillController!,
            config: QuillSimpleToolbarConfig(
              showListCheck: false,
              showInlineCode: false,
              showLink: false,
              showCodeBlock: false,
              showHeaderStyle: false,
              showAlignmentButtons: true,
              showColorButton: false,
              showBackgroundColorButton: false,
              showSearchButton: false,
              showSuperscript: true,
              showSubscript: true,
              multiRowsDisplay: true,
              showIndent: true,
              showFontFamily: true,
              buttonOptions: QuillSimpleToolbarButtonOptions(
                fontFamily: QuillToolbarFontFamilyButtonOptions(
                  items: ConstList.textFontList.map((k, v) => MapEntry(k, v.fontFamily!)),
                ),
                fontSize: QuillToolbarFontSizeButtonOptions(
                  items: Map.fromIterables(fontSize, fontSize),
                ),
              ),
              customButtons: [
                QuillToolbarCustomButtonOptions(
                  icon: const Icon(Icons.color_lens),
                  onPressed: () {
                    colorIconDialog(getColor(), false);
                  },
                ),
                QuillToolbarCustomButtonOptions(
                  icon: const Icon(Icons.format_color_fill),
                  onPressed: () {
                    colorIconDialog(getColorBackground(), true);
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Card(
            elevation: ConstList.elevation,
            color: Colors.blue.shade50,
            child: QuillEditor(
              controller: _quillController!,
              config: QuillEditorConfig(
                padding: const EdgeInsets.all(3),
                expands: true,
                scrollable: true,
                autoFocus: true,
                showCursor: true,
                customStyles: ConstList.getDefaultThemeData(context, 1, fontStyle: ConstList.getFontWithColor(preset.mainFont!)),
              ),
              focusNode: _focusNode!,
              scrollController: _scrollController!,
            ),
          ),
        ),
      ],
    );
  }
}

class ImageSourceDialog extends ConsumerStatefulWidget {
  final String name;

  const ImageSourceDialog(this.name, {
    super.key,
  });

  @override
  ConsumerState createState() => _ImageSourceDialogState();
}

class _ImageSourceDialogState extends ConsumerState<ImageSourceDialog> {
  TextEditingController? _sourceController;

  @override
  void initState() {
    _sourceController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _sourceController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('source'.i18n),
      content: TextField(
        controller: _sourceController,
        decoration: InputDecoration(
          hintText: 'source_hint'.i18n,
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, (true, _sourceController?.text ?? ''));
          },
          child: Text('crop'.i18n),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, (false, _sourceController?.text ?? ''));
          },
          child: Text('save'.i18n),
        ),
      ],
    );
  }
}

class ViewNodeOptionEditor extends ConsumerWidget {
  const ViewNodeOptionEditor({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var design = ref.watch(nodeEditorDesignProvider);
    var nodeMode = ref.watch(nodeEditorTargetProvider).choiceNodeMode;
    var nodeOption = ref
        .watch(nodeEditorTargetProvider)
        .choiceNodeOption;
    var left = Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'preset_setting'.i18n),
              items: ref
                  .watch(choiceNodePresetListProvider)
                  .keys
                  .map<DropdownMenuItem<String>>((name) => DropdownMenuItem(value: name, child: Text(name)))
                  .toList(),
              onChanged: (String? t) {
                if (t != null) {
                  ref.read(nodeEditorTargetProvider.notifier).setChoiceNodeOption(nodeOption.copyWith(presetName: t));
                }
              },
              value: design.presetName,
            ),
            DropdownButtonFormField<ChoiceNodeMode>(
              decoration: InputDecoration(labelText: 'node_mode'.i18n),
              items: [
                DropdownMenuItem(value: ChoiceNodeMode.defaultMode, child: Text('default'.i18n)),
                DropdownMenuItem(value: ChoiceNodeMode.randomMode, child: Text('random'.i18n)),
                DropdownMenuItem(value: ChoiceNodeMode.multiSelect, child: Text('multiple'.i18n)),
                DropdownMenuItem(value: ChoiceNodeMode.unSelectableMode, child: Text('unselect'.i18n)),
                DropdownMenuItem(value: ChoiceNodeMode.onlyCode, child: Text('onlyCode'.i18n)),
              ],
              onChanged: (ChoiceNodeMode? value) {
                if (value != null) {
                  ref.read(nodeEditorTargetProvider.notifier).setChoiceMode(value);
                }
              },
              value: ref.watch(nodeEditorTargetProvider).choiceNodeMode,
            ),
          ],
        ),
      ),
    );
    var right = Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          controller: ScrollController(),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: MaximumStateEditor(),
                ),
                if (nodeMode != ChoiceNodeMode.unSelectableMode && nodeMode != ChoiceNodeMode.onlyCode)
                  ViewSwitchLabel(
                        () => ref.read(nodeEditorTargetProvider.notifier).setChoiceNodeOption(nodeOption.copyWith(hideAsResult: !design.hideAsResult, showAsResult: false)),
                    design.hideAsResult,
                    label: 'hide_result'.i18n,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                if (nodeMode == ChoiceNodeMode.unSelectableMode)
                  ViewSwitchLabel(
                        () => ref.read(nodeEditorTargetProvider.notifier).setChoiceNodeOption(nodeOption.copyWith(showAsResult: !design.showAsResult, hideAsResult: false)),
                    design.showAsResult,
                    label: 'show_result'.i18n,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                if (nodeMode == ChoiceNodeMode.unSelectableMode)
                  ViewSwitchLabel(
                        () => ref.read(nodeEditorTargetProvider.notifier).setChoiceNodeOption(nodeOption.copyWith(executeWhenVisible: design.executeWhenVisible)),
                    design.executeWhenVisible,
                    label: 'execute_when_visible'.i18n,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                if (nodeMode == ChoiceNodeMode.multiSelect)
                  ViewSwitchLabel(
                        () => ref.read(nodeEditorTargetProvider.notifier).setChoiceNodeOption(nodeOption.copyWith(showAsSlider: !design.showAsSlider)),
                    design.showAsSlider,
                    label: 'slider_mode'.i18n,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
              ]),
            ),
          ],
        ),
      ),
    );

    if (ConstList.isSmallDisplay(context)) {
      return Column(
        children: [
          Expanded(
            child: left,
          ),
          Expanded(
            child: right,
          ),
        ],
      );
    }
    return Row(children: [
      Expanded(
        child: left,
      ),
      Expanded(
        child: right,
      ),
    ]);
  }
}

class MaximumStateEditor extends ConsumerStatefulWidget {
  const MaximumStateEditor({super.key});

  @override
  ConsumerState createState() => _MaximumStateEditorState();
}

class _MaximumStateEditorState extends ConsumerState<MaximumStateEditor> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: ref.read(nodeEditorTargetProvider).maximumStatus.toString());
    _controller.addListener(() {
      ref.read(nodeEditorTargetProvider.notifier).setState((node) {
        node.maximumStatus = int.tryParse(_controller.text) ?? 0;
        return node;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var title = ref.watch(nodeTitleProvider);
    var nodeMode = ref.watch(nodeEditorTargetProvider).choiceNodeMode;
    return Visibility(
      visible: nodeMode == ChoiceNodeMode.multiSelect || nodeMode == ChoiceNodeMode.randomMode,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${'variable_name'.i18n} \n${title.replaceAll(" ", "")}:${nodeMode == ChoiceNodeMode.multiSelect ? 'multi' : 'random'}', style: Theme
              .of(context)
              .textTheme
              .labelLarge),
          const SizedBox(width: 40),
          SizedBox(
            width: 120,
            child: TextField(
              textAlign: TextAlign.end,
              maxLength: 3,
              minLines: 1,
              maxLines: 1,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
              controller: _controller,
              decoration: InputDecoration(
                label: Text(nodeMode == ChoiceNodeMode.multiSelect ? 'max_select'.i18n : 'max_random'.i18n),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
