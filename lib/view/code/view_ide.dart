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

class ViewIdeTab extends ConsumerStatefulWidget {
  const ViewIdeTab({
    super.key,
  });

  @override
  ConsumerState createState() => _ViewIdeTabState();
}

class _ViewIdeTabState extends ConsumerState<ViewIdeTab>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kDebugMode
          ? TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: "editor_simple".i18n),
                Tab(text: "editor_code".i18n)
              ],
            )
          : null,
      body: TabBarView(
        controller: _tabController,
        children: [
          if (kDebugMode) const ViewIdeSimple(),
          const ViewIde(),
        ],
      ),
    );
  }
}

class ViewIdeSimple extends ConsumerStatefulWidget {
  const ViewIdeSimple({
    super.key,
  });

  @override
  ConsumerState createState() => _ViewIdeSimpleState();
}

class _ViewIdeSimpleState extends ConsumerState<ViewIdeSimple> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListView(
            children: [
              Center(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: 0,
                    onChanged: (index) {},
                    items: [
                      const DropdownMenuItem(value: 0, child: Text('and')),
                      const DropdownMenuItem(value: 1, child: Text('or')),
                    ],
                  ),
                ),
              ),
              const TextField(),
              IconButton(onPressed: () {}, icon: const Icon(Icons.add))
            ],
          ),
        ),
        const VerticalDivider(),
        Expanded(
          child: ListView(
            children: [
              Center(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: 0,
                    onChanged: (index) {},
                    items: [
                      const DropdownMenuItem(value: 0, child: Text('and')),
                      const DropdownMenuItem(value: 1, child: Text('or')),
                    ],
                  ),
                ),
              ),
              const TextField(),
              IconButton(onPressed: () {}, icon: const Icon(Icons.add))
            ],
          ),
        ),
      ],
    );
  }
}

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
                    child: QuillProvider(
                      configurations: QuillConfigurations(
                        controller: ref.watch(controllerIdeProvider),
                        sharedConfigurations: QuillSharedConfigurations(
                          locale: ref.watch(localeStateProvider),
                        ),
                      ),
                      child: QuillEditor(
                        configurations: QuillEditorConfigurations(
                          scrollable: false,
                          readOnly: false,
                          autoFocus: false,
                          padding: EdgeInsets.zero,
                          expands: false,
                          placeholder: "code_hint_execute".i18n,
                        ),
                        focusNode: _focusNode,
                        scrollController: _scrollController!,
                      ),
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
                          var text = ref
                              .read(controllerIdeProvider)
                              .document
                              .toPlainText();
                          var output = ref
                              .read(ideCurrentInputProvider.notifier)
                              .formatting(text);
                          if (output.$2) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("sort_error".i18n),
                            ));
                          }
                          ref.read(ideCurrentInputProvider.notifier).reformat =
                              true;
                          ref.read(controllerIdeProvider).clear();
                          ref
                              .read(controllerIdeProvider)
                              .document
                              .insert(0, output.$1);
                          ref.read(ideCurrentInputProvider.notifier).reformat =
                              false;
                        },
                      ),
                      if (kDebugMode)
                        IconButton(
                          icon: const Icon(Icons.dns_rounded),
                          tooltip: "gui".i18n,
                          onPressed: () {
                            var ast = Analyser().toAst(ref
                                .read(controllerIdeProvider)
                                .document
                                .toPlainText());
                            ref
                                .read(codeBlockProvider.notifier)
                                .updateFromAst(ast);
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
