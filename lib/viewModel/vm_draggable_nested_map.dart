import 'package:cyoap_flutter/model/choiceNode/choice_line.dart';
import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/choiceNode/choice_node.dart';
import '../model/choiceNode/generable_parser.dart';
import '../model/choiceNode/pos.dart';
import '../model/image_db.dart';
import '../model/platform_system.dart';
import '../model/variable_db.dart';

const int maxWidthSize = 12;

final draggableNestedMapChangedProvider = StateProvider<bool>((ref) => false);

final vmDraggableNestedMapProvider =
    Provider.autoDispose((ref) => VMDraggableNestedMap(ref));

final removedChoiceNode = StateProvider.autoDispose<ChoiceNode?>((ref) => null);
final dragPositionProvider = StateProvider.autoDispose<double?>((ref) => null);
final backgroundColorProvider = Provider.autoDispose<Color>(
    (ref) => getPlatform.designSetting.colorBackground);

final dragChoiceNodeProvider =
    StateNotifierProvider.autoDispose<DragChoiceNodeNotifier, Pos?>(
        (ref) => DragChoiceNodeNotifier(ref));

class DragChoiceNodeNotifier extends StateNotifier<Pos?> {
  Ref ref;

  DragChoiceNodeNotifier(this.ref) : super(null);

  void dragStart(Pos pos) {
    state = pos.copyWith();
  }

  void dragEnd() {
    state = null;
  }
}

class VMDraggableNestedMap {
  Ref ref;

  VMDraggableNestedMap(this.ref) {
    ImageDB().clearImageCache();
  }

  void copyData(WidgetRef ref, ChoiceNode choiceNode) {
    ref.read(removedChoiceNode.notifier).state = choiceNode.clone();
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    refreshPage(ref);
  }

  void removeData(WidgetRef ref, Pos data) {
    var choiceNode = getPlatform.removeData(data);
    copyData(ref, choiceNode);
    VariableDataBase().updateCheckList();
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    refreshPage(ref);
  }

  void addData(WidgetRef ref, Pos data, ChoiceNode choiceNode) {
    getPlatform.addData(data, choiceNode);
    VariableDataBase().updateCheckList();
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    refreshPage(ref);
  }

  static ChoiceNode createNodeForTemp() {
    return ChoiceNode.noTitle(3, true, '', '');
  }

  void changeData(WidgetRef ref, Pos input, Pos target) {
    if (input.last == nonPositioned) {
      getPlatform.addData(target, createNodeForTemp());
    } else {
      var inputNode = getPlatform.getChoiceNode(input)!;
      var targetNode = getPlatform.getChoiceNode(target);
      if (targetNode == null) {
        var generableParser = getPlatform
            .getGenerableParserAndPosition(target.removeLast());
        if (generableParser == null) {
          getPlatform.removeData(input);
          getPlatform.addData(target, inputNode);
        } else {
          getPlatform.insertDataWithParent(inputNode, generableParser);
        }
      } else {
        getPlatform.insertData(inputNode, targetNode);
      }
    }
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    refreshPage(ref);
  }
}

void moveLine(WidgetRef ref, int before, int after) {
  if (after >= getPlatform.lineSettings.length) {
    return;
  }
  if (after < 0) {
    return;
  }
  var temp = getPlatform.lineSettings[before];
  getPlatform.lineSettings[before] = getPlatform.lineSettings[after];
  getPlatform.lineSettings[after] = temp;
  getPlatform.checkDataCorrect();
  refreshLine(ref, before);
  refreshLine(ref, after);
}

void refreshPage(WidgetRef ref) {
  for (var pos = 0; pos < getPlatform.lineSettings.length; pos++) {
    refreshLine(ref, pos);
  }
}

void refreshLine(WidgetRef ref, int pos) {
  ref.invalidate(lineProvider(pos));
  ref.read(childrenChangeProvider(Pos(data: [pos])).notifier).update();
  for (var child in ref.read(lineProvider(pos))!.children) {
    refreshChild(ref, child);
  }
}

final lineProvider = Provider.autoDispose
    .family<LineSetting?, int>((ref, pos) => getPlatform.getLineSetting(pos));

final childrenProvider = Provider.autoDispose
    .family<List<GenerableParserAndPosition>, Pos>((ref, pos) {
  if (pos.data.length == 1) {
    return ref.watch(lineProvider(pos.data.first))!.children;
  } else {
    return ref.watch(choiceNodeProvider(pos))!.children;
  }
});

final childrenChangeProvider = StateNotifierProvider.autoDispose
    .family<ChildrenNotifier, List<GenerableParserAndPosition>, Pos>(
        (ref, pos) => ChildrenNotifier(ref, pos));

class ChildrenNotifier extends StateNotifier<List<GenerableParserAndPosition>> {
  Ref ref;
  Pos pos;

  ChildrenNotifier(this.ref, this.pos) : super([...ref.read(childrenProvider(pos))]);

  void update() {
    state = [...ref.read(childrenProvider(pos))];
  }
}

final lineAlwaysVisibleProvider = StateProvider.autoDispose.family<bool, int>(
    (ref, pos) => ref.watch(lineProvider(pos))!.alwaysVisible);

final lineMaxSelectProvider = StateProvider.autoDispose
    .family<int, int>((ref, pos) => ref.watch(lineProvider(pos))!.maxSelect);
