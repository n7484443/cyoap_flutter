import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/grammar/function_list.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/view/util/controller_adjustable_scroll.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../viewModel/vm_editor.dart';
import '../viewModel/vm_ide.dart';

class ViewCodeIde extends ConsumerStatefulWidget {
  const ViewCodeIde({
    super.key,
  });

  @override
  ConsumerState createState() => _ViewCodeIdeState();
}

class _ViewCodeIdeState extends ConsumerState<ViewCodeIde> {
  final FocusNode _focusNode = FocusNode();
  QuillController? _quillExecuteCodeController;
  ScrollController? _scrollController;

  final regexSpace =
      RegExp(r"(\b|}|\))(if|for|else|in|break|continue)(\b|{|\()");
  final regexBrace = RegExp(r"[{}()]");
  final regexComment = RegExp(r"//.*");
  final regexFunction = RegExp(
      "(${FunctionListEnum.values.where((e) => e.displayWithColor).map((e) => e.functionName ?? e.name).join('|')})"
      r"\(");
  String currentTargetVariable = '';

  @override
  void initState() {
    var data = [
      {
        "insert":
            "${ref.read(nodeEditorTargetProvider).node.recursiveStatus.executeCodeString ?? ''}\n"
      }
    ];
    _quillExecuteCodeController = QuillController(
        document: Document.fromJson(data),
        selection: const TextSelection.collapsed(offset: 0));
    _quillExecuteCodeController?.addListener(() {
      EasyDebounce.debounce('code-ide', const Duration(milliseconds: 500), () {
        var plainText =
            _quillExecuteCodeController?.document.toPlainText() ?? '';
        if (ref
                .read(nodeEditorTargetProvider)
                .node
                .recursiveStatus
                .executeCodeString !=
            plainText) {
          var styleNull = Attribute.color;
          var styleDeepOrange =
              ColorAttribute('#${Colors.deepOrangeAccent.hex}');
          var styleDeepPurple = ColorAttribute('#${Colors.deepPurple.hex}');
          var styleGrey = ColorAttribute('#${Colors.grey.hex}');

          _quillExecuteCodeController?.formatText(
              0, plainText.length, styleNull);
          var match = regexSpace.allMatches(plainText);
          for (var m in match) {
            _quillExecuteCodeController?.formatText(
                m.start, m.end - m.start, styleDeepOrange);
          }

          match = regexFunction.allMatches(plainText);
          for (var m in match) {
            _quillExecuteCodeController?.formatText(
                m.start, m.end - m.start, styleDeepPurple);
          }

          match = regexBrace.allMatches(plainText);
          for (var m in match) {
            _quillExecuteCodeController?.formatText(
                m.start, m.end - m.start, styleNull);
          }

          match = regexComment.allMatches(plainText);
          for (var m in match) {
            _quillExecuteCodeController?.formatText(
                m.start, m.end - m.start, styleGrey);
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

    _quillExecuteCodeController?.onReplaceText =
        (int index, int len, Object? data) {
      ref.read(ideCurrentInputProvider.notifier).addText(
          _quillExecuteCodeController!.document.toPlainText(),
          index,
          len,
          data);
      return true;
    };
    _scrollController = AdjustableScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _quillExecuteCodeController?.dispose();
    _scrollController?.dispose();
    EasyDebounce.cancel('code-ide');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          title: SizedBox(
            height: 44,
            child: HorizontalScroll(
              itemBuilder: (BuildContext context, int index) {
                var text = ref.watch(ideVariableListProvider)[index];
                return TextButton(
                  onPressed: () {
                    ref.read(ideCurrentInputProvider.notifier).insertText(text);
                  },
                  child: Text(
                    text,
                    style: ConstList.getCurrentFont(context).bodyLarge,
                  ),
                );
              },
              itemCount: ref.watch(ideVariableListProvider).length,
            ),
          ),
          floating: true,
          pinned: true,
          expandedHeight: 44.0,
          toolbarHeight: 44.0,
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            if (ref.watch(nodeEditorTargetProvider).node.isSelectableMode)
              Focus(
                onFocusChange: (bool hasFocus) {
                  ref.read(ideCurrentInputProvider.notifier).lastFocusText =
                      ref.watch(controllerClickableProvider);
                  ref.read(ideCurrentInputProvider.notifier).lastFocusQuill =
                      null;
                },
                child: TextField(
                  controller: ref.watch(controllerClickableProvider),
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                      hintText: 'code_hint_execute_condition'.i18n),
                ),
              ),
            if (ref.watch(nodeModeProvider) != ChoiceNodeMode.onlyCode)
              Focus(
                onFocusChange: (bool hasFocus) {
                  ref.read(ideCurrentInputProvider.notifier).lastFocusText =
                      ref.watch(controllerVisibleProvider);
                  ref.read(ideCurrentInputProvider.notifier).lastFocusQuill =
                      null;
                },
                child: TextField(
                  controller: ref.watch(controllerVisibleProvider),
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                      hintText: 'code_hint_visible_condition'.i18n),
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Focus(
                    onFocusChange: (bool hasFocus) {
                      ref.read(ideCurrentInputProvider.notifier).lastFocusText =
                          null;
                      ref
                          .read(ideCurrentInputProvider.notifier)
                          .lastFocusQuill = _quillExecuteCodeController!;
                    },
                    child: QuillEditor(
                      locale: ref.watch(localeStateProvider),
                      focusNode: _focusNode,
                      scrollable: false,
                      readOnly: false,
                      autoFocus: false,
                      scrollController: _scrollController!,
                      controller: _quillExecuteCodeController!,
                      padding: EdgeInsets.zero,
                      expands: false,
                      placeholder: "code_hint_execute".i18n,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.reorder),
                        tooltip: "sort".i18n,
                        onPressed: () {
                          var text = _quillExecuteCodeController?.document
                                  .toPlainText() ??
                              '';
                          var output = ref
                              .read(ideCurrentInputProvider.notifier)
                              .formatting(text);
                          if (output.item2) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("sort_error".i18n),
                            ));
                          }
                          _quillExecuteCodeController?.clear();
                          _quillExecuteCodeController?.document
                              .insert(0, output.item1);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]),
        ),
      ],
    );
  }
}
