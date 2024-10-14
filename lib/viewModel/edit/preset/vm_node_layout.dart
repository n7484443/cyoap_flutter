import 'package:cyoap_core/preset/layout.dart';
import 'package:cyoap_core/preset/node_preset.dart';
import 'package:cyoap_flutter/viewModel/edit/preset/vm_node_preset.dart';
import 'package:cyoap_flutter/viewModel/edit/preset/vm_preset.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../main.dart';

part 'vm_node_layout.g.dart';

@riverpod
class CurrentNodeLayoutElementIndex extends _$CurrentNodeLayoutElementIndex {
  @override
  int? build() {
    return null;
  }
}

// void setLayoutElementValue(Ref ref, double value, bool type){
//
// }
//
// @riverpod
// bool nodeLayoutElementType(NodeLayoutElementTypeRef ref, {
//   required String position,
// }){
//   ref.listen(currentPresetIndexProvider, (previous, next) {
//     ref.invalidateSelf();
//   });
//   ResponsiveBox getValue() {
//     int index = ref.read(currentNodeLayoutElementIndexProvider)!;
//     return ref
//         .read(choiceNodePresetCurrentEditProvider)
//         .layout!
//         .nodeLayoutElements[index]
//         .responsiveBox;
//   }
//   return true;
// }
//
// @riverpod
// TextEditingController nodeLayoutElementController(
//   NodeLayoutElementControllerRef ref, {
//   required String position, required String type
// }) {
//   String debounceName = 'Node Layout Element $position';
//   ref.listen(currentPresetIndexProvider, (previous, next) {
//     ref.invalidateSelf();
//   });
//   ResponsiveBox getValue() {
//     int index = ref.read(currentNodeLayoutElementIndexProvider)!;
//     return ref
//         .read(choiceNodePresetCurrentEditProvider)
//         .layout!
//         .nodeLayoutElements[index]
//         .responsiveBox;
//   }
//
//   var controller =
//       TextEditingController(text: getValue().getValue(position).toString());
//   controller.addListener(() {
//     EasyDebounce.debounce(debounceName, ConstList.debounceDuration, () {
//       ResponsiveBox responsiveBox = getValue();
//       Map<String, ResponsiveSize?> values = {
//         'left': responsiveBox.left,
//         'right': responsiveBox.right,
//         'top': responsiveBox.top,
//         'bottom': responsiveBox.bottom
//       };
//       values[position] = double.tryParse(controller.text) ?? 0.0;
//       ChoiceNodeDesignPreset? newValue;
//       var newNodeLayoutElements = ref
//           .read(choiceNodePresetCurrentEditProvider)
//           .layout!
//           .nodeLayoutElements;
//
//       newValue = ref
//           .read(choiceNodePresetCurrentEditProvider)
//           .copyWith.layout!(
//           nodeLayoutElements: newNodeLayoutElements
//       );
//       ref
//           .read(choiceNodePresetListProvider.notifier)
//           .updateIndex(ref.watch(currentPresetIndexProvider), newValue!);
//     });
//   });
//   ref.onDispose(() {
//     EasyDebounce.cancel(debounceName);
//     controller.dispose();
//   });
//   return controller;
// }
