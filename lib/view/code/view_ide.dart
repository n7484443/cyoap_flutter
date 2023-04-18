import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/view/code/view_ide_gui.dart';
import 'package:cyoap_flutter/view/util/controller_adjustable_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../../viewModel/code/vm_ide.dart';
import '../../viewModel/vm_editor.dart';

class ViewIde extends ConsumerStatefulWidget {
  const ViewIde({
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

  @override
  Widget build(BuildContext context) {
    if (!ref.watch(currentIdeOpenProvider)) {
      return const ViewIdeGui();
    }
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
                      return TextButton(
                        onPressed: () {
                          ref
                              .read(ideCurrentInputProvider.notifier)
                              .insertText(text);
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
                          .lastFocusQuill = ref.watch(controllerIdeProvider);
                    },
                    child: QuillEditor(
                      locale: ref.watch(localeStateProvider),
                      focusNode: _focusNode,
                      scrollable: false,
                      readOnly: false,
                      autoFocus: false,
                      scrollController: _scrollController!,
                      controller: ref.watch(controllerIdeProvider),
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
                          var text = ref.read(controllerIdeProvider).document
                              .toPlainText();
                          var output = ref
                              .read(ideCurrentInputProvider.notifier)
                              .formatting(text);
                          if (output.item2) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("sort_error".i18n),
                            ));
                          }
                          ref.read(ideCurrentInputProvider.notifier).reformat =
                              true;
                          ref.read(controllerIdeProvider).clear();
                          ref.read(controllerIdeProvider).document
                              .insert(0, output.item1);
                          ref.read(ideCurrentInputProvider.notifier).reformat =
                              false;
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.dns_rounded),
                        tooltip: "gui".i18n,
                        onPressed: () {
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
          ]),
        ),
      ],
    );
  }
}
