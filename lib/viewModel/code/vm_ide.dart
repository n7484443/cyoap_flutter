import 'package:cyoap_core/choiceNode/choice.dart';
import 'package:cyoap_core/choiceNode/choice_line.dart';
import 'package:cyoap_core/choiceNode/conditional_code_handler.dart';
import 'package:cyoap_core/grammar/function_list.dart';
import 'package:cyoap_core/variable_db.dart';
import 'package:cyoap_flutter/viewModel/vm_editor.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../main.dart';

part 'vm_ide.g.dart';

final controllerClickableProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  var node = ref.watch(nodeEditorTargetProvider);
  var controller = TextEditingController(
      text: node.conditionalCodeHandler.conditionClickableString);
  controller.addListener(() {
    ref
        .read(ideCurrentInputProvider.notifier)
        .addCheckText(controller.text, controller.selection.end);
    EasyDebounce.debounce(
        'conditionClickableString', ConstList.debounceDuration, () {
      ref.read(nodeEditorTargetProvider.notifier).setState((node) {
        node.conditionalCodeHandler.conditionClickableString = controller.text;
        return node;
      });
    });
  });
  ref.onDispose(() {
    controller.dispose();
    EasyDebounce.cancel('conditionClickableString');
  });
  return controller;
});

@riverpod
TextEditingController controllerVisible(ControllerVisibleRef ref) {
  Choice node;
  if (ref.watch(nodeEditorTargetPosProvider) != null) {
    node = ref.watch(nodeEditorTargetProvider);
  } else {
    node = ref.watch(lineEditorTargetProvider);
  }
  var controller = TextEditingController(
      text: node.conditionalCodeHandler.conditionVisibleString);
  controller.addListener(() {
    ref
        .read(ideCurrentInputProvider.notifier)
        .addCheckText(controller.text, controller.selection.end);
    EasyDebounce.debounce('conditionVisibleString', ConstList.debounceDuration,
        () {
      node.conditionalCodeHandler.conditionVisibleString = controller.text;
    });
  });
  ref.onDispose(() {
    controller.dispose();
    EasyDebounce.cancel('conditionVisibleString');
  });
  return controller;
}

final regexSpace = RegExp(r"(\b|}|\))(if|for|else|in|break|continue)(\b|{|\()");
final regexBrace = RegExp(r"[{}()]");
final regexComment = RegExp(r"//.*");
final regexFunction = RegExp(
    "(${FunctionListEnum.values.where((e) => e.displayWithColor).map((e) => e.functionName ?? e.name).join('|')})"
    r"\(");

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
      var plainText = controller.document.toPlainText();
      if (handler.executeCodeString != plainText) {
        var styleNull = Attribute.color;
        var styleDeepOrange = ColorAttribute('#${Colors.deepOrangeAccent.hex}');
        var styleDeepPurple = ColorAttribute('#${Colors.deepPurple.hex}');
        var styleGrey = ColorAttribute('#${Colors.grey.hex}');

        controller.formatText(0, plainText.length, styleNull);

        var match = regexFunction.allMatches(plainText);
        for (var m in match) {
          controller.formatText(m.start, m.end - m.start, styleDeepPurple);
        }

        match = regexSpace.allMatches(plainText);
        for (var m in match) {
          controller.formatText(m.start, m.end - m.start, styleDeepOrange);
        }

        match = regexBrace.allMatches(plainText);
        for (var m in match) {
          controller.formatText(m.start, m.end - m.start, styleNull);
        }

        match = regexComment.allMatches(plainText);
        for (var m in match) {
          controller.formatText(m.start, m.end - m.start, styleGrey);
        }

        if (ref.watch(nodeEditorTargetPosProvider) != null) {
          ref.read(nodeEditorTargetProvider.notifier).setState((node) {
            node.conditionalCodeHandler.executeCodeString = plainText;
            return node;
          });
        } else {
          ref.read(lineEditorTargetProvider.notifier).setState((line) {
            line.conditionalCodeHandlerFinalize.executeCodeString = plainText;
            return line;
          });
        }
      }
    });
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
      .varMapGlobal
      .keys
      .where((e) => e.startsWith(ref.watch(ideCurrentInputProvider)))
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
      String input = lastFocusText!.text.replaceRange(end - len, end, "$text ");
      lastFocusText!.value = TextEditingValue(
          text: input,
          selection:
              TextSelection.collapsed(offset: end - len + text.length + 1));
    } else if (lastFocusQuill != null) {
      int end = lastFocusQuill!.selection.end;
      lastFocusQuill!.document.replace(end - len, len, "$text ");
      lastFocusQuill!.moveCursorToPosition(end - len + text.length + 1);
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
