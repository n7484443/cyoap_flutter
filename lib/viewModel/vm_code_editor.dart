import 'package:cyoap_flutter/model/editor.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/choiceNode/choice_node.dart';

final choiceNodeProvider = Provider.autoDispose<ChoiceNode>((ref) {
  return NodeEditor().target;
});

final isOccupySpaceButtonProvider = StateProvider.autoDispose<bool>((ref) {
  return ref.watch(choiceNodeProvider).isOccupySpace;
});

final vmCodeEditorProvider = Provider((ref) => VMCodeEditor(ref));

final controllerClickableProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  var controller = TextEditingController(
      text: ref
          .watch(choiceNodeProvider)
          .recursiveStatus
          .conditionClickableString)
    ..addListener(() {
      ref.read(codeEditorChanged.notifier).update((state) => true);
    });
  ref.onDispose(() => controller.dispose());
  return controller;
});

final controllerVisibleProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  var controller = TextEditingController(
      text:
          ref.watch(choiceNodeProvider).recursiveStatus.conditionVisibleString)
    ..addListener(() {
      ref.read(codeEditorChanged.notifier).update((state) => true);
    });
  ref.onDispose(() => controller.dispose());
  return controller;
});

final controllerExecuteProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  var controller = TextEditingController(
      text: ref.watch(choiceNodeProvider).recursiveStatus.executeCodeString)
    ..addListener(() {
      ref.read(codeEditorChanged.notifier).update((state) => true);
    });
  ref.onDispose(() => controller.dispose());
  return controller;
});

final codeEditorChanged = StateProvider<bool>((ref) => false);

class VMCodeEditor{
  final Ref ref;

  VMCodeEditor(this.ref);
  TextEditingController? lastFocus;

  void insertText(TextEditingController controller, String text) {
    var selection = controller.selection;
    controller.text =
        controller.text.replaceRange(selection.start, selection.end, text);
    controller.selection =
        TextSelection.collapsed(offset: selection.start + text.length);
  }

  void save() {
    ref.read(choiceNodeProvider).recursiveStatus.conditionClickableString =
        ref.read(controllerClickableProvider).text;
    ref.read(choiceNodeProvider).recursiveStatus.conditionVisibleString =
        ref.read(controllerVisibleProvider).text;
    ref.read(choiceNodeProvider).recursiveStatus.executeCodeString =
        ref.read(controllerExecuteProvider).text;
    ref.read(codeEditorChanged.notifier).update((state) => false);
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
  }
}
