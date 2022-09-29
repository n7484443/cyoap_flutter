import 'dart:convert';
import 'dart:ui';

import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_flutter/model/image_db.dart';
import 'package:cyoap_flutter/view/util/view_image_loading.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:cyoap_flutter/viewModel/vm_design_setting.dart';
import 'package:cyoap_flutter/viewModel/vm_image_editor.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import '../main.dart';
import '../model/platform_system.dart';
import '../viewModel/vm_editor.dart';
import '../viewModel/vm_make_platform.dart';

class ViewEditor extends ConsumerWidget {
  const ViewEditor({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<Pos?>(nodeEditorTargetPosProvider, (previous, next) {
      ref.read(nodeEditorTargetProvider.notifier).update();
    });
    if (ref.watch(nodeEditorTargetPosProvider) == null) {
      return const SizedBox.shrink();
    }
    var children = [
      const ViewContentsEditor(),
      const ViewCodeIde(),
      const ViewNodeOptionEditor()
    ];
    var childrenText = const ["내용", "코드", "설정"];
    return WillPopScope(
      child: DefaultTabController(
        length: children.length,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (ref.watch(nodeTitleProvider).isNotEmpty) {
                    ref.read(changeTabProvider.notifier).back(context);
                  }
                  DefaultTabController.of(context)?.index = 0;
                },
              ),
            ),
            title: TabBar(
              labelColor: Theme.of(context).colorScheme.secondary,
              unselectedLabelColor: Theme.of(context).colorScheme.primary,
              tabs: childrenText.map((String e) => Tab(text: e)).toList(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  ref.read(editorChangeProvider.notifier).save();
                },
              ),
            ],
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
    ref.listen(nodeEditorDesignProvider, (previous, ChoiceNodeDesign next) {
      ref.read(nodeEditorTargetProvider).node.choiceNodeDesign = next;
      ref.read(editorChangeProvider.notifier).needUpdate();
    });

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
    return TextField(
      controller: _controller,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: '제목',
        hintStyle: ConstList.getFont(ref.watch(titleFontProvider))
            .copyWith(fontSize: 24, color: Colors.red),
        filled: true,
      ),
      style: ConstList.getFont(ref.watch(titleFontProvider)).copyWith(
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
                  fontStyle: ConstList.getFont(ref.watch(mainFontProvider))),
            ),
          ),
        ),
        const Expanded(
          child: ViewNodeImageEditor(),
        ),
      ],
    );
  }
}

