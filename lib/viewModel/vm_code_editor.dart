import 'package:cyoap_flutter/viewModel/vm_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isOccupySpaceButtonProvider = StateProvider.autoDispose<bool>((ref) {
  return ref.watch(nodeEditorTargetProvider).isOccupySpace;
});

final vmCodeEditorProvider = Provider((ref) => VMCodeEditor(ref));

final controllerClickableProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  var controller = TextEditingController(
      text: ref
          .watch(nodeEditorTargetProvider)
          .recursiveStatus
          .conditionClickableString)
    ..addListener(() {
      ref.read(changeProvider.notifier).needUpdate();
    });
  ref.onDispose(() => controller.dispose());
  return controller;
});

final controllerVisibleProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  var controller = TextEditingController(
      text:
          ref.watch(nodeEditorTargetProvider).recursiveStatus.conditionVisibleString)
    ..addListener(() {
      ref.read(changeProvider.notifier).needUpdate();
    });
  ref.onDispose(() => controller.dispose());
  return controller;
});

final controllerExecuteProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  var controller = TextEditingController(
      text: ref.watch(nodeEditorTargetProvider).recursiveStatus.executeCodeString)
    ..addListener(() {
      ref.read(changeProvider.notifier).needUpdate();
    });
  ref.onDispose(() => controller.dispose());
  return controller;
});

class VMCodeEditor {
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
}
