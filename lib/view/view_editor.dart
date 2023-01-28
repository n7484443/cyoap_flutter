import 'dart:convert';
import 'dart:ui';

import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/grammar/function_list.dart';
import 'package:cyoap_flutter/model/image_db.dart';
import 'package:cyoap_flutter/view/util/controller_adjustable_scroll.dart';
import 'package:cyoap_flutter/view/util/view_image_loading.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import '../main.dart';
import '../model/platform_system.dart';
import '../viewModel/preset/vm_choice_node_preset.dart';
import '../viewModel/vm_editor.dart';
import '../viewModel/vm_image_editor.dart';
import '../viewModel/vm_make_platform.dart';

class ViewEditor extends ConsumerWidget {
  const ViewEditor({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(nodeEditorTargetPosProvider) == null) {
      return const SizedBox.shrink();
    }
    var children = [
      const ViewContentsEditor(),
      const ViewCodeIde(),
      const ViewNodeOptionEditor(),
      const ViewImageDraggable()
    ];
    var childrenText = const ["Content", "Code", "Setting", "Image"];
    return WillPopScope(
      child: DefaultTabController(
        length: children.length,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (ref.watch(nodeTitleProvider).isNotEmpty) {
                  ref.read(changeTabProvider.notifier).back(context);
                }
                DefaultTabController.of(context)?.index = 0;
              },
            ),
            title: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              }),
              child: TabBar(
                labelColor: Theme.of(context).colorScheme.secondary,
                unselectedLabelColor: Theme.of(context).colorScheme.primary,
                tabs: childrenText.map((String e) => Tab(text: e)).toList(),
                isScrollable: true,
                physics: const AlwaysScrollableScrollPhysics(),
              ),
            ),
            actions: ConstList.isMobile()
                ? [
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () {
                        ref.read(editorChangeProvider.notifier).save();
                      },
                    ),
                  ]
                : null,
          ),
          body: TabBarView(
            children: children,
          ),
        ),
      ),
      onWillPop: () async {
        ref.read(changeTabProvider.notifier).back(context);
        return false;
      },
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
              visible: ref.watch(nodeModeProvider) != ChoiceNodeMode.onlyCode,
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

