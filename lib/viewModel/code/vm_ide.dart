import 'package:cyoap_core/choiceNode/choice.dart';
import 'package:cyoap_core/choiceNode/choice_line.dart';
import 'package:cyoap_core/choiceNode/conditional_code_handler.dart';
import 'package:cyoap_core/grammar/analyser.dart';
import 'package:cyoap_core/grammar/analyser_const.dart';
import 'package:cyoap_core/grammar/ast.dart';
import 'package:cyoap_core/grammar/simple_code.dart';
import 'package:cyoap_core/variable_db.dart';
import 'package:cyoap_flutter/viewModel/edit/vm_editor.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../main.dart';

part 'vm_ide.g.dart';

enum ChoiceType {
  node,
  line,
  page;

  @override
  String toString() => 'ChoiceType.$name';
}

@riverpod
QuillController ideController(Ref ref, ChoiceType type) {
  Choice? choice;
  ConditionalCodeHandler? handler;
  String? str;
  switch (type) {
    case ChoiceType.node:
      choice = ref.watch(nodeEditorTargetProvider);
      handler = choice!.conditionalCodeHandler;
      break;
    case ChoiceType.line:
      choice = ref.watch(lineEditorTargetProvider);
      handler = (choice as ChoiceLine).conditionalCodeHandlerFinalize;
      break;
    case ChoiceType.page:
      break;
  }
  str = handler!.executeCodeString;

  var data = [
    {"insert": "${str ?? ''}\n"}
  ];
  var controller = QuillController(document: Document.fromJson(data), selection: const TextSelection.collapsed(offset: 0));
  controller.addListener(() {
    EasyDebounce.debounce('code-ide-$type', ConstList.debounceDuration, () {
      const styleNull = Attribute.color;
      final styleDeepOrange = ColorAttribute('#${Colors.deepOrangeAccent.hex}');
      final styleDeepPurple = ColorAttribute('#${Colors.deepPurpleAccent.hex}');
      final styleBlue = ColorAttribute('#${Colors.blueAccent.hex}');
      var plainText = controller.document.toPlainText();
      var compile = Analyser().toAst(plainText, isCondition: false);

      var needUpdate = [];
      void recursive(AST ast) {
        switch (ast.data!.value.type) {
          case AnalyserConst.keywordIfCondition:
          case AnalyserConst.keywordElse:
          case AnalyserConst.keywordFor:
          case AnalyserConst.keywordBreak:
          case AnalyserConst.keywordContinue:
            needUpdate.add((ast.data!.start, ast.data!.stop, styleDeepOrange));
            break;
          case AnalyserConst.keywordDot:
          case AnalyserConst.keywordIn:
          case AnalyserConst.function:
            needUpdate.add((ast.data!.start, ast.data!.stop, styleDeepPurple));
            break;
          case AnalyserConst.bools:
          case AnalyserConst.loadAddress:
            needUpdate.add((ast.data!.start, ast.data!.stop, styleBlue));
            break;
          default:
            break;
        }
        for (var child in ast.child) {
          recursive(child);
        }
      }

      if (compile == null) {
        return;
      }
      recursive(compile);
      controller.formatText(0, plainText.length, styleNull, shouldNotifyListeners: false);
      for (var i = 0; i < needUpdate.length; i++) {
        var (start, end, style) = needUpdate[i];
        controller.formatText(start, end - start, style, shouldNotifyListeners: false);
      }
    });
    if (type == ChoiceType.node) {
      choice!.conditionalCodeHandler.executeCodeString = controller.document.toPlainText();
    } else {
      (choice as ChoiceLine).conditionalCodeHandlerFinalize.executeCodeString = controller.document.toPlainText();
    }
  });
  ref.onDispose(() {
    controller.dispose();
    EasyDebounce.cancel('code-ide-$type');
  });

  controller.onReplaceText = (int index, int len, Object? data) {
    ref.read(ideCurrentInputProvider.notifier).addText(controller.document.toPlainText(), index, len, data);
    return true;
  };
  return controller;
}

final ideVariableListProvider = Provider.autoDispose<List<String>>((ref) {
  return VariableDataBase().stackFrames.first.getVariableMap().keys.where((e) => e.contains(ref.watch(ideCurrentInputProvider))).toList();
});

final ideCurrentInputProvider = StateNotifierProvider<IdeCurrentInputNotifier, String>((ref) => IdeCurrentInputNotifier(ref));

class IdeCurrentInputNotifier extends StateNotifier<String> {
  final regexNonAlphabet = RegExp(r"[=<>{}\[\]().\s\n]");
  final Ref ref;

