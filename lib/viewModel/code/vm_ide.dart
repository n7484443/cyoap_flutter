import 'package:cyoap_core/choiceNode/choice.dart';
import 'package:cyoap_core/choiceNode/choice_line.dart';
import 'package:cyoap_core/choiceNode/conditional_code_handler.dart';
import 'package:cyoap_core/grammar/analyser.dart';
import 'package:cyoap_core/grammar/analyser_const.dart';
import 'package:cyoap_core/grammar/ast.dart';
import 'package:cyoap_core/variable_db.dart';
import 'package:cyoap_flutter/viewModel/edit/vm_editor.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';

final controllerIdeProvider = Provider.autoDispose<QuillController>((ref) {
  Choice node;
  ConditionalCodeHandler handler;
  String? str;
  if (ref.watch(nodeEditorTargetPosProvider) != null) {
    node = ref.watch(nodeEditorTargetProvider);
    handler = node.conditionalCodeHandler;
  } else {
    node = ref.watch(lineEditorTargetProvider);
    handler = (node as ChoiceLine).conditionalCodeHandlerFinalize;
  }
  str = handler.executeCodeString;

  var data = [
    {"insert": "${str ?? ''}\n"}
  ];
  var controller = QuillController(
      document: Document.fromJson(data),
      selection: const TextSelection.collapsed(offset: 0));
  controller.addListener(() {
    EasyDebounce.debounce('code-ide', ConstList.debounceDuration, () {
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
      controller.formatText(0, plainText.length, styleNull,
          shouldNotifyListeners: false);
      for (var i = 0; i < needUpdate.length; i++) {
        var (start, end, style) = needUpdate[i];
        controller.formatText(start, end - start, style,
            shouldNotifyListeners: false);
      }
    });
    node.conditionalCodeHandler.executeCodeString =
        controller.document.toPlainText();
  });
  ref.onDispose(() {
    controller.dispose();
    EasyDebounce.cancel('code-ide');
  });

  controller.onReplaceText = (int index, int len, Object? data) {
    ref
        .read(ideCurrentInputProvider.notifier)
        .addText(controller.document.toPlainText(), index, len, data);
    return true;
  };
  return controller;
});

final ideVariableListProvider = Provider.autoDispose<List<String>>((ref) {
  return VariableDataBase()
      .stackFrames.first.getVariableMap()
      .keys
      .where((e) => e.contains(ref.watch(ideCurrentInputProvider)))
      .toList();
});

final ideCurrentInputProvider =
    StateNotifierProvider<IdeCurrentInputNotifier, String>(
        (ref) => IdeCurrentInputNotifier(ref));

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
      lastFocusText!.value = TextEditingValue(
          text: input,
          selection: TextSelection.collapsed(offset: start + text.length - 1));
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

final currentIdeOpenProvider = StateProvider<bool>((ref) {
  return true;
});
