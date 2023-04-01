import 'package:cyoap_core/variable_db.dart';
import 'package:cyoap_flutter/viewModel/vm_editor.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final controllerClickableProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  var node = ref.watch(nodeEditorTargetProvider).node;
  var controller = TextEditingController(
      text: node.recursiveStatus.conditionClickableString);
  controller.addListener(() {
    ref.read(ideCurrentInputProvider.notifier).addText(
        controller.text,
        controller.selection.start,
        controller.selection.end - controller.selection.start,
        controller.selection.textInside(controller.text));
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
    ref.read(ideCurrentInputProvider.notifier).addText(
        controller.text,
        controller.selection.start,
        controller.selection.end - controller.selection.start,
        controller.selection.textInside(controller.text));
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
  final regexAlphabet = RegExp(r"^[a-zA-Z0-9_]+$");
  final regexNonAlphabet = RegExp(r"[{}\[\]().\s\n]");
  final Ref ref;

  IdeCurrentInputNotifier(this.ref) : super('');

  void addText(String plainText, int index, int len, Object? data) {
    if (data == null) return;
    if (data is! String) return;

    var carrot = index;
    if (plainText.length <= index) {
      carrot = plainText.length;
    }
    var spacePos = plainText.substring(0, carrot).lastIndexOf(regexNonAlphabet);
    if (spacePos == -1) {
      spacePos = 0;
    } else {
      spacePos += 1;
    }
    var output = plainText.substring(spacePos, carrot).trim();
    if (regexAlphabet.hasMatch(data.toString())) {
      output = plainText.substring(spacePos, carrot).trim() + data.toString();
    }

    ref.read(ideCurrentInputProvider.notifier).state = output.trim();
    return;
  }
}
