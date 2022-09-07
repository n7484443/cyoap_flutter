import 'dart:convert';
import 'dart:ui';

import 'package:cyoap_flutter/view/util/view_image_loading.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:cyoap_flutter/viewModel/vm_design_setting.dart';
import 'package:cyoap_flutter/viewModel/vm_image_editor.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import '../main.dart';
import '../model/choiceNode/choice_node.dart';
import '../model/choiceNode/pos.dart';
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
    if(ref.watch(nodeEditorTargetPosProvider) == null){
      return const SizedBox.shrink();
    }
    var children = [const ViewContentsEditor(), const ViewCodeEditor()];
    var childrenText = const ["내용 수정", "코드 수정"];
    return DefaultTabController(
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
    );
  }
}

class ViewContentsEditor extends ConsumerWidget {
  const ViewContentsEditor({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(isCardSwitchProvider, (previous, bool next) {
      ref.read(nodeEditorTargetProvider).node.isCard = next;
      ref.read(editorChangeProvider.notifier).needUpdate();
    });
    ref.listen(isRoundSwitchProvider, (previous, bool next) {
      ref.read(nodeEditorTargetProvider).node.isRound = next;
      ref.read(editorChangeProvider.notifier).needUpdate();
    });
    ref.listen(hideTitleProvider, (previous, bool next) {
      ref.read(nodeEditorTargetProvider).node.hideTitle = next;
      ref.read(editorChangeProvider.notifier).needUpdate();
    });
    ref.listen(maximizingImageSwitchProvider, (previous, bool next) {
      ref.read(nodeEditorTargetProvider).node.maximizingImage = next;
      ref.read(editorChangeProvider.notifier).needUpdate();
    });
    ref.listen(imagePositionProvider, (previous, int next) {
      ref.read(nodeEditorTargetProvider).node.imagePosition = next;
      ref.read(editorChangeProvider.notifier).needUpdate();
    });
    ref.listen(nodeModeProvider, (previous, ChoiceNodeMode next) {
      ref.read(nodeEditorTargetProvider).node.choiceNodeMode = next;
      ref.read(editorChangeProvider.notifier).needUpdate();
    });
    ref.listen(nodeModeProvider, (previous, ChoiceNodeMode next) {
      ref.read(nodeEditorTargetProvider).node.choiceNodeMode = next;
      ref.read(editorChangeProvider.notifier).needUpdate();
    });

    return WillPopScope(
      child: Column(
        children: [
          const ViewTitleTextFieldInput(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Visibility(
                      visible: ref.watch(nodeModeProvider) !=
                          ChoiceNodeMode.onlyCode,
                      child: const ViewTextContentsEditor(),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(ConstList.paddingSmall),
                  child: SingleChildScrollView(
                    child: ViewControlPanel(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onWillPop: () async {
        ref.read(changeTabProvider.notifier).back(context);
        return false;
      },
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

class ViewControlPanel extends ConsumerWidget {
  const ViewControlPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var title = ref.watch(nodeTitleProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        DropdownButton<ChoiceNodeMode>(
          value: ref.watch(nodeModeProvider),
          items: const [
            DropdownMenuItem(
                value: ChoiceNodeMode.defaultMode, child: Text('기본')),
            DropdownMenuItem(
                value: ChoiceNodeMode.randomMode, child: Text('랜덤 선택')),
            DropdownMenuItem(
                value: ChoiceNodeMode.multiSelect, child: Text('다중 선택')),
            DropdownMenuItem(
                value: ChoiceNodeMode.unSelectableMode, child: Text('선택 불가')),
            DropdownMenuItem(
                value: ChoiceNodeMode.onlyCode, child: Text('코드만 사용')),
          ],
          onChanged: (ChoiceNodeMode? value) {
            ref.read(nodeModeProvider.notifier).update((state) => value!);
          },
        ),
        Visibility(
          visible: ref.watch(nodeModeProvider) == ChoiceNodeMode.randomMode,
          child: SizedBox(
            width: 120,
            child: Column(children: [
              Text('변수명', style: Theme.of(context).textTheme.labelLarge),
              Text('${title.replaceAll(" ", "")}:random',
                  softWrap: true, style: Theme.of(context).textTheme.bodySmall),
              TextField(
                textAlign: TextAlign.end,
                maxLength: 3,
                minLines: 1,
                maxLines: 1,
                keyboardType: TextInputType.number,
                controller: ref.watch(maximumProvider),
                decoration: const InputDecoration(
                  label: Text('랜덤 수, 0 ~ n-1'),
                ),
              ),
            ]),
          ),
        ),
        Visibility(
          visible: ref.watch(nodeModeProvider) == ChoiceNodeMode.multiSelect,
          child: SizedBox(
            width: 120,
            child: Column(children: [
              Text('변수명', style: Theme.of(context).textTheme.labelLarge),
              Text('${title.replaceAll(" ", "")}:multi',
                  softWrap: true, style: Theme.of(context).textTheme.bodySmall),
              TextField(
                textAlign: TextAlign.end,
                maxLength: 3,
                minLines: 1,
                maxLines: 1,
                keyboardType: TextInputType.number,
                controller: ref.watch(maximumProvider),
                decoration: const InputDecoration(
                  label: Text('최대 선택'),
                ),
              ),
            ]),
          ),
        ),
        Visibility(
          visible: ref.watch(nodeModeProvider) != ChoiceNodeMode.onlyCode,
          child: ViewSwitchLabel(
            () => ref
                .read(isCardSwitchProvider.notifier)
                .update((state) => !state),
            ref.watch(isCardSwitchProvider),
            label: '카드 모드',
          ),
        ),
        Visibility(
          visible: ref.watch(nodeModeProvider) != ChoiceNodeMode.onlyCode,
          child: ViewSwitchLabel(
            () => ref
                .read(isRoundSwitchProvider.notifier)
                .update((state) => !state),
            ref.watch(isRoundSwitchProvider),
            label: '외곽선 둥글게',
          ),
        ),
        Visibility(
          visible: ref.watch(nodeModeProvider) != ChoiceNodeMode.onlyCode,
          child: ViewSwitchLabel(
            () => ref
                .read(maximizingImageSwitchProvider.notifier)
                .update((state) => !state),
            ref.watch(maximizingImageSwitchProvider),
            label: '이미지 최대화',
          ),
        ),
        Visibility(
          visible: ref.watch(nodeModeProvider) != ChoiceNodeMode.onlyCode,
          child: ViewSwitchLabel(
            () =>
                ref.read(hideTitleProvider.notifier).update((state) => !state),
            ref.watch(hideTitleProvider),
            label: '제목 숨기기',
          ),
        ),
        Visibility(
          visible: ref.watch(nodeModeProvider) != ChoiceNodeMode.onlyCode,
          child: ViewSwitchLabel(
            () => ref
                .read(imagePositionProvider.notifier)
                .update((state) => state == 0 ? 1 : 0),
            ref.watch(imagePositionProvider) != 0,
            label: '가로 모드',
          ),
        ),
        Visibility(
          visible: ref.watch(nodeModeProvider) != ChoiceNodeMode.onlyCode,
          child: ViewSwitchLabel(
            () {
              if (ref.watch(imagePositionProvider) == 1) {
                ref.read(imagePositionProvider.notifier).update((state) => 2);
              } else if (ref.watch(imagePositionProvider) == 2) {
                ref.read(imagePositionProvider.notifier).update((state) => 1);
              }
            },
            ref.watch(imagePositionProvider) == 2,
            disable: ref.watch(imagePositionProvider) == 0,
            label: '이미지 왼쪽으로',
          ),
        ),
      ],
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
    _focusNode!.addListener(() {
      if (!_focusNode!.hasFocus) {
        ref.read(nodeEditorTargetProvider).node.contentsString =
            jsonEncode(_quillController?.document.toDelta().toJson());
        ref.read(editorChangeProvider.notifier).needUpdate();
      }
    });
    var node = ref.read(nodeEditorTargetProvider).node;
    if (node.contentsString.isEmpty) {
      _quillController = QuillController.basic();
    } else {
      _quillController = QuillController(
          document: Document.fromJson(jsonDecode(node.contentsString)),
          selection: const TextSelection.collapsed(offset: 0));
    }
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
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

class ViewCodeEditor extends ConsumerWidget {
  const ViewCodeEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Visibility(
                  visible: ref.watch(nodeEditorTargetProvider).node.isSelectableMode,
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
                  visible:
                      ref.watch(nodeModeProvider) != ChoiceNodeMode.onlyCode,
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
                Expanded(
                  child: Focus(
                    onFocusChange: (bool hasFocus) => ref
                        .read(editorChangeProvider.notifier)
                        .lastFocus = ref.watch(controllerExecuteProvider),
                    child: TextField(
                      controller: ref.watch(controllerExecuteProvider),
                      textAlign: TextAlign.left,
                      scrollController: ScrollController(),
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        hintText: '선택 시 시행 코드',
                      ),
                    ),
                  ),
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
                    ref.read(nodeEditorTargetProvider).node.isOccupySpace =
                        !ref.read(isOccupySpaceButtonProvider);
                    ref
                        .read(isOccupySpaceButtonProvider.notifier)
                        .update((value) => value = !value);
                  },
                  ref.watch(isOccupySpaceButtonProvider),
                  label: '숨김 시 공간 차지',
                ),
              ],
            ),
          ),
        ],
      ),
      onWillPop: () async {
        ref.read(changeTabProvider.notifier).back(context);
        return false;
      },
    );
  }
}