class ViewNodeImageEditor extends ConsumerWidget {
  const ViewNodeImageEditor({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(imageStateProvider, (previous, int index) {
      ref.read(nodeEditorTargetProvider).node.imageString =
          ImageDB().getImageName(index);
      ref.read(editorChangeProvider.notifier).needUpdate();
    });
    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
                onPressed: () async {
                  var name = await ref
                      .read(imageListStateProvider.notifier)
                      .addImage();
                  if (name != '') {
                    getPlatformFileSystem.addSource(
                        name, ref.read(imageSourceProvider));
                    showDialog<bool>(
                      builder: (_) => ImageSourceDialog(name),
                      context: context,
                      barrierDismissible: false,
                    ).then((value) {
                      if (value ?? false) {
                        ref.read(imageProvider.notifier).update((state) =>
                            Tuple2(name, ref.watch(lastImageProvider)!));
                        ref
                            .read(changeTabProvider.notifier)
                            .changePageString('viewImageEditor', context);
                      } else {
                        ref
                            .read(imageListStateProvider.notifier)
                            .addImageToList(name);
                      }
                    });
                  }
                },
                icon: const Icon(Icons.add)),
          ],
        ),
        Expanded(
          child: Card(
            elevation: ConstList.elevation,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                }),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  controller: ScrollController(),
                  itemCount: ref.watch(imageListStateProvider).length,
                  itemBuilder: (BuildContext context, int index) {
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
                ),
              ),
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
    _sourceController!.addListener(() {
      ref.read(imageSourceProvider.notifier).state = _sourceController!.text;
    });
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
      title: const Text('출처'),
      content: TextField(
        controller: _sourceController,
        decoration: const InputDecoration(
          hintText: '출처를 모르거나 없을 경우 비워두세요.',
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text('자르기'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('저장하기'),
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

  var regexSpace = RegExp(
      r"((if|for)(?=\())|((?<=(\s|}))else)|((?<=(\s|{))(in|break|continue)(?=\s))");

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

          _quillController?.formatText(0, plainText.length, styleNull);
          var match = regexSpace.allMatches(plainText);
          for (var m in match) {
            _quillController?.formatText(
                m.start, m.end - m.start, styleDeepOrange);
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
    _scrollController = ScrollController();
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
                    decoration: const InputDecoration(hintText: '실행 조건'),
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
                        hintText: '보이는 조건(true일 때 보임, 비어있을 시 true)'),
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
                placeholder: "선택 시 시행 코드",
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
                label: '숨김 시 공간 차지',
              ),
              IconButton(
                icon: const Icon(Icons.start),
                tooltip: "정렬",
                onPressed: () {
                  var text = _quillController?.document.toPlainText() ?? '';
                  var output =
                      ref.read(editorChangeProvider.notifier).formatting(text);
                  if (output.item2) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("코드의 {의 개수와 }의 개수가 같지 않습니다."),
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
    ref.listen(nodeModeProvider, (previous, ChoiceNodeMode next) {
      ref.read(nodeEditorTargetProvider).node.choiceNodeMode = next;
      ref.read(editorChangeProvider.notifier).needUpdate();
    });
    ref.listen(nodeEditorDesignProvider, (previous, ChoiceNodeDesign next) {
      ref.read(nodeEditorTargetProvider).node.choiceNodeDesign = next;
      ref.read(editorChangeProvider.notifier).needUpdate();
    });
    var title = ref.watch(nodeTitleProvider);
    var design = ref.watch(nodeEditorDesignProvider);
    var nodeMode = ref.watch(nodeModeProvider);

    List<Widget> list = [];
    if (nodeMode != ChoiceNodeMode.onlyCode) {
      list.add(
        ViewSwitchLabel(
          () => ref
              .read(nodeEditorDesignProvider.notifier)
              .update((state) => state.copyWith(isCard: !design.isCard)),
          design.isCard,
          label: '카드 모드',
        ),
      );
      list.add(
        ViewSwitchLabel(
          () => ref
              .read(nodeEditorDesignProvider.notifier)
              .update((state) => state.copyWith(isRound: !design.isRound)),
          design.isRound,
          label: '외곽선 둥글게',
        ),
      );
      list.add(
        ViewSwitchLabel(
          () => ref.read(nodeEditorDesignProvider.notifier).update((state) =>
              state.copyWith(maximizingImage: !design.maximizingImage)),
          design.maximizingImage,
          label: '이미지 최대화',
        ),
      );
      list.add(
        ViewSwitchLabel(
          () => ref
              .read(nodeEditorDesignProvider.notifier)
              .update((state) => state.copyWith(hideTitle: !design.hideTitle)),
          design.hideTitle,
          label: '제목 숨기기',
        ),
      );
      list.add(
        ViewSwitchLabel(
          () => ref.read(nodeEditorDesignProvider.notifier).update((state) =>
              state.copyWith(imagePosition: design.imagePosition == 0 ? 1 : 0)),
          design.imagePosition != 0,
          label: '가로 모드',
        ),
      );
      list.add(
        ViewSwitchLabel(
          () {
            if (design.imagePosition == 1) {
              ref
                  .read(nodeEditorDesignProvider.notifier)
                  .update((state) => state.copyWith(imagePosition: 2));
            } else if (design.imagePosition == 2) {
              ref
                  .read(nodeEditorDesignProvider.notifier)
                  .update((state) => state.copyWith(imagePosition: 1));
            }
          },
          design.imagePosition == 2,
          disable: design.imagePosition == 0,
          label: '이미지 왼쪽으로',
        ),
      );
      if (nodeMode != ChoiceNodeMode.unSelectableMode) {
        list.add(
          ViewSwitchLabel(
            () => ref.read(nodeEditorDesignProvider.notifier).update(
                (state) => state.copyWith(hideAsResult: !design.hideAsResult)),
            design.hideAsResult,
            label: '결론창에서 \n숨기기',
          ),
        );
      }
    }

    return CustomScrollView(
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
                      value: ChoiceNodeMode.defaultMode, child: Text('기본')),
                  DropdownMenuItem(
                      value: ChoiceNodeMode.randomMode, child: Text('랜덤 선택')),
                  DropdownMenuItem(
                      value: ChoiceNodeMode.multiSelect, child: Text('다중 선택')),
                  DropdownMenuItem(
                      value: ChoiceNodeMode.unSelectableMode,
                      child: Text('선택 불가')),
                  DropdownMenuItem(
                      value: ChoiceNodeMode.onlyCode, child: Text('코드만 사용')),
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
                    Text('변수명', style: Theme.of(context).textTheme.labelLarge),
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
                            ? '최대선택'
                            : '랜덤 수, 0 ~ n-1'),
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
      ],
    );
  }
}