class _ViewTitleTextFieldInputState
    extends ConsumerState<ViewTitleTextFieldInput> {
  TextEditingController? _controller;

  @override
  void initState() {
    var node = ref.read(nodeEditorTargetProvider).node;
    _controller = TextEditingController(text: node.title);
    _controller!.addListener(() {
      node.title = _controller!.text;
      ref.read(nodeTitleProvider.notifier).state = node.title;
      ref.read(editorChangeProvider.notifier).needUpdate();
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
        hintText: 'Title',
        hintStyle: ConstList.getFont(preset.titleFont)
            .copyWith(fontSize: 24, color: Colors.red),
        filled: true,
      ),
      style: ConstList.getFont(preset.titleFont).copyWith(
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

class _ViewTextContentsEditorState
    extends ConsumerState<ViewTextContentsEditor> {
  FocusNode? _focusNode;
  ScrollController? _scrollController;
  QuillController? _quillController;

  @override
  void initState() {
    _focusNode = FocusNode();
    var node = ref.read(nodeEditorTargetProvider).node;
    if (node.contentsString.isEmpty) {
      _quillController = QuillController.basic();
    } else {
      _quillController = QuillController(
          document: Document.fromJson(jsonDecode(node.contentsString)),
          selection: const TextSelection.collapsed(offset: 0));
    }
    _quillController?.addListener(() {
      EasyDebounce.debounce('content-editor', const Duration(milliseconds: 500),
          () {
        ref.read(nodeEditorTargetProvider).node.contentsString =
            jsonEncode(_quillController?.document.toDelta().toJson());
        ref.read(editorChangeProvider.notifier).needUpdate();
      });
    });
    _scrollController = AdjustableScrollController();
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

  @override
  Widget build(BuildContext context) {
    void changeColor(QuillController controller, Color color, bool background) {
      var hex = color.value.toRadixString(16);
      if (hex.startsWith('ff')) {
        hex = hex.substring(2);
      }
      hex = '#$hex';
      controller.formatSelection(
          background ? BackgroundAttribute(hex) : ColorAttribute(hex));
    }

    void colorIconDialog(bool background) {
      Color newColor = const Color(0x00000000);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Select Color'),
          backgroundColor: Theme.of(context).canvasColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ColorPicker(
                pickersEnabled: {
                  ColorPickerType.both: true,
                  ColorPickerType.primary: false,
                  ColorPickerType.accent: false
                },
                color: const Color(0x00000000),
                onColorChanged: (color) {
                  newColor = color;
                },
              ),
            ],
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
                changeColor(_quillController!, newColor, background);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }

    var design = ref.watch(nodeEditorDesignProvider);
    var preset = ref.watch(choiceNodePresetProvider(design.presetName));
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: QuillToolbar.basic(
            controller: _quillController!,
            showListCheck: false,
            showInlineCode: false,
            showLink: false,
            showCodeBlock: false,
            showHeaderStyle: false,
            showAlignmentButtons: true,
            showColorButton: false,
            showBackgroundColorButton: false,
            showFontFamily: false,
            showSearchButton: false,
            showIndent: false,
            customButtons: [
              QuillCustomButton(
                icon: Icons.color_lens,
                onTap: () {
                  colorIconDialog(false);
                },
              ),
              QuillCustomButton(
                icon: Icons.format_color_fill,
                onTap: () {
                  colorIconDialog(true);
                },
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Card(
            elevation: ConstList.elevation,
            child: QuillEditor(
              padding: const EdgeInsets.all(3),
              controller: _quillController!,
              focusNode: _focusNode!,
              expands: true,
              scrollable: true,
              autoFocus: true,
              readOnly: false,
              showCursor: true,
              scrollController: _scrollController!,
              customStyles: ConstList.getDefaultThemeData(context, 1,
                  fontStyle: ConstList.getFont(preset.mainFont)),
            ),
          ),
        ),
      ],
    );
  }
}

class ImageSourceDialog extends ConsumerStatefulWidget {
  final String name;

  const ImageSourceDialog(
    this.name, {
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
      title: const Text('Sources'),
      content: TextField(
        controller: _sourceController,
        decoration: const InputDecoration(
          hintText: 'If you dont know or dont have a source, leave it blank.',
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, Tuple2(true, _sourceController?.text ?? ''));
          },
          child: const Text('Crop'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, Tuple2(false, _sourceController?.text ?? ''));
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class ViewCodeIde extends ConsumerStatefulWidget {
  const ViewCodeIde({
    super.key,
  });

  @override
  ConsumerState createState() => _ViewCodeIdeState();
}

class _ViewCodeIdeState extends ConsumerState<ViewCodeIde> {
  FocusNode? _focusNode;
  QuillController? _quillController;
  ScrollController? _scrollController;

  final regexSpace =
      RegExp(r"(\b|}|\))(if|for|else|in|break|continue)(\b|{|\()");
  final regexBrace = RegExp(r"[{}()]");
  final regexComment = RegExp(r"//.*");
  final regexFunction = RegExp("(${
        FunctionListEnum.values
            .where((e) => e.displayWithColor)
            .map((e) => e.functionName ?? e.name)
            .join('|')
      })"r"\(");

  @override
  void initState() {
    _focusNode = FocusNode();
    var data = [
      {
        "insert":
            "${ref.read(nodeEditorTargetProvider).node.recursiveStatus.executeCodeString ?? ''}\n"
      }
    ];
    _quillController = QuillController(
        document: Document.fromJson(data),
        selection: const TextSelection.collapsed(offset: 0));
    _quillController?.addListener(() {
      EasyDebounce.debounce('code-ide', const Duration(milliseconds: 500), () {
        var plainText = _quillController?.document.toPlainText() ?? '';
        if (ref
                .read(nodeEditorTargetProvider)
                .node
                .recursiveStatus
                .executeCodeString !=
            plainText) {
          var styleNull = Attribute.color;
          var styleDeepOrange =
              ColorAttribute('#${Colors.deepOrangeAccent.hex}');
          var styleDeepPurple =
          ColorAttribute('#${Colors.deepPurple.hex}');
          var styleGrey = ColorAttribute('#${Colors.grey.hex}');

          _quillController?.formatText(0, plainText.length, styleNull);
          var match = regexSpace.allMatches(plainText);
          for (var m in match) {
            _quillController?.formatText(
                m.start, m.end - m.start, styleDeepOrange);
          }

          match = regexFunction.allMatches(plainText);
          for (var m in match) {
            _quillController?.formatText(m.start, m.end - m.start, styleDeepPurple);
          }

          match = regexBrace.allMatches(plainText);
          for (var m in match) {
            _quillController?.formatText(m.start, m.end - m.start, styleNull);
          }

          match = regexComment.allMatches(plainText);
          for (var m in match) {
            _quillController?.formatText(m.start, m.end - m.start, styleGrey);
          }


          ref
              .read(nodeEditorTargetProvider)
              .node
              .recursiveStatus
              .executeCodeString = plainText;
          ref.read(editorChangeProvider.notifier).needUpdate();
        }
      });
    });
    _scrollController = AdjustableScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _quillController?.dispose();
    _scrollController?.dispose();
    EasyDebounce.cancel('code-ide');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var design = ref.watch(nodeEditorDesignProvider);
    return Row(
      children: [
        Expanded(
          child: ListView(
            controller: _scrollController,
            children: [
              Visibility(
                visible:
                    ref.watch(nodeEditorTargetProvider).node.isSelectableMode,
                child: Focus(
                  onFocusChange: (bool hasFocus) => ref
                      .read(editorChangeProvider.notifier)
                      .lastFocus = ref.watch(controllerClickableProvider),
                  child: TextField(
                    controller: ref.watch(controllerClickableProvider),
                    textAlign: TextAlign.left,
                    decoration: const InputDecoration(hintText: 'Execution Conditions'),
                  ),
                ),
              ),
              Visibility(
                visible: ref.watch(nodeModeProvider) != ChoiceNodeMode.onlyCode,
                child: Focus(
                  onFocusChange: (bool hasFocus) => ref
                      .read(editorChangeProvider.notifier)
                      .lastFocus = ref.watch(controllerVisibleProvider),
                  child: TextField(
                    controller: ref.watch(controllerVisibleProvider),
                    textAlign: TextAlign.left,
                    decoration: const InputDecoration(
                        hintText: 'Visible conditions(Visible when true, true if empty)'),
                  ),
                ),
              ),
              QuillEditor(
                focusNode: _focusNode!,
                scrollable: false,
                readOnly: false,
                autoFocus: false,
                scrollController: _scrollController!,
                controller: _quillController!,
                padding: EdgeInsets.zero,
                expands: false,
                placeholder: "Enforcement code on selection",
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: [
              ViewSwitchLabel(
                () {
                  ref.read(nodeEditorDesignProvider.notifier).state =
                      design.copyWith(isOccupySpace: !design.isOccupySpace);
                },
                design.isOccupySpace,
                label: 'Takes up space when hidden',
              ),
              IconButton(
                icon: const Icon(Icons.start),
                tooltip: "Sort",
                onPressed: () {
                  var text = _quillController?.document.toPlainText() ?? '';
                  var output =
                      ref.read(editorChangeProvider.notifier).formatting(text);
                  if (output.item2) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("The number of {'s and }'s in the code are not equal."),
                    ));
                  }
                  _quillController?.clear();
                  _quillController?.document.insert(0, output.item1);
                },
              ),
            ],
          ),
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
    var title = ref.watch(nodeTitleProvider);
    var design = ref.watch(nodeEditorDesignProvider);
    var nodeMode = ref.watch(nodeModeProvider);

    List<Widget> list = [];
    if (nodeMode != ChoiceNodeMode.unSelectableMode) {
      list.add(
        ViewSwitchLabel(
          () => ref.read(nodeEditorDesignProvider.notifier).update((state) =>
              state.copyWith(
                  hideAsResult: !design.hideAsResult, showAsResult: false)),
          design.hideAsResult,
          label: 'Hide \n in the final window',
        ),
      );
    } else {
      list.add(
        ViewSwitchLabel(
          () => ref.read(nodeEditorDesignProvider.notifier).update((state) =>
              state.copyWith(
                  showAsResult: !design.showAsResult, hideAsResult: false)),
          design.showAsResult,
          label: 'Show \n in the final window',
        ),
      );
    }
    if (nodeMode == ChoiceNodeMode.multiSelect) {
      list.add(
        ViewSwitchLabel(
              () => ref.read(nodeEditorDesignProvider.notifier).update((state) =>
              state.copyWith(
                  showAsSlider: !design.showAsSlider)),
          design.showAsSlider,
          label: 'Slider mode',
        ),
      );
    }
    list.add(DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Preset settings'),
      items: ref
          .watch(choiceNodePresetListProvider)
          .map<DropdownMenuItem<String>>((preset) =>
              DropdownMenuItem(value: preset.name, child: Text(preset.name)))
          .toList(),
      onChanged: (String? t) {
        if (t != null) {
          ref
              .read(nodeEditorDesignProvider.notifier)
              .update((state) => state.copyWith(presetName: t));
        }
      },
      value: design.presetName,
    ));

    return CustomScrollView(
      controller: ScrollController(),
      slivers: [
        SliverToBoxAdapter(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<ChoiceNodeMode>(
                value: nodeMode,
                items: const [
                  DropdownMenuItem(
                      value: ChoiceNodeMode.defaultMode, child: Text('Default')),
                  DropdownMenuItem(
                      value: ChoiceNodeMode.randomMode, child: Text('Randomize')),
                  DropdownMenuItem(
                      value: ChoiceNodeMode.multiSelect, child: Text('Multiple selections')),
                  DropdownMenuItem(
                      value: ChoiceNodeMode.unSelectableMode,
                      child: Text('Unable to select')),
                  DropdownMenuItem(
                      value: ChoiceNodeMode.onlyCode, child: Text('Use code only')),
                ],
                onChanged: (ChoiceNodeMode? value) {
                  ref.read(nodeModeProvider.notifier).update((state) => value!);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Visibility(
                visible: nodeMode == ChoiceNodeMode.multiSelect ||
                    nodeMode == ChoiceNodeMode.randomMode,
                child: SizedBox(
                  width: 120,
                  child: Column(children: [
                    Text('Variable name', style: Theme.of(context).textTheme.labelLarge),
                    Text(
                        '${title.replaceAll(" ", "")}:${nodeMode == ChoiceNodeMode.multiSelect ? 'multi' : 'random'}',
                        softWrap: true,
                        style: Theme.of(context).textTheme.bodySmall),
                    TextField(
                      textAlign: TextAlign.end,
                      maxLength: 3,
                      minLines: 1,
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      controller: ref.watch(maximumProvider),
                      decoration: InputDecoration(
                        label: Text(nodeMode == ChoiceNodeMode.multiSelect
                            ? 'MaxSelect'
                            : 'Random number, 0 to n-1'),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ]),
        ),
        SliverGrid(
          delegate: SliverChildListDelegate(list),
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
      ],
    );
  }
}

class ViewImageDraggable extends ConsumerWidget {
  const ViewImageDraggable({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ConstList.isDesktop()) {
      return const ViewImageSelector();
    }
    return DropTarget(
      onDragDone: (detail) async {
        for (var file in detail.files) {
          var fileName = file.name;
          if (!ImageDB.regCheckImage.hasMatch(fileName)) {
            continue;
          }
          var fileData = await file.readAsBytes();
          ref.read(lastImageProvider.notifier).update((state) => fileData);
          ref.read(editorChangeProvider.notifier).needUpdate();
          openImageEditor(ref, context, fileName);
          break;
        }
      },
      onDragEntered: (detail) {
        ref.read(editorImageDragDropColorProvider.notifier).state =
            Colors.lightBlueAccent;
      },
      onDragExited: (detail) {
        ref.read(editorImageDragDropColorProvider.notifier).state =
            Colors.black12;
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: ref.watch(editorImageDragDropColorProvider), width: 5),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(4.0),
        child: const ViewImageSelector(),
      ),
    );
  }

  void openImageEditor(WidgetRef ref, BuildContext context, String name) {
    if (name != '') {
      showDialog<Tuple2<bool, String>>(
        builder: (_) => ImageSourceDialog(name),
        context: context,
        barrierDismissible: false,
      ).then((value) {
        getPlatformFileSystem.addSource(name, value?.item2 ?? '');
        if (value?.item1 ?? false) {
          ref
              .read(imageProvider.notifier)
              .update((state) => Tuple2(name, ref.watch(lastImageProvider)!));
          ref
              .read(changeTabProvider.notifier)
              .changePageString('viewImageEditor', context);
        } else {
          ref.read(imageListStateProvider.notifier).addImageToList(name);
        }
      });
    }
  }
}

class ViewImageSelector extends ConsumerStatefulWidget {
  const ViewImageSelector({
    super.key,
  });

  @override
  ConsumerState createState() => _ViewImageSelectorState();
}

class _ViewImageSelectorState extends ConsumerState<ViewImageSelector> {
  ScrollController? _controller;

  @override
  void initState() {
    _controller = AdjustableScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          controller: _controller,
          slivers: [
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 3,
                        color: index == ref.watch(imageStateProvider)
                            ? Colors.redAccent
                            : Colors.white,
                      ),
                    ),
                    child: GestureDetector(
                      child: ViewImageLoading(
                          ref.watch(imageListStateProvider)[index]),
                      onDoubleTap: () {
                        if (ref.read(imageStateProvider.notifier).state ==
                            index) {
                          ref.read(imageStateProvider.notifier).state = -1;
                        } else {
                          ref.read(imageStateProvider.notifier).state = index;
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
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: FloatingActionButton(
            onPressed: () {
              ref
                  .read(imageListStateProvider.notifier)
                  .addImage()
                  .then((name) => openImageEditor(ref, context, name));
            },
            child: const Icon(Icons.add),
          ),
        )
      ],
    );
  }

  void openImageEditor(WidgetRef ref, BuildContext context, String name) {
    if (name != '') {
      showDialog<Tuple2<bool, String>>(
        builder: (_) => ImageSourceDialog(name),
        context: context,
        barrierDismissible: false,
      ).then((value) {
        getPlatformFileSystem.addSource(name, value?.item2 ?? '');
        if (value?.item1 ?? false) {
          ref
              .read(imageProvider.notifier)
              .update((state) => Tuple2(name, ref.watch(lastImageProvider)!));
          ref
              .read(changeTabProvider.notifier)
              .changePageString('viewImageEditor', context);
        } else {
          ref.read(imageListStateProvider.notifier).addImageToList(name);
        }
      });
    }
  }
}