  int currentFocus = 0;
  TextEditingController? lastFocusText;
  QuillController? lastFocusQuill;

  int len = 0;
  bool reformat = false;

  IdeCurrentInputNotifier(this.ref) : super('');

  void addText(String plainText, int index, int len, Object? data) {
    if (reformat) return;
    if (data == null) return;
    if (data is! String) return;
    var carrot = index;
    plainText = plainText.replaceRange(index, index + len, data);
    carrot = carrot - len + data.length;
    addCheckText(plainText, carrot);
    plainText.trim();
  }

  void addCheckText(String plainText, int index) {
    if (plainText.isEmpty) return;
    index = index.clamp(0, plainText.length - 1);
    var spacePos = plainText.substring(0, index).lastIndexOf(regexNonAlphabet);
    if (spacePos == -1) {
      spacePos = 0;
    } else {
      spacePos += 1;
    }
    var output = plainText.substring(spacePos, index);
    state = output.trim();
    len = index - spacePos;
    return;
  }

  void insertText(String text) {
    if (lastFocusText != null) {
      int end = lastFocusText!.selection.end;
      int start = end - len - 1;
      String input = lastFocusText!.text.replaceRange(start, end, "$text ");
      lastFocusText!.value = TextEditingValue(text: input, selection: TextSelection.collapsed(offset: start + text.length - 1));
    } else if (lastFocusQuill != null) {
      int end = lastFocusQuill!.selection.end;
      int start = end - len - 1;
      lastFocusQuill!.document.replace(start, len, "$text ");
      lastFocusQuill!.moveCursorToPosition(start + text.length - 1);
    }
    state = "";
    len = 0;
  }

  (String, bool) formatting(String input) {
    var text = input.split("\n");
    var stack = 0;
    var output = [];
    var regexSpace = RegExp(r"if +\(");
    for (var code in text) {
      stack -= "}".allMatches(code).length;
      var outputCode = code.trim().replaceAll(regexSpace, "if(");

      for (var i = 0; i < stack; i++) {
        outputCode = "  $outputCode";
      }
      output.add(outputCode);
      stack += "{".allMatches(code).length;
    }
    return (output.join("\n").trim(), stack != 0);
  }
}

enum CodeActivationType { visible, clickable, execute }

@riverpod
class SimpleCodesIde extends _$SimpleCodesIde {
  Choice? choice;

  @override
  SimpleCodes? build(CodeActivationType type) {
    choice = ref.watch(nodeEditorTargetProvider);
    return getSimpleCodes(choice!, type);
  }

  SimpleCodes? getSimpleCodes(Choice choice, CodeActivationType type) {
    switch (type) {
      case CodeActivationType.visible:
        return choice.conditionalCodeHandler.conditionVisibleSimple;
      case CodeActivationType.clickable:
        return choice.conditionalCodeHandler.conditionClickableSimple;
      case CodeActivationType.execute:
        return choice.conditionalCodeHandler.executeSimple;
    }
  }

  void setSimpleCodes(Choice choice, CodeActivationType type, SimpleCodes? simpleCodes) {
    ref.read(nodeEditorTargetProvider.notifier).setState((e){
      switch (type) {
        case CodeActivationType.visible:
          e.conditionalCodeHandler.conditionVisibleSimple = simpleCodes;
        case CodeActivationType.clickable:
          e.conditionalCodeHandler.conditionClickableSimple = simpleCodes;
        case CodeActivationType.execute:
          e.conditionalCodeHandler.executeSimple = simpleCodes;
      }
      return e;
    });
  }

  void setSimpleCodeBlock(SimpleCodeBlock simpleCodeBlock, int index) {
    var simpleCodes = getSimpleCodes(choice!, type);
    var codes = [...?simpleCodes?.code];
    codes[index] = simpleCodeBlock;
    simpleCodes = simpleCodes?.copyWith(code: codes) ?? SimpleCodes(code: codes, type: type == CodeActivationType.execute ? SimpleType.action : SimpleType.condition);
    state = simpleCodes;
    setSimpleCodes(choice!, type, state);
  }

  void addSimpleCodeBlock(SimpleCodeBlock simpleCodeBlock, {int? index}) {
    var simpleCodes = getSimpleCodes(choice!, type);
    var codes = [...?simpleCodes?.code];
    if (index != null) {
      codes.insert(index, simpleCodeBlock);
    } else {
      codes.add(simpleCodeBlock);
    }
    simpleCodes = simpleCodes?.copyWith(code: codes) ?? SimpleCodes(code: codes, type: type == CodeActivationType.execute ? SimpleType.action : SimpleType.condition);
    state = simpleCodes;
    setSimpleCodes(choice!, type, state);
  }
}
