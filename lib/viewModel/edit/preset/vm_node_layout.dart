import 'dart:math';

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

  void setIndex(int? index) {
    state = index;
  }
}

@riverpod
class LayoutElementIndex extends _$LayoutElementIndex {
  @override
  int? build() {
    return null;
  }

  void setIndex(int? index) {
    state = index;
  }
}

ResponsiveBox getResponsiveBox(AutoDisposeRef ref, NodeLayout layout,
    {bool isInitial = false}) {
  var func = isInitial ? ref.read : ref.watch;
  var index = func(currentNodeLayoutElementIndexProvider);
  if (index == null) {
    return const ResponsiveBox();
  }
  NodeLayout nodeLayout =
      func(choiceNodePresetCurrentEditProvider).layout ??
          const NodeLayout();
  return nodeLayout.nodeLayoutElements[index].responsiveBox;
}

NodeLayout getNodeLayout(AutoDisposeRef ref, {bool isInitial = false}) {
  var func = isInitial ? ref.read : ref.watch;
  return func(choiceNodePresetCurrentEditProvider)
      .layout ??
      const NodeLayout();
}

void setResponsiveBox(AutoDisposeRef ref, ResponsiveBox original,
    Map<String, ResponsiveSize?> values, NodeLayout layout) {
  var nodeLayoutElementIndex = ref.read(currentNodeLayoutElementIndexProvider)!;
  ResponsiveBox newResponsiveBox = original.copyWith(
    left: values['left'],
    right: values['right'],
    top: values['top'],
    bottom: values['bottom'],
    width: values['width'],
    height: values['height'],
  );
  var newNodeLayoutElements = [...layout.nodeLayoutElements];
  newNodeLayoutElements[nodeLayoutElementIndex] =
      newNodeLayoutElements[nodeLayoutElementIndex]
          .copyWith(responsiveBox: newResponsiveBox);
  var newLayout = layout.copyWith(nodeLayoutElements: newNodeLayoutElements);
  ChoiceNodeDesignPreset newValue =
  ref.read(choiceNodePresetCurrentEditProvider).copyWith(layout: newLayout);
  ref
      .read(choiceNodePresetListProvider.notifier)
      .updateIndex(ref.watch(currentPresetIndexProvider), newValue);
  ;
}

@riverpod
class NodeLayoutResponsiveSizeOption extends _$NodeLayoutResponsiveSizeOption {
  @override
  ResponsiveSizeOption build({required String position}) {
    var responsiveBox = getResponsiveBox(ref, getNodeLayout(ref));
    return responsiveBox
        .getValue(position)
        ?.option ?? ResponsiveSizeOption.px;
  }

  void setValue(ResponsiveSizeOption option) {
    var layout = getNodeLayout(ref);
    var index = ref.watch(currentNodeLayoutElementIndexProvider);
    if (index == null) {
      return;
    }
    ResponsiveBox responsiveBox = getResponsiveBox(ref, layout);
    Map<String, ResponsiveSize?> values = {
      'left': responsiveBox.left,
      'right': responsiveBox.right,
      'top': responsiveBox.top,
      'bottom': responsiveBox.bottom,
      'width': responsiveBox.width,
      'height': responsiveBox.height
    };
    values[position] = values[position]?.copyWith(option: option);
    setResponsiveBox(ref, responsiveBox, values, layout);
  }
}

@riverpod
TextEditingController nodeLayoutElementController(
    NodeLayoutElementControllerRef ref,
    {required String position,
      required String type}) {
  String debounceName = 'Node Layout Element $position $type';

  ResponsiveSize? responsiveSize =
  getResponsiveBox(ref, getNodeLayout(ref, isInitial: true), isInitial: true).getValue(position);
  var initValue =
      (type == 'px' ? responsiveSize?.px : responsiveSize?.percentage) ?? 0.0;
  var controller = TextEditingController(text: initValue.toString());
  controller.addListener(() {
    EasyDebounce.debounce(debounceName, ConstList.debounceDuration, () {
      var layout = getNodeLayout(ref, isInitial: true);
      var index = ref.read(currentNodeLayoutElementIndexProvider);
      if (index == null) {
        return;
      }
      ResponsiveBox responsiveBox = getResponsiveBox(ref, layout, isInitial: true);
      Map<String, ResponsiveSize?> values = {
        'left': responsiveBox.left,
        'right': responsiveBox.right,
        'top': responsiveBox.top,
        'bottom': responsiveBox.bottom,
        'width': responsiveBox.width,
        'height': responsiveBox.height
      };
      var value = double.tryParse(controller.text) ?? 0.0;
      if (type == 'px') {
        value = max(value, 0.0);
        values[position] = values[position]?.copyWith(px: value);
      } else {
        value = value.clamp(0.0, 100.0);
        values[position] = values[position]?.copyWith(percentage: value);
      }
      setResponsiveBox(ref, responsiveBox, values, layout);
    });
  });
  ref.onDispose(() {
    EasyDebounce.cancel(debounceName);
    controller.dispose();
  });
  return controller;
}
