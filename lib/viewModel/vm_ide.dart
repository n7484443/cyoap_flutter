import 'package:cyoap_core/variable_db.dart';
import 'package:cyoap_flutter/viewModel/vm_editor.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

final controllerClickableProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  var node = ref.watch(nodeEditorTargetProvider).node;
  var controller = TextEditingController(
      text: node.recursiveStatus.conditionClickableString);
  controller.addListener(() {
    ref
        .read(ideCurrentInputProvider.notifier)
        .addCheckText(controller.text, controller.selection.end);
    EasyDebounce.debounce(
        'conditionClickableString', const Duration(milliseconds: 500), () {
      ref
          .read(nodeEditorTargetProvider)
          .node
          .recursiveStatus
          .conditionClickableString = controller.text;
      ref.read(editorChangeProvider.notifier).needUpdate();
    });
  });
  ref.onDispose(() {
    controller.dispose();
    EasyDebounce.cancel('conditionClickableString');
  });
  return controller;
});

final controllerVisibleProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  var node = ref.watch(nodeEditorTargetProvider).node;
  var controller =
      TextEditingController(text: node.recursiveStatus.conditionVisibleString);
  controller.addListener(() {
    ref
        .read(ideCurrentInputProvider.notifier)
        .addCheckText(controller.text, controller.selection.end);
    EasyDebounce.debounce(
        'conditionVisibleString', const Duration(milliseconds: 500), () {
      node.recursiveStatus.conditionVisibleString = controller.text;
      ref.read(editorChangeProvider.notifier).needUpdate();
    });
  });
  ref.onDispose(() {
    controller.dispose();
    EasyDebounce.cancel('conditionVisibleString');
  });
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

  TextEditingController? lastFocusText;
  QuillController? lastFocusQuill;

  int len = 0;
  bool reformat = false;

  IdeCurrentInputNotifier(this.ref) : super('');

  void addText(String plainText, int index, int len, Object? data) {
    if(reformat) return;
    if (data == null) return;
    if (data is! String) return;
    var carrot = index;
    plainText = plainText.replaceRange(index, index + len, data);
    carrot = carrot - len + data.length;
    addCheckText(plainText, carrot);
  }

  void addCheckText(String plainText, int index) {
    if(plainText.isEmpty) return;
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
          selection: TextSelection.collapsed(offset: end - len + text.length + 1)
      );
    } else if (lastFocusQuill != null) {
      int end = lastFocusQuill!.selection.end;
      lastFocusQuill!.document.replace(end - len, len, "$text ");
      lastFocusQuill!.moveCursorToPosition(end - len + text.length + 1);
    }
    state = "";
    len = 0;
  }

  Tuple2<String, bool> formatting(String input) {
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
    return Tuple2(output.join("\n").trim(), stack != 0);
  }
}