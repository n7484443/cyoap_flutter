import 'package:cyoap_core/choiceNode/choice.dart';
import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/grammar/simple_code.dart';
import 'package:cyoap_core/variable_db.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/view/util/controller_adjustable_scroll.dart';
import 'package:cyoap_flutter/view/util/view_options.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:searchfield/searchfield.dart';

import '../../main.dart';
import '../../viewModel/code/vm_ide.dart';
import '../../viewModel/edit/vm_editor.dart';

class ViewIde extends ConsumerStatefulWidget {
  final ChoiceType choiceType;
  final Choice choice;

  const ViewIde({
    this.choiceType = ChoiceType.node,
    required this.choice,
    super.key,
  });

  @override
  ConsumerState createState() => _ViewCodeIdeState();
}

class _ViewCodeIdeState extends ConsumerState<ViewIde> {
  final FocusNode _focusNode = FocusNode();
  ScrollController? _scrollController;
  TextEditingController? _controllerClickable;
  TextEditingController? _controllerVisible;

  String currentTargetVariable = '';

  @override
  void initState() {
    _scrollController = ScrollController();
    _controllerClickable = TextEditingController(
      text: widget.choice.conditionalCodeHandler.conditionClickableString,
    );
    _controllerClickable!.addListener(() {
      ref.read(ideCurrentInputProvider.notifier).addCheckText(_controllerClickable!.text, _controllerClickable!.selection.end);
      EasyDebounce.debounce('conditionClickableString', ConstList.debounceDuration, () {
        widget.choice.conditionalCodeHandler.conditionClickableString = _controllerClickable!.text;
      });
    });
    _controllerVisible = TextEditingController(
      text: widget.choice.conditionalCodeHandler.conditionVisibleString,
    );
    _controllerVisible!.addListener(() {
      ref.read(ideCurrentInputProvider.notifier).addCheckText(_controllerVisible!.text, _controllerVisible!.selection.end);
      EasyDebounce.debounce('conditionVisibleString', ConstList.debounceDuration, () {
        widget.choice.conditionalCodeHandler.conditionVisibleString = _controllerVisible!.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController?.dispose();
    _controllerClickable?.dispose();
    _controllerVisible?.dispose();
    EasyDebounce.cancel('conditionClickableString');
    EasyDebounce.cancel('conditionVisibleString');
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
                            ref.read(ideCurrentInputProvider.notifier).insertText(text);
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
            if (widget.choiceType == ChoiceType.node && ref.watch(nodeEditorTargetProvider).isSelectableMode)
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
                        ref.read(ideCurrentInputProvider.notifier).lastFocusText = _controllerClickable;
                        ref.read(ideCurrentInputProvider.notifier).lastFocusQuill = null;
                      },
                      child: TextField(
                        controller: _controllerClickable,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
              ),
            if (widget.choiceType == ChoiceType.node && ref.watch(nodeEditorTargetProvider).isSelectableMode) const Divider(),
            if (widget.choiceType != ChoiceType.node || ref.watch(nodeEditorTargetProvider).choiceNodeMode != ChoiceNodeMode.onlyCode)
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
                        ref.read(ideCurrentInputProvider.notifier).lastFocusText = _controllerVisible;
                        ref.read(ideCurrentInputProvider.notifier).lastFocusQuill = null;
                      },
                      child: TextField(
                        controller: _controllerVisible,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
              ),
            const Divider(),
            rowColumn(
              leftOrTop: SizedBox(
                width: size,
                child: Text(widget.choiceType == ChoiceType.node ? "${"code_hint_execute".i18n}\n${"code_hint_execute_sub".i18n}" : "code_hint_fin".i18n),
              ),
              rightOrBottom: Card(
                child: Padding(
                  padding: const EdgeInsets.all(ConstList.padding),
                  child: ViewQuillCodeIde(choiceType: widget.choiceType),
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

class SimpleCodeEditor extends ConsumerStatefulWidget {
  final ChoiceType choiceType;
  final Choice choice;

  const SimpleCodeEditor({
    this.choiceType = ChoiceType.node,
    required this.choice,
    super.key,
  });

  @override
  ConsumerState createState() => _SimpleCodeEditorState();
}

class _SimpleCodeEditorState extends ConsumerState<SimpleCodeEditor> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var codeHandler = widget.choice.conditionalCodeHandler;
    return Scrollbar(
      thumbVisibility: true,
      trackVisibility: true,
      controller: _scrollController,
      child: ListView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        children: [
          SimpleCodeBlockEditor(
            title: 'code_hint_execute_condition'.i18n,
            simpleCodes: codeHandler.conditionClickableSimple,
            codeActivationType: CodeActivationType.clickable,
          ),
          SimpleCodeBlockEditor(
            title: 'code_hint_visible_condition'.i18n,
            simpleCodes: codeHandler.conditionVisibleSimple,
            codeActivationType: CodeActivationType.visible,
          ),
          SimpleCodeBlockEditor(
            title: 'code_hint_execute'.i18n,
            simpleCodes: codeHandler.executeSimple,
            codeActivationType: CodeActivationType.execute,
          ),
        ],
      ),
    );
  }
}

class SimpleCodeBlockEditor extends ConsumerStatefulWidget {
  final SimpleCodes? simpleCodes;
  final String title;
  final CodeActivationType codeActivationType;

  const SimpleCodeBlockEditor({this.simpleCodes, required this.title, required this.codeActivationType, super.key});

  @override
  ConsumerState createState() => _SimpleCodeBlockEditorState();
}

class _SimpleCodeBlockEditorState extends ConsumerState<SimpleCodeBlockEditor> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _searchScrollController = ScrollController();
  final Map<int, List<TextEditingController>> _controllers = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _searchScrollController.dispose();
    for (var key in _controllers.keys) {
      for (var controller in _controllers[key]!) {
        controller.dispose();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var addButton = IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        ref.read(simpleCodesIdeProvider(widget.codeActivationType).notifier).addSimpleCodeBlock(getDefaultValue());
      },
    );
    var children = ref.watch(simpleCodesIdeProvider(widget.codeActivationType))?.code.indexed.map((e) {
          var (index, data) = e;
          return buildFromSimpleCodeBlock(data, index);
        }).toList() ??
        [];
    children.add(addButton);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.title),
        ),
        const ColoredBox(
          color: Colors.black12,
          child: SizedBox(
            width: 160,
            height: 2,
          ),
        ),
        Flexible(
          child: SizedBox(
            width: 320,
            child: Scrollbar(
              thumbVisibility: true,
              trackVisibility: true,
              controller: _scrollController,
              child: ListView(
                controller: _scrollController,
                children: children,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFromSimpleCodeBlock(SimpleCodeBlock simpleCodeBlock, int index) {
    Widget dropdown;
    if (simpleCodeBlock is Action) {
      dropdown = CustomDropdownButton<SimpleActionType>(
        value: simpleCodeBlock.type,
        items: SimpleActionType.values
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e.toString()),
              ),
            )
            .toList(),
        onChanged: (SimpleActionType? type) {
          if (type == null) return;
          simpleCodeBlock = (simpleCodeBlock as Action).copyWith(type: type);
          ref.read(simpleCodesIdeProvider(widget.codeActivationType).notifier).setSimpleCodeBlock(simpleCodeBlock, index);
        },
        forceWidth: 230,
        useCard: false,
      );
    } else {
      simpleCodeBlock = simpleCodeBlock as Condition;
      dropdown = CustomDropdownButton<SimpleConditionType>(
        value: simpleCodeBlock.type,
        items: SimpleConditionType.values
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e.toString()),
              ),
            )
            .toList(),
        onChanged: (SimpleConditionType? type) {
          if (type == null) return;
          simpleCodeBlock = (simpleCodeBlock as Condition).copyWith(type: type);
          ref.read(simpleCodesIdeProvider(widget.codeActivationType).notifier).setSimpleCodeBlock(simpleCodeBlock, index);
        },
        forceWidth: 230,
        useCard: false,
      );
    }
    var count = simpleCodeBlock.argumentLength;
    if (_controllers[index] == null) {
      _controllers[index] = [];
    }
    var currentControllerList = _controllers[index]!;
    for (var i = 0; i < count; i++) {
      if (currentControllerList.length <= i) {
        currentControllerList.add(TextEditingController());
      }
      if (simpleCodeBlock.arguments.length <= i) {
        currentControllerList[i].text = "";
      } else {
        currentControllerList[i].text = simpleCodeBlock.arguments[i].data;
      }
    }

