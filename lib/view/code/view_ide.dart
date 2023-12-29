import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/grammar/analyser.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/view/code/view_ide_gui.dart';
import 'package:cyoap_flutter/view/util/controller_adjustable_scroll.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../../viewModel/code/vm_ide.dart';
import '../../viewModel/code/vm_ide_gui.dart';
import '../../viewModel/vm_editor.dart';

class ViewIde extends ConsumerStatefulWidget {
  final bool isChoiceNode;

  const ViewIde({
    this.isChoiceNode = true,
    super.key,
  });

  @override
  ConsumerState createState() => _ViewCodeIdeState();
}

class _ViewCodeIdeState extends ConsumerState<ViewIde> {
  final FocusNode _focusNode = FocusNode();
  ScrollController? _scrollController;

  String currentTargetVariable = '';

  @override
  void initState() {
    _scrollController = AdjustableScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  Widget rowColumn({required Widget leftOrTop, required Widget rightOrBottom}) {
    return ConstList.isMobile()
        ? Column(
            children: [
              leftOrTop,
              rightOrBottom,
            ],
          )
        : Row(
            children: [
              leftOrTop,
              Expanded(child: rightOrBottom),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    if (!ref.watch(currentIdeOpenProvider)) {
      return const ViewIdeGui();
    }
    var size = 240.0;
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          title: SizedBox(
            height: 44,
            child: Row(
              children: [
                Text(
                  'auto_complete'.i18n,
                  style: ConstList.getCurrentFont(context).bodyMedium,
                ),
                const VerticalDivider(),
                Expanded(
                  child: HorizontalScroll(
                    itemBuilder: (BuildContext context, int index) {
                      var text = ref.watch(ideVariableListProvider)[index];
                      return FittedBox(
                        child: TextButton(
                          onPressed: () {
                            ref
                                .read(ideCurrentInputProvider.notifier)
                                .insertText(text);
                          },
                          child: Text(
                            text,
                            style: ConstList.getCurrentFont(context).bodyLarge,
                          ),
                        ),
                      );
                    },
                    itemCount: ref.watch(ideVariableListProvider).length,
                  ),
                ),
              ],
            ),
          ),
          floating: true,
          pinned: true,
          expandedHeight: 44.0,
          toolbarHeight: 44.0,
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            if (ref.watch(nodeEditorTargetProvider).node.isSelectableMode &&
                widget.isChoiceNode)
              rowColumn(
                leftOrTop: SizedBox(
                  width: size,
                  child: Text('code_hint_execute_condition'.i18n),
                ),
                rightOrBottom: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(ConstList.padding),
                    child: Focus(
                      onFocusChange: (bool hasFocus) {
                        ref
                                .read(ideCurrentInputProvider.notifier)
                                .lastFocusText =
                            ref.watch(controllerClickableProvider);
                        ref
                            .read(ideCurrentInputProvider.notifier)
                            .lastFocusQuill = null;
                      },
                      child: TextField(
                        controller: ref.watch(controllerClickableProvider),
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (ref.watch(nodeEditorTargetProvider).node.isSelectableMode &&
                widget.isChoiceNode)
              const Divider(),
            if (ref.watch(nodeModeProvider) != ChoiceNodeMode.onlyCode)
              rowColumn(
                leftOrTop: SizedBox(
                  width: size,
                  child: Text('code_hint_visible_condition'.i18n),
                ),
                rightOrBottom: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(ConstList.padding),
                    child: Focus(
                      onFocusChange: (bool hasFocus) {
                        ref
                                .read(ideCurrentInputProvider.notifier)
                                .lastFocusText =
                            ref.watch(controllerVisibleProvider);
                        ref
                            .read(ideCurrentInputProvider.notifier)
                            .lastFocusQuill = null;
                      },
                      child: TextField(
                        controller: ref.watch(controllerVisibleProvider),
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            const Divider(),
            rowColumn(
              leftOrTop: SizedBox(
                width: size,
                child: Text("code_hint_execute".i18n),
              ),
              rightOrBottom: const Card(
                child: Padding(
                  padding: EdgeInsets.all(ConstList.padding),
                  child: ViewQuillCodeIde(),
                ),
              ),
            ),
            const Divider(),
            if (!widget.isChoiceNode)
              rowColumn(
                leftOrTop: SizedBox(
                  width: size,
                  child: Text("code_hint_execute".i18n),
                ),
                rightOrBottom: const Card(
                  child: Padding(
                    padding: EdgeInsets.all(ConstList.padding),
                    child: ViewQuillCodeIde(),
                  ),
                ),
              ),
          ]),
        ),
      ],
    );
  }
}

class ViewQuillCodeIde extends ConsumerStatefulWidget {
  const ViewQuillCodeIde({super.key});

  @override
  ConsumerState createState() => _ViewQuillCodeIdeState();
}

class _ViewQuillCodeIdeState extends ConsumerState<ViewQuillCodeIde> {
  final FocusNode _focusNode = FocusNode();
  final AdjustableScrollController _scrollController =
      AdjustableScrollController();

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Focus(
              onFocusChange: (bool hasFocus) {
                ref.read(ideCurrentInputProvider.notifier).lastFocusText = null;
                ref.read(ideCurrentInputProvider.notifier).lastFocusQuill =
                    ref.watch(controllerIdeProvider);
              },
              child: QuillEditor(
                configurations: QuillEditorConfigurations(
                  controller: ref.watch(controllerIdeProvider),
                  sharedConfigurations: QuillSharedConfigurations(
                    locale: ref.watch(localeStateProvider),
                  ),
                  scrollable: false,
                  readOnly: false,
                  autoFocus: false,
                  padding: EdgeInsets.zero,
                  expands: true,
                ),
                focusNode: _focusNode,
                scrollController: _scrollController,
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
                    var text =
                        ref.read(controllerIdeProvider).document.toPlainText();
                    var output = ref
                        .read(ideCurrentInputProvider.notifier)
                        .formatting(text);
                    if (output.$2) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("sort_error".i18n),
                      ));
                    }
                    ref.read(ideCurrentInputProvider.notifier).reformat = true;
                    ref.read(controllerIdeProvider).clear();
                    ref.read(controllerIdeProvider).document.insert(0, output.$1);
                    ref.read(ideCurrentInputProvider.notifier).reformat = false;
                  },
                ),
                if (kDebugMode)
                  IconButton(
                    icon: const Icon(Icons.dns_rounded),
                    tooltip: "gui".i18n,
                    onPressed: () {
                      var ast = Analyser().toAst(
                          ref.read(controllerIdeProvider).document.toPlainText());
                      ref.read(codeBlockProvider.notifier).updateFromAst(ast);
                      ref
                          .read(currentIdeOpenProvider.notifier)
                          .update((state) => !state);
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