    var variableList = VariableDataBase().stackFrames.last.getVariableMap();
    print(variableList.keys);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
        child: Column(
          children: [
            dropdown,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(count, (index) {
                return Expanded(
                  child: SearchField<String>(
                    controller: currentControllerList[index],
                    suggestions: variableList.keys.map((name) => SearchFieldListItem<String>(name)).toList(),
                    onSuggestionTap: (SearchFieldListItem<String> suggestion) {
                      currentControllerList[index].text = suggestion.searchKey;
                      return suggestion.searchKey;
                    },
                    scrollController: _searchScrollController,
                    scrollbarDecoration: ScrollbarDecoration(),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  SimpleCodeBlock getDefaultValue() {
    if (widget.codeActivationType == CodeActivationType.execute) {
      return const SimpleCodeBlock.action(type: SimpleActionType.nothing);
    }
    return const SimpleCodeBlock.condition(type: SimpleConditionType.alwaysOn);
  }
}

class ViewQuillCodeIde extends ConsumerStatefulWidget {
  final ChoiceType choiceType;

  const ViewQuillCodeIde({required this.choiceType, super.key});

  @override
  ConsumerState createState() => _ViewQuillCodeIdeState();
}

class _ViewQuillCodeIdeState extends ConsumerState<ViewQuillCodeIde> {
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

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
                ref.read(ideCurrentInputProvider.notifier).lastFocusQuill = ref.watch(ideControllerProvider(widget.choiceType));
              },
              child: QuillEditor(
                controller: ref.watch(ideControllerProvider(widget.choiceType)),
                config: const QuillEditorConfig(
                  scrollable: false,
                  autoFocus: false,
                  padding: EdgeInsets.zero,
                  expands: true,
                  enableSelectionToolbar: false,
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
                    var text = ref.read(IdeControllerProvider(ChoiceType.node)).document.toPlainText();
                    var (output, checkGrammerWrong) = ref.read(ideCurrentInputProvider.notifier).formatting(text);
                    if (checkGrammerWrong) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("sort_error".i18n),
                      ));
                    }
                    ref.read(ideCurrentInputProvider.notifier).reformat = true;
                    var length = ref.read(ideControllerProvider(widget.choiceType)).plainTextEditingValue.text.length - 1;
                    ref.read(ideControllerProvider(widget.choiceType)).replaceText(0, length, output, const TextSelection.collapsed(offset: 0));
                    ref.read(ideCurrentInputProvider.notifier).reformat = false;
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
